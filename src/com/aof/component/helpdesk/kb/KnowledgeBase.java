/*
 * Created on 2004-11-26
 *
 */
package com.aof.component.helpdesk.kb;


/**
 * @author nicebean
 *
 */
public class KnowledgeBase extends SimpleKnowledgeBase {
    private String solution;

    public String getSolution() {
        return solution;
    }

    public void setSolution(String solution) {
        this.solution = solution;
    }

    public boolean equals(Object obj) {
        if (obj == null) return false;
        if (this == obj) return true;
        if (!(obj instanceof KnowledgeBase)) return false;
        KnowledgeBase that = (KnowledgeBase)obj;
        if (this.getId() != null) {
            return this.getId().equals(that.getId());
        }
        return that.getId() == null;	
    }

}

