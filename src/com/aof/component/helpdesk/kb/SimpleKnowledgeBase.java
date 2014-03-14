/*
 * Created on 2004-11-28
 *
 */
package com.aof.component.helpdesk.kb;

import java.io.Serializable;

import com.aof.component.domain.party.Party;
import com.aof.component.helpdesk.CallMaster;
import com.aof.component.helpdesk.servicelevel.SLACategory;

/**
 * @author nicebean
 *
 */
public class SimpleKnowledgeBase implements Serializable  {
    /** identifier field */
    private Integer id;

    private SLACategory category;
    
    private Party customer;
    
    private Party originalCustomer;
    
    /*
    private CallMaster call;
    */
    private String subject;
    
    private String problemDesc;
    /*
    private String keyword;
    */
    private String problemAttachGroupId;
    
    private String solutionAttachGroupId;
    
    private boolean published;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public SLACategory getCategory() {
        return category;
    }

    public void setCategory(SLACategory category) {
        this.category = category;
    }

    public Party getCustomer() {
        return customer;
    }

    public void setCustomer(Party customer) {
        this.customer = customer;
    }

    public Party getOriginalCustomer() {
        return originalCustomer;
    }

    public void setOriginalCustomer(Party originalCustomer) {
        this.originalCustomer = originalCustomer;
    }
    /*
    public CallMaster getCall() {
        return call;
    }
    
    public void setCall(CallMaster call) {
        this.call = call;
    }
    */
    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getProblemDesc() {
        return problemDesc;
    }

    public void setProblemDesc(String problemDesc) {
        this.problemDesc = problemDesc;
    }
    /*
    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }
    */
    public String getProblemAttachGroupId() {
        return problemAttachGroupId;
    }

    public void setProblemAttachGroupId(String problemAttachGroupId) {
        this.problemAttachGroupId = problemAttachGroupId;
    }

    public String getSolutionAttachGroupId() {
        return solutionAttachGroupId;
    }

    public void setSolutionAttachGroupId(String solutionAttachGroupId) {
        this.solutionAttachGroupId = solutionAttachGroupId;
    }

    public boolean getPublished() {
        return published;
    }
    
    public void setPublished(boolean published) {
        this.published = published;
    }
    
    public boolean equals(Object obj) {
        if (obj == null) return false;
        if (this == obj) return true;
        if (!(obj instanceof SimpleKnowledgeBase)) return false;
        SimpleKnowledgeBase that = (SimpleKnowledgeBase)obj;
        if (this.getId() != null) {
            return this.getId().equals(that.getId());
        }
        return that.getId() == null;	
    }

}

