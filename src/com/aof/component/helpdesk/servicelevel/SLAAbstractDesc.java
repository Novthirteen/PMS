/*
 * Created on 2004-11-30
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.helpdesk.servicelevel;

import java.io.Serializable;
import java.util.Locale;

/**
 * @author nicebean
 *
 */
public abstract class SLAAbstractDesc implements Serializable {
    /** nullable persistent field */
    private String chsDesc;
    /** nullable persistent field */
    private String engDesc;
    
	private String fullchsDesc;
	private String fullengDesc;
	
    private Locale locale;

    public java.lang.String getChsDesc() {
        return this.chsDesc;
    }

	public void setChsDesc(java.lang.String chsDesc) {
		this.chsDesc = chsDesc;
	}

    public java.lang.String getEngDesc() {
        return this.engDesc;
    }

	public void setEngDesc(java.lang.String engDesc) {
		this.engDesc = engDesc;
	}

	public void setLocale(Locale locale) {
	    this.locale = locale;
	}

	public java.lang.String getFullengDesc() {
		return this.fullengDesc;
	}
	public void setFullengDesc(java.lang.String fullengDesc) {
		this.fullengDesc = fullengDesc;
	}
	
	public java.lang.String getFullchsDesc() {
		return this.fullchsDesc;
	}
	public void setFullchsDesc(java.lang.String fullchsDesc) {
		this.fullchsDesc = fullchsDesc;
	}
	
    public java.lang.String getDesc() {
        if (locale == null) return engDesc;
        if (locale.equals(Locale.CHINA) || locale.equals(Locale.CHINESE) || locale.equals(Locale.SIMPLIFIED_CHINESE)) return chsDesc;
        return engDesc;
    }
    
	public java.lang.String getFullDesc() {
		if (locale == null) return fullengDesc;
		if (locale.equals(Locale.CHINA) || locale.equals(Locale.CHINESE) || locale.equals(Locale.SIMPLIFIED_CHINESE)) return fullchsDesc;
		return fullengDesc;
	}
}
