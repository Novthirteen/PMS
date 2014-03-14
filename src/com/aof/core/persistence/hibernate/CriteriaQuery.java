package com.aof.core.persistence.hibernate;

public interface CriteriaQuery extends CommonQuery {

    CriteriaQuery add(Expression expression);

    CriteriaQuery addOrder(Order order);
}
