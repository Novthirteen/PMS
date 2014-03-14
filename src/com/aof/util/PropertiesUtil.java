package com.aof.util;


import java.util.*;
import java.io.FileInputStream;

public class PropertiesUtil {

    public static final String PROPERTIES_PATH = "aof.dir";   
    public static final String AOF_SYSTEM_HOME = System.getProperty(PROPERTIES_PATH);
    public static final String AOF_SYSTEM_PROFILE = System.getProperty(PROPERTIES_PATH) + "/etc/aof.properties";
    private static Properties prop = null;

    /**load a property*/
    public static String getProperty(String propertyName) {
        try {
            if( prop == null ) {                
                prop = new Properties();                
                prop.load(new FileInputStream(AOF_SYSTEM_PROFILE));
            }       
            return AOF_SYSTEM_HOME + "/etc/" + prop.get(propertyName);
			
        } catch( Exception ex ) {
            ex.printStackTrace();  
            return "";  
        }
    }
    
	public static String getPropertyValue(String propertyName) {
		try {
			if( prop == null ) {                
				prop = new Properties();                
				prop.load(new FileInputStream(AOF_SYSTEM_PROFILE));
			}       
			return prop.get(propertyName).toString();
			
		} catch( Exception ex ) {
			ex.printStackTrace();  
			return "";  
		}
	}
    
    
}
    
    
