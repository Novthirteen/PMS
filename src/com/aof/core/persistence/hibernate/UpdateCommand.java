package com.aof.core.persistence.hibernate;

import net.sf.hibernate.HibernateException;

class UpdateCommand extends TransactionalCommand {
    protected Object command(Object[] args, net.sf.hibernate.Session session) throws Exception {
        try {
            session.update(args[0]);
        } catch (HibernateException e) {
            throw new PersistenceException("Unable to persist object update", e);
        }
        return null;
    }
}
