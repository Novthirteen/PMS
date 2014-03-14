package com.aof.core.persistence.hibernate;

import java.util.Collection;
import java.util.Map;

import net.sf.hibernate.expression.Criterion;
import net.sf.hibernate.expression.SimpleExpression;

public class Expression {
    private net.sf.hibernate.expression.Expression expression;

    private Expression(net.sf.hibernate.expression.Expression exp) {
        expression = exp;
    }

    /**
	 * @param expression2
	 */
	public Expression(SimpleExpression expression2) {
	}

	/**
	 * @param criterion
	 */
	public Expression(Criterion criterion) {

	}

	net.sf.hibernate.expression.Expression getExpression() {
        return expression;
    }
    /**
	 * Apply an "equal" constraint to the named property
	 * @param propertyName
	 * @param value
	 * @return ExpressionIntf
	 */
    public static Expression eq(String propertyName, Object value) {
        return new Expression(net.sf.hibernate.expression.Expression.eq(propertyName, value));
    }
    /**
	 * Apply a "like" constraint to the named property
	 * @param propertyName
	 * @param value
	 * @return ExpressionIntf
	 */
    public static Expression like(String propertyName, Object value) {
        return new Expression(net.sf.hibernate.expression.Expression.like(propertyName, value));
    }
    /**
	 * A case-insensitive "like", similar to Postgres <tt>ilike</tt>
	 * operator
	 *
	 * @param propertyName
	 * @param value
	 * @return ExpressionIntf
	 */
    public static Expression ilike(String propertyName, Object value) {
        return new Expression(net.sf.hibernate.expression.Expression.ilike(propertyName, value));
    }
    /**
	 * Apply a "greater than" constraint to the named property
	 * @param propertyName
	 * @param value
	 * @return ExpressionIntf
	 */
    public static Expression gt(String propertyName, Object value) {
        return new Expression(net.sf.hibernate.expression.Expression.gt(propertyName, value));
    }
    /**
	 * Apply a "less than" constraint to the named property
	 * @param propertyName
	 * @param value
	 * @return ExpressionIntf
	 */
    public static Expression lt(String propertyName, Object value) {
        return new Expression(net.sf.hibernate.expression.Expression.lt(propertyName, value));
    }
    /**
	 * Apply a "less than or equal" constraint to the named property
	 * @param propertyName
	 * @param value
	 * @return ExpressionIntf
	 */
    public static Expression le(String propertyName, Object value) {
        return new Expression(net.sf.hibernate.expression.Expression.le(propertyName, value));
    }
    /**
	 * Apply a "greater than or equal" constraint to the named property
	 * @param propertyName
	 * @param value
	 * @return ExpressionIntf
	 */
    public static Expression ge(String propertyName, Object value) {
        return new Expression(net.sf.hibernate.expression.Expression.ge(propertyName, value));
    }
    /**
	 * Apply a "between" constraint to the named property
	 * @param propertyName
	 * @param lo
     * @param hi
	 * @return ExpressionIntf
	 */
    public static Expression between(String propertyName, Object lo, Object hi) {
        return new Expression(net.sf.hibernate.expression.Expression.between(propertyName, lo, hi));
    }
    /**
	 * Apply an "in" constraint to the named property
	 * @param propertyName
	 * @param values
	 * @return ExpressionIntf
	 */
    public static Expression in(String propertyName, Object[] values) {
        return new Expression(net.sf.hibernate.expression.Expression.in(propertyName, values));
    }
    /**
	 * Apply an "in" constraint to the named property
	 * @param propertyName
	 * @param values
	 * @return ExpressionIntf
	 */
    public static Expression in(String propertyName, Collection values) {
        return new Expression(net.sf.hibernate.expression.Expression.in(propertyName, values));
    }
    /**
	 * Apply an "is null" constraint to the named property
	 * @return ExpressionIntf
	 */
    public static Expression isNull(String propertyName) {
        return new Expression(net.sf.hibernate.expression.Expression.isNull(propertyName));
    }
    /**
	 * Apply an "equal" constraint to two properties
	 */
    public static Expression eqProperty(String propertyName, String otherPropertyName) {
        return new Expression(net.sf.hibernate.expression.Expression.eqProperty(propertyName, otherPropertyName));
    }
    /**
	 * Apply a "less than" constraint to two properties
	 */
    public static Expression ltProperty(String propertyName, String otherPropertyName) {
        return new Expression(net.sf.hibernate.expression.Expression.ltProperty(propertyName, otherPropertyName));
    }
    /**
	 * Apply a "less than or equal" constraint to two properties
	 */
    public static Expression leProperty(String propertyName, String otherPropertyName) {
        return new Expression(net.sf.hibernate.expression.Expression.leProperty(propertyName, otherPropertyName));
    }
    /**
	 * Apply an "is not null" constraint to the named property
	 * @return ExpressionIntf
	 */
    public static Expression isNotNull(String propertyName) {
        return new Expression(net.sf.hibernate.expression.Expression.isNotNull(propertyName));
    }
    /**
	 * Return the conjuction of two expressions
	 *
	 * @param lhs
	 * @param rhs
	 * @return ExpressionIntf
	 */
    public static Expression and(Criterion lhs, Criterion rhs) {
        return new Expression(net.sf.hibernate.expression.Expression.and(lhs, rhs));
    }
    /**
	 * Return the disjuction of two expressions
	 *
	 * @param lhs
	 * @param rhs
	 * @return ExpressionIntf
	 */
    public static Expression or(Criterion lhs, Criterion rhs) {
        return new Expression(net.sf.hibernate.expression.Expression.or(lhs,rhs));
    }
    /**
	 * Return the negation of an expression
	 *
	 * @param expression
	 * @return ExpressionIntf
	 */
    public Expression not(Criterion lhs) {
        return new Expression(net.sf.hibernate.expression.Expression.not(lhs));
    }
    /**
	 * Apply a constraint expressed in SQL. Any occurrences of <tt>$alias</tt>
	 * will be replaced by the table alias.
	 *
	 * @param sql
	 * @return ExpressionIntf
	 */
    public static Expression sql(String sql) {
        return new Expression(net.sf.hibernate.expression.Expression.sql(sql));
    }
    /**
	 * Apply an "equals" constraint to each property in the
	 * key set of a <tt>Map</tt>
	 *
	 * @param propertyNameValues a map from property names to values
	 * @return ExpressionIntf
	 */
    public static Expression allEq(Map propertyNameValues) {
        return new Expression(net.sf.hibernate.expression.Expression.allEq(propertyNameValues));
    }  
}
