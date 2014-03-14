package com.aof.core.persistence.hibernate;

import net.sf.hibernate.Criteria;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.expression.Criterion;

import java.util.List;



class CriteriaQueryImpl implements CriteriaQuery {
    private Criteria criteria;

    CriteriaQueryImpl(Criteria criteria) {
        this.criteria = criteria;
    }
    public List execute() throws LookupException {
        try {
            return criteria.list();
        } catch (HibernateException e) {
            throw new LookupException("Unable to execute the CriteriaQuery", e);
        }
    }

    public void setFirstResult(int firstResult) {
        criteria.setFirstResult(firstResult);
    }

    public void setMaxResults(int maxResults) {
        criteria.setMaxResults(maxResults);
    }

    public CriteriaQuery add(Criterion value) {
        criteria.add(value);
        return this;
    }

    public CriteriaQuery addOrder(Order order) {
        criteria.addOrder(order.getOrder());
        return this;
    }
	/* (non-Javadoc)
	 * @see com.aof.core.persistence.hibernate.CriteriaQuery#add(com.aof.core.persistence.hibernate.Expression)
	 */
	public CriteriaQuery add(Expression expression) {
		// TODO Auto-generated method stub
		return null;
	}
}
