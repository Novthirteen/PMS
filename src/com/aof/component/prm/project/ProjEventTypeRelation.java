package com.aof.component.prm.project;

import java.io.Serializable;
import org.apache.commons.lang.builder.ToStringBuilder;

/** @author Hibernate CodeGenerator */
public class ProjEventTypeRelation implements Serializable {

    /** persistent field */
    private Integer peventId;

    /** persistent field */
    private ProjectEventType petId;

    /** full constructor */
    public ProjEventTypeRelation(Integer peventId, ProjectEventType petId) {
        this.peventId = peventId;
        this.petId = petId;
    }

    /** default constructor */
    public ProjEventTypeRelation() {
    }

    public Integer getPeventId() {
        return this.peventId;
    }

	public void setPeventId(Integer peventId) {
		this.peventId = peventId;
	}

    public ProjectEventType getPetId() {
        return this.petId;
    }

	public void setPetId(ProjectEventType petId) {
		this.petId = petId;
	}

    public String toString() {
        return new ToStringBuilder(this)
            .toString();
    }

}
