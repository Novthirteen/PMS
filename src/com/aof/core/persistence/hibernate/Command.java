package com.aof.core.persistence.hibernate;


public interface Command {
    Object execute(java.lang.reflect.Method method, Object[] args, net.sf.hibernate.Session session) throws Exception;
    
}
