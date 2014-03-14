/*
 * Created on 2004-11-15
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.component.helpdesk;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;

import com.aof.component.BaseServices;
import com.aof.component.domain.party.PartyServices;
import com.aof.component.domain.party.UserLoginServices;
import com.aof.component.helpdesk.party.PartyResponsibilityUserService;
import com.aof.component.helpdesk.servicelevel.SLACategoryService;
import com.aof.component.helpdesk.servicelevel.SLAPriorityService;
import com.aof.helpdesk.util.EmailUtil;
import com.aof.webapp.action.ActionException;
import com.shcnc.hibernate.CompositeQuery;
import com.shcnc.hibernate.QueryCondition;
import com.shcnc.struts.form.Formatter;
import com.shcnc.struts.form.TimeFormatter;



/**
 * @author shilei
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class CallService extends BaseServices {

	static Logger log = Logger.getLogger(CallService.class.getName());
	/**
	 * @param callID
	 * @return
	 * @throws HibernateException
	 */
	public CallMaster find(Integer callID) throws HibernateException {
		Session sess=null;
		try{
			sess=this.getSession();
			return find(callID,session);
		}
		finally{
			this.closeSession();
		}
	}
	
	public static CallMaster find(Integer callID,Session session) throws HibernateException{
		return (CallMaster) session.get(CallMaster.class,callID);
	}

	
	private void fillPartyAndUserToCall(final CallMaster call) throws HibernateException
	{
		//user
		if(call.getAssignedUser()!=null)
		{
			UserLoginServices uls=new UserLoginServices();
			call.setAssignedUser(uls.getUserLogin(call.getAssignedUser().getUserLoginId()));
			if(call.getAssignedUser()==null)
			{
				throw new ActionException("helpdesk.call.user.notexist");
			}
		}
		
		//party
		PartyServices ps=new PartyServices();
		call.setAssignedParty(ps.getParty(call.getAssignedParty().getPartyId()));
		if(call.getAssignedParty()==null)
		{
			throw new ActionException("helpdesk.call.group.notexist"); 
		}
	}
	
	public void notifyCreateCustomer(String emailAddr, String targetName, String userName, String custName, String chnName, String address, String industry)
	throws Exception{
		String title = "PAS Notification";
		String body = getEmailBody(targetName, userName, custName, chnName, address, industry);
		EmailUtil.sendMail(emailAddr, title, body);
	}
	
	private String getEmail(final CallMaster call) throws HibernateException
	{
		String email="";
		if(call.getAssignedUser()==null)
		{
			//get linkman's email
			PartyResponsibilityUserService pruService=new PartyResponsibilityUserService();
			email=pruService.getPartyNotifyEmail(call.getAssignedParty());
		} else {
			//get user's email
			email=call.getAssignedUser().getEmail_addr();
		}
		String notifycustomer = call.getNotifyCustomer();
		if (notifycustomer.equals("Y") && call.getContactInfo().getEmail() != null) {
			email = email +" ; "+call.getContactInfo().getEmail();
		}
		log.info("Email-->"+email);
		return email;
	}
	
	/**
	 * @param call
	 * @throws SQLException
	 * @throws Exception
	 */
	public boolean update(final CallMaster call) throws SQLException, Exception{
		
		this.fillPartyAndUserToCall(call);
		
		CallMaster oldCall=this.find(call.getCallID());
		if(oldCall==null)
		{
			throw new ActionException("helpdesk.call.oldcall.notexist");
		}
		
		//notifyUser if change party or user
		
		
		Session sess=null;
		Transaction tx = null;
		try{
			sess=this.getSession();
			tx = sess.beginTransaction();
			
			//modifyLog 
			//createUser and createDate has set in retrieving the old call before form populate
			//modifyUser has set in action
			call.getModifyLog().setModifyDate(new java.util.Date());
			
			
			//the accepted date is readonly when edit
			call.setAcceptedDate(oldCall.getAcceptedDate());
			//company,contact is readonly when edit
		//	call.setCompany(oldCall.getCompany());
		//	call.setContact(oldCall.getContact());
		//	call.getContactInfo().setCompanyName(oldCall.getContactInfo().getCompanyName());
		//	call.getContactInfo().setContactName(oldCall.getContactInfo().getContactName());
			System.out.println(isPartyChange(oldCall,call));
			if(isUserChange(oldCall,call)||isPartyChange(oldCall,call))
			{
				if (call.getAssignedUser() == null) {
					call.setReAssigned("Y");
					notifyUser(call);
				} else {
					String PartyNote = call.getAssignedUser().getNote();
					if (PartyNote.equals("EXT")) {
						call.setEscalated("Y");
					} else {
						call.setReAssigned("Y");
					}
				}
			}
			
			sess.update(call);
			sess.flush();
			//call change history
			this.createHistory(oldCall,call,sess);
			
			tx.commit();
		} 
		catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		}
		finally{
			this.closeSession();
		}
		
		if(isUserChange(oldCall,call)||isPartyChange(oldCall,call))
		{
			notifyUser(call);
		}
		return true;
	}

	/**
	 * @param oldCall
	 * @param call
	 * @param sess
	 * @throws SQLException
	 * @throws HibernateException
	 */
	private void createHistory(CallMaster oldCall, CallMaster call, Session sess) throws HibernateException, SQLException {
		
		if(isTypeChange(oldCall,call)||isPriorityChange(oldCall,call)
			||isPartyChange(oldCall,call)||isUserChange(oldCall,call))
		{
			CallHistory ch=new CallHistory();
			ch.setCall(call);
			if(isTypeChange(oldCall,call))
			{
				ch.setOldRequestType(oldCall.getRequestType());
				ch.setNewReqeustType(call.getRequestType());
			}
			if(isPriorityChange(oldCall,call))
			{
				ch.setOldPriority(oldCall.getPriority());
				ch.setNewPriority(call.getPriority());
			}
			if(isPartyChange(oldCall,call)||isUserChange(oldCall,call))
			{
				ch.setOldParty(oldCall.getAssignedParty());
				ch.setNewParty(call.getAssignedParty());
				ch.setOldUser(oldCall.getAssignedUser());
				ch.setNewUser(call.getAssignedUser());
			}
			ch.getModifyLog().setCreateDate(new java.util.Date());
			ch.getModifyLog().setCreateUser(call.getModifyLog().getModifyUser());
			ch.getModifyLog().setModifyDate(new java.util.Date());
			ch.getModifyLog().setModifyUser(call.getModifyLog().getModifyUser());
			sess.save(ch);
			sess.flush();
		}
	}
	private boolean isTypeChange(CallMaster oldCall, CallMaster call)
	{
		return !oldCall.getRequestType().equals(call.getRequestType());
	}
	
	private boolean isPriorityChange(CallMaster oldCall, CallMaster call)
	{
		return !oldCall.getPriority().equals(call.getPriority());
	}
	
	private boolean isPartyChange(CallMaster oldCall, CallMaster call)
	{
		return !oldCall.getAssignedParty().equals(call.getAssignedParty());
	}
	
	private boolean isUserChange(CallMaster oldCall, CallMaster call)
	{
		boolean userChange=false;
		if(oldCall.getAssignedUser()!=null && call.getAssignedUser()!=null)
		{
			userChange=!oldCall.getAssignedUser().equals(call.getAssignedUser());
		}
		else if(oldCall.getAssignedUser()==null && call.getAssignedUser()!=null)
		{
			userChange=true;
		}
		else if(oldCall.getAssignedUser()!=null && call.getAssignedUser()==null)
		{
			userChange=true;
		}
		return userChange;
	}

	/**
	 * can't be used in other session 
	 * @param call
	 * @throws SQLException
	 * @throws Exception
	 */
	public void notifyUser(final CallMaster call) throws SQLException, Exception {
		
		final String email=this.getEmail(call);
		log.info("send email to:"+email);
		final String title=call.getTicketNo()+"-"+call.getSubject();
		
		if(!(email==null||email.trim().equals("")))
		{
			final String body=getEmailBody(call);
			log.info(body);
			EmailUtil.sendMail(email,title,body);
		}
		else
		{
			log.info("no email address");
		}
	}
	
	
	private String getEmailBody(final CallMaster call) throws Exception
	{
		StringWriter sw=new StringWriter();
		PrintWriter out=new PrintWriter(sw);
		
		final int length=0;
		
		printWithRightPadding(out,"Helpdesk Ref No:\t\t",length);
		out.println(call.getTicketNo());
		
		printWithRightPadding(out,"Status:\t\t\t\t",length);
		out.println(call.getStatus().getDesc());
		
		printWithRightPadding(out,"Customer:\t\t\t",length);
		out.println(call.getContactInfo().getCompanyName());
		
		printWithRightPadding(out,"Requestor:\t\t\t",length);
		out.println(call.getContactInfo().getContactName());
		
		printWithRightPadding(out,"Telephone:\t\t\t",length);
		out.println(call.getContactInfo().getTeleCode());
		
		printWithRightPadding(out,"E-Mail:\t\t\t\t",length);
		out.println(call.getContactInfo().getEmail());

		SLACategoryService slaService=new SLACategoryService();
		printWithRightPadding(out,"Request Area:\t\t\t",length);
		out.println(slaService.getPathDesc(slaService.find(call.getRequestType().getId()),Locale.ENGLISH));
		
		SLAPriorityService slpservice=new SLAPriorityService();
		printWithRightPadding(out,"Priority:\t\t\t",length);
		out.println(slpservice.find(call.getPriority().getId()).getEngDesc());
		Formatter formatter=new TimeFormatter();
		printWithRightPadding(out,"Request Date:\t\t\t",length);
		out.println(formatter.format(call.getAcceptedDate()));
		
		printWithRightPadding(out,"Target Response Date:\t\t",length);
		out.println(formatter.format(call.getTargetResponseDate()));
		
		printWithRightPadding(out,"Target Solution Provide Date:\t",length);
		out.println(formatter.format(call.getTargetSolvedDate()));
		
		/*
		printWithRightPadding(out,"Target Closed Date:\t",length);
		out.println(formatter.format(call.getTargetClosedDate()));
		*/
		
		printWithRightPadding(out,"Assign to:\t\t\t",length);
		out.println(call.getAssignedParty().getDescription());		
		

		printWithRightPadding(out,"Create User:\t\t\t", length);
		out.print(call.getModifyLog().getCreateUser().getName());
		
		if(call.getAssignedUser()!=null)
		{
			out.print(" -- ");
			out.println(call.getAssignedUser().getName());
		}
		/* Modification : add detail information , by Bill Yu */
		printWithRightPadding(out, "-----------------------------------------------------\n", length);
		printWithRightPadding(out, "Subject: ", length);
		out.println(call.getSubject());
		out.println(call.getDesc());
		out.println("");
		out.println("");
		out.println("This is an automatically generated New Call Notification . " +
						"If you have problems please reply to shanghai.helpdesk@atosorigin.com.");
		out.println("");
		//out.println("Please access directly at ");
		out.println("http://192.168.2.4/Helpdesk");
		
		return sw.toString();
	}
	
	private String getEmailBody(String targetName, String userName, String custName, String chnName, String address, String industry) 
	throws Exception{
		StringWriter sw=new StringWriter();
		PrintWriter out=new PrintWriter(sw);
		
		final int length=0;
		
		out.println("Dear "+targetName+":");
		
		out.println("");
		out.println("	"+userName+" requires the new customer creation in PAS for new bid.");
		out.println("");
		out.println("");
		
		printWithRightPadding(out,"Customer Name:\t\t",length);
		out.println(custName);
		
		printWithRightPadding(out,"Chinese Name:\t\t",length);
		out.println(chnName);
		
		printWithRightPadding(out,"Address:\t\t",length);
		out.println(address);
		
		printWithRightPadding(out,"Industry:\t\t",length);
		out.println(industry);
		
		return sw.toString();
	}
	
	private void printWithRightPadding(PrintWriter out,String s,int len)
	{
		out.print(s);
		for(int i=0;i<len-s.length();i++)
		{
			out.print(' ');
		}
	}
	
	/**
	 * @param call
	 * @throws SQLException
	 * @throws Exception
	 */
	public boolean insert(CallMaster call) throws SQLException, Exception{
		call.setStatus(new StatusTypeService().getDefaultStatusType(call.getType()));
		
		this.fillPartyAndUserToCall(call);
		
		
		Session sess=null;
		Transaction tx = null;
		try{
			sess=this.getSession();
			tx = sess.beginTransaction();
			//modifyLog
			//createUser and modifyUser has set in action
			call.getModifyLog().setCreateDate(new java.util.Date());
			call.getModifyLog().setModifyDate(new java.util.Date());
			//call.setSolveUser(null);
			//call.setAcceptedDate(new Date());
			call.setTicketNo(getTicketNo(call,sess));
			
			if (call.getAssignedUser() != null) {
				call.setEscalated("N");
			} else {
				String PartyNote = call.getAssignedUser().getNote();
				if (PartyNote.equals("EXT")) {
					call.setEscalated("Y");
				} else {
					call.setEscalated("N");
				}
			}
			call.setReAssigned("N");
			
			sess.save(call);
			sess.flush();
			
			tx.commit();
		} 
		catch (HibernateException e) {
			if (tx != null) {
				tx.rollback();
			}
			throw e;
		}
		finally{
			this.closeSession();
		}
		
		notifyUser(call);
		return true;
	}
	
	private String getTicketNo(CallMaster call,Session sess) throws HibernateException
	{
		final String callType=call.getType().getType();
		CompositeQuery query=new CompositeQuery(
				"select count(call) from CallMaster as call",
				"",session);
		query.createQueryCondition("call.type.type=?").appendParameter(callType);
		
		QueryCondition qc=query.createQueryCondition("call.acceptedDate>=? and call.acceptedDate<?");
		final int year=getYear(call.getAcceptedDate());
		Calendar calendar=Calendar.getInstance();
		calendar.clear();
		calendar.set(
			year,//year
			0,//month
			1,//day
			0,//hour
			0,//minute
			0//second
		);
		qc.appendParameter(calendar.getTime());

		calendar.clear();
		calendar.set(
			year+1,//year
			0,//month
			1,//day
			0,//hour
			0,//minute
			0//second
		);
		qc.appendParameter(calendar.getTime());
		
		List result=query.list();
		int count = ((Integer) result.get(0)).intValue();
		return getTicketNo(callType,year,count+1);
	}
	
	private int getYear(Date date)
	{
		Calendar calendar=Calendar.getInstance();
		calendar.setTime(date);
		return calendar.get(Calendar.YEAR);
	}
	
	private String getTicketNo(String callType,int year,int no)
	{
		StringBuffer sb=new StringBuffer();
		sb.append(callType);
		sb.append(String.valueOf(year).substring(2));
		sb.append(fillPreZero(no,6));
		return sb.toString();
	}
	
	/**
	 * @param i
	 * @return
	 */
	private String fillPreZero(int no,int len) {
		String s=String.valueOf(no);
		StringBuffer sb=new StringBuffer();
		for(int i=0;i<len-s.length();i++)
		{
			sb.append('0');
		}
		sb.append(s);
		return sb.toString();
	}

	public boolean delete(Integer callID) throws HibernateException{
		Session sess=null;
		CallMaster call=null;
		try{
			sess=this.getSession();
			sess.delete("from CallStatusHistory as csh where csh.callActionHistory.callMaster.callID=?",callID,
					Hibernate.INTEGER);
			sess.delete("from CallActionHistory as cah where cah.callMaster.callID=?",callID,
					Hibernate.INTEGER);
			sess.delete("from CallHistory as ch where ch.call.callID=?",callID,
					Hibernate.INTEGER);
			sess.delete("from CallMaster as cm where cm.callID=?",callID,
				Hibernate.INTEGER);
			sess.flush();
		} 
		finally{
			this.closeSession();
		}
		return true;
	}
	
	public List listHistory(Integer callID) throws HibernateException
	{
		if(callID==null)
		{
			throw new RuntimeException("callID mustn't be null");
		}
		List retVal=new ArrayList();
		Session sess=null;
		CallMaster call=null;
		try{
			sess=this.getSession();
			retVal=sess.find("from CallHistory as ch where ch.call.callID=?",callID,Hibernate.INTEGER);
		} 
		finally{
			this.closeSession();
		}
		return retVal;
	}
	
	public List listHistory(CallMaster call)throws HibernateException
	{
		return listHistory(call.getCallID());
	}

	
	public int getCount(final Map conditions) throws HibernateException
	{
		Session sess=null;
		try{
			sess=this.getSession();
			CompositeQuery query=new CompositeQuery(
				"select count(call) from CallMaster as call",
				"",session);
			appendConditions(query,conditions);
			List result=query.list();
			if(!result.isEmpty())
			{
				//Object[] row =(Object[]) result.get(0);
				Integer count = (Integer) result.get(0);
				if(count!=null)	return count.intValue();
			}
		}
		finally{
			this.closeSession();
		}
		return 0;
	}
	
	/**
	 * @param query
	 * @param conditions
	 */
	private void appendConditions(final CompositeQuery query, final Map conditions) {
		//one para
		final String simpleConds[][]={
			{QUERY_CONDITION_TICKETNO,
				"call.ticketNo=?"},
			{QUERY_CONDITION_PRIORITY,
				"call.priority.id=?"},
			{QUERY_CONDITION_COMPANY_ID,
				"call.company.partyId=?"},
			{QUERY_CONDITION_CONTACT_ID,
				"call.contact.userLoginId=?"},
			{QUERY_CONDITION_PARTY,
				"call.assignedParty.partyId=?"},
			{QUERY_CONDITION_USER,
				"call.assignedUser.userLoginId=?"},
			{QUERY_CONDITION_TYPE,
				"call.type.type=?"},
			{QUERY_CONDITION_STATUS,
				"call.status.id=?"},
			{QUERY_CONDITION_REQUESTTYPE2,
				"call.requestType2.id=?"},
			{QUERY_CONDITION_PROBLEMTYPE,
				"call.problemType.id=?"},
				
			//{QUERY_CONDITION_STATUS,
			//	"call.status.code=?"},
		};
		for(int i=0;i<simpleConds.length;i++)
		{
			Object value=conditions.get(simpleConds[i][0]);
			if(value!=null)
			{
				if(!(value instanceof String &&((String)value).trim().equals("")))
				{
					//if value is 99,(means status "unclosed" , then query call "open","accept","solve"
					if(!(value instanceof String)&& ((Integer)value).intValue()==99){
						this.makeSimpeCondition(query, "call.status.id<>?", new Integer(3));  //3 means "CLOSE"
						this.makeSimpeCondition(query, "call.status.id<>?", new Integer(10)); //10 means "CANCELLED"
					}else{
						this.makeSimpeCondition(query,simpleConds[i][1],value);
					}	
				}
			}
		}
		//like 
		final String listConds[][]={
			{QUERY_CONDITION_COMPANY,
				"call.contactInfo.companyName like ?"},	
			{QUERY_CONDITION_CONTACT,
				"call.contactInfo.contactName like ?"},
		};
		for(int i=0;i<listConds.length;i++)
		{
			Object value=conditions.get(listConds[i][0]);
			if(value!=null)
			{
				this.makeSimpeLikeCondition(query,listConds[i][1],value);
			}
		}
		final String likeConds[][]={
			{QUERY_CONDITION_REQUESTTYPE,
				"call.requestType.fullPath like ?"},		
		};
		for(int i=0;i<likeConds.length;i++)
		{
			Object value=conditions.get(likeConds[i][0]);
			if(value!=null)
			{
				this.makeSimpeLeftLikeCondition(query,likeConds[i][1],value);
			}
		}
		
		//		{QUERY_CONDITION_STATUS,
		//	"call.status.code=?"},
		/*Integer status=(Integer) conditions.get(QUERY_CONDITION_STATUS);
		if(status!=null)
		{
			QueryCondition qc=query.createQueryCondition("call.status.id=?");
			qc.appendParameter(status);
		}*/
		
		final String dateConds[][]=
		{
			{
				QUERY_CONDITION_RESPONSE,
				"targetResponseDate",
				"responseDate",
			},
			{
				QUERY_CONDITION_SOLVE,
				"targetSolvedDate",
				"solvedDate",
			},
			{
				QUERY_CONDITION_CLOSE,
				"targetClosedDate",
				"closedDate",
			},
		};
		for(int i=0;i<dateConds.length;i++)
		{
			Object value=conditions.get(dateConds[i][0]);
			if(value!=null)
			{
				/*QueryCondition qc=
					query.createQueryCondition
					("((datediff(hh,call."+dateConds[i][1]+
					",getDate())>? and call."+dateConds[i][2]+
					" is null) or (datediff(hh,call."+dateConds[i][1]+
					",call."+dateConds[i][2]+
					")>? and call."+dateConds[i][2]+" is not null)  )");*/
				int hour=((Integer)value).intValue();
				QueryCondition qc=
					query.createQueryCondition
					("( datediff(mi,call."+dateConds[i][1]+
					",getDate())>=?*60 and call."+dateConds[i][2]+
					" is null )");
				qc.appendParameter(hour);
				qc.appendParameter(hour);
			}
		}
		
		{
			Date requestDate1=(Date) conditions.get(QUERY_CONDITION_REQUESTDATE1);
			if(requestDate1!=null)
			{
				QueryCondition qc=
					query.createQueryCondition
					("call.acceptedDate>=?");
				qc.appendParameter(requestDate1);
			}
		}
		
		{
			Date requestDate2=(Date) conditions.get(QUERY_CONDITION_REQUESTDATE2);
			if(requestDate2!=null)
			{
				QueryCondition qc=
					query.createQueryCondition
					("call.acceptedDate<?");
				Calendar calendar=Calendar.getInstance();
				calendar.setTime(requestDate2);
				calendar.add(Calendar.DATE,1);
				qc.appendParameter(calendar.getTime());
			}
		}
		
	}

	/**
	 * @return
	 * @throws HibernateException
	 */
	public List findCall(final Map conditions,final int pageNo,final int pageSize,final String order,final boolean isDesc,boolean byCategory ) 
		throws HibernateException {
		Session sess=null;
		try{
			sess=this.getSession();
			sess.flush();
			String theOrder="call.callID desc";
			if(byCategory)
				theOrder = "call.contactInfo.companyName asc,call.requestType.id asc";
			if(order!=null&&!order.trim().equals(""))
			{
				theOrder=order;
				if(isDesc){
					theOrder+=" desc";
				}
				else
				{
					theOrder+=" asc";
				}
			}
			CompositeQuery query=new CompositeQuery(
				"select call from CallMaster as call",
				theOrder,session);
			appendConditions(query,conditions);
			return query.list(pageNo*pageSize,pageSize);
		}
		finally
		{
			this.closeSession();
		}
	}
	
	public static final String QUERY_CONDITION_TICKETNO="TicketNo";
	public static final String QUERY_CONDITION_REQUESTTYPE="requestType";
	public static final String QUERY_CONDITION_PRIORITY="priority";
	public static final String QUERY_CONDITION_COMPANY_ID="companyID";
	public static final String QUERY_CONDITION_COMPANY="company";
	public static final String QUERY_CONDITION_CONTACT_ID="contactID";
	public static final String QUERY_CONDITION_CONTACT="contact";
	public static final String QUERY_CONDITION_PARTY="party";
	public static final String QUERY_CONDITION_USER="user";
	public static final String QUERY_CONDITION_STATUS="status";
	public static final String QUERY_CONDITION_TYPE="type";
	public static final String QUERY_CONDITION_RESPONSE="response";
	public static final String QUERY_CONDITION_SOLVE="solve";
	public static final String QUERY_CONDITION_CLOSE="close";
	public static final String QUERY_CONDITION_REQUESTDATE1="request_date1";
	public static final String QUERY_CONDITION_REQUESTDATE2="request_date2";
	public static final String QUERY_CONDITION_REQUESTTYPE2="requestType2";
	public static final String QUERY_CONDITION_PROBLEMTYPE="problemType";
	/**
	 * @param ticketNo
	 * @return
	 * @throws HibernateException
	 */
	public CallMaster getCallByTicketNo(String ticketNo) throws HibernateException {
		Map conditions=new HashMap();
		conditions.put(QUERY_CONDITION_TICKETNO,ticketNo);
		List list=findCall(conditions,0,1,"",false,false);
		if(list.isEmpty())
			return null;
		else
		{
			return (CallMaster) list.get(0);
		
		}
	}
	
	public List getSLACategory()
	{
		Session sess=null;
		try{
			sess=this.getSession();
			sess.flush();
			List result =null;
			result = sess.find("from SLACategory as sla where sla.parentId = 112 order by sla.id");
			return result;
		}catch(Exception e)
		{
			e.printStackTrace();
			return null;
		}
	}
}
