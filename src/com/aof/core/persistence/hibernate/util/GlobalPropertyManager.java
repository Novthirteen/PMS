package com.aof.core.persistence.hibernate.util;

import java.util.ResourceBundle;
import java.util.Enumeration;

public class GlobalPropertyManager {
    private static PropertyManager managerInstance;

    public static PropertyManager get() {
        if (managerInstance == null) {
            ResourceBundle bundle = ResourceBundle.getBundle("config");
            PropertyManagerImpl impl = new PropertyManagerImpl();
            managerInstance = impl;
            Enumeration e = bundle.getKeys();
            while (e.hasMoreElements()) {
                String key = (String)e.nextElement();
                impl.addProperty(key, bundle.getString(key));
            }
        }
        return managerInstance;
    }

    public static void set(PropertyManager manager) {
        managerInstance = manager;
    }
}
