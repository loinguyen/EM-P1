package vn.com.lco.storm.spout;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.atomic.AtomicBoolean;

import org.mortbay.log.Log;

import vn.com.lco.constants.Constants;
import backtype.storm.Config;
import backtype.storm.spout.SpoutOutputCollector;
import backtype.storm.task.TopologyContext;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseRichSpout;
import backtype.storm.tuple.Fields;
import backtype.storm.tuple.Values;
import backtype.storm.utils.Utils;

import com.mongodb.BasicDBObject;
import com.mongodb.Bytes;
import com.mongodb.DB;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.mongodb.MongoException;

/**
* A Spout which consumes documents from a Mongodb tailable cursor.
*
* Subclasses should simply override two methods:
* <ul>
* <li>{@link #declareOutputFields(OutputFieldsDeclarer) declareOutputFields}
* <li>{@link #dbObjectToStormTuple(DBObject) dbObjectToStormTuple}, which turns
* a Mongo document into a Storm tuple matching the declared output fields.
* </ul>
*
** <p>
* <b>WARNING:</b> You can only use tailable cursors on capped collections.
* 
* @author Dan Beaulieu <danjacob.beaulieu@gmail.com>
*
*/
public abstract class MongoCappedCollectionSpout extends BaseRichSpout {

	/**
	 * Adds a default serial version ID to the selected type.
	 */
	private static final long serialVersionUID = 1L;

	private SpoutOutputCollector collector;
	
	private LinkedBlockingQueue<DBObject> queue;
	private final AtomicBoolean opened = new AtomicBoolean(false);
	
	private DB mongoDB;
	private final DBObject query;
	
	private final String mongoHost;
	private final int mongoPort;
	private final String mongoDbName;
	private final String mongoCollectionName;
	
	boolean _isDistributed;
	
	public MongoCappedCollectionSpout(String mongoHost, int mongoPort,
									  String mongoDbName, String mongoCollectionName,
									  DBObject query) {
		
		this.mongoHost = mongoHost;
		this.mongoPort = mongoPort;
		this.mongoDbName = mongoDbName;
		this.mongoCollectionName = mongoCollectionName;
		this.query = query;
		this._isDistributed = true;
		Log.info("MongoSpout constructor");
	}
	
	class TailableCursorThread extends Thread {
		
		LinkedBlockingQueue<DBObject> queue;
		String mongoCollectionName;
		DB mongoDB;
		DBObject query;

		public TailableCursorThread(LinkedBlockingQueue<DBObject> queue, DB mongoDB,
									String mongoCollectionName, DBObject query) {
			
			this.queue = queue;
			this.mongoDB = mongoDB;
			this.mongoCollectionName = mongoCollectionName;
			this.query = query;
		}

		@Override
		public void run() {
			Log.info("TailableCursorThread run");
			while(opened.get()) {
				try {
					// create the cursor
					mongoDB.requestStart();
					
					Log.info("query: " + query.toString());
					
					final DBCursor cursor = mongoDB.getCollection(mongoCollectionName)
												.find(query)
												.sort(new BasicDBObject("$natural", 1))
												.addOption(Bytes.QUERYOPTION_TAILABLE)
												.addOption(Bytes.QUERYOPTION_AWAITDATA)
												.addOption(Bytes.QUERYOPTION_NOTIMEOUT);

					try {
						while (opened.get() && cursor.hasNext()) {
		                    final DBObject doc = cursor.next();
		
		                    if (doc == null) break;
		
		                    if (doc.get("_id") != null && doc.get("operation") != null && doc.get("eventId") != null && doc.get("timeLog")!= null) {
								String operation = doc.get("operation").toString();
								if (!operation.equals(Constants.OPERATON_UPDATE_RANK)) {
									Log.info("document: " + doc);
									queue.put(doc);
								}
							}
		                }
					} finally {
						try { 
							if (cursor != null) cursor.close(); 
						} catch (final Throwable t) { }
	                    try { 
	                    	mongoDB.requestDone(); 
	                    	} catch (final Throwable t) { }
	                }
					
					Utils.sleep(500);
				} catch (final MongoException.CursorNotFound cnf) {
					// rethrow only if something went wrong while we expect the cursor to be open.
                    if (opened.get()) {
                    	throw cnf;
                    }
                } catch (InterruptedException e) { break; }
			}
		};
	}
	
	@Override
	public void open(Map conf, TopologyContext context, SpoutOutputCollector collector) {
		Log.info("MongoSput Open");
		
		this.collector = collector;
		this.queue = new LinkedBlockingQueue<DBObject>(1000);
		try {
			this.mongoDB = new Mongo(this.mongoHost, this.mongoPort).getDB(this.mongoDbName);
			this.mongoDB.authenticate("eventmap", "nv.pamevent".toCharArray());
		} catch (Exception e) {
			throw new RuntimeException(e);
		}

		TailableCursorThread listener = new TailableCursorThread(this.queue, this.mongoDB, this.mongoCollectionName, this.query);
		this.opened.set(true);
		listener.start();
	}

	@Override
	public void close() {
		this.opened.set(false);
	}

	@Override
	public void nextTuple() {
		
		DBObject dbo = this.queue.poll();
		if(dbo == null) {
            Utils.sleep(50);
        } else {
        	Log.info("nextTuple:" + dbo);
        	
        	// _id, operation, eventId, timeLog
        	if (dbo.get("_id") != null && dbo.get("operation") != null && dbo.get("eventId") != null && dbo.get("timeLog")!= null) {
	        	String id = dbo.get("_id").toString();
	        	String operation = dbo.get("operation").toString();
	        	String eventId = dbo.get("eventId").toString();
	        	String timeLog = dbo.get("timeLog").toString();
	        	
	            this.collector.emit(new Values(id, operation, eventId, timeLog));
        	} else {
        		Utils.sleep(50);
        	}
        }
	}

	@Override
	public void ack(Object msgId) {
		// TODO Auto-generated method stub	
	}

	@Override
	public void fail(Object msgId) {
		// TODO Auto-generated method stub	
	}

	@Override
	public void declareOutputFields(OutputFieldsDeclarer declarer) {
		
		declarer.declare(new Fields("id", "operation", "eventId", "timeLog"));
	}
	
	public abstract List<Object> dbObjectToStormTuple(DBObject message);

	@Override
    public Map<String, Object> getComponentConfiguration() {
        if(!_isDistributed) {
            Map<String, Object> ret = new HashMap<String, Object>();
            ret.put(Config.TOPOLOGY_MAX_TASK_PARALLELISM, 1);
            return ret;
        } else {
            return null;
        }
    }
}
