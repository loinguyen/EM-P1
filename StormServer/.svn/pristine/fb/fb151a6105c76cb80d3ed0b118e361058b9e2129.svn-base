package vn.com.lco.storm.bolt;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.mortbay.log.Log;

import vn.com.lco.constants.Constants;
import vn.com.lco.storm.tools.Rankable;
import vn.com.lco.storm.tools.Rankings;
import backtype.storm.task.OutputCollector;
import backtype.storm.task.TopologyContext;
import backtype.storm.topology.base.BaseRichBolt;
import backtype.storm.tuple.Tuple;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.mongodb.MongoException;
import com.mongodb.WriteConcern;

/**
 * A Bolt for recording input tuples to Mongo. Subclasses are expected to
 * provide the logic behind mapping input tuples to Mongo objects.
 * 
 * @todo Provide optional batching of calls.
 *
 * @author Adrian Petrescu <apetresc@gmail.com>
 *
 */
public abstract class MongoBaseBolt extends BaseRichBolt {
	
	private static final long serialVersionUID = 1L;
	private OutputCollector collector;
	private DB mongoDB;
	
	private final String mongoHost;
	private final int mongoPort;
	private final String mongoDbName;

	/**
	 * @param mongoHost The host on which Mongo is running.
	 * @param mongoPort The port on which Mongo is running.
	 * @param mongoDbName The Mongo database containing all collections being
	 * written to.
	 */
	protected MongoBaseBolt(String mongoHost, int mongoPort, String mongoDbName) {
		this.mongoHost = mongoHost;
		this.mongoPort = mongoPort;
		this.mongoDbName = mongoDbName;
		Log.info("MongoBolt constructor");
	}
	
	@Override
	public void prepare(
			@SuppressWarnings("rawtypes") Map stormConf, TopologyContext context, OutputCollector collector) {
		Log.info("Mongo Bolt prepare");
		this.collector = collector;
		try {
			this.mongoDB = new Mongo(mongoHost, mongoPort).getDB(mongoDbName);
			this.mongoDB.authenticate("eventmap", "nv.pamevent".toCharArray());
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	/**
	 * edit by OaiDQ.
	 */
	@Override
	public void execute(Tuple input) {
		Log.info("Mongo Bolt execute");
		
		Log.info("before drop");
		this.mongoDB.getCollection(Constants.TRENDING_HOT_EVENT_COLLECTION).drop();
		Log.info("after drop");
		final BasicDBObject options = new BasicDBObject("capped", true);
		options.put("size", Constants.TOP_N);
		mongoDB.createCollection(Constants.TRENDING_HOT_EVENT_COLLECTION, options);
		Log.info("after create");
		
		if (shouldActOnInput(input)) {
			String collectionName = getMongoCollectionForInput(input);
			Log.info("collectionName:" + collectionName);
			
			try {
				Rankings rankings = (Rankings) input.getValueByField("rankings");
				Log.info(rankings.toString());
				if (rankings.size() > 0 && rankings != null) {
					List<Rankable> ranks = rankings.getRankings();
					if (ranks.size() > 0 && ranks != null) {
						
						List<DBObject> dbol = new ArrayList<DBObject>();
						Iterator<Rankable> iter = ranks.iterator();
						while (iter.hasNext()) {
							Rankable rankable = iter.next(); 
							final BasicDBObject dbObject = new BasicDBObject("_id", UUID.randomUUID().toString());
							dbObject.put("eventId", rankable.getObject());
							dbol.add(dbObject);
						}
						mongoDB.getCollection(collectionName).insert(dbol, new WriteConcern(1));
					}
				}

				collector.ack(input);
			} catch (MongoException me) {
				collector.fail(input);
			}
		} else {
			collector.ack(input);
		}
	}

	/**
	 * Decide whether or not this input tuple should trigger a Mongo write.
	 *
	 * @param input the input tuple under consideration
	 * @return {@code true} iff this input tuple should trigger a Mongo write
	 */
	public abstract boolean shouldActOnInput(Tuple input);
	
	/**
	 * Returns the Mongo collection which the input tuple should be written to.
	 *
	 * @param input the input tuple under consideration
	 * @return the Mongo collection which the input tuple should be written to
	 */
	public abstract String getMongoCollectionForInput(Tuple input);
	
	/**
	 * Returns the DBObject to store in Mongo for the specified input tuple.
	 * 
	 * @param input the input tuple under consideration
	 * @return the DBObject to be written to Mongo
	 */
	public abstract DBObject getDBObjectForInput(Tuple input);
	
	@Override
	public void cleanup() {
		this.mongoDB.getMongo().close();
	}

}
