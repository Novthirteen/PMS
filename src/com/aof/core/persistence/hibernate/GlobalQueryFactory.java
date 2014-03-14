package com.aof.core.persistence.hibernate;

public class GlobalQueryFactory {
    private static QueryFactory instance;

    public static QueryFactory get() {
        if (instance == null) {
            instance = new QueryFactoryImpl();
        }
        return instance;
    }

    public static void set(QueryFactory queryFactory) {
        instance = queryFactory;
    }
}
