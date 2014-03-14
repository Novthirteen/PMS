package com.aof.core.persistence.hibernate.util;

public interface PropertyManager {
    String getPropertyValue(String propertyName);
    String getPropertyValue(String propertyName, String defaultValue);
}
