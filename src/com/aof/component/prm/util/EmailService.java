/*
 * Created on 2005-6-13
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.aof.component.prm.util;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;

import com.aof.component.crm.customer.CustomerProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.ProjectReceiptMaster;
import com.aof.component.prm.TimeSheet.TimeSheetDetail;
import com.aof.component.prm.TimeSheet.TimeSheetMaster;
import com.aof.component.prm.bid.BidMaster;
import com.aof.component.prm.expense.ExpenseMaster;
import com.aof.component.prm.project.ProjPlanBomMaster;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.helpdesk.util.EmailUtil;
import com.aof.util.GeneralException;

/**
 * @author stanley
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */

public class EmailService {

	static Logger log = Logger.getLogger(EmailService.class.getName());

	static public void notifyUser(final ExpenseMaster expense) throws SQLException {

		String email = null;
		if (expense.getStatus().equalsIgnoreCase("Submitted"))
			email = expense.getProject().getProjectManager().getEmail_addr();
		else
			email = expense.getExpenseUser().getEmail_addr();
		log.info("Email --> " + email);

		String title = "Expense ER No. " + expense.getFormCode() + " - " + expense.getStatus();
		log.info("Title -->" + title);

		if (!(email == null || email.trim().equals(""))) {
			final String body = getEmailBody(expense);
			log.info(body);
			EmailUtil.sendMail(email, title, body);
		} else {
			log.info("No email address");
		}
	}

	static public void sendMail(final TimeSheetMaster tsm) throws SQLException, GeneralException,
			HibernateException {

		net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
		Transaction tx = null;
		tx = hs.beginTransaction();

		final int length = 0;

		String email = null;
		String title = null;
		String body = null;

		java.util.Set set = tsm.getDetails();
		java.util.Iterator i = set.iterator();
		java.util.ArrayList mailList = new java.util.ArrayList();
		java.util.HashMap map = new java.util.HashMap();

		TimeSheetDetail tsd = null;
		title = "TimeSheet for " + tsm.getPeriod() + " Submitted";

		while (i.hasNext()) {

			tsd = (TimeSheetDetail) i.next();
			email = tsd.getProject().getProjectManager().getEmail_addr();
			/*
			 * Modification : annotate incorrect code , by Bill Yu
			 * if(!tsd.getProject().getProjectCategory().getId().equals("C") ||
			 * tsd.getStatus().equals("Submitted") ||
			 * tsd.getProject().getMailFlag().equals("N")){
			 * tsd.setStatus("Submitted"); hs.update(tsd); continue; }
			 */// replace code below
			if (tsd.getStatus().equals("draft") || tsd.getStatus().equals("Rejected")) {
				tsd.setStatus("Submitted");
				hs.update(tsd);
			}
			if (tsd.getProject().getMailFlag() != null
					&& tsd.getProject().getMailFlag().equals("N")) {
				continue;
			}
			if (tsd.getProject().getMailFlag() == null) {
				continue;
			}
			// Modification end
			if (!map.containsKey(email)) {
				mailList.add(email);
				ArrayList list = new ArrayList();
				// for simplity
				list.add(new String(tsd.getProject().getProjectManager().getName()));
				list.add(new String(tsd.getProject().getProjId() + ":"
						+ tsd.getProject().getProjName()));
				map.put(email, list);
			} else {
				ArrayList temp = (ArrayList) map.get(email);
				String s = new String(tsd.getProject().getProjId() + ":"
						+ tsd.getProject().getProjName() + " - Customer:"
						+ tsd.getProject().getCustomer().getDescription());
				if (!temp.contains(s)) {
					temp.add(s);
					map.put(email, temp);
				}
			}
			/*
			 * Modification : annotate incorrect code , by Bill Yu
			 * tsd.setStatus("Submitted"); hs.update(tsd);
			 */
		}
		tx.commit();

		for (int j = 0; j < mailList.size(); j++) {
			StringWriter sw = new StringWriter();
			PrintWriter out = new PrintWriter(sw);

			String mail = (String) mailList.get(j);
			ArrayList al = (ArrayList) map.get(mail);

			out.println("Dear " + al.get(0) + " :");
			out
					.println("\tPAS kindly reminds you that the following timesheet needs your approval.");

			printWithRightPadding(out, "\tStaff:\t\t\t", length);
			out.println(tsm.getTsmUser().getName());

			printWithRightPadding(out, "\tEntry Period:\t\t", length);
			out.println(tsm.getPeriod());

			out.print("\tProject List:\t\t");

			for (int k = 1; k < al.size(); k++) {
				out.println(al.get(k) + ";");
			}

			body = sw.toString();

			log.info(body);
			EmailUtil.sendMail(mail, title, body);
		}

	}

	static public void notifyUser(final TimeSheetMaster tsm, final TimeSheetDetail tsd)
			throws SQLException {

		String email = null;
		String title = null;
		String body = null;

		java.util.Set set = tsm.getDetails();
		java.util.Iterator i = set.iterator();
		java.util.List list = new java.util.ArrayList();

		if (tsd.getStatus().equals("Submitted")) {

		} else if (tsd.getStatus().equals("Approved") || tsd.getStatus().equals("Rejected")) {

			email = tsd.getTimeSheetMaster().getTsmUser().getEmail_addr();
			log.info(email);
			title = "TimeSheet for " + tsm.getPeriod() + " " + tsd.getStatus();
			if (!(email == null || email.trim().equals(""))) {
				body = getEmailBody(tsm, tsd);
				EmailUtil.sendMail(email, title, body);
				log.info(body);
			} else
				log.info("Email Address Error");

		}

	}

	static private String getEmailBody(TimeSheetMaster tsm, TimeSheetDetail tsd) {

		final int length = 0;
		StringWriter sw = new StringWriter();
		PrintWriter out = new PrintWriter(sw);

		java.util.Set set = tsm.getDetails();
		java.util.Iterator i = set.iterator();

		out.println("Dear " + tsm.getTsmUser().getName() + " :");
		out.println("\tPAS kindly prompts you the following timesheet has been " + tsd.getStatus()
				+ ".");

		// printWithRightPadding(out,"TimeSheet Id:\t\t",length);
		// out.println(tsm.getTsmId());

		// printWithRightPadding(out,"Department:\t\t",length);
		// out.println(tsm.getTsmUser().getParty().getDescription());

		// printWithRightPadding(out,"User:\t\t\t",length);
		// out.println(tsm.getTsmUser().getName());

		// printWithRightPadding(out,"Status:\t\t\t",length);
		// out.println(tsd.getStatus());

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		printWithRightPadding(out, "\tEntry Period:\t\t", length);
		out.println(tsm.getPeriod());

		printWithRightPadding(out, "\tProject Manager:\t", length);
		out.println(tsd.getProject().getProjectManager().getName());

		// printWithRightPadding(out,"Project:\t\t",length);
		// out.println(tsd.getProject().getProjId()+":"+tsd.getProject().getProjName());

		// printWithRightPadding(out,"Customer:\t\t",length);
		// out.println(tsd.getProject().getCustomer().getDescription());

		// printWithRightPadding(out,"Event:\t\t",length);
		// out.println(tsd.getProjectEvent().getPeventName());

		// printWithRightPadding(out,"Service Type:\t\t",length);
		// out.println(tsd.getTSServiceType().getDescription());

		// printWithRightPadding(out,"Need CAF:\t\t",length);
		// out.println(tsd.getProject().getCAFFlag());

		/*
		 * printWithRightPadding(out,"Total Hours:\t\t",length); float
		 * totalHours = 0; Iterator iterator = set.iterator();
		 * while(iterator.hasNext()){ TimeSheetDetail ts =
		 * (TimeSheetDetail)iterator.next();
		 * if(ts.getProject().equals(tsd.getProject()) &&
		 * ts.getProjectEvent().equals(tsd.getProjectEvent())) totalHours +=
		 * ts.getTsHoursUser().floatValue(); } out.println(totalHours);
		 * totalHours = 0;
		 */
		out.println("");
		printWithRightPadding(out, "http://192.168.2.4/Live", length);
		out.println("");
		return sw.toString();
	}

	static private String getEmailBody(ExpenseMaster expense) {

		final int length = 0;
		StringWriter sw = new StringWriter();
		PrintWriter out = new PrintWriter(sw);

		if (expense.getStatus().equals("Submitted")) {
			out.println("Dear " + expense.getProject().getProjectManager().getName() + ":"
					+ "\n PAS kindly advises you that following expense form from "
					+ expense.getExpenseUser().getName() + " need your online approval.\n");
		} else if (expense.getStatus().equals("Approved") || expense.getStatus().equals("Rejected")) {
			out.println("Dear " + expense.getExpenseUser().getName() + ":"
					+ "\n PAS kindly advises you that following expense form has been "
					+ expense.getStatus() + " by "
					+ expense.getProject().getProjectManager().getName() + "\n");
		} else if (expense.getStatus().equals("Confirmed")
				|| expense.getStatus().equals("F&A Rejected")
				|| expense.getStatus().equals("Claimed")) {
			out.println("Dear " + expense.getExpenseUser().getName() + ":"
					+ "\n PAS kindly advises you that following expense form has been "
					+ expense.getStatus() + " by Finance" + "\n");
		} else if (expense.getStatus().equals("Claimed")) {
			out
					.println("Dear "
							+ expense.getExpenseUser().getName()
							+ ":"
							+ "\n PAS kindly advises you that following expense form has been paid out by Finance"
							+ "\n");
		}

		out.println("== Expense Form Information Sumary == ");

		printWithRightPadding(out, "ER No:\t\t\t\t\t", length);
		out.println(expense.getFormCode());
		NumberFormat Num_formater = NumberFormat.getInstance();
		Num_formater.setMaximumFractionDigits(2);
		Num_formater.setMinimumFractionDigits(2);

		// printWithRightPadding(out,"Expense Amount:\t\t\t\t",length);
		// Iterator itAmt = expense.getAmounts().iterator();
		// System.out.println("size is || "+expense.getAmounts().size());
		// ExpenseAmount ea = null;
		// / float AmtStaff = 0;
		// / float AmtVerify = 0;
		// float AmtClaim = 0;
		// boolean verified = false;
		// boolean claimed = false;
		// while (itAmt.hasNext()) {
		// ea = (ExpenseAmount)itAmt.next();
		// if (ea.getUserAmount() != null) AmtStaff = AmtStaff +
		// ea.getUserAmount().floatValue();
		// if (ea.getConfirmedAmount() != null && !verified) verified = true;
		// if (ea.getConfirmedAmount() != null) AmtVerify = AmtVerify +
		// ea.getConfirmedAmount().floatValue();
		// if (ea.getPaidAmount() != null && !claimed) claimed = true;
		// if (ea.getPaidAmount() != null) AmtClaim = AmtClaim +
		// ea.getPaidAmount().floatValue();
		// }
		// /////
		try {
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil
					.getConnectionByName("jdbc/aofdb")));
			double ToBeClaimedAmt = 0;
			String QryStr = "select ea.em_id , em_code, sum(ea_amt_user) as amtUser, sum(ea_amt_confirm) as amtConfirm, sum(ea_amt_paid) as amtPaid";
			QryStr = QryStr
					+ " from proj_exp_mstr as em inner join proj_exp_amt as ea on ea.em_id = em.em_id";
			QryStr = QryStr + " where em_userlogin = '" + expense.getExpenseUser().getUserLoginId()
					+ "' and em_code = '" + expense.getFormCode() + "'";
			QryStr = QryStr + " group by ea.em_id, em_code";
			SQLResults srr = sqlExec.runQueryCloseCon(QryStr);
			printWithRightPadding(out, "Expense Amount:\t\t\t\t", length);
			Object resultSet_data;
			if (expense.getStatus().equals("Submitted")) {
				out.println((resultSet_data = srr.getObject(0, "amtUser")) == null ? "0.00"
						: resultSet_data);
			} else if (expense.getStatus().equals("Approved")
					|| expense.getStatus().equals("Rejected")) {
				out.println((resultSet_data = srr.getObject(0, "amtUser")) == null ? "0.00"
						: resultSet_data);
			} else if (expense.getStatus().equals("Confirmed")
					|| expense.getStatus().equals("F&A Rejected")) {
				out.println((resultSet_data = srr.getObject(0, "amtConfirm")) == null ? "0.00"
						: resultSet_data);
			} else if (expense.getStatus().equals("Claimed")) {
				out.println((resultSet_data = srr.getObject(0, "amtConfirm")) == null ? "0.00"
						: resultSet_data);
			}

			// hs.flush();
		} catch (Exception e) {
			e.printStackTrace();
		}
		// /////

		// printWithRightPadding(out,"Department:\t\t",length);
		// out.println(expense.getExpenseUser().getParty().getDescription());
		// List result = null;
		if (expense.getStatus().equals("Claimed")) {
			try {
				net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
				SQLExecutor sqlExec = new SQLExecutor(Persistencer
						.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
				double ToBeClaimedAmt = 0;
				String QryStr = "select ea.em_id , em_code, sum(ea_amt_user) as amt";
				QryStr = QryStr
						+ " from proj_exp_mstr as em inner join proj_exp_amt as ea on ea.em_id = em.em_id";
				QryStr = QryStr
						+ " where em_userlogin = '"
						+ expense.getExpenseUser().getUserLoginId()
						+ "' and em_status not in ('Draft', 'Rejected', 'Claimed', 'F&A Rejected') and em_code <> '"
						+ expense.getFormCode() + "'";
				QryStr = QryStr + " group by ea.em_id, em_code";
				SQLResults sr = sqlExec.runQueryCloseCon(QryStr);
				for (int row = 0; row < sr.getRowCount(); row++) {
					System.out.println("ER code = " + sr.getString(row, "em_code"));
					ToBeClaimedAmt = ToBeClaimedAmt + sr.getFloat(row, "amt");
				}
				printWithRightPadding(out, "Total outstanding amount to be claimed:\t", length);
				out.println(Num_formater.format(ToBeClaimedAmt));
				// hs.flush();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		printWithRightPadding(out, "Staff:\t\t\t\t\t", length);
		out.println(expense.getExpenseUser().getName());

		// printWithRightPadding(out,"Status:\t\t",length);
		// out.println(expense.getStatus());

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		printWithRightPadding(out, "Entry Date:\t\t\t\t", length);
		out.println(formatter.format(expense.getEntryDate()));

		// printWithRightPadding(out,"Expense Date:\t\t",length);
		// out.println(formatter.format(expense.getExpenseDate()));

		// printWithRightPadding(out,"Currency Type:\t",length);
		// out.println(expense.getExpenseCurrency().getCurrName());

		// printWithRightPadding(out,"Currency Rate:\t",length);
		// out.println(expense.getCurrencyRate());

		printWithRightPadding(out, "Project:\t\t\t\t", length);
		out.println(expense.getProject().getProjId() + ":" + expense.getProject().getProjName());

		// printWithRightPadding(out,"Customer:\t\t",length);
		// out.println(expense.getProject().getCustomer().getAccount().getDescription());

		printWithRightPadding(out, "Paid By:\t\t\t\t", length);
		if (expense.getClaimType().equalsIgnoreCase("CY"))
			out.println("Customer");
		else
			out.println("Companyg");
		if (expense.getStatus().equals("Submitted")) {
			printWithRightPadding(out, "http://192.168.2.4/Live/findExpToApprovalPage.do", length);
		}else{
			printWithRightPadding(out, "http://192.168.2.4/Live ", length);
		}
		/*
		 * printWithRightPadding(out,"Total Amount:\t\t",length); float amount =
		 * 0; java.util.Set set = expense.getAmounts(); Iterator iterator =
		 * set.iterator(); while(iterator.hasNext()){ ExpenseAmount ea =
		 * (ExpenseAmount)iterator.next(); amount +=
		 * ea.getUserAmount().floatValue(); } out.println(amount); amount = 0;
		 */
		return sw.toString();
	}

	// when creating a new receipt , send mails to four PA
	static public void notifyUser(ProjectReceiptMaster receipt, String location)
			throws SQLException {

		String email = null;
		String title = null;
		String body = null;

		java.util.List list = new java.util.ArrayList();

		if (location.equals("Shanghai")) {
			email = "jasmine.wang@atosorigin.com";
			email += ";troly.tang@atosorigin.com";
			email += ";Jasey.xi@atosorigin.com";
			email += ";queenie.yu@atosorigin.com";
			email += ";cathy.song@atosorigin.com";
			email += ";ivy.feng@atosorigin.com";
		} else if (location.equals("Beijing")) {
			// email = "hongyan.zhao@atosorigin.com";
			// email += ";qi.shen@atosorigin.com";
			// email += ";chengdong.sun@atosorigin.com";
		}
		log.info(email);

		title = "PAS Information : New Receipt Created";
		if (!(email == null || email.trim().equals(""))) {
			body = getEmailBody(receipt);
			EmailUtil.sendMail(email, title, body);
			log.info(body);
		} else {
			log.info("Email Address Error");
		}
	}

	private static String getEmailBody(ProjectReceiptMaster receipt) {

		final int length = 0;
		StringWriter sw = new StringWriter();
		PrintWriter out = new PrintWriter(sw);

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

		out.println("Dear All,");
		out.println("");
		out
				.println("	PAS kindly prompts you that the following customer receipt has been created by "
						+ receipt.getCreateUser().getName());

		out.println("");
		out.println("");

		printWithRightPadding(out, "Receipt No.:\t\t", length);
		out.println(receipt.getReceiptNo());

		printWithRightPadding(out, "Receipt Amount:\t\t", length);
		out.println(receipt.getReceiptAmount());

		printWithRightPadding(out, "Currency:\t\t", length);
		out.println(receipt.getCurrency().getCurrName());

		printWithRightPadding(out, "Customer:\t\t", length);
		out.println(receipt.getCustomerId().getDescription());

		printWithRightPadding(out, "Receipt Date:\t\t", length);
		out.println(formatter.format(receipt.getReceiptDate()));

		out.println("");
		printWithRightPadding(out, "http://192.168.2.4/Live ", length);
		return sw.toString();
	}

	// when creating a new project , send mails to PM and PA
	static public void notifyUser(ProjectMaster proj_master) throws SQLException {

		String email = null;
		String title = null;
		String body = null;

		java.util.List list = new java.util.ArrayList();

		email = proj_master.getProjectManager().getEmail_addr()
				+ ((proj_master.getProjAssistant() != null && proj_master.getProjAssistant().getEmail_addr() != null) ?  (";" + proj_master.getProjAssistant().getEmail_addr()) : "");
		log.info(email);
		if (proj_master.getProjectCategory().getId().equals("I")) {
			if ((proj_master.getProjName().startsWith("PRESALE")))
				title = "PAS Information : New Internal Presale Project Created";
			else
				title = "PAS Information : New Internal Project Created";
		} else {
			title = "PAS Information : New Project Created";
		}

		if (!(email == null || email.trim().equals(""))) {
			body = getEmailBody(proj_master);
			EmailUtil.sendMail(email, title, body);
			log.info(body);
		} else {
			log.info("Email Address Error");
		}
	}

	private static String getEmailBody(ProjectMaster proj_master) {

		final int length = 0;
		StringWriter sw = new StringWriter();
		PrintWriter out = new PrintWriter(sw);

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

		out.println("Dear All,");
		out.println("");
		if (proj_master.getProjectCategory().getId().equals("I")) {
			if ((proj_master.getProjName().startsWith("PRESALE")))
				out
						.println("	PAS kindly prompts you that the following Internal Presale Project has been created in the system. Please quote this project code "
								+ proj_master.getProjId() + " for related TS and Expense input.");
			else
				out
						.println("	PAS kindly prompts you that the following Internal Project has been created in the system. Please quote this project code "
								+ proj_master.getProjId() + " for related TS and Expense input.");
		} else {
			out
					.println("	PAS kindly prompts you that the following project has been created in the system. Please quote this project code "
							+ proj_master.getProjId() + " for related TS and Expense input.");
		}
		// out.println(" PAS kindly prompts you that the following project has
		// been created in the system");

		out.println("");
		out.println("");

		if (proj_master.getProjectCategory().getId().equals("I")) {
			if ((proj_master.getProjName().startsWith("PRESALE")))
				printWithRightPadding(out, "Internal Presale Project Code:\t", length);
			else
				printWithRightPadding(out, "Internal Project Code:\t\t", length);
		} else {
			printWithRightPadding(out, "Project Code:\t\t\t", length);
		}
		out.println(proj_master.getProjId());

		printWithRightPadding(out, "Description:\t\t\t\t", length);
		out.println(proj_master.getProjName());

		printWithRightPadding(out, "Customer:\t\t\t\t", length);
		out.println(proj_master.getCustomer().getDescription());

		printWithRightPadding(out, "Contract Type:\t\t\t", length);
		out.println(proj_master.getContractType());

		printWithRightPadding(out, "Start Date:\t\t\t\t", length);
		out.println(formatter.format(proj_master.getStartDate()));

		printWithRightPadding(out, "End Date:\t\t\t\t", length);
		out.println(formatter.format(proj_master.getEndDate()));

		printWithRightPadding(out, "Project Manager:\t\t\t", length);
		out.println(proj_master.getProjectManager().getName());

		if (!proj_master.getProjectCategory().getId().equals("I")) {
			printWithRightPadding(out, "Project Assistant:\t\t\t", length);
			//out.println(proj_master.getProjAssistant().getName());
		}

		NumberFormat Num_formater = NumberFormat.getInstance();
		Num_formater.setMaximumFractionDigits(2);
		Num_formater.setMinimumFractionDigits(2);

		printWithRightPadding(out, "Total Contract Value (RMB):\t\t", length);
		out.println(Num_formater.format(proj_master.getTotalServiceValue()));

		if (proj_master.getProjectCategory().getId().equals("I")) {
			if (proj_master.getProjName().startsWith("PRESALE")) {
				StringTokenizer st = new StringTokenizer(proj_master.getProjName(), "-");
				st.nextToken();
				String bidno = st.nextToken();
				String biddesc = st.nextToken();
				printWithRightPadding(out, "Bid No:\t\t\t\t", length);
				out.println(bidno);
				printWithRightPadding(out, "Bid Salesperson:\t\t\t", length);
				out.println(proj_master.getProjAssistant().getName());
			}
		}

		out.println("");
		out.println("");
		printWithRightPadding(out, "Dear " + proj_master.getProjectManager().getName()
				+ ", please assign proper resources for this project.", length);
		out.println("");
		out.println("");
		printWithRightPadding(out, "http://192.168.2.4/Live", length);

		return sw.toString();
	}

	// when delete a bid master, send mails to PM
	static public void notifyUser(BidMaster bm, String reason) throws SQLException {

		String address = null;
		String title = null;
		String body = null;

		address = bm.getPresalePM().getEmail_addr() + ";" + bm.getSalesPerson().getEmail_addr();

		if (bm.getSecondarySalesPerson() != null) {
			address += bm.getSecondarySalesPerson().getEmail_addr();
		}
		log.info(address);

		title = "PAS Information : Bid Master was Deleted";

		if (!(address == null || address.trim().equals(""))) {
			body = getEmailBody(bm, reason);
			EmailUtil.sendMail(address, title, body);
			log.info(body);
		} else {
			log.info("Email Address Error");
		}
	}

	private static String getEmailBody(BidMaster bm, String reason) {

		final int length = 0;
		StringWriter sw = new StringWriter();
		PrintWriter out = new PrintWriter(sw);

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

		out.println("Dear All,");
		out.println("");

		out
				.println("	PAS kindly prompts you that the following bid master has been deleted from the system.");

		out.println("");
		out.println("");

		printWithRightPadding(out, "Bid Master Code:\t\t", length);

		out.println(bm.getNo());

		printWithRightPadding(out, "Description:\t\t\t", length);
		out.println(bm.getDescription());

		printWithRightPadding(out, "Prospect/Customer:\t\t", length);
		out.println(bm.getProspectCompany().getDescription());

		printWithRightPadding(out, "Contract Type:\t\t\t", length);
		out.println(bm.getContractType());

		printWithRightPadding(out, "Start Date:\t\t\t", length);
		out.println(formatter.format(bm.getEstimateStartDate()));

		printWithRightPadding(out, "End Date:\t\t\t", length);
		out.println(formatter.format(bm.getEstimateEndDate()));

		printWithRightPadding(out, "Presale Project Manager:\t", length);
		out.println(bm.getPresalePM().getName());

		if (bm.getSecondarySalesPerson() != null) {

			printWithRightPadding(out, "Sales Person 1:\t\t\t", length);
			out.println(bm.getSalesPerson().getName());

			printWithRightPadding(out, "Sales Person 2:\t\t\t", length);
			out.println(bm.getSecondarySalesPerson().getName());
		} else {
			printWithRightPadding(out, "Sales Person:\t\t\t", length);
			out.println(bm.getSalesPerson().getName());
		}

		NumberFormat Num_formater = NumberFormat.getInstance();
		Num_formater.setMaximumFractionDigits(2);
		Num_formater.setMinimumFractionDigits(2);

		printWithRightPadding(out, "Total Contract Value(RMB):\t", length);
		out.println(Num_formater.format(bm.getEstimateAmount()));

		printWithRightPadding(out, "Deletion Reason:\t\t", length);
		out.println(reason);

		out.println("");
		out.println("");
		printWithRightPadding(out, "http://192.168.2.4/Live", length);

		return sw.toString();
	}

	private static void printWithRightPadding(PrintWriter out, String s, int len) {
		out.print(s);
		for (int i = 0; i < len - s.length(); i++) {
			out.print(' ');
		}
	}

	static public void notifyUser(final UserLogin ul) throws SQLException {

		String email = null;
		// if(expense.getStatus().equalsIgnoreCase("Submitted"))
		email = ul.getEmail_addr();
		if (email != null && email.length() > 1) {
			log.info("Email --> " + email);

			String title = "Your PAS Password ";
			log.info("Title -->" + title);

			if (!(email == null || email.trim().equals(""))) {
				final String body = "Dear "
						+ ul.getName()
						+ ": \n\nYour original password for PAS system is "
						+ ul.getCurrent_password()
						+ ".  \n\nThis is an auto-generated mail from PAS as you have requested for password prompt. Please do not reply this mail.";
				// log.info(body);
				EmailUtil.sendMail(email, title, body);
			} else {
				log.info("No email address");
			}
		}
	}

	// add by Will begin. 2006-06-01
	// send mail to outstanding ts users.
	static public void notifyUser(String theEmailAddr, String theFromDate, String theEndDate)
			throws SQLException {

		// test email address
		// String test ="will.li@atosorigin.com";

		String emailAddr = null;
		String title = null;
		String body = null;
		String fromDate = theFromDate;
		String endDate = theEndDate;

		emailAddr = theEmailAddr;
		log.info(emailAddr);

		title = "Outstanding Time Sheet entry";
		if (emailAddr != null && !emailAddr.trim().equals("")) {
			if (fromDate != null && !fromDate.trim().equals("")) {
				if (endDate != null && !endDate.trim().equals("")) {
					body = getEmailBody(fromDate, endDate);
					String tmpAddr = "";
					StringTokenizer token = new StringTokenizer(emailAddr, ";");

					int count = 0;
					while (token.hasMoreTokens()) {
						tmpAddr += token.nextToken() + ";";
						count++;
						if(count == 5){
							EmailUtil.sendMail(tmpAddr, title, body);
							tmpAddr = "";
							count = 0;
						}
					}
					if(!tmpAddr.equals("")){
						EmailUtil.sendMail(tmpAddr, title, body);
					}

					//EmailUtil.sendMail(emailAddr, title, body);
					// EmailUtil.sendMail(test, title, body);
					log.info(body);
				} else {
					log.info("EndDate is empty");
				}
			} else {
				log.info("FromDate is empty");
			}
		} else {
			log.info("Email Address Error");
		}
	}

	private static String getEmailBody(String theFromDate, String theEndDate) {

		final int length = 0;

		StringWriter sw = new StringWriter();
		PrintWriter out = new PrintWriter(sw);

		String fromDate = theFromDate;
		String endDate = theEndDate;

		out.println("Dear All,");
		out.println("");
		out
				.println("\n\n    PAS reminds you that your time sheet from "
						+ fromDate
						+ " to "
						+ endDate
						+ " is not fully filled! Please take your time to complete your time sheet."
						+ "\n\nYour expense claim during this time period will be affected if you haven't completed "
						+ "time sheet on time.");
		out.println("");
		printWithRightPadding(out, "http://192.168.2.4/Live", length);
		out.println("");
		out.println("");

		out.println("");

		return sw.toString();
	}

	// add by Will end. 2006-06-01

	// Send mail for outstanding CAF report
	static public void notifyUser(SQLResults sr, String fromDate, String endDate)
			throws SQLException {

		if (sr != null || sr.getRowCount() >= 0) {

			SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");

			NumberFormat numformater = NumberFormat.getInstance();
			numformater.setMaximumFractionDigits(1);
			numformater.setMinimumFractionDigits(1);

			String title = "Outstanding CAF Status Report";

			String body = "";

			int rowSize = sr.getRowCount();

			List staffList = new ArrayList();

			// 查找Results中需要发送mail的员工
			for (int row = 0; row < rowSize; row++) {
				String staffId = "";
				if (row == 0) {
					staffList.add(sr.getString(row, "tsm_userlogin"));
				} else {
					staffId = sr.getString(row, "tsm_userlogin");
					String tmpId = sr.getString(row - 1, "tsm_userlogin");
					if (!staffId.equals(tmpId)) {
						staffList.add(staffId);
					}
				}
			}

			if (staffList != null && staffList.size() > 0) {

				// 分别取得每个员工的CAF信息，并发送mail
				for (int i = 0; i < staffList.size(); i++) {

					String staffName = "";
					String emailAddr = "";
					String testAddr = "";

					List proj = new ArrayList();
					List projMana = new ArrayList();
					List custName = new ArrayList();
					List cafDate = new ArrayList();
					List event = new ArrayList();
					List serviceType = new ArrayList();
					List cafHrs = new ArrayList();
					List outDays = new ArrayList();

					String tmpStaffId = (String) staffList.get(i);

					for (int row = 0; row < rowSize; row++) {

						if (tmpStaffId.equals(sr.getString(row, "tsm_userlogin"))) {
							staffName = sr.getString(row, "name");
							emailAddr = sr.getString(row, "email_addr");
							// test email address
							testAddr = "will.li@atosorigin.com";
							proj.add(sr.getString(row, "pid") + ":" + sr.getString(row, "pname"));
							projMana.add(sr.getString(row, "pmname"));
							custName.add(sr.getString(row, "cname"));
							cafDate.add(dateFormater.format(sr.getDate(row, "date")));
							event.add(sr.getString(row, "event"));
							serviceType.add(sr.getString(row, "servicetype"));
							cafHrs.add(numformater.format(sr.getDouble(row, "hrs")));
							int tmpDc = 0;
							if (sr.getInt(row, "dc") > 0) {
								tmpDc = sr.getInt(row, "dc");
							}
							outDays.add(String.valueOf(tmpDc));
						}
					}
					// 每封mail设置为发送5条记录
					if (proj.size() <= 5) {
						body = getEmailBody(staffName, fromDate, endDate, proj, projMana, custName,
								cafDate, event, serviceType, cafHrs, outDays);
						log.info(body);

						EmailUtil.sendMail(emailAddr, title, body);
						// EmailUtil.sendMail(testAddr, title, body);
						log.info(body);
					} else {

						// 如果记录数大于5，则分多封mail发送
						int mailCount = proj.size() / 5;
						int remainder = proj.size() % 5;

						for (int count = 0; count <= mailCount; count++) {

							int begin = 5 * count;
							int end = 5 + 5 * count;
							if (end <= proj.size()) {

								body = getEmailBody(staffName, fromDate, endDate, proj.subList(
										begin, end), projMana.subList(begin, end), custName
										.subList(begin, end), cafDate.subList(begin, end), event
										.subList(begin, end), serviceType.subList(begin, end),
										cafHrs.subList(begin, end), outDays.subList(begin, end));

								EmailUtil.sendMail(emailAddr, title, body);
								// EmailUtil.sendMail(testAddr, title, body);
								log.info(body);

							} else if (begin < proj.size()) {

								body = getEmailBody(staffName, fromDate, endDate, proj.subList(
										begin, (begin + remainder)), projMana.subList(begin,
										(begin + remainder)), custName.subList(begin,
										(begin + remainder)), cafDate.subList(begin,
										(begin + remainder)), event.subList(begin,
										(begin + remainder)), serviceType.subList(begin,
										(begin + remainder)), cafHrs.subList(begin,
										(begin + remainder)), outDays.subList(begin,
										(begin + remainder)));

								log.info(body);

								EmailUtil.sendMail(emailAddr, title, body);
								// EmailUtil.sendMail(testAddr, title, body);
								log.info(body);
							}
						}
					}
				}
			} else {
				log.info("No Employee Error");
			}
		} else {
			log.info("No Result Error");
		}
	}

	private static String getEmailBody(String name, String fromDate, String endDate, List proj,
			List projMana, List custName, List cafDate, List event, List serviceType, List cafHrs,
			List outDays) {

		final int length = 0;

		StringWriter sw = new StringWriter();
		PrintWriter out = new PrintWriter(sw);

		out.println("Dear " + name + ",");
		out.println("");
		out.println("    PAS kindly prompts you that the following Outstanding CAF from "
				+ fromDate + " to " + endDate + " of you did not finished: \n");
		for (int i = 0; i < proj.size(); i++) {

			printWithRightPadding(out, "Project:\t\t", length);
			out.println((String) proj.get(i));

			printWithRightPadding(out, "ProjectManager:\t\t", length);
			out.println((String) projMana.get(i));

			printWithRightPadding(out, "Customer Name:\t\t", length);
			out.println((String) custName.get(i));

			printWithRightPadding(out, "CAF Date:\t\t", length);
			out.println((String) cafDate.get(i));

			printWithRightPadding(out, "Event:\t\t\t", length);
			out.println((String) event.get(i));

			printWithRightPadding(out, "Service Type:\t\t", length);
			out.println((String) serviceType.get(i));

			printWithRightPadding(out, "CAF Hours:\t\t", length);
			out.println((String) cafHrs.get(i));

			printWithRightPadding(out, "Outstanding Days:\t", length);
			out.println((String) outDays.get(i));

			out.println("");
		}
		out.println("");
		printWithRightPadding(out, "http://192.168.2.4/Live", length);
		out.println("");

		return sw.toString();
	}

	private static String getEmailBody(ProjPlanBomMaster master, String slmanager) {

		final int length = 0;
		StringWriter sw = new StringWriter();
		PrintWriter out = new PrintWriter(sw);

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

		out.println("Dear " + slmanager + ",");
		out.println("");
		out
				.println("	PAS kindly prompts you the Project Bom has been created,Please maitain the Project Service Type");

		out.println("");
		out.println("");

		printWithRightPadding(out, "Bid No.:\t\t\t", length);
		out.println(master.getBid().getNo());

		printWithRightPadding(out, "Bid Descritpion.:\t\t\t", length);
		out.println(master.getBid().getDescription());

		printWithRightPadding(out, "Project ID.:\t\t\t", length);
		out.println(master.getProject().getProjId());

		printWithRightPadding(out, "Project Description:\t\t", length);
		out.println(master.getProject().getProjName());

		printWithRightPadding(out, "Project BOM version:\t\t", length);
		out.println(master.getVersion());

		out.println("");
		printWithRightPadding(out, "http://192.168.2.4/Live ", length);
		return sw.toString();
	}

	static public void notifyUser(ProjPlanBomMaster master) throws SQLException {
		try {
			String emailAddr = null;
			String title = null;
			String body = null;
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			tx = hs.beginTransaction();
			UserLogin sl;
			List result = hs
					.find("from UserLogin as ul where ul.type='slmanager' and ul.party.partyId='"
							+ master.getProject().getDepartment().getPartyId() + "'");
			if ((result != null) && (result.size()) > 0) {
				sl = (UserLogin) result.get(0);
				emailAddr = sl.getEmail_addr();
				body = getEmailBody(master, sl.getName());
			}
			title = "Project BOM ";
			if (emailAddr != null && !emailAddr.trim().equals("")) {
				EmailUtil.sendMail(emailAddr, title, body);
				log.info(body);
			} else {
				log.info("Email Address Error");
			}
			tx.commit();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static String getEmailBodyMaster(ProjPlanBomMaster master, String type) {

		final int length = 0;
		StringWriter sw = new StringWriter();
		PrintWriter out = new PrintWriter(sw);

		out.println("Dear " + master.getBid().getPresalePM().getName() + ",");
		out.println("");
		out
				.println("	PAS kindly prompts you the Project Service Types have been created,Please do Project Revenue Calculation");

		out.println("");
		out.println("");

		printWithRightPadding(out, "Bid ID.:\t\t\t", length);
		out.println(master.getBid().getNo());

		printWithRightPadding(out, "Bid Description:\t\t", length);
		out.println(master.getBid().getDescription());

		printWithRightPadding(out, "Project ID.:\t\t\t", length);
		out.println(master.getProject().getProjId());

		printWithRightPadding(out, "Project Description:\t\t", length);
		out.println(master.getProject().getProjName());

		out.println("");
		printWithRightPadding(out, "http://192.168.2.4/Live ", length);
		return sw.toString();
	}

	static public void notifyUser(ProjPlanBomMaster master, String type) throws SQLException {
		try {
			String emailAddr = null;
			String title = null;
			String body = null;

			emailAddr = master.getBid().getPresalePM().getEmail_addr();
			if (master.getProject() != null)
				emailAddr += ";" + master.getProject().getProjectManager().getEmail_addr();
			title = "Project Service Type ";
			if (emailAddr != null && !emailAddr.trim().equals("")) {
				body = getEmailBodyMaster(master, type);
				EmailUtil.sendMail(emailAddr, title, body);
				log.info(body);
			} else {
				log.info("Email Address Error");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	static public void notifyUser(CustomerProfile prospect) throws SQLException {
		try {
			String emailAddr = null;
			String title = null;
			String body = null;
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = hs.beginTransaction();
			UserLogin ul = (UserLogin) hs.load(UserLogin.class, "CN01535");

			emailAddr = ul.getEmail_addr();
			title = "New Prospect Customer Created";
			if (emailAddr != null && !emailAddr.trim().equals("")) {
				body = getEmailBodyMaster(prospect);
				EmailUtil.sendMail(emailAddr, title, body);
				log.info(body);
			} else {
				log.info("Email Address Error");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	static public String getEmailBodyMaster(CustomerProfile customer) {
		final int length = 0;
		StringWriter sw = new StringWriter();
		PrintWriter out = new PrintWriter(sw);

		out.println("Dear Sir/Lady,");
		out.println("");
		out
				.println("	PAS kindly prompts you a new Prospect Customer has been created,Please Verify it");

		out.println("");
		out.println("");

		printWithRightPadding(out, "Prospect Customer.:\t\t", length);
		out.println(customer.getDescription());

		printWithRightPadding(out, "Account:\t\t", length);
		out.println(customer.getAccount().getDescription());

		printWithRightPadding(out, "Industry.:\t\t", length);
		out.println(customer.getIndustry().getDescription());

		out.println("");
		printWithRightPadding(out, "http://192.168.2.4/Live ", length);

		return sw.toString();
	}

}
