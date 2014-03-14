package com.aof.core.persistence.hibernate;

import java.util.List;

interface CommonQuery {
    List execute() throws LookupException;

    void setFirstResult(int firstResult);

    void setMaxResults(int maxResults);
}
