package com.aof.core.persistence.hibernate;

public class LookupException extends Exception {
    public LookupException(String message, Throwable cause) {
        super(message, cause);
    }

    public LookupException(String message) {
        super(message);
    }
}
