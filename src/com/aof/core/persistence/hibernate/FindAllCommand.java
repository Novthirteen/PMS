package com.aof.core.persistence.hibernate;


import java.lang.reflect.Method;

class FindAllCommand implements Command {
    public Object execute(Method method, Object[] args, net.sf.hibernate.Session session) throws Exception {
        return session.find(constructFindString(method));
    }

    private String constructFindString(Method method) throws LookupException {
        Method findByPKMethod = getFindByPKMethod(method);
        String className = extractClassNameFromReturnType(findByPKMethod);
        return "from " + className;
    }

    private String extractClassNameFromReturnType(Method method) {
        String fqName = method.getReturnType().getName();
        return fqName.substring(fqName.lastIndexOf('.') + 1);
    }

    private Method getFindByPKMethod(Method method) throws LookupException {
        Class declaringClass = method.getDeclaringClass();
        Method[] allMethods = declaringClass.getMethods();
        for (int i = 0; i < allMethods.length; i++) {
            Method meth = allMethods[i];
            if (meth.getName().endsWith("findByPrimaryKey")) {
                return meth;
            }
        }
        throw new LookupException(
                "No findByPrimaryKey method found in Manager interface.  findAll() cannot know its return type");
    }
}
