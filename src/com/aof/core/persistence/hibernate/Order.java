package com.aof.core.persistence.hibernate;

public class Order {
    private net.sf.hibernate.expression.Order order;

    private Order(net.sf.hibernate.expression.Order order) {
        this.order = order;
    }

    net.sf.hibernate.expression.Order getOrder() {
        return order;
    }

    public static Order asc(String propertyName) {
        return new Order(net.sf.hibernate.expression.Order.asc(propertyName));
    }

    public static Order desc(String propertyName) {
        return new Order(net.sf.hibernate.expression.Order.desc(propertyName));
    }
}
