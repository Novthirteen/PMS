/*
 * Created on 2004-11-14
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.helpdesk;
import com.aof.component.BaseServices;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import java.util.ArrayList;
import java.util.List;

/**
 * @author yech
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class CallActionTrackService extends BaseServices{
	
	public CallActionHistory find(Integer callActionTrackID){
		CallActionHistory callActionTrack=null;
		Session sess = null;
		try {
			sess=this.getSession();
			callActionTrack = (CallActionHistory) sess.load(CallActionHistory.class ,callActionTrackID);
		} catch (HibernateException e) {
			e.printStackTrace();
		} 
		finally {
			this.closeSession();
		}
		return callActionTrack;
	}
	
	public List listActionTrack(Integer callID) throws HibernateException
	{
		if(callID==null)
		{
			throw new RuntimeException("callID mustn't be null");
		}
		try{
		    getSession();
		    return listActionTrack(callID, session);
		} 
		finally{
			this.closeSession();
		}
	}
	
	public static List listActionTrack(Integer callId, Session sess) throws HibernateException {
		return sess.find("from CallActionHistory as cah where cah.callMaster.callID=? order by cah.id ", callId, Hibernate.INTEGER);
	}
	
	public Float getSumOfActionSpentHour(Integer callId,Session sess) throws HibernateException {
		List result=sess.find("select sum(cah.cost) from CallActionHistory as cah where cah.callMaster.callID=?  ", callId, Hibernate.INTEGER);
		Float retVal= (Float) result.iterator().next();
		if (retVal==null) retVal=new Float(0);
		return retVal;
	}
	
	public List listStatusChange(Integer callID) throws HibernateException
	{
		if(callID==null)
		{
			throw new RuntimeException("callID mustn't be null");
		}
		List retVal=new ArrayList();
		Session sess=null;
		try{
			sess=this.getSession();
			retVal=sess.find("from CallStatusHistory as csh where csh.callActionHistory.callMaster.callID=? order by csh.Id ",callID,Hibernate.INTEGER);
		} 
		finally{
			this.closeSession();
		}
		return retVal;
	}
	
	public List listAttachment(String attachmentID) throws HibernateException
	{
		List retVal=new ArrayList();
		if(attachmentID==null)
		{
			return retVal;
		}
		Session sess=null;
		try{
			sess=this.getSession();
			retVal=sess.find("from attachment as att where att.attachId=? order by att.attachSerialno",attachmentID,Hibernate.STRING);
		} 
		finally{
			this.closeSession();
		}
		return retVal;
	}
	
	public boolean update(CallActionHistory callActionHistory) throws HibernateException {
		CallService cs=new CallService();
		CallMaster call=cs.find(callActionHistory.getCallMaster().getCallID());
		boolean statusChange= !(call.getStatus().getId().equals(callActionHistory.getCallMaster().getStatus().getId()));
			
		Session sess = this.getSession();

		Transaction tx = null;
		try {
			tx = sess.beginTransaction();
			callActionHistory.getModifyLog().setModifyDate(new java.util.Date());
			sess.update(callActionHistory);
			if (statusChange) {
				this.newStatusChangeHistory(call,callActionHistory,sess);
			}
			this.updateCall(call,callActionHistory,sess);
			sess.flush();
			tx.commit();

		} catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		} finally {
			this.closeSession();
		}
		return true;
	}

	public boolean insert(CallActionHistory callActionHistory) throws HibernateException {
		CallService cs=new CallService();
		CallMaster call=cs.find(callActionHistory.getCallMaster().getCallID());
		boolean statusChange= !(call.getStatus().getId().equals(callActionHistory.getCallMaster().getStatus().getId()));
		
		Session sess = this.getSession();
		Transaction tx = null;
		try {
			tx = sess.beginTransaction();
			callActionHistory.getModifyLog().setCreateDate(new java.util.Date());
			callActionHistory.getModifyLog().setModifyDate(new java.util.Date());
			sess.save(callActionHistory);
			if (statusChange) {
				this.newStatusChangeHistory(call,callActionHistory,sess);
			}
			this.updateCall(call,callActionHistory,sess);
			sess.flush();
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		} finally {
			this.closeSession();
		}
		return true;
	}
	
	private void updateCall(CallMaster call,CallActionHistory callActionHistory,Session sess) throws HibernateException {
		StatusTypeService statusTypeService=new StatusTypeService();
		StatusType statusType=null;
		StatusType callStatusType=statusTypeService.findStatusType(call.getStatus().getId(),sess);
		if (call.getResponseDate()==null) {
			statusType=statusTypeService.getStatusType(sess,StatusTypeService.STATUS_FLAG_RESPONSE);
			if (callStatusType.getLevel().intValue()>=statusType.getLevel().intValue()) {
				call.setResponseDate(callActionHistory.getModifyLog().getModifyDate());
			}
		}
		statusType=statusTypeService.getStatusType(sess,StatusTypeService.STATUS_FLAG_SOLVED);
		if (call.getSolvedDate()==null) {
			if ((callStatusType.getLevel().intValue()== 3) || (callStatusType.getLevel().intValue()==4) || (callStatusType.getLevel().intValue()==5 )) {
				call.setSolvedDate(callActionHistory.getModifyLog().getModifyDate());
				call.setSolveUser(callActionHistory.getModifyLog().getModifyUser());
			}
		} else {
			if ((callStatusType.getLevel().intValue()== 2) || (callStatusType.getLevel().intValue()==6) || (callStatusType.getLevel().intValue()==7 )) {
				call.setSolvedDate(null);
				call.setSolveUser(null);
				call.setClosedDate(null);
			}
		}
		if (call.getClosedDate()==null) {
			statusType=statusTypeService.getStatusType(sess,StatusTypeService.STATUS_FLAG_CLOSED);
			if (callStatusType.getLevel().intValue()>=statusType.getLevel().intValue()) {
				call.setClosedDate(callActionHistory.getModifyLog().getModifyDate());
			}
		} else {
			if (callStatusType.getLevel().intValue()<statusType.getLevel().intValue()) {
				call.setClosedDate(null);
			}
		}
		call.setSumCost(this.getSumOfActionSpentHour(call.getCallID(),sess).floatValue());
		sess.update(call);
	}
	
	private void newStatusChangeHistory(CallMaster call,CallActionHistory callActionHistory,Session sess) throws HibernateException {
		CallStatusHistory csh=new CallStatusHistory();
		csh.setCallActionHistory(callActionHistory);
		csh.setStatusOld(call.getStatus());
		call.setStatus(callActionHistory.getCallMaster().getStatus());
		csh.setStatusNew(call.getStatus());
		csh.getModifyLog().setCreateDate(new java.util.Date());
		csh.getModifyLog().setModifyDate(new java.util.Date());
		csh.getModifyLog().setCreateUser(callActionHistory.getModifyLog().getModifyUser());
		csh.getModifyLog().setModifyUser(callActionHistory.getModifyLog().getModifyUser());
		sess.save(csh);
		sess.update(call);
	}
	
	public boolean delete(Integer callActionTrackID) throws HibernateException {
		Session sess = this.getSession();
		Transaction tx = null;
		try{
			tx = sess.beginTransaction();
			sess.delete("from CallStatusHistory as csh where csh.callActionHistory.id=?",callActionTrackID,Hibernate.INTEGER);
			sess.delete("from CallActionHistory as cah where cah.id=?",callActionTrackID,Hibernate.INTEGER);
			sess.flush();
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		}
		finally{
			this.closeSession();
		}
		return true;
	}
	
}

