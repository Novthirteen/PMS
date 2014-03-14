package com.aof.webapp.action.prm.report;

import java.sql.SQLException;
import java.util.Hashtable;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyHelper;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.component.prm.report.BackLog;
import com.aof.component.prm.report.BackLogBean;
import com.aof.component.prm.report.BackLogMaster;
import com.aof.component.prm.report.BackLogService;
import com.aof.component.prm.report.ProjectBean;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;
import com.aof.util.Constants;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;

public class ViewBackLogAction extends BaseAction {
	protected ActionErrors errors = new ActionErrors();

	protected ActionErrorLog actionDebug = new ActionErrorLog();

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		// Extract attributes we will need
		ActionErrors errors = this.getActionErrors(request.getSession());
		Logger log = Logger.getLogger(ViewBackLogAction.class.getName());

		try {
			String action = request.getParameter("formaction");
			String cyear = request.getParameter("cyear");
			String cmonth = request.getParameter("cmonth");
			String status = request.getParameter("status");
			String department = request.getParameter("departmentId");
			String type = request.getParameter("type");
			String flag = request.getParameter("recurringflag");

			String attr_department = "";
			String attr_flag ="";
			log.info("action="+action);
			if ((action == null)||(action.equalsIgnoreCase("formaction"))) {
				action = (String) request.getAttribute("formaction");
				if(!((cyear!=null&&(cyear.length()>0)))){
				cyear = (String) request.getAttribute("cyear");
				cmonth = (String) request.getAttribute("cmonth");
				}
				attr_department = (String)request.getAttribute("departmentId");
				attr_flag = (String)request.getAttribute("recurringflag");
				action = "draft";
			}
			log.info("action="+action);

			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			tx = hs.beginTransaction();
			String bldate = cyear + "-" + "1-1";

			List securitylist = new LinkedList();
			List depcodelist = new LinkedList();
			List partyList = null;
			String departmentdesc = ((Party)hs.load(Party.class,department)).getDescription();

			UserLogin ul = (UserLogin) request.getSession().getAttribute(
					Constants.USERLOGIN_KEY);
			if(ul.getParty().getPartyId()==null)
			return null;
			long start=System.currentTimeMillis();
			Query query = hs
					.createQuery("select distinct pt from Party as p inner join p.relationships as pr inner join pr.partyTo as pt"
							+ " where p.partyId=? and pr.relationshipType=?");
			if((department==null)&&(department.length()<1))
			{
				query.setString(0,attr_department);
			}
			else
				query.setString(0, department);
			query.setString(1, "GROUP_ROLLUP");
			partyList = query.list();
			Party childparty=(Party)hs.load(Party.class,department);
			if (partyList.size() == 0) {
				partyList = new LinkedList();
			}
				partyList.add(0,childparty);
			for (int x = 0; x < partyList.size(); x++) {
				securitylist.add(((Party) partyList.get(x)).getDescription());
				depcodelist.add(((Party) partyList.get(x)).getPartyId());
			}
			request.setAttribute("securitylist", securitylist);
			String strquery="";
			if(depcodelist.size()==1)
				strquery=strquery+"'"+depcodelist.get(0)+"'";
			else if(depcodelist.size()>1)
				for(int n=0;n<depcodelist.size();n++)
				{
					strquery=strquery+"'"+depcodelist.get(n)+"'";
					if(n!=depcodelist.size()-1)
						strquery+=",";
				}
//			System.out.println("the query string for backlog is: "+strquery);			
			if (action.equalsIgnoreCase("realtime")) {
				BackLogService blservice = new BackLogService(cyear, cmonth, department);
				blservice.execuSQL(hs,strquery);
				}
			query = hs
					.createQuery("select bl from BackLog as bl inner join bl.project as pm"
							+ " where pm.projectCategory.Id='c'"
							+ " and (pm.projStatus='wip' or pm.closeDate >= case when (pm.projStatus='pc')then convert(datetime,?)"
							+ " end or pm.closeDate >= case when (pm.projStatus='close')then convert(datetime,?) end) and "
							+ " pm.department.partyId in("+strquery+")order by blm.project");
			query.setString(0,bldate);
			query.setString(1,bldate);		
			List backlist = new LinkedList();					
			backlist = query.list();
			Hashtable backtable = new Hashtable();
			for (int b = 0; b < backlist.size(); b++) {
				BackLog backlog = (BackLog) backlist.get(b);
				if (backtable.get(backlog.getproject().getProjId()) == null) {
					List rcdlist = new LinkedList();
					rcdlist.add(backlog);
					backtable.put(backlog.getProject().getProjId(), rcdlist);
				} else {
					List rcdlist = null;
					rcdlist = (List) backtable.get(backlog.getproject()
							.getProjId());
					rcdlist.add(backlog);
				}
			}
			query = hs.createQuery("select blm from BackLogMaster as blm inner join blm.project as pm  "
			+ " where  pm.projectCategory.Id='c'"
			+ " and (pm.projStatus='wip' or pm.closeDate >= case when (pm.projStatus='pc')then convert(datetime,?)"
			+ " end or pm.closeDate >= case when (pm.projStatus='close')then convert(datetime,?) end)"
			+ " and pm.department.partyId in("+strquery+") order by blm.project");
			query.setString(0,bldate);
			query.setString(1,bldate);		
			List masterlist = null;
			masterlist = query.list();
			Hashtable mastertable = new Hashtable();
			if((masterlist!=null)&&(masterlist.size()!=0)){
			for (int b = 0; b < masterlist.size(); b++) {
				BackLogMaster master = (BackLogMaster) masterlist.get(b);
				if (mastertable.get(master.getProject()) == null) {
					List rcdlist = new LinkedList();
					rcdlist.add(master);
					mastertable.put(master.getProject().getProjId(), rcdlist);
				} else {
					List rcdlist = null;
					rcdlist = (List) mastertable.get(master.getProject().getProjId());
					rcdlist.add(master);
				}
			}
			}

			for (int p = 0; p < depcodelist.size(); p++) {
				List recordlist = new LinkedList();
				SQLExecutor sqlExec = new SQLExecutor(Persistencer
						.getSQLExecutorConnection(EntityUtil
								.getConnectionByName("jdbc/aofdb")));
				String SqlStr;

				SqlStr = "select proj_id, proj_name,dep_id,proj_pm_user,total_service_value"
						+ ",start_date,end_date,proj_status,contracttype,proj_caf_flag,total_service_value,"
						+ "close_date,cust.description,cp.t2_code,ind_description,duration from proj_mstr inner join party as cust"
						+ " on proj_mstr.cust_id=cust.party_id  inner join custprofile as cp on proj_mstr.cust_id=cp.party_id "
						+ " inner join industry as ind  on cust_industry=ind.ind_id ";
				SqlStr = SqlStr
						+ " where proj_mstr.dep_id="+(String) depcodelist.get(p)+" and proj_mstr.proj_Category='c'";
				SqlStr = SqlStr
						+ " and (proj_status='wip' or close_date >= case when (proj_status='pc')then convert(datetime,'"+bldate+"')";
				SqlStr = SqlStr
						+ " end or close_date >= case when (proj_status='close')then convert(datetime,'"+bldate+"') end)" ;
				if((flag!=null)&&((flag.equalsIgnoreCase("on"))||(flag.equalsIgnoreCase("y")))){
					SqlStr  =SqlStr+" and duration='recurring'";
					request.setAttribute("recurringflag","y");
				}
				if((attr_flag!=null)&&((attr_flag.equalsIgnoreCase("on"))||(attr_flag.equalsIgnoreCase("y"))))
				{
					SqlStr  =SqlStr+" and duration='recurring'";
					request.setAttribute("recurringflag","y");					
				}
//				else
//					request.setAttribute("recurringflag","n");
				if ((type!=null)){
					if(!type.equalsIgnoreCase("all")){
					SqlStr  =SqlStr+" and duration='"+type+"'";
					if(type.trim().equalsIgnoreCase("recurring"))
						request.setAttribute("recurringflag","y");
					}
					else{
					SqlStr  =SqlStr+" and duration!='other'";
					}
					request.setAttribute("type",type);
				}
					
				SqlStr = SqlStr
						+ " order by duration desc,proj_id";
//				System.out.println(SqlStr);
				SQLResults sr = sqlExec.runQueryCloseCon(SqlStr);
				int row = 0;
				if (sr.getRowCount() != 0) {
					for (int i = 0; i < sr.getRowCount(); i++) {
						ProjectBean pb = new ProjectBean(sr.getString(row,
								"proj_id"), sr.getString(row, "proj_name"), sr
								.getString(row, "description"), sr.getString(
								row, "dep_id"), sr
								.getString(row, "proj_status"), sr.getString(
								row, "proj_pm_user"), sr.getString(row,
								"proj_caf_flag"), sr.getDouble(row,
								"total_service_value"), sr.getString(row,
								"proj_id"), sr.getString(row, "contracttype"),
								sr.getDate(row, "start_date"), sr.getDate(row,
										"end_date"), sr.getString(row,
										"t2_code"), sr.getString(row,
										"ind_description"),sr.getString(row,"duration"));
						List bllist = (List) backtable.get(sr.getString(row,
								"proj_id"));
						List mstlist = (List)mastertable.get(sr.getString(row,
								"proj_id"));
						if (bllist == null)
							bllist = new LinkedList();
						if(mstlist==null)
							mstlist=new LinkedList();
						BackLogBean bean = new BackLogBean();
						bean.initial(pb, bllist, cyear, cmonth, action,mstlist);
						bean.setBean();
						recordlist.add(bean);
						row++;
					}
					request.setAttribute((String) securitylist.get(p),
							recordlist);
				}
				
				else
				{
					request.setAttribute((String) securitylist.get(p),
							new LinkedList());
				}
			}
			
			request.setAttribute("enter_month", cmonth);
			request.setAttribute("enter_year", cyear);
			request.setAttribute("departmentId", department);
			request.setAttribute("departmentdesc",departmentdesc);

			hs.flush();
			tx.commit();
			
//			System.out.println(action);
			if ((action.equalsIgnoreCase("export"))&&(status!=null)&&(status.equalsIgnoreCase("export")))
				return (mapping.findForward("export"));
			if (action.equalsIgnoreCase("draft")
					|| (action.equalsIgnoreCase("realtime"))||(action.equalsIgnoreCase("requery"))){
				return (mapping.findForward("view"));
			}
			else
				return (mapping.findForward("error"));
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			return (mapping.findForward("error"));

		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			} catch (SQLException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
		}
	}

}
