package vn.com.lco.dto;

import java.util.List;

import vn.com.lco.model.Message;


public class MessageDTO {
	
	private String conversId;
	private String sender;
	private String receiver;
	private List <Message> messageList;
	
	
	public String getConversId() {
		return conversId;
	}
	public void setConversId(String conversId) {
		this.conversId = conversId;
	}
	public String getSender() {
		return sender;
	}
	public void setSender(String sender) {
		this.sender = sender;
	}
	public String getReceiver() {
		return receiver;
	}
	public void setReceiver(String receiver) {
		this.receiver = receiver;
	}
	public List<Message> getMessageList() {
		return messageList;
	}
	public void setMessageList(List<Message> messageList) {
		this.messageList = messageList;
	}
	
}
