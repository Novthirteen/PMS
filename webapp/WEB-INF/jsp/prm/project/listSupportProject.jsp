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

if (AOFSECURITY.hasEntityPermission("CUST_SUPP_PROJECT", "_VIEW", session)) {
	net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
	List result = null;

	if(request.getAttribute("QryList")==null){
		result = new ArrayList();
		request.setAttribute("QryList",result);
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
<form name="" action="listSupportProject.do" method="post">
<table>
<tr>
	<td>
		<%
		String textcode = request.getParameter("textcode");
		String textdesc = request.getParameter("textdesc");
		String texttype = request.getParameter("texttype");
		String textstatus = request.getParameter("textstatus");
		String textcust = request.getParameter("textcust");
		if (textcode == null) textcode ="";
		if (textdesc == null) textdesc ="";
		if (texttype == null) texttype ="";
		if (textstatus == null) textstatus ="";
		if (textcust == null) textcust ="";
		%>
		Code:<input type="text" name="textcode" value="<%=textcode%>" class="">
		Desc:<input type="text" name="textdesc" value="<%=textdesc%>" class="">
		Customer:<input type="text" name="textcust" value="<%=textcust%>" class="">
		Event Category:
		<select name="texttype">
		<option value="" selected></option>
		<%
		Iterator itt = ptList.iterator();
		while(itt.hasNext()){
			ProjectType pt = (ProjectType)itt.next();
			if (pt.getPtId().equals(texttype)) {
				out.println("<option value=\""+pt.getPtId()+"\" selected>"+pt.getPtName()+"</option>");
			} else {
				out.println("<option value=\""+pt.getPtId()+"\">"+pt.getPtName()+"</option>");
			}
		}
		%>
		</select>   
	    Status:
	    <select name="textstatus" >
			<option value="" <%if (textstatus.equals("")) out.print("selected");%>></option>
			<option value="WIP" <%if (textstatus.equals("WIP")) out.print("selected");%>>WIP</option>
			<option value="Close" <%if (textstatus.equals("Close")) out.print("selected");%>>Closed</option>
			
	    </select>
		<input type="submit" value="Search" class="">
	</td>
	<td>   
	    <input type="button" value="New" class="" onclick="location.replace('editSupportProject.do')">
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
                <td align="center" width="4%" class="bottomBox">Seq</td>
                <td align="center" width="8%" class="bottomBox">Code</td>
                <td align="center" width="10%" class="bottomBox">Name</td>
                <td align="center" width="10%" class="bottomBox">Status</td>
				<td align="center" width="10%" class="bottomBox">Contract No.</td>
                <td align="center" width="10%" class="bottomBox">Project Manager</td>
				<td align="center" width="8%" class="bottomBox">Customer</td>
                <td align="center" width="8%" class="bottomBox">Department</td> 
              </tr>
           	<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="QryList" type="com.aof.component.prm.project.ProjectMaster" >                
			<tr>  
                <td align="left"><%=i++%></td>
                <td> 
					<a href="editSupportProject.do?DataId=<bean:write name="p" property="projId"/>"><bean:write name="p" property="projId"/></a> 
                </td>
                <td>
                    <div class="tabletext">
                    <p ><bean:write name="p" property="projName"/>
                    </div>   
                </td>            
                <td align="center"> 
                  <div class="head4">                   
                    <p ><%=((ProjectMaster) p).getProjStatus()%>
                  </div>
                </td>
				<td align="center"> 
                  <div class="head4">                   
                    <p ><%=((ProjectMaster) p).getContractNo()%>
                  </div>
                </td>
				<td align="center"> 
                  <div class="head4">                   
                    <p ><%=((ProjectMaster) p).getProjectManager().getName()%>
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
					  <td width="100%" colspan="8" align="right">
						<%if(offset.intValue()>0){%>
						<a href="listSupportProject.do?offset=<%=offset.intValue()-length.intValue()%>"><image src="<%=request.getContextPath()%>/images/pre.gif" border="0"></a>
						<%}%>
						<a href="listSupportProject.do?offset=<%=offset.intValue()+length.intValue()%>"><image src="<%=request.getContextPath()%>/images/next.gif"  border="0"></a>                    
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
