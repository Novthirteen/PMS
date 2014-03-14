/*
 * Created on 2004-11-15
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action;

/**
 * @author nicebean
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ActionException extends RuntimeException {
    private String key;
    private Object values[];
    public ActionException(String key) {
        this(key, null);
    }
    
    public ActionException(String key, Object values[]) {
        super(key);
        this.key = key;
        this.values = values;
    }
    
    public ActionException(String key, Object v1) {
        super(key);
        this.key = key;
        this.values = new Object[]{v1};
    }
    
    public ActionException(String key, Object v1,Object v2) {
        super(key);
        this.key = key;
        this.values = new Object[]{v1,v2};
    }


    public String getKey() {
        return key;
    }
    
    public Object[] getValues() {
        return values;
    }
}
