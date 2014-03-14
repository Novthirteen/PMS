/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.domain.party;

import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;
import net.sf.hibernate.type.Type;

import com.aof.component.BaseServices;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.util.EntityUtil;

/**
 * @author xxp 
 * @version 2003-6-22
 *
 */
public class PartyServices extends BaseServices{

	public PartyServices(){
		super();
	}
	
	public Party getParty(String id) throws HibernateException
	{
		Session session=null;
		try{
			session=this.getSession();
			return getParty(id,session);
		}
		finally
		{
			this.closeSession();
		}
	}
	public Party getParty(String id,Session session) throws HibernateException
	{
		return (Party) session.get(Party.class,id);
	}

	
	/**
	 * @param userLoginId
	 * @return
	 * @throws HibernateException
	 */
	public UserLogin findUserLogin(String userLoginId) throws HibernateException {
	    try {
			getSession();
			UserLogin userLogin = null;
			userLogin = (UserLogin) session.load(UserLogin.class, userLoginId);
			return userLogin;
	    } catch (HibernateException e) {
	        throw e;
	    } finally {
	        closeSession();
	    }
	}
	
	/**
	 * @param userId
	 * @param password
	 * @return
	 * @throws HibernateException
	 */
	public boolean validateUser(String userId,String password) throws HibernateException {
	    try {
	        getSession();
	        UserLogin userLogin = (UserLogin)session.get(UserLogin.class, userId);
	        if (userLogin == null) return false;
			if (userLogin.getCurrent_password().equals(password) && userLogin.getEnable().equals("Y")) return true;
			return false;
	    } catch (HibernateException e) {
	        throw e;
	    } finally {
			closeSession();
		}
	}
	
	public List getAllCustomer() throws HibernateException {
	    try {
		    getSession();
			return getAllCustomer(session);
	    } catch (HibernateException e) {
	        throw e;
	    } finally {
	        closeSession();
	    }
	}

	public static List getAllCustomer(Session sess) throws HibernateException {
		return sess.find("select p from Party p left outer join p.partyRoles r where r.roleTypeId = ?", PartyKeys.CUSTOMER_ROLE_KEY, Hibernate.STRING);
	}

	public List getCustomer(String searchKey) throws HibernateException {
	    try {
		    getSession();
		    if (searchKey == null) {
		        searchKey = "%";
		    } else {
		        searchKey = '%' + searchKey.trim() + '%';
		    }
		    Object[] params = { PartyKeys.CUSTOMER_ROLE_KEY, searchKey, searchKey };
		    Type[] paramTypes = { Hibernate.STRING, Hibernate.STRING, Hibernate.STRING };
		    return session.find("select p from Party p left outer join p.partyRoles r where r.roleTypeId = ? and (p.partyId like ? or p.description like ?)", params, paramTypes);
		} catch (HibernateException e) {
	        throw e;
	    } finally {
	        closeSession();
	    }
	}

	public void removeRelationshipByPartyId(Session hs,String ParentPartyId,String ChildPartyId,String RelationshipType) throws HibernateException{
		Transaction tx = null;
		tx = hs.beginTransaction();
						
		Party parentParty =(Party)hs.load(Party.class,ParentPartyId);
		Set prSet = parentParty.getRelationships();
		Set newSet = new HashSet();
		if(prSet==null){
		
		} else {
			Iterator prIt = prSet.iterator();
			while(prIt.hasNext()){
				PartyRelationship pr = (PartyRelationship)prIt.next();
				if(pr.getPartyTo().getPartyId().equals(ChildPartyId) && pr.getRelationshipType().getRelationshipTypeId().equals(RelationshipType)){
					//prSet.remove(pr);
				}
				else 
					newSet.add(pr);
			}
			parentParty.setRelationships(newSet);
		}
		hs.update(parentParty);
		hs.flush();
		hs.clear();
		tx.commit();
	}
	
	public String addPartyRelationshipByPartyId(Session hs,String ParentPartyId,String ChildPartyId,String RelationshipType) throws HibernateException{
		Transaction tx = null;
		tx = hs.beginTransaction();
		String ChildLinkNote = "";
				
		Party parentParty =(Party)hs.load(Party.class,ParentPartyId);
		Set prSet = parentParty.getRelationships();
		if(prSet==null){
			prSet = new HashSet();
		} else {
			PartyRelationship pr = new PartyRelationship();
			Party ChildParty =(Party)hs.load(Party.class,ChildPartyId);
			pr.setPartyTo(ChildParty);
			pr.setRoleFrom((RoleType)hs.load(RoleType.class,"ORGANIZATION_UNIT"));
			pr.setRoleTo((RoleType)hs.load(RoleType.class,"ORGANIZATION_UNIT"));
			pr.setRelationshipType((PartyRelationshipType)hs.load(PartyRelationshipType.class,RelationshipType));
			PartyHelper ph = new PartyHelper();
			String LinkNote = ph.findPartyRelationshipNoteByPartyId(hs,ParentPartyId,RelationshipType);
			pr.setNote(LinkNote+":"+ChildPartyId);
			ChildLinkNote = LinkNote+":"+ChildPartyId;
			prSet.add(pr);
			parentParty.setRelationships(prSet);
			hs.update(parentParty);
		}
		hs.flush();
		hs.clear();
		tx.commit();
		return ChildLinkNote;
	}
	
	public void updateSubPartyRelationshipByNote(String FromNote, String ToNote){
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
		String sql = "update PARTY_RELATIONSHIP set note='"+ToNote+"'+ right(note,len(note)-len('"+FromNote+"')) where note like '"+FromNote+"%'";
		sqlExec.runQueryCloseCon(sql);
	}
	
	public void updatePartyRelationshipByPartyId(Session hs,String ParentPartyId,String ChildPartyId,String RelationshipType) throws HibernateException{
		PartyHelper ph = new PartyHelper();
		String NewLinkNote = "";
		String OldLinkNote = ph.findPartyRelationshipNoteByPartyId(hs,ChildPartyId,RelationshipType);
		
		if (!OldLinkNote.equals(ChildPartyId)) {
			Iterator itparty = ph.getAllParentPartysByPartyId(hs,ChildPartyId).iterator();
			while (itparty.hasNext()) {
				Party ParentParty = (Party)itparty.next();
				removeRelationshipByPartyId(hs,ParentParty.getPartyId(),ChildPartyId,RelationshipType);
			}
		}
		if (ParentPartyId.equals("None")) {
			NewLinkNote = ChildPartyId;
		} else {
			NewLinkNote = addPartyRelationshipByPartyId(hs,ParentPartyId,ChildPartyId,RelationshipType);
		}
		updateSubPartyRelationshipByNote(OldLinkNote,NewLinkNote);
	}
}
