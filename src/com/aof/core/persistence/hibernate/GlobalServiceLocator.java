package com.aof.core.persistence.hibernate;


public class GlobalServiceLocator {
    private static ServiceLocator instance;

    public static ServiceLocator get() {
        if (instance == null) {
            instance = new ServiceLocatorImpl();
        }
        return instance;
    }

    public static void set(ServiceLocator locator) {
        instance = locator;
    }
}
