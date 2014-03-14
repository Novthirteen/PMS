package com.aof.core.persistence.hibernate;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.util.*;

import net.sf.hibernate.Session;
import net.sf.hibernate.HibernateException;
import org.apache.log4j.Logger;
import org.apache.log4j.LogManager;

class ServiceLocatorImpl implements ServiceLocator {
    private static final Map COMMANDS = new Hashtable();
    private static final Command FIND_WITH_NAMED_QUERY_COMMAND = new FindWithNamedQueryCommand();
    private List validatedClasses = new Vector();

    public ServiceLocatorImpl() {
        COMMANDS.put("add", new AddCommand());
        COMMANDS.put("update", new UpdateCommand());
        COMMANDS.put("remove", new RemoveCommand());
        COMMANDS.put("findByPrimaryKey", new FindByPrimaryKeyCommand());
        COMMANDS.put("findAll", new FindAllCommand());
    }

    public Object getDomainObjectManager(Class managerClass) throws ServiceLocatorException {
        validate(managerClass);
        return Proxy.newProxyInstance(managerClass.getClassLoader(), new Class[]{managerClass},
                                      new ManagerDelegate());
    }

    private void validate(Class managerClass) throws ServiceLocatorException {
        if (!validatedClasses.contains(managerClass)) {
            validateIsInterface(managerClass);
            validateHasCRUDlikeAPI(managerClass);
            validatedClasses.add(managerClass);
        }
    }

    private void validateIsInterface(Class managerClass) throws ServiceLocatorException {
        if (!managerClass.isInterface()) {
            throw exceptionFactory(managerClass, " is not an Interface");
        }
    }

    private void validateHasCRUDlikeAPI(Class managerClass) throws ServiceLocatorException {
        Method[] methods = managerClass.getMethods();
        List mgrMethods = new ArrayList(methods.length);
        for (int i = 0; i < methods.length; i++) {
            Method method = methods[i];
            mgrMethods.add(method.getName());
        }
        if (!mgrMethods.containsAll(COMMANDS.keySet())) {
            throw exceptionFactory(managerClass,
                                   " must contain all of the following methods: 'add', 'update', 'remove', " +
                                   "'findByPrimaryKey', 'findAll'");
        }
    }

    private ServiceLocatorException exceptionFactory(Class managerClass, String message) {
        return new ServiceLocatorException("The supplied Class object (" + managerClass.getName() + ") " + message);
    }

    private static class ManagerDelegate implements InvocationHandler {
        private Logger log = LogManager.getLogger(getClass());

        public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
            Command command = resolveCommand(method);
            if (command == null) {
                throw new UnsupportedOperationException();
            }
            try {
                return command.execute(method, args, getSession());
            } catch (Exception e) {
                invalidateSession();
                throw e;
            }
        }

        private Command resolveCommand(Method method) {
            Command result = (Command) COMMANDS.get(method.getName());
            if (result == null && method.getName().startsWith("find")) {
                //If it is not one of the default commands but it begins with 'find', assume it is a finder for
                //named queries
                result = FIND_WITH_NAMED_QUERY_COMMAND;
            }
            return result;
        }

        private Session getSession() throws SessionException {
            Session session = ThreadSessionHolder.get();

            if (!session.isConnected()) {
                try {
                    session.reconnect();
                } catch (HibernateException he) {
                    throw new SessionException("Could not reconnect the session", he);
                }
            }
            return session;
        }

        private void invalidateSession() {
            try {
                ThreadSessionHolder.get().close();
            } catch (HibernateException e) {
                log.error("Unable to close the session");
            }
            ThreadSessionHolder.set(null);
        }
    }
}
