/**
 * 
 */
package vn.com.lco.webapp.models;

/**
 * @author Huy
 * 
 */
public class Location {

	private String lat;
	private String lon;
	
	/**
	 * 
	 */
	public Location() {
		super();
	}

	/**
	 * @param lon
	 * @param lat
	 */
	public Location(String lon, String lat) {
		super();
		this.lon = lon;
		this.lat = lat;
	}
	
	public Location(String[] loc) {
		super();
		this.lon = loc[1];
		this.lat = loc[0];
	}
	
	/**
	 * @return the lat
	 */
	public String getLat() {
		return lat;
	}

	/**
	 * @param lat the lat to set
	 */
	public void setLat(String lat) {
		this.lat = lat;
	}

	/**
	 * @return the lon
	 */
	public String getLon() {
		return lon;
	}

	/**
	 * @param lon the lon to set
	 */
	public void setLon(String lon) {
		this.lon = lon;
	}
	
	@Override
	public String toString() {
		return new StringBuilder().append(lat).append(",").append(lon).toString();
	}
}
