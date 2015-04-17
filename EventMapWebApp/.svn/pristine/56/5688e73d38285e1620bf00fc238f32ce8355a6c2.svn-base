/**
 * 
 */
package vn.com.lco.webapp.action;

import java.io.File;
import java.io.IOException;
import java.util.Date;

import org.apache.commons.io.FileUtils;
import org.apache.struts2.ServletActionContext;

import vn.com.lco.webapp.Constants;
import vn.com.lco.webapp.utils.DateUtils;

/**
 * @author Huy
 *
 */
public class FileAction extends BaseAction {

	private static final long serialVersionUID = 1L;
	
	private File file;
	private String fileContentType;
	private String fileFileName;
	private String album;
	private boolean coverPicture;
	private boolean avatar;
	private boolean updateEvent;
	private static String imgRoot = new StringBuilder(ServletActionContext.getServletContext().getRealPath(Constants.File_Dir.IMAGE_DIR))
										.append(File.separator).append(Constants.File_Dir.USR_IMAGE_DIR).toString();
	
	public String uploadFile() {
		
		if (avatar) {
			 String avaDir  = new StringBuilder(imgRoot).append(File.separator).append(getCurrentUserId()).toString();
			 File avaPath = new File(avaDir);			
			
			 if (!avaPath.exists()) {
				 avaPath.mkdirs();
			 }
			 File destFile  = new File(avaPath, Constants.File_Dir.AVATAR);
			 
			 try {
				FileUtils.copyFile(file, destFile);
			} catch (IOException e) {
				e.printStackTrace();
				avatar = false;
			}
			 
			return SUCCESS;
		}
		
		if (album == null || album.isEmpty()) {
			album = DateUtils.formatDate(Constants.dateFormat.YYYY_MM_DD_TIME, new Date());
		}
		
		if (coverPicture) {
			 String coverDir  = new StringBuilder(imgRoot).append(File.separator).append(updateEvent?getCurrentUserId():"tmp").append(File.separator).append(album).append(File.separator).append(Constants.File_Dir.COVER).toString();
			 File coverPath = new File(coverDir);			
			
			 if (!coverPath.exists()) {
				 coverPath.mkdirs();
			 }
			    
			File destFile  = new File(coverPath, Constants.File_Dir.COVER_IMG);
		 	try {
				FileUtils.copyFile(file, destFile);
				coverPicture = false;
			} catch (IOException e) {
				coverPicture = true;
				e.printStackTrace();
			}
		}
		
		try {
			
		    String uploadDir = new StringBuilder()
										.append(imgRoot).append(File.separator).append(updateEvent?getCurrentUserId():"tmp")
										.append(File.separator).append(album).toString();
		    File dirPath = new File(uploadDir);
		    
		    if (!dirPath.exists()) {
		        dirPath.mkdirs();
		    }
		    
			File destFile  = new File(uploadDir, fileFileName);
		 	FileUtils.copyFile(file, destFile);
		} catch (Exception ex) {
			ex.printStackTrace();
			album = null;
		}
		return SUCCESS;
	}
	
	public String removeFile() {
		
		try {
			
			String path = new StringBuilder()
								.append(imgRoot).append(File.separator).append(updateEvent?getCurrentUserId():"tmp")
								.append(File.separator).append(album).toString();
			
			File destFile  = new File(new StringBuilder().append(path)
										.append(File.separator).append(fileFileName).toString());
			FileUtils.forceDelete(destFile);
			
			File dir = new File(path);
			String[] list = dir.list();
			
			if (list.length == 0) {
				FileUtils.forceDelete(dir);
				album = null;
			}
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		
		return SUCCESS;
	}

	/**
	 * @return the file
	 */
	public File getFile() {
		return file;
	}

	/**
	 * @param file the file to set
	 */
	public void setFile(File file) {
		this.file = file;
	}

	/**
	 * @return the fileContentType
	 */
	public String getFileContentType() {
		return fileContentType;
	}

	/**
	 * @param fileContentType the fileContentType to set
	 */
	public void setFileContentType(String fileContentType) {
		this.fileContentType = fileContentType;
	}

	/**
	 * @return the fileFileName
	 */
	public String getFileFileName() {
		return fileFileName;
	}

	/**
	 * @param fileFileName the fileFileName to set
	 */
	public void setFileFileName(String fileFileName) {
		this.fileFileName = fileFileName;
	}

	/**
	 * @return the album
	 */
	public String getAlbum() {
		return album;
	}

	/**
	 * @param album the album to set
	 */
	public void setAlbum(String album) {
		this.album = album;
	}

	/**
	 * @return the updateEvent
	 */
	public boolean isUpdateEvent() {
		return updateEvent;
	}

	/**
	 * @param updateEvent the updateEvent to set
	 */
	public void setUpdateEvent(boolean updateEvent) {
		this.updateEvent = updateEvent;
	}

	/**
	 * @return the coverPicture
	 */
	public boolean isCoverPicture() {
		return coverPicture;
	}

	/**
	 * @param coverPicture the coverPicture to set
	 */
	public void setCoverPicture(boolean coverPicture) {
		this.coverPicture = coverPicture;
	}

	/**
	 * @return the avatar
	 */
	public boolean isAvatar() {
		return avatar;
	}

	/**
	 * @param avatar the avatar to set
	 */
	public void setAvatar(boolean avatar) {
		this.avatar = avatar;
	}
}
