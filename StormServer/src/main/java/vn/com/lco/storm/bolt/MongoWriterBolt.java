package vn.com.lco.storm.bolt;

import java.util.Date;

import org.mortbay.log.Log;

import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.tuple.Tuple;

import com.mongodb.BasicDBObjectBuilder;
import com.mongodb.DBObject;

/**
 * A simple implementation of {@link MongoBaseBolt} which attempts to map the input
 * tuple directly to a MongoDB object.
 *
 * @author Adrian Petrescu <apetresc@gmail.com>
 *
 */
public class MongoWriterBolt extends MongoBaseBolt {

	private static final long serialVersionUID = 1L;
	private final String mongoCollectionName;

	/**
	 * @param mongoHost The host on which Mongo is running.
	 * @param mongoPort The port on which Mongo is running.
	 * @param mongoDbName The Mongo database containing all collections being
	 * written to.
	 * @param mongoCollectionName The Mongo collection to write to. If a
	 * collection with this name does not already exist, it will be
	 * automatically created.
	 */
	public MongoWriterBolt(String mongoHost, int mongoPort, String mongoDbName, String mongoCollectionName) {

		super(mongoHost, mongoPort, mongoDbName);
		this.mongoCollectionName = mongoCollectionName;
		Log.info("MongoWriterBolt constructor");
	}


	@Override
	public boolean shouldActOnInput(Tuple input) {
		Log.info("shouldActOnInput start");
		return true;
	}

	@Override
	public String getMongoCollectionForInput(Tuple input) {
		Log.info("getMongoCollectionForInput start");
		return mongoCollectionName;
	}

	@Override
	public DBObject getDBObjectForInput(Tuple input) {
		Log.info("getDBObjectForInput: " + input.toString());
		BasicDBObjectBuilder dbObjectBuilder = new BasicDBObjectBuilder();
		
		for (String field : input.getFields()) {
			Object value = input.getValueByField(field);
			if (isValidDBObjectField(value)) {
				Log.info("field&value: " + field + ":" + value);
				dbObjectBuilder.append(field, value);
			}
		}

		return dbObjectBuilder.get();
	}
	
	private boolean isValidDBObjectField(Object value) {
		return value instanceof String
				|| value instanceof Date
				|| value instanceof Integer
				|| value instanceof Float
				|| value instanceof Double
				|| value instanceof Short
				|| value instanceof Long
				|| value instanceof DBObject;
	}

	@Override
	public void declareOutputFields(OutputFieldsDeclarer declarer) { }
}
