package com.aof.core.persistence.hibernate;

import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;
import net.sf.hibernate.HibernateException;

abstract class TransactionalCommand implements Command {

    public Object execute(java.lang.reflect.Method method, Object[] args, Session session) throws Exception {
        if (args == null || args[0] == null) {
            throw new PersistenceException("Null target record cannot be added, updated, or removed");
        }
        Transaction txn = session.beginTransaction();
        try {
            Object result = command(args, session);
            txn.commit();
            return result;
        } finally {
            if (!txn.wasCommitted()) {
                txn.rollback();
            }
        }
    }

    protected abstract Object command(Object[] args, Session session) throws Exception;
}
