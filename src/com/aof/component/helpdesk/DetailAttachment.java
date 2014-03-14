/*
 * Created on 2004-11-18
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.helpdesk;

/**
 * @author shilei
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class DetailAttachment extends Attachment {
	private byte[] content;
	
	/**
	 * @return Returns the pic.
	 */
	public byte[] getContent() {
		return content;
	}
	/**
	 * @param pic The pic to set.
	 */
	public void setContent(byte[] content) {
		this.content = content;
	}
}
