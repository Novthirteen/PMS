package com.aof.core.persistence.hibernate;

import net.sf.hibernate.Session;

public class ThreadSessionHolder {
    private static ThreadLocal threadLocal = new ThreadLocal();

    public static Session get() {
        return (Session)threadLocal.get();
    }

    public static void set(Session session) {
        threadLocal.set(session);
    }
}
