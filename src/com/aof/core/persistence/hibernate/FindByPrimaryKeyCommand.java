package com.aof.core.persistence.hibernate;

import net.sf.hibernate.HibernateException;

import java.io.Serializable;


class FindByPrimaryKeyCommand implements Command {
    public Object execute(java.lang.reflect.Method method, Object[] args, net.sf.hibernate.Session session) throws Exception {
        try {
            return session.load(method.getReturnType(), (Serializable)args[0]);
        } catch (HibernateException e) {
            throw new LookupException("Unable to load instance", e);
        }
    }
}
