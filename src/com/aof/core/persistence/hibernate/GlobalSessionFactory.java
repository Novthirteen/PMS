package com.aof.core.persistence.hibernate;

public class GlobalSessionFactory {
    private static SessionFactory instance;

    public static SessionFactory get() {
        if (instance == null) {
            instance = new SessionFactoryImpl();
        }
        return instance;
    }

    public static void set(SessionFactory factory) {
        instance = factory;
    }
}
