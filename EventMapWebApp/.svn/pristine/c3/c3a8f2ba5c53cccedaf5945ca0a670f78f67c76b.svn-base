/**
 * 
 */
package vn.com.lco.webapp.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

import vn.com.lco.webapp.Constants;

/**
 * @author Huy
 *
 */
public class DateUtils {
	public static String getFormattedDate(String patten, String date) {
		
		if (CommonUtils.isNullOrEmptyString(date)) {
			return null;
		}
		
		return formatDate(patten, obtainDateFromAPI(date));
	}
	
	public static Date obtainDateFromAPI(String date) {
		
		if (CommonUtils.isNullOrEmptyString(date)) {
			return null;
		}
		
		return new Date(Long.parseLong(date));
	}
	
	public static String getDefaultFormattedDate(String date) {
		return getFormattedDate(Constants.dateFormat.DD_MM_YYY, date);
	}
	
	public static String getDefaultFormattedDate(Date date) {
		return formatDate(Constants.dateFormat.DD_MM_YYY, date);
	}
	
	public static String formatDate(String patten, Date date) {
		if (date == null) return "";
		SimpleDateFormat df = new SimpleDateFormat(patten);
		return df.format(date);
	}
}
