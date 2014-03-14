/*
 * Created on 2005-4-28
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.prm.originaldata;

import java.util.List;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

import org.apache.log4j.Logger;

import com.aof.component.prm.TimeSheet.TimeSheetDetail;
import com.aof.component.prm.TimeSheet.TimeSheetMaster;
import com.aof.component.prm.project.ServiceType;

/**
 * @author CN01458
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class CAFLoader {
	
	private final int fetchSize = 20;
	private Logger log = Logger.getLogger(CAFLoader.class);
	
	public void loadCAF(Session session) throws HibernateException {
		log.info("start load CAF...");
		
		try {
			String sqlStr1 = "select c.id from CAF as c order by c.id where c.status <> 'done'";
			Query query1 = session.createQuery(sqlStr1);
			List list1 = query1.list();
			TimeSheetLoader tsLoader = new TimeSheetLoader();
			DownPaymentLoader dpLoader = new DownPaymentLoader();
			ServiceTypeLoader stLoader = new ServiceTypeLoader();
			
			log.info("Total load ["+ list1.size() +"]...");
			
			int count = 0;
			while (list1.size() > count) {
				Long fromId = (Long)list1.get(count);
				Long toId = (Long)list1.get(
						(count + fetchSize < list1.size() ? count + fetchSize : list1.size()) - 1);
				count = count + fetchSize;
				
				String sqlStr2 = "from CAF as c where c.id between ? and ? order by c.id";
				Query query2 = session.createQuery(sqlStr2);
				query2.setLong(0, fromId.longValue());
				query2.setLong(1, toId.longValue());
				
				List list2 = query2.list();
				
				for (int i0 = 0; i0 < list2.size(); i0++) {
					CAF caf = (CAF)list2.get(i0);
					
					if (caf.getStaff() != null) {//load to timesheet
						TimeSheetMaster tsm = tsLoader.getTimeSheetMaster(
									session, caf.getStaff().getUserLoginId(), caf.getCafDate());
						
						if (tsm == null) {//not have TimeSheetMaster
							tsm = tsLoader.createTimeSheetMaster(session, caf);
						}
						
						TimeSheetDetail tsd = tsLoader.getTimeSheetDetail(session, 
												                          tsm.getTsmId(), 
																		  caf.getProject().getProjId(),
																		  caf.getProjectEvent().getPeventId(),
																		  caf.getServiceType().getId(),
																		  caf.getCafDate());
						
						if (tsd == null) {//insert into TimeSheetDetail
							tsd = tsLoader.createTimeSheetDetail(session, caf, tsm);
						}
						
						//insert into trasaction table
						tsLoader.createTransaction(tsd, caf.getCreateUser());
						//add to bill instruction
						if (caf.getBilling() != null) {
							tsLoader.addToBillInstruction(session, caf.getBilling(), tsd);
						}
					} else if ("downpay".equalsIgnoreCase(caf.getStaffName())) {//load down payment
						if (caf.getRate().doubleValue() * caf.getWorkingHours().floatValue() > 0D) {
							//down payment
							dpLoader.createDownPayment(session, caf);
						} else {
							//credit down payment
							dpLoader.createCreditDownPayment(session, caf);
						}
					} else {//load serviceType
						ServiceType st = stLoader.getServiceType(session, caf);
						caf.setServiceType(st);
						stLoader.addToBillInstruction(session, caf);
					}
					
					caf.setStatus("done");
					session.update(caf);
				}
			}
		} catch (HibernateException e) {
			log.error("load CAF failure...");
			throw e;
		}

		log.info("load CAF successful...");
	}
}
