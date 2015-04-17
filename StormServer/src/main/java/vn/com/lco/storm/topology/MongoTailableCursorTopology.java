package vn.com.lco.storm.topology;

import static backtype.storm.utils.Utils.tuple;

import java.util.List;

import vn.com.lco.constants.Constants;
import vn.com.lco.storm.bolt.CountRankEventBolt;
import vn.com.lco.storm.bolt.IntermediateRankingsBolt;
import vn.com.lco.storm.bolt.MongoWriterBolt;
import vn.com.lco.storm.bolt.RollingCountBolt;
import vn.com.lco.storm.bolt.TotalRankingsBolt;
import vn.com.lco.storm.spout.MongoCappedCollectionSpout;
import backtype.storm.Config;
import backtype.storm.LocalCluster;
import backtype.storm.generated.StormTopology;
import backtype.storm.topology.TopologyBuilder;
import backtype.storm.tuple.Fields;

import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;

/**
 * 
 * Quick and dirty test. Parts of this should probably be turned into a proper
 * integration test.
 * 
 * @author Dan Beaulieu
 *
 */
public class MongoTailableCursorTopology {
	
	public static StormTopology buildTopology() {
		TopologyBuilder builder = new TopologyBuilder();
		
		// declare name of spouts and bolts
		String mongoCappedCollectionSpoutId = "mongoCappedCollectionSpout";
        String counterHotBoltId = "counterHotBolt";
        String intermediateRankerBoltId = "intermediateRankerBolt";
        String totalRankerBoltId = "totalRankerBolt";
        String mongoWriterBoltId = "mongoWriterBolt";
        String counterRankBoltId = "counterRankBolt";
		
		// set spout to read from capped collection by tailable cursor
        MongoCappedCollectionSpout mongoSpout = new MongoCappedCollectionSpout(Constants.MONGO_HOST, Constants.MONGO_PORT,
        																	   Constants.MONGO_DB_EVENTMAP_NAME, Constants.USER_INTERACT_LOG_COLLECTION, new BasicDBObject()) {

        	/**
			 * Adds a default serial version ID to the selected type.
			 */
			private static final long serialVersionUID = 1L;

			@Override
			public List<Object> dbObjectToStormTuple(DBObject document) {
				
				return tuple(document);
			}
        	
        };
        builder.setSpout(mongoCappedCollectionSpoutId, mongoSpout, 1);
        
        // set bolt to find top 10 hot event
        builder.setBolt(counterHotBoltId, new RollingCountBolt(9, 3), 2).fieldsGrouping(mongoCappedCollectionSpoutId, new Fields("eventId"));
        builder.setBolt(intermediateRankerBoltId, new IntermediateRankingsBolt(Constants.TOP_N), 2).fieldsGrouping(counterHotBoltId, new Fields("obj"));
        builder.setBolt(totalRankerBoltId, new TotalRankingsBolt(Constants.TOP_N)).globalGrouping(intermediateRankerBoltId);

        // set bolt to write the top 10 hot event to DB
        builder.setBolt(mongoWriterBoltId, new MongoWriterBolt(Constants.MONGO_HOST, Constants.MONGO_PORT,
        													   Constants.MONGO_DB_EVENTMAP_NAME, Constants.TRENDING_HOT_EVENT_COLLECTION)).globalGrouping(totalRankerBoltId);
        
        // set bolt to calculate rank of event and update this event
        builder.setBolt(counterRankBoltId, new CountRankEventBolt(), 2).fieldsGrouping(mongoCappedCollectionSpoutId, new Fields("eventId"));
        
		return builder.createTopology();
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {
		
		// mongo stuff
//        Mongo mongo = new Mongo(new MongoURI("mongodb://" + Constants.MONGO_HOST + ":" + Constants.MONGO_PORT));
//        //mongo.dropDatabase(Constants.MONGO_DB_EVENTMAP_NAME);
//        
//        // create userInteractLog collection
//        final BasicDBObject options = new BasicDBObject("capped", true);
//        options.put("size", 10000);
//        mongo.getDB(Constants.MONGO_DB_EVENTMAP_NAME).createCollection(Constants.USER_INTERACT_LOG_COLLECTION, options);
//        
//        // create trendingHotEvent collection
//        options.put("size", Constants.TOP_N);
//        mongo.getDB(Constants.MONGO_DB_EVENTMAP_NAME).createCollection(Constants.TRENDING_HOT_EVENT_COLLECTION, options);
        
        Config conf = new Config();
//        conf.setDebug(true);
        
        LocalCluster cluster = new LocalCluster();
        String topologyName = "trendingHot";
        cluster.submitTopology(topologyName, conf, buildTopology());
	}
}
