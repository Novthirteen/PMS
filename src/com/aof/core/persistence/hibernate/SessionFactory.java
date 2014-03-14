package com.aof.core.persistence.hibernate;

import net.sf.hibernate.Session;

public interface SessionFactory {
    Session newSession() throws SessionException;

}
