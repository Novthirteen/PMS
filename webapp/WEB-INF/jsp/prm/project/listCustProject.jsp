<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.Query"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%

if (AOFSECURITY.hasEntityPermission("CUST_PROJECT", "_VIEW", session)) {
 net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush(); 
 List result = null;
		
	String textcode = request.getParameter("textcode");
	String textdesc = request.getParameter("textdesc");
	String texttype = request.getParameter("texttype");
	String textstatus = request.getParameter("textstatus");
    String textcust = request.getParameter("textcust");
	if((textcode!=null && textcode.length()>1)||(textdesc!=null && textdesc.length()>1)||(texttype!=null && texttype.length()>1)||(textstatus!=null && textstatus.length()>1) ||(textcust!=null && textcust.length()>1)){
	
		Query q=Hibernate2Session.currentSession().createQuery("select p from ProjectMaster as p inner join p.projectType as pt inner join p.customer as c where ((p.projId like '%"+ textcode +"%') and (p.projName like '%"+ textdesc +"%') and (p.projStatus like '%"+ textstatus +"%') and ((c.partyId like '%"+ textcust +"%') or (c.description like '%"+ textcust +"%')) and (pt.ptId like '%"+ texttype +"%') )");
		result = q.list();
		request.setAttribute("QryList",result);
			
	}else{
		if(request.getAttribute("QryList")==null){
			result = new ArrayList();
			request.setAttribute("QryList",result);
		}
	}
	
	Integer offset = null;	
	if( request.getParameter("offset") == null || request.getParameter("offset").equals("") ){
		offset = new Integer(0);
	}else{
		offset = new Integer(request.getParameter("offset"));
	} 
	
	Integer length = new Integer(15);	

    request.setAttribute("offset", offset);
    request.setAttribute("length", length);	
    
    int i = offset.intValue()+1;
List ptList=null;
try{    
    ProjectHelper proh= new ProjectHelper();
    ptList=proh.getAllProjectType(hs);
}catch(Exception e){
	out.println(e.getMessage());
}  

    
%>
<form name="" action="listCustProject.do" method="post">
<table>
<tr>
	
	<td>
	<form name="" action="listCustProject.do" method="post">
		Code:
		<input type="text" name="textcode" value="" class="">
	    Desc:
	    <input type="text" name="textdesc" value="" class="">
	    Customer:
       <input type="text" name="textcust" value="" class="">
	   Event Category:
	    <select name="texttype">
	       <option value="" selected></option>
	      <%
			Iterator itt = ptList.iterator();
			while(itt.hasNext()){
				ProjectType pt = (ProjectType)itt.next();
				out.println("<option value=\""+pt.getPtId()+"\">"+pt.getPtName()+"</option>");
			}
			%>
			</select>   
	    Status:
	    <select name="textstatus" >
	    <option value=""></option>
	    <option value="WIP">WIP</option>
		<option value="Close">Close</option>
		<option value="Cancel">Cancel</option>
	    </select> 
		
	    <input type="submit" value="Search" class="">
    </form>
	</td>
	<td>   
	    <form name="" action="editCustProject.do" method="post">
		    <input type="submit" value="New" class="">
	    </form>
	</td>
</tr>
</table>
</form>

<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="topBox">
            Project List
          </TD>
        </tr>
      </table>
    </TD>
  </TR>
  <TR>
    <TD width='100%'>
            <table width='100%' border='0' cellspacing='0' cellpadding='0' >
              <tr>
                <td align="center" valign="center" width='100%'>
                 
                    <table width='100%' border='0' cellpadding='0' cellspacing='1'>
                      <tr >
                        
                <td align="left" width="4%" class="bottomBox"> 
                  <p align="left">Seq 
                </td>
                        
                <td align="left" width="8%" class="bottomBox"> 
                  <p align="left">Code 
                </td>
                <td align="left" width="10%" class="bottomBox">
                    <p align="left">Name
                </td>
                <td align="left" width="10%" class="bottomBox">
                    <p align="left">Event Category
                </td>
                
                <td align="center" width="8%" class="bottomBox"> 
                  <p align="center">Customer 
                </td>
                <td align="center" width="8%" class="bottomBox"> 
                  <p align="center">Department 
                </td> 
              </tr>
           	<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="QryList" type="com.aof.component.prm.project.ProjectMaster" >                
           	         	<tr>  
           	
                <td align="left"> 
                 <div class="tabletext">
                  <p align="left"><%= i++%> 
                  </div>
                </td>
			                        
                <td> 
                  <p ><a href="editCustProject.do?DataId=<bean:write name="p" property="projId"/>"><bean:write name="p" property="projId"/></a> 
                </td>
                <td>
                    <div class="tabletext">
                    <p ><bean:write name="p" property="projName"/>
                    </div>   
                </td>            
                <td align="center"> 
                  <div class="head4">                   
                    <p ><%=((ProjectMaster) p).getProjectType().getPtId()%>
                  </div>
                </td>
                 
                <td>
                    <div class="head4">
                    <p ><%=((ProjectMaster) p).getCustomer().getDescription()%>
                    
                    </div>
                </td>
                <td>
                    <div class="head4">
                    <p > <%=((ProjectMaster) p).getDepartment().getDescription()%> 
                  
                    </div>
                </td>
				</tr>
				</logic:iterate> 		
					  <tr class="bottomBox">
					  <td width="100%" colspan="7" align="right">
						<%if(offset.intValue()>0){%>
						<a href="listCustProject.do?offset=<%=offset.intValue()-length.intValue()%>"><image src="<%=request.getContextPath()%>/images/pre.gif" border="0"></a>
						<%}%>
						<a href="listCustProject.do?offset=<%=offset.intValue()+length.intValue()%>"><image src="<%=request.getContextPath()%>/images/next.gif"  border="0"></a>                      
 					  </td>
					  </tr>
						
                    </table>
                </td>
              </tr>
            </table>
         </td>
        </tr>
</table>
<%
request.removeAttribute("QryList");
}else{
	out.println("!!你没有相关访问权限!!");
}

		Hibernate2Session.closeSession();

%>
