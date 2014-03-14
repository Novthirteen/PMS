package com.aof.core.persistence.hibernate;

import net.sf.hibernate.HibernateException;

class RemoveCommand extends TransactionalCommand {
    protected Object command(Object[] args, net.sf.hibernate.Session session) throws Exception {
        try {
            session.delete(args[0]);
        } catch (HibernateException e) {
            throw new PersistenceException("Unable to remove object from the datastore", e);
        }
        return null;
    }
}
