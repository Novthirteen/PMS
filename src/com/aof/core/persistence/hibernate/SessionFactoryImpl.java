package com.aof.core.persistence.hibernate;

import com.aof.core.persistence.hibernate.util.GlobalPropertyManager;

import net.sf.hibernate.Session;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.cfg.Configuration;

class SessionFactoryImpl implements SessionFactory {
    private net.sf.hibernate.SessionFactory factory;
    private static final String HIBERNATE_CONFIG_FILE = "hibernate.config_file";
	

    public Session newSession() throws SessionException {
        try {
            return getSessionFactory().openSession();
        } catch (HibernateException e) {
            throw new SessionException("Unable to open new session", e);
        }
    }

    private net.sf.hibernate.SessionFactory getSessionFactory() throws SessionException {
        if (factory == null) {
            Configuration configuration = new Configuration();
            try {
                String hibernateConfigFile = GlobalPropertyManager.get().getPropertyValue(HIBERNATE_CONFIG_FILE);
                configuration.configure(hibernateConfigFile);
                factory = configuration.buildSessionFactory();
            } catch (Throwable e) {
                throw new SessionException("Unable to configure a new SessionFactory", e);
            }
        }
        return factory;
    }
}
