/*
 * Created on 2004-11-10
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form;

/**
 * @author shilei
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class FormattingException extends RuntimeException {
	private Throwable cause;

	public FormattingException(String message) {
		super(message);
	}

	public FormattingException(String message, Throwable cause) {
		super(message);
		this.cause = cause;
	}

	public void setCause(Throwable cause) {
		this.cause = cause;
	}

	public Throwable getCause() {
		return cause;
	}

	public String toString() {
		return super.toString()
				+ (cause == null ? "" : "\nOriginal Cause:\n"
						+ cause.toString());
	}

	public void printStackTrace() {
		super.printStackTrace();
		if (cause != null) {
			cause.printStackTrace();
		}
	}

	private Formatter formatter;

	public Formatter getFormatter() {
		return formatter;
	}

	public void setFormatter(Formatter formatter) {
		this.formatter = formatter;
	}
}