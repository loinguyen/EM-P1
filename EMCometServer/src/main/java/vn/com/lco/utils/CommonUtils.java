/**
 * Legend Company
 */
package vn.com.lco.utils;

import java.lang.reflect.Type;
import java.util.Date;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;

/**
 * @author OaiPanda
 *
 * CommonUtils.java
 */
public class CommonUtils {

	public static boolean isNullOrEmptyString(String str) {
		return str == null || str.isEmpty();
	}
	
	public static boolean isNotEmptyString(String str) {
		return !isNullOrEmptyString(str);
	}
	
	public static Gson getCustomizeDateGson() {
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
}
