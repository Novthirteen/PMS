package com.aof.core.persistence.hibernate;

import net.sf.hibernate.HibernateException;

class AddCommand extends TransactionalCommand {
    protected Object command(Object[] args, net.sf.hibernate.Session session) throws Exception {
        try {
            return session.save(args[0]);
        } catch (HibernateException e) {
            throw new PersistenceException("Unable to add new object to the datastore", e);
        }
    }
}
