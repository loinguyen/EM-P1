/**
 * Legend Company
 */
package vn.com.lco.storm.bolt;

import java.lang.reflect.Type;
import java.util.Date;
import java.util.Map;

import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.UriBuilder;

import org.apache.log4j.Logger;

import vn.com.lco.constants.Constants;
import vn.com.lco.model.Event;
import vn.com.lco.storm.util.DateUtils;
import backtype.storm.task.OutputCollector;
import backtype.storm.task.TopologyContext;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseRichBolt;
import backtype.storm.tuple.Tuple;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;
import com.mongodb.MongoException;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
import com.sun.jersey.api.representation.Form;

/**
 * @author OaiPanda
 *
 * CountRankEvent.java
 */
public class CountRankEventBolt extends BaseRichBolt {

	private static final long serialVersionUID = 1L;
	private static final Logger LOG = Logger.getLogger(CountRankEventBolt.class);

	private OutputCollector collector;
	private Event eventObj;
	
	public CountRankEventBolt() { }

	@SuppressWarnings("rawtypes")
	@Override
	public void prepare(Map stormConf, TopologyContext context, OutputCollector collector) {
		this.collector = collector;
	}

	@Override
	public void execute(Tuple tuple) {
		Object event = tuple.getValue(2);
        String operation = "";
        operation = (String) tuple.getValue(1);
        long point = 0;
        if (operation.equals(Constants.OPERATON_LIKE)) {
        	point = 2;
        } else if (operation.equals(Constants.OPERATON_SUBSCRIBE)) {
        	point = 3;
        } else if (operation.equals(Constants.OPERATON_COMMENT)) {
        	point = 4;
        } else if (operation.equals(Constants.OPERATON_UNLIKE)) {
        	point = -2;
        } else if (operation.equals(Constants.OPERATON_UNSUBSCRIBE)) {
        	point = -3;
        }
        LOG.info("CountRankEvent - execute");
        LOG.info("eventId & point: " + event + " - " + point);
        
        try {
        	this.eventObj = this.getEventFromDB(event);
        	LOG.info("event: " + this.eventObj.getId());
        	if (this.eventObj != null) {
        		this.calculateRank(point);
        		this.savePointAndRank();
        	}
        } catch (Exception ex) {
        	LOG.info(ex.getMessage());
        }
        
        collector.ack(tuple);
	}

	@Override
	public void declareOutputFields(OutputFieldsDeclarer declarer) { }
	
	/*------------------------------ Private method ---------------------------------------*/
	private Event getEventFromDB(Object event) throws Exception {

		Event eventObj = null;
		try {
			ClientConfig config = new DefaultClientConfig();
	        Client client = Client.create(config);
	        String url = Constants.API_URL;
			Form form = new Form();
			form.add("eId", (String) event);
			WebResource service = client.resource(UriBuilder.fromUri(url).build());
			String serviceRespone = service.path(Constants.REST_PATH)
									 .path(Constants.RESOURCE_PATH_SEARCH_EVENT_BY_ID)
									 .type(MediaType.APPLICATION_FORM_URLENCODED).post(String.class, form);
			LOG.info("serviceRespone: " + serviceRespone);
			Gson gson = getCustomizeDateGson();
			eventObj = gson.fromJson(serviceRespone, Event.class);
		} catch(Exception ex) {
			LOG.info(ex.getMessage());
		}
		
		return eventObj;
	}
	
	private Gson getCustomizeDateGson() {
		return new GsonBuilder().registerTypeAdapter(Date.class,
				new JsonDeserializer<Date>() {

					@Override
					public Date deserialize(JsonElement arg0, Type arg1,
							JsonDeserializationContext arg2)
							throws JsonParseException {

						return DateUtils.obtainDateFromAPI(arg0.getAsString());
					}
				}).create();
	}
	
	private void savePointAndRank() throws MongoException {
		ClientConfig config = new DefaultClientConfig();
        Client client = Client.create(config);
        String url = Constants.API_URL;
		WebResource service = client.resource(UriBuilder.fromUri(url).build());
		service.path(Constants.REST_PATH)
			   .path(Constants.RESOURCE_PATH_SAVE_EVENT)
			   .type(MediaType.APPLICATION_JSON)
			   .accept(MediaType.APPLICATION_JSON)
			   .post(String.class, this.eventObj);
	}

	private void calculateRank(long additionalPoint) {
		long currentPoint = this.eventObj.getPoint();
		LOG.info("oldPoint: " + currentPoint);
		int rank = 1;
		currentPoint = currentPoint + additionalPoint;
		if (currentPoint >= Constants.MILESTONE_1 && currentPoint < Constants.MILESTONE_2) {
			rank = 2;
		} else if (currentPoint >= Constants.MILESTONE_2 && currentPoint < Constants.MILESTONE_3) {
			rank = 3;
		} else if (currentPoint >= Constants.MILESTONE_3 && currentPoint < Constants.MILESTONE_4) {
			rank = 4;
		} else if (currentPoint >= Constants.MILESTONE_4) {
			rank = 5;
		}
		LOG.info("newPoint: " + currentPoint);
		LOG.info("newRank: " + rank);
		this.eventObj.setPoint(currentPoint);
		this.eventObj.setRank(rank);
	}
}
