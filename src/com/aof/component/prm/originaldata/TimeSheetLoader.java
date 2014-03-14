/*
 * Created on 2005-4-28
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.prm.originaldata;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

import org.apache.log4j.Logger;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.BillInstructionService;
import com.aof.component.prm.Bill.BillTransactionDetail;
import com.aof.component.prm.Bill.ProjectBill;
import com.aof.component.prm.Bill.TransactionServices;
import com.aof.component.prm.TimeSheet.TimeSheetDetail;
import com.aof.component.prm.TimeSheet.TimeSheetMaster;
import com.aof.component.prm.project.ConsultantCost;
import com.aof.component.prm.project.FMonth;
import com.aof.component.prm.project.ServiceType;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class TimeSheetLoader {
	
	private Logger log = Logger.getLogger(TimeSheetLoader.class);
	
	public TimeSheetDetail createTimeSheetDetail(Session session, CAF caf, TimeSheetMaster tsm) throws HibernateException {
		log.info("load CAF ID = [" + caf.getId() + "]...");
		try {
			TimeSheetDetail tsd = new TimeSheetDetail();
			
			tsd.setProject(caf.getProject());
			tsd.setProjectEvent(caf.getProjectEvent());
			tsd.setTSServiceType(caf.getServiceType());
			tsd.setTsHoursUser(new Float(caf.getWorkingHours().floatValue()));
			tsd.setTsRateUser(new Double(getCostRate(session, tsm, caf.getServiceType()).doubleValue() / 8));
			//tsd.setTsHoursConfirm(new Float(caf.getWorkingHours().floatValue()));
			tsd.setStatus("Approved");
			//tsd.setCAFStatusUser("N");
			//tsd.setCAFStatusConfirm("Y");
			tsd.setTsDate(caf.getCafDate());
			//tsd.setConfirm("Confirmed");
			//tsd.setTsConfirmDate(caf.getCafDate());
			//tsd.setTSAllowance(new Float(caf.getWorkingHours().floatValue() / 8));
			
			Integer tsdId = (Integer)session.save(tsd);
			
			tsm.addDetails(tsd);
			
			return tsd;

		} catch (HibernateException e) {
			log.error("insert into TimeSheetDetail failure, CAF ID = [" + caf.getId() + "]...");
			throw e;
		}
	}
	
	public void createTransaction(TimeSheetDetail tsd, UserLogin ul) throws HibernateException {
		log.info("insert into trasaction table, TimeSheetDetail ID = [" + tsd.getTsId() + "]...");
		try {
			TransactionServices tService = new TransactionServices();
			if (tsd.getTsHoursConfirm() == null 
					|| tsd.getTsHoursConfirm().floatValue() == 0L) {
				tsd.setTsHoursConfirm(tsd.getTsHoursUser());
			}
			
			//tsd.setStatus("Approved");
			tsd.setCAFStatusUser("N");
			tsd.setCAFStatusConfirm("Y");
			tsd.setConfirm("Confirmed");
			tsd.setTsConfirmDate(tsd.getTsDate());
			if (tsd.getTSAllowance() == null
					|| tsd.getTSAllowance().floatValue() == 0L) {
				tsd.setTSAllowance(new Float(tsd.getTsHoursConfirm().floatValue() / 8));
			}
			
			tService.insert(tsd, ul);
		} catch (Exception e) {
			log.error("insert into trasaction table failure, TimeSheetDetail ID = [" + tsd.getTsId() + "]...");
			e.printStackTrace();
			throw new HibernateException("insert into trasaction table failure");
		}
	}
	
	public void addToBillInstruction(Session session, ProjectBill pb, TimeSheetDetail tsd) throws HibernateException {
		TransactionServices tService = new TransactionServices();
		BillInstructionService biService = new BillInstructionService();
		log.info("add to bill instruction, TimeSheetDetail ID = [" + tsd.getTsId() + "]...");
		try {
			BillTransactionDetail btd = null;
			btd = (BillTransactionDetail)tService.getInsertedRecord(
					"BillTransactionDetail", tsd.getTsId().longValue(), Constants.TRANSACATION_CATEGORY_CAF);
				
			if (btd != null) {
				btd.setTransactionMaster(pb);
				session.update(btd);
				
				//recalculate amount
				pb.addDetail(btd);
				pb.setCalAmount(biService.calculateBillingAmount(pb.getId()));
				session.update(pb);
			}
			
			btd = (BillTransactionDetail)tService.getInsertedRecord(
					"BillTransactionDetail", tsd.getTsId().longValue(), Constants.TRANSACATION_CATEGORY_ALLOWANCE);
			if (btd != null) {
				btd.setTransactionMaster(pb);
				session.update(btd);
				
				//recalculate amount
				pb.addDetail(btd);
				pb.setCalAmount(biService.calculateBillingAmount(pb.getId()));
				session.update(pb);
			}
		} catch (Exception e) {
			log.error("add to bill instruction failure, TimeSheetDetail ID = [" + tsd.getTsId() + "]...");
			e.printStackTrace();
			throw new HibernateException("add to bill instruction failure");
		}
	}
	
	public TimeSheetDetail getTimeSheetDetail(Session session,
			Integer tsmId, String projectId, Integer projEventId, Long serviceTypeId, Date tsDate) throws HibernateException {
		
		String sqlStr = "from TimeSheetDetail as tsd " +
			"where tsd.TimeSheetMaster.tsmId = ? " +
			"  and tsd.Project.projId = ? " +
			"  and tsd.projectEvent.peventId = ? " +
			"  and tsd.TSServiceType.Id = ? " +
			"  and tsd.TsDate = ? ";
		
		Query query = session.createQuery(sqlStr);
		query.setInteger(0, tsmId.intValue());
		query.setString(1, projectId);
		query.setInteger(2, projEventId.intValue());
		query.setLong(3, serviceTypeId.longValue());
		query.setDate(4, tsDate);
		
		List list = query.list();
		if (list != null && list.size() > 0) {
			return (TimeSheetDetail)list.get(0);
		} else {
			return null;
		}
	}
	
	public TimeSheetMaster getTimeSheetMaster(
			Session session, String userloginId, Date cafDate) throws HibernateException {
		
		String sqlStr = "from TimeSheetMaster as tsm inner join tsm.TsmUser as ul " +
				"where ul.userLoginId = ? and tsm.Period = ? ";

		Query query = session.createQuery(sqlStr);
		query.setString(0, userloginId);
		query.setString(1, findMonday(cafDate));
		List list = query.list();
		
		if (list != null && list.size() > 0) {
			return (TimeSheetMaster)((Object[])list.get(0))[0];
		}
		
		return null;
	}
	
	public TimeSheetMaster createTimeSheetMaster(Session session, CAF caf) throws HibernateException {
		TimeSheetMaster tsm = new TimeSheetMaster();
		
		tsm.setTsmUser(caf.getStaff());
		tsm.setStatus("draft");
		tsm.setPeriod(findMonday(caf.getCafDate()));
		tsm.setUpdateDate(new Date());
		tsm.setTotalHours(new Float(0));
	
		try {
			Integer tsmId = (Integer)session.save(tsm);
			log.info("create TimeSheetMaster, Id = " + tsmId + "...");
		} catch (HibernateException e) {
			log.info("create TimeSheetMaster failure...");
			throw e;
		}
		return tsm;
	}
	
	private String findMonday(Date cafDate) {
		Date monday = null;
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(cafDate);

		switch (calendar.get(Calendar.DAY_OF_WEEK)) {
			case Calendar.MONDAY:
				monday = calendar.getTime();
				break;
			case Calendar.TUESDAY:
				calendar.add(Calendar.DATE, -1);
				monday = calendar.getTime();
				break;
			case Calendar.WEDNESDAY:
				calendar.add(Calendar.DATE, -2);
				monday = calendar.getTime();
				break;
			case Calendar.THURSDAY:
				calendar.add(Calendar.DATE, -3);
				monday = calendar.getTime();
				break;
			case Calendar.FRIDAY:
				calendar.add(Calendar.DATE, -4);
				monday = calendar.getTime();
				break;
			case Calendar.SATURDAY:
				calendar.add(Calendar.DATE, -5);
				monday = calendar.getTime();
				break;
			case Calendar.SUNDAY:
				calendar.add(Calendar.DATE, -6);
				monday = calendar.getTime();
				break;
		}
		
		return dateFormat.format(monday);
	}
	
	private Double getCostRate(Session session, TimeSheetMaster tsm, ServiceType st) {
		Double CostRate = new Double(0);
		try {
			String PartyNote = tsm.getTsmUser().getNote();
			if (PartyNote == null) PartyNote = "";
			if (PartyNote.equals("EXT")) {
				return st.getSubContractRate();
			} else {
				Query q = session.createQuery("select fm from FMonth as fm where fm.DateTo >=:DataPeriod and fm.DateFrom <=:DataPeriod");
				q.setParameter("DataPeriod",UtilDateTime.toDate2(tsm.getPeriod() + " 00:00:00.000"));
				List result = q.list();
				Iterator itFm = result.iterator();
				if (itFm.hasNext()) {
					FMonth fm =(FMonth)itFm.next();
					q = session.createQuery("select cr from ConsultantCost cr inner join cr.User as ul where ul.userLoginId = :UserId and cr.Year =:CRYear");
					q.setParameter("UserId", tsm.getTsmUser().getUserLoginId());
					q.setParameter("CRYear", fm.getYear());
					result = q.list();
					Iterator itCR = result.iterator();
					if (itCR.hasNext()) {
						ConsultantCost cr = (ConsultantCost)itCR.next();
						return new Double(cr.getCost().doubleValue());
					}
				} 
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return CostRate;
	}
}
