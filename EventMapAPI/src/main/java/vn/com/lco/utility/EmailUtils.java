package vn.com.lco.utility;
/**
 * 
 */

import java.io.UnsupportedEncodingException;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 * @author Huy
 *
 */
public class EmailUtils {

	public static void sendEmail(String toAddress, String subject, String body) {
//		final String fromUserName = PropertiesUtils.readProperty("username"); 
//		final String fromUserPassword = PropertiesUtils.readProperty("password");
//		
//		Properties props = new Properties();
//		props.put("mail.smtp.auth", "true");
//		props.put("mail.smtp.starttls.enable", "true");
//		props.put("mail.smtp.host", "smtp.gmail.com");
//		props.put("mail.smtp.port", "587");
// 
//		String encodingOptions = "text/html; charset=UTF-8";
//		
//		Session session = Session.getInstance(props,
//		  new javax.mail.Authenticator() {
//			@Override
//			protected PasswordAuthentication getPasswordAuthentication() {
//				return new PasswordAuthentication(fromUserName, fromUserPassword);
//			}
//		  });
// 
		Properties props = new Properties();
		props.put("mail.smtp.starttls.enable", "false");
		props.put("mail.smtp.host", "localhost");
		props.put("mail.smtp.port", "25");
 
		String encodingOptions = "text/html; charset=UTF-8";
		
		Session session = Session.getInstance(props);
		
		try {
 
			MimeMessage message = new MimeMessage(session);
			message.setHeader("Content-Type", encodingOptions);			
			message.setFrom(new InternetAddress("noreply@eventmap.vn", "EventMap"));
			message.setReplyTo(InternetAddress.parse("whitehorse132@gmail.com"));
			message.setRecipients(Message.RecipientType.TO,
				InternetAddress.parse(toAddress));
			message.setSubject(subject, "UTF-8");
			message.setContent(body, encodingOptions);
			
			Transport.send(message);
 
		} catch (MessagingException e) {
			throw new RuntimeException(e);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}
	
	public static void sendActivationEmail(String email, String userId, String activationId) {
		String webUrl = PropertiesUtils.readProperty("web.url");
		String activationLink = PropertiesUtils.readProperty("handle.email.url") + activationId;
		String subject = "Xác nhận tài khoản tại eventmapvn";
		String body = new StringBuilder().append("Xin chào ").append(userId).append(",<br />Chào mừng bạn đến với eventmap!<br />Đây là email xác nhận tài khoản tại <a href='").append(webUrl).append("'>eventmap</a>.<br />Vui lòng nháy vào <a href='").append(activationLink).append("'> đây </a>để kích hoạt tài khoản.<br />Thân ái,<br /><br />EventMap. ").toString();
		
		sendEmail(email, subject, body);
	}
	
	public static void sendResetPwdEmail(String email, String userId, String activationId) {
		String webUrl = PropertiesUtils.readProperty("web.url");
		String activationLink = PropertiesUtils.readProperty("handle.email.url") + activationId;
		String subject = "Khôi phục mật khẩu tại eventmapvn";
		String body = new StringBuilder().append("Xin chào ").append(userId).append(",<br />Đây là email xác nhận yêu cầu mật khẩu mới tại <a href='").append(webUrl).append("'>eventmap</a>.<br />Vui lòng nháy vào <a href='").append(activationLink).append("'> đây </a>để xác nhận yêu cầu.<br />Thân ái,<br /><br />EventMap. ").toString();
		
		sendEmail(email, subject, body);
	}
	
	public static void sendNewPwdEmail(String email, String userId, String newpwd) {
		String webUrl = PropertiesUtils.readProperty("web.url");
		String subject = "Mật khẩu mới tại eventmapvn";
		String body = new StringBuilder().append("Xin chào ").append(userId).append(",<br />Mật khẩu mới của bạn tại <a href='").append(webUrl).append("'>eventmap</a> là: ").append(newpwd).append("<br />Vui lòng đang nhập và đổi mật khẩu.<br />Thân ái,<br /><br />EventMap. ").toString();
		
		sendEmail(email, subject, body);
	}
}
