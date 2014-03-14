/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.domain.party;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.StringTokenizer;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import net.sf.hibernate.type.Type;

import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.GeneralException;

/**
 * @author xxp
 * @version 2003-7-1
 * 
 */
public class PartyHelper {

	public PartyHelper() {
	}

	/**
	 * 过的指定机构编号的机构
	 * 
	 * @param partyId
	 * @return
	 */
	public Party getPartyByPartyId(String partyId) {
		Party party = null;
		try {
			party = (Party) Hibernate2Session.currentSession().load(Party.class, partyId);
		} catch (HibernateException e) {
			e.printStackTrace();
		} catch (GeneralException e) {
			e.printStackTrace();
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}
		return party;
	}

	public String getPartyRoleByPartyId(String partyId) {
		String role = "";
		try {
			Party party = (Party) Hibernate2Session.currentSession().load(Party.class, partyId);
			Iterator it = party.getPartyRoles().iterator();
			if (it.hasNext()) {
				role = ((RoleType) it.next()).getRoleTypeId().toString();
			}
		} catch (HibernateException e) {
			e.printStackTrace();
		} catch (GeneralException e) {
			e.printStackTrace();
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}
		return role;
	}

	/**
	 * 获得指定机构的下级机构列表
	 * 
	 * @param party
	 * @return
	 */
	public List getGroupRollupParty(Party party) {
		List result = new ArrayList();

		try {
			party = (Party) Hibernate2Session.currentSession()
					.load(Party.class, party.getPartyId());

			Set prSet = party.getRelationships();
			if (prSet == null)
				return null;
			Iterator prIt = prSet.iterator();
			while (prIt.hasNext()) {
				PartyRelationship pr = (PartyRelationship) prIt.next();

				if (pr.getRelationshipType().getRelationshipTypeId().equals(
						PartyKeys.GROUP_ROLLUP_ROLE_KEY)) {
					result.add(pr.getPartyTo());
				}
			}
		} catch (HibernateException e) {
			e.printStackTrace();
		} catch (GeneralException e) {
			e.printStackTrace();
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			return result;
		}
	}

	/**
	 * 获得指定机构的供应商列表
	 * 
	 * @param party
	 * @return
	 */
	public List getSuppliersByParty(Party party) {
		List result = new ArrayList();
		try {
			party = (Party) Hibernate2Session.currentSession()
					.load(Party.class, party.getPartyId());

			Set prSet = party.getRelationships();
			if (prSet == null) {
				return null;
			} else {
				Iterator prIt = prSet.iterator();
				while (prIt.hasNext()) {
					PartyRelationship pr = (PartyRelationship) prIt.next();
					if (pr.getRelationshipType().getRelationshipTypeId().equals(
							PartyKeys.MANAGER_RELATIONSHIP_KEY)) {
						result.add(pr.getPartyTo());
					}
				}
			}
		} catch (HibernateException e) {
			e.printStackTrace();
		} catch (GeneralException e) {
			e.printStackTrace();
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			return result;
		}
	}

	public List getShipmentedByParty(Party party) {
		List result = new ArrayList();
		try {
			party = (Party) Hibernate2Session.currentSession()
					.load(Party.class, party.getPartyId());

			Set prSet = party.getRelationships();
			if (prSet == null) {
				return null;
			} else {
				Iterator prIt = prSet.iterator();
				while (prIt.hasNext()) {
					PartyRelationship pr = (PartyRelationship) prIt.next();
					if (pr.getRelationshipType().getRelationshipTypeId().equals(
							PartyKeys.SHIPMENT_RELATIONSHIP_KEY)) {
						result.add(pr.getPartyTo());
					}
				}
			}
		} catch (HibernateException e) {
			e.printStackTrace();
		} catch (GeneralException e) {
			e.printStackTrace();
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			return result;
		}
	}

	/**
	 * 获得供应商列表
	 * 
	 * @param session
	 * @param partyId
	 * @return
	 * @throws HibernateException
	 */
	public List getSuppliersByPartyId(Session session, String partyId) throws HibernateException {
		Party party = (Party) session.load(Party.class, partyId);
		Set prSet = party.getRelationships();
		List result = new ArrayList();
		if (prSet == null) {
			return null;
		} else {
			Iterator prIt = session.filter(result, "order by party_from_id").iterator();

			while (prIt.hasNext()) {
				PartyRelationship pr = (PartyRelationship) prIt.next();
				if (pr.getRelationshipType().getRelationshipTypeId().equals(
						PartyKeys.MANAGER_RELATIONSHIP_KEY)) {
					result.add(pr.getPartyTo());
				}
			}
			return result;
		}
	}

	/**
	 * 获得指定机构的仓储中心
	 * 
	 * @param party
	 * @return
	 */
	public List getStoragesByParty(Party party) {
		party = getPartyByPartyId(party.getPartyId());

		Set prSet = party.getRelationships();
		List result = new ArrayList();
		if (prSet == null) {
			return null;
		} else {
			Iterator prIt = prSet.iterator();
			while (prIt.hasNext()) {
				PartyRelationship pr = (PartyRelationship) prIt.next();
				if (pr.getRelationshipType().getRelationshipTypeId().equals(
						PartyKeys.PARTNERSHIP_RELATIONSHIP_KEY)) {
					result.add(pr.getPartyTo());
				}
			}
			return result;
		}
	}

	/**
	 * 获得指定机构的仓储中心
	 * 
	 * @param session
	 * @param partyId
	 * @return
	 * @throws HibernateException
	 */
	public List getStoragesByPartyId(Session session, String partyId) throws HibernateException {
		Party party = (Party) session.load(Party.class, partyId);
		Set prSet = party.getRelationships();
		List result = new ArrayList();
		if (prSet == null) {
			return null;
		} else {
			Iterator prIt = prSet.iterator();
			while (prIt.hasNext()) {
				PartyRelationship pr = (PartyRelationship) prIt.next();
				if (pr.getRelationshipType().getRelationshipTypeId().equals(
						PartyKeys.PARTNERSHIP_RELATIONSHIP_KEY)) {
					result.add(pr.getPartyTo());
				}
			}
			return result;
		}
	}

	/**
	 * 获得指定机构的人员列表
	 * 
	 * @param session
	 * @param partyId
	 * @return
	 * @throws HibernateException
	 */
	public List getPersonsByPartyId(Session session, Party party) throws HibernateException {

		List result = new ArrayList();
		result = session.find("from UserLogin ul where ul.party =?", party, Hibernate
				.entity(Party.class));
		// List blogs = session.createQuery("from Blog blog where blog.blogger =
		// :blogger order by blog.datetime desc")
		// .setEntity("blogger", blogger)
		// .setMaxResults(15)
		// .setCacheable(true)
		// .setCacheRegion("frontpages")
		// .list();
		return result;
	}

	/**
	 * 获得所有机构信息
	 * 
	 * @param session
	 * @return
	 * @throws HibernateException
	 */
	public List getAllParty(Session session) throws HibernateException {
		List result = new ArrayList();
		result = session.find("from Party p ");
		return result;
	}

	public List getAllDepartment(Session session) throws HibernateException {
		List result = new ArrayList();
		result = session
				.find(
						"select p from Party as p left outer join p.partyRoles as partyRole where partyRole.roleTypeId = ?",
						"ORGANIZATION_UNIT", Hibernate.STRING);
		return result;
	}

	/**
	 * 获得所有Sales Bid相关部门信息
	 * 
	 * @param session
	 * @return
	 * @throws HibernateException
	 */
	public List getAllBidDept(Session session) throws HibernateException {
		List result = new ArrayList();
		String strQuery = "select sg.department from SalesStepGroup as sg where sg.disableFlag = 'N'";
		result = session.find(strQuery);
		return result;
	}

	/**
	 * 获得指定机构类型的机构
	 * 
	 * @param session
	 * @param partyType
	 * @return
	 * @throws HibernateException
	 */
	public List getPartyByType(Session session, PartyType partyType) throws HibernateException {
		List result = new ArrayList();
		result = session.find("from Party p where p.partyType =? ", partyType, Hibernate
				.association(PartyType.class));
		return result;
	}

	/**
	 * 获得所有的供应商机构
	 * 
	 * @param session
	 * @return
	 * @throws HibernateException
	 */
	public List getAllSupplier(Session session) throws HibernateException {
		List result = new ArrayList();
		result = session
				.find(
						"select p from Party as p left outer join p.partyRoles as partyRole where partyRole.roleTypeId = ?",
						PartyKeys.SUPPLIER_ROLE_KEY, Hibernate.STRING);
		// result = session.fin
		return result;
	}

	public List getAllSupplier() {
		List result = new ArrayList();
		Session session = null;
		try {
			session = Hibernate2Session.currentSession();
			result = session
					.find(
							"select p from Party as p left outer join p.partyRoles as partyRole where partyRole.roleTypeId = ?",
							PartyKeys.SUPPLIER_ROLE_KEY, Hibernate.STRING);
		} catch (GeneralException e) {
			e.printStackTrace();
		} catch (HibernateException he) {
			he.printStackTrace();
		} finally {
			try {
				session.close();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			}
			return result;
		}
	}

	public String getAvaSuppliersByCondition(String partyId, String suppliers) {

		String result = "";
		Party party = getPartyByPartyId(partyId);

		List partys = new ArrayList();
		String partyRole = party.getPartyRoles().iterator().next().toString();
		// /////////////////////////////////////////////////////
		// /1.B5.安庭
		// /2.当前仓储中心
		// /3.当前供应商
		// /////////////////////////////////////////////////////
		if (partyRole.equals(PartyKeys.ORGANIZATION_UNIT_ROLE_KEY)) {
			return "";
		}
		if (partyRole.equals(PartyKeys.STORAGE_ROLE_KEY)) {
			List tempList = getSuppliersByParty(party);
			Iterator it = tempList.iterator();
			while (it.hasNext()) {
				partys.add(((Party) it.next()).getPartyId());
			}
		}
		if (partyRole.equals(PartyKeys.SUPPLIER_ROLE_KEY)) {
			partys.add(partyId);
		}
		// supplers=null or "" 系统判断partyId的角色。决定显示的内容
		if (suppliers == null && suppliers.equals("")) {
			Iterator it = partys.iterator();
			while (it.hasNext()) {
				result = "'" + it.next().toString() + "',";
			}
		} else {
			StringTokenizer oTokenizer = new StringTokenizer(suppliers, ",");
			while (oTokenizer.hasMoreTokens()) {
				String sNextToken = oTokenizer.nextToken();
				if (partys.indexOf(sNextToken) >= 0) {
					result = "'" + sNextToken.toString() + "',";
				}
			}

		}

		return result.substring(0, result.length() - 1);
	}

	public static String getPartyAttr(String partyId, String attrType, String attrName) {
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
				.getConnectionByName("jdbc/aofdb")));
		SQLResults sr = null;

		String sql = "select attr_value from party_attr where party_id = ? and attr_type=? and attr_name=? ";
		sqlExec.addParam(partyId);
		sqlExec.addParam(attrType);
		sqlExec.addParam(attrName);

		sr = sqlExec.runQueryCloseCon(sql);
		if (sr.getRowCount() > 0) {
			return sr.getString(0, "attr_Value");
		} else {
			return null;
		}
	}

	public static boolean setPartyAttr(String partyId, String attrType, String attrName,
			String attrValue) {
		boolean result = false;

		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
				.getConnectionByName("jdbc/aofdb")));
		SQLResults sr = null;

		String sql = "select attr_value from party_attr where party_id = ? and attr_type=? and attr_name=? ";
		sqlExec.addParam(partyId);
		sqlExec.addParam(attrType);
		sqlExec.addParam(attrName);

		sr = sqlExec.runQueryCloseCon(sql);
		if (sr.getRowCount() > 0) {
			sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
					.getConnectionByName("jdbc/aofdb")));
			sql = "update party_attr set attr_value=? where party_id = ? and attr_type=? and attr_name=? ";
			sqlExec.addParam(attrValue);
			sqlExec.addParam(partyId);
			sqlExec.addParam(attrType);
			sqlExec.addParam(attrName);
			sqlExec.runQueryCloseCon(sql);
			result = true;
		} else {
			sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
					.getConnectionByName("jdbc/aofdb")));
			sql = "insert into party_attr (party_id,attr_type,attr_name,attr_value) values (?,?,?,?)";
			sqlExec.addParam(partyId);
			sqlExec.addParam(attrType);
			sqlExec.addParam(attrName);
			sqlExec.addParam(attrValue);
			sqlExec.runQueryCloseCon(sql);
			result = true;
		}
		return result;
	}

	public List getAllCustomers(Session session) throws HibernateException {
		List result = new ArrayList();
		result = session
				.find(
						"select p from Party as p left outer join p.partyRoles as partyRole where partyRole.roleTypeId = ? order by p.description",
						PartyKeys.CUSTOMER_ROLE_KEY, Hibernate.STRING);
		// result = session.fin
		return result;
	}

	public List getAllOrgUnits(Session session) throws HibernateException {
		List result = new ArrayList();
		result = session
				.find(
						"select p from Party as p left outer join p.partyRoles as partyRole where partyRole.roleTypeId = ? order by p.description",
						PartyKeys.ORGANIZATION_UNIT_ROLE_KEY, Hibernate.STRING);
		// result = session.fin
		return result;
	}

	public List getAllPASUnits(Session session) throws HibernateException {
		List result = new ArrayList();
		result = session
				.find(
						"select p from Party as p left outer join p.partyRoles as partyRole where partyRole.roleTypeId = ? and p.address='Y' order by p.description",
						PartyKeys.ORGANIZATION_UNIT_ROLE_KEY, Hibernate.STRING);
		// result = session.fin
		return result;
	}

	/**
	 * 获得指定机构的上级机构列表
	 * 
	 * @param session
	 * @param partyId
	 * @return
	 * @throws HibernateException
	 */
	public List getAllParentPartysByPartyId(Session session, String partyId)
			throws HibernateException {

		List result = new ArrayList();
		result = session
				.find(
						"select p from Party as p inner join p.relationships as pr inner join pr.partyTo as pt where pt.partyId=? order by p.partyId",
						partyId, Hibernate.STRING);
		return result;
	}

	public List getAllParentPartysByPartyId(Session session, String partyId, String RelationshipType)
			throws HibernateException {
		List result = new ArrayList();
		Query q = session
				.createQuery("select p from Party as p inner join p.relationships as pr inner join pr.partyTo as pt inner join pr.relationshipType as rt where pt.partyId=:PartyId and rt.relationshipTypeId =:RelationshipType");
		q.setParameter("PartyId", partyId);
		q.setParameter("RelationshipType", RelationshipType);
		result = q.list();
		return result;
	}

	public String findPartyRelationshipNoteByPartyId(Session hs, String PartyId,
			String RelationshipType) throws HibernateException {
		String LinkNote = "";
		Query q = hs
				.createQuery("select p from Party as p inner join p.relationships as pr inner join pr.partyTo as pt inner join pr.relationshipType as rt where pt.partyId=:PartyId and rt.relationshipTypeId =:RelationshipType");
		q.setParameter("PartyId", PartyId);
		q.setParameter("RelationshipType", RelationshipType);
		Iterator it = q.list().iterator();
		if (it.hasNext()) {
			Party Party = (Party) it.next();
			Set prSet = Party.getRelationships();
			if (prSet != null) {
				Iterator prIt = prSet.iterator();
				while (prIt.hasNext()) {
					PartyRelationship pr = (PartyRelationship) prIt.next();
					if (pr.getPartyTo().getPartyId().equals(PartyId)
							&& pr.getRelationshipType().getRelationshipTypeId().equals(
									RelationshipType)) {
						LinkNote = pr.getNote();
						return LinkNote;
					}
				}
			}
		} else {
			LinkNote = PartyId;
		}
		return LinkNote;
	}

	public List getAllSubPartysByPartyId(Session hs, String partyId, String RelationshipType)
			throws HibernateException {
		List result = null;
		String LinkNote = findPartyRelationshipNoteByPartyId(hs, partyId, RelationshipType);
		String QryStr = "select distinct pt from Party as p inner join p.relationships as pr inner join pr.partyTo as pt inner join pr.relationshipType as rt";
		QryStr = QryStr + " where (pr.note like '" + LinkNote
				+ ":%' and rt.relationshipTypeId =:RelationshipType)";
		QryStr = QryStr + " order by pt.description";
		Query q = hs.createQuery(QryStr);
		q.setParameter("RelationshipType", RelationshipType);
		result = q.list();
		return result;
	}

	public List getAllSubPartysByPartyId(Session hs, String partyId) throws HibernateException {

		List result = null;
		String LinkNote = findPartyRelationshipNoteByPartyId(hs, partyId, "GROUP_ROLLUP");
		String QryStr = "select distinct pt from Party as p inner join p.relationships as pr inner join pr.partyTo as pt inner join pr.relationshipType as rt";
		QryStr = QryStr + " where (pr.note like '" + LinkNote + ":%')";
		LinkNote = findPartyRelationshipNoteByPartyId(hs, partyId, "LOCATION_ROLLUP");
		QryStr = QryStr + " or (pr.note like '" + LinkNote + ":%')";
		QryStr = QryStr + " order by pt.linkMan asc";
		Query q = hs.createQuery(QryStr);
		result = q.list();
		return result;
	}

	public String getParentPartyQryStrByPartyId(Session hs, String partyId, String RelationshipType)
			throws HibernateException {
		String LinkNote = findPartyRelationshipNoteByPartyId(hs, partyId, RelationshipType);
		String PartyListStr = "('" + LinkNote.replaceAll(":", "','") + "')";
		return PartyListStr;
	}

	public String getParentPartyQryStrByPartyId(Session hs, String partyId)
			throws HibernateException {
		String LinkNote = findPartyRelationshipNoteByPartyId(hs, partyId, "GROUP_ROLLUP");
		String LinkNote2 = findPartyRelationshipNoteByPartyId(hs, partyId, "LOCATION_ROLLUP");
		String PartyListStr = "('" + LinkNote.replaceAll(":", "','") + "','"
				+ LinkNote2.replaceAll(":", "','") + "')";
		return PartyListStr;
	}
}
