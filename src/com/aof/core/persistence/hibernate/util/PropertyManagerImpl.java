package com.aof.core.persistence.hibernate.util;

import com.aof.core.persistence.hibernate.util.PropertyManager;

import java.util.Properties;
import java.io.InputStream;
import java.io.IOException;

public class PropertyManagerImpl implements PropertyManager {
    private Properties properties = new Properties();

    public void loadPropertiesFromStream(InputStream in) throws IOException {
        Properties props = new Properties();
        props.load(in);
        properties.putAll(props);
    }

    public void addProperty(String propertyName, String propertyValue) {
        properties.put(propertyName, propertyValue);
    }

    public String getPropertyValue(String propertyName, String defaultValue) {
        return properties.getProperty(propertyName, defaultValue);
    }

    public String getPropertyValue(String propertyName) {
        return getPropertyValue(propertyName, null);
    }
}
