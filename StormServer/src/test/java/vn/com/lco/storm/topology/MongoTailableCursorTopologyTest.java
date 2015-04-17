/**
 * Legend Company
 */
package vn.com.lco.storm.topology;

import java.util.Date;
import java.util.Random;
import java.util.UUID;

import org.junit.Test;

import vn.com.lco.constants.Constants;
import backtype.storm.Config;
import backtype.storm.LocalCluster;
import backtype.storm.utils.Utils;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCollection;
import com.mongodb.Mongo;
import com.mongodb.MongoURI;

/**
 * @author OaiPanda
 *
 * MongoTailableCursorTopologyTest.java
 */
public class MongoTailableCursorTopologyTest {

	@Test
	public void test() throws Exception {
		// mongo stuff
        Mongo mongo = new Mongo(new MongoURI("mongodb://" + Constants.MONGO_HOST + ":" + Constants.MONGO_PORT));
        mongo.dropDatabase(Constants.MONGO_DB_NAME);
        
        // create userInteractLog collection
        final BasicDBObject options = new BasicDBObject("capped", true);
        options.put("size", 10000);
        mongo.getDB(Constants.MONGO_DB_NAME).createCollection(Constants.USER_INTERACT_LOG_COLLECTION, options);
        final DBCollection coll = mongo.getDB(Constants.MONGO_DB_NAME).getCollection(Constants.USER_INTERACT_LOG_COLLECTION);
        
        // create trendingHotEvent collection
        options.put("size", Constants.TOP_N);
        mongo.getDB(Constants.MONGO_DB_NAME).createCollection(Constants.TRENDING_HOT_EVENT_COLLECTION, options);
        
        Config conf = new Config();
        conf.setDebug(true);
        
        LocalCluster cluster = new LocalCluster();
        String topologyName = "trendingHot";
        cluster.submitTopology(topologyName, conf, MongoTailableCursorTopology.buildTopology());
        
        // for JUnit test
        Runnable writer = new Runnable() {

			@Override
			public void run() {
				final String[] operations = new String[] { "LIKE", "SUBSCRIBE", "COMMENT" };
				final String[] eventIds = new String[] { "520654cb84aec5ff1ac8d4dd",
														 "5206507e84aec5ff1ac8d4d8" };
		        final Random rand = new Random();
		        
				for (int i=0; i < 10; i++) {
	                final BasicDBObject document = new BasicDBObject("_id", UUID.randomUUID().toString());
	                document.put("operation", operations[rand.nextInt(operations.length)]);
	                document.put("eventId", eventIds[rand.nextInt(eventIds.length)]);
	                document.put("timeLog", new Date());
	                coll.insert(document);
	                Utils.sleep(1000);
	            }
			}
		};
		
		new Thread(writer).start();
		
        Utils.sleep((long) 60 * Constants.MILLIS_IN_SEC);
        cluster.killTopology(topologyName);
        cluster.shutdown();
        
        mongo.dropDatabase(Constants.MONGO_DB_NAME);
	}

}
