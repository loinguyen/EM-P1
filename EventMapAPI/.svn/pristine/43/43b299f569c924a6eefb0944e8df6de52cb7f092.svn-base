/**
 * 
 */
package vn.com.lco.utility;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

import vn.com.lco.constants.Constants;

/**
 * @author Huy
 *
 */
public class DateUtils {
	
	public static String getFormattedDate(String patten, String date) {
		
		if (date == null || date.isEmpty()) {
			return null;
		}
		
		return formatDate(patten, obtainDateFromAPI(date));
	}
	
	public static Date obtainDateFromAPI(String date) {
		
		if (date == null || date.isEmpty()) {
			return null;
		}
		
		return new Date(Long.parseLong(date));
	}
	
	public static String getDefaultFormattedDate(String date) {
		return getFormattedDate(Constants.dateFormat.DD_MM_YYY, date);
	}
	
	public static String formatDate(String patten, Date date) {
		TimeZone utc = TimeZone.getTimeZone("UTC");
		SimpleDateFormat df = new SimpleDateFormat(patten);
		df.setTimeZone(utc);
		return df.format(date);
	}
	
	public static Date converDatefromString (String dateString) {
		Date convertedDate;
		try {
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/mm/dd"); 
			convertedDate = dateFormat.parse(dateString); 
	    
		} catch(ParseException e) {
			// if cannot parse return null
			convertedDate = null;
		}
	    return convertedDate;
	}
}
