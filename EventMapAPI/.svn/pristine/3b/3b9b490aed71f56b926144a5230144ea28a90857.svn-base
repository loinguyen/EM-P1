/**
 * 
 */
package vn.com.lco.utility;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

/**
 * @author Huy
 *
 */
public class PropertiesUtils {
	public static String readProperty(String key) {
		
		Properties prop = new Properties();
		
    	try {
               //load a properties file
    		prop.load(new FileInputStream(PropertiesUtils.class.getClassLoader().getResource("EventMapConfig.properties").getPath()));
 
               //get the property value and print it out
             return prop.getProperty(key);
    		 
    	} catch (IOException ex) {
    		ex.printStackTrace();
    		return null;
        }
	}
	
	public static List<String> readProperties(List<String> listKey) {
		Properties prop = new Properties();
		
    	try {
    		
    		List<String> resultList = new ArrayList<String>();
    		
               //load a properties file
    		prop.load(new FileInputStream(PropertiesUtils.class.getClassLoader().getResource("EventMapConfig.properties").getPath()));
 
            for (String key : listKey) {
            	resultList.add(prop.getProperty(key));
            }
            
            return resultList;
    		 
    	} catch (IOException ex) {
    		ex.printStackTrace();
    		return null;
        }
	}
}
