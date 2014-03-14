package com.aof.core.persistence.hibernate;

import net.sf.hibernate.Session;

import java.lang.reflect.Method;

class FindWithNamedQueryCommand implements Command {
    public Object execute(Method method, Object[] args, Session session) throws Exception {
        Query query = GlobalQueryFactory.get().getNamedQuery(getNamedQueryString(method));
        for (int i = 0; i < args.length; i++) {
            query.setParameter(i, args[i]);
        }
        return query.execute();
    }

    private String getNamedQueryString(Method method) {
        String clazz = method.getDeclaringClass().getName();
        return clazz + "." + method.getName();
    }
}
