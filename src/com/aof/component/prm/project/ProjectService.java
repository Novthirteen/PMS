package com.aof.component.prm.project;

import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;

import com.aof.component.BaseServices;
import com.aof.core.persistence.Persistencer;
import com.aof.core.persistence.jdbc.SQLExecutor;
import com.aof.core.persistence.jdbc.SQLResults;
import com.aof.core.persistence.util.EntityUtil;

public class ProjectService extends BaseServices {
	public String getProjectNo(ProjectMaster Project,Session sess) throws HibernateException {
		Calendar calendar=Calendar.getInstance();
		final int year=calendar.get(Calendar.YEAR);
		String CodePrefix = getProjectNoPrefix(Project,year);
		Query q = sess.createQuery("select max(p.projId) from ProjectMaster as p where p.projId like '"+CodePrefix+"%'");
		
		List result=q.list();
		int count = 0;
		String GetResult = (String)result.get(0);
		if (GetResult !=  null)
			count = (new Integer(GetResult.substring(CodePrefix.length()))).intValue();
		return getProjectNo(CodePrefix,count+1);
	}
	
	private String getProjectNo(String CodePrefix,int no)
	{
		StringBuffer sb=new StringBuffer();
		sb.append(CodePrefix);
		sb.append(fillPreZero(no,4));
		return sb.toString();
	}
	private String getProjectNoPrefix(ProjectMaster Project,int year)
	{
		StringBuffer sb=new StringBuffer();
		sb.append(Project.getProjectCategory().getId());
		sb.append(String.valueOf(year).substring(2));
		sb.append(Project.getDepartment().getPartyId());
		return sb.toString();
	}
	
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
	
	private int getYear(Date date)
	{
		Calendar calendar=Calendar.getInstance();
		calendar.setTime(date);
		return calendar.get(Calendar.YEAR);
	}
	
	public void UpdateProjectLink (Session hs, ProjectMaster Project, String ParentProjectId) throws HibernateException{
		String OldProjectLinkNote = "";
		OldProjectLinkNote = Project.getProjectLink();
		if (ParentProjectId.equals("")) {
			Project.setParentProject(null);
			Project.setProjectLink(Project.getProjId()+":");
		} else {
			ProjectMaster ParentProject = (ProjectMaster)hs.load(ProjectMaster.class,ParentProjectId);
			Project.setParentProject(ParentProject);
			Project.setProjectLink(ParentProject.getProjectLink()+Project.getProjId()+":");
		}
		Iterator itChildProject = hs.find("from ProjectMaster as p where p.ProjectLink like '"+OldProjectLinkNote+"%'").iterator();
		while (itChildProject.hasNext()) {
			ProjectMaster ChildProject= (ProjectMaster)itChildProject.next();
			ChildProject.setProjectLink(Project.getProjectLink()+ChildProject.getProjId()+":");
			hs.update(ChildProject);
		}
	}
	
	public String genMaxEventCode(Session hs) {
		SQLExecutor sqlExec = new SQLExecutor(Persistencer.getSQLExecutorConnection(EntityUtil.getConnectionByName("jdbc/aofdb")));
		SQLResults rs = sqlExec.runQueryCloseCon("select max(PEvent_Code) from ProjEvent");
		int maxCode = Integer.parseInt(rs.getString(0, 0));
		return (maxCode+1)+"";
	}
}