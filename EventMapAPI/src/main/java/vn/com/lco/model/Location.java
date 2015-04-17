/**
 * 
 */
package vn.com.lco.model;

/**
 * @author Huy
 * 
 */
public class Location {

	private String lon;
	private String lat;

	
	
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

}
