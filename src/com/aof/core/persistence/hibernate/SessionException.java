package com.aof.core.persistence.hibernate;

public class SessionException extends Exception {
    public SessionException(String message, Throwable cause) {
        super(message, cause);
    }
}