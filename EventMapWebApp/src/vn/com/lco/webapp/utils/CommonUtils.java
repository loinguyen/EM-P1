/**
 * 
 */
package vn.com.lco.webapp.utils;

/**
 * @author Huy
 *
 */
public class CommonUtils {
	public static boolean isNullOrEmptyString(String str) {
		return str == null || str.isEmpty();
	}
	 public static boolean isNotEmptyString(String str) {
		 return !isNullOrEmptyString(str);
	 }
}
