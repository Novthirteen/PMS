package com.aof.core.persistence.hibernate;

public interface ServiceLocator {
    Object getDomainObjectManager(Class managerClass) throws ServiceLocatorException;
}
