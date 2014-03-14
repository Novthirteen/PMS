/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.core.persistence.util;

/**
 * @author xxp 
 * @version 2003-10-25
 *
 */
public class EntityDelegator {

	public EntityDelegator() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Long getNextSeqId(String seqName) {
			SequenceUtil sequencer = null;
			synchronized (this) {
				sequencer = new SequenceUtil("SEQUENCE_VALUE_ITEM", "SEQ_NAME", "SEQ_ID", seqName);
			}
			if (sequencer != null) {
				return sequencer.getNextSeqId(seqName);
			} else {
				return null;
			}
		}
}
