<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.prm.master.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="net.sf.hibernate.*"%>

<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%

if (AOFSECURITY.hasEntityPermission("PROJECT_CALENDAR", "_VIEW", session)) {

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
	

    request.setAttribute("offset", offset);
			
    int i = 1;
%>
<table>
<tr>
	<td>   
	    <form name="" action="editProjCalendarType.do" method="post">
		    <input type="submit" value="new" class="">
		</form>
	</td>
</tr>
</table>

<form name="ProjectCalendarListForm" action="editProjCalendarType.do" method="post">
<input type="hidden" name="FormAction" id="FormAction" value="batchUpdate">
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="topBox">
            Project Working Calendar List
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
                  <p align="center"># 
                </td>
                        
                <td align="left" width="8%" class="bottomBox"> 
                  <p align="left">Calendar Type 
                </td>
                <td align="left" width="10%" class="bottomBox">
                    <p align="left">Description
                </td>
                
             </tr>
             <%
				//List list = (List)request.getAttribute("QryList");
				
				//if (list != null && list.iterator().hasNext()) {
				//	Iterator iterator = list.iterator();
					
				//	while(iterator.hasNext()) {
					//	ProjectCalendarType PT = (ProjectCalendarType)iterator.next();
			%>
             <logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="QryList" type="com.aof.component.prm.master.ProjectCalendarType" >
				<%ProjectCalendarType pc = (ProjectCalendarType)p;%>
				<tr>  
                <td align="center"> 
                 <div class="tabletext">
                  <p ><%= i++%> 
                  </div>
                </td>
                <td align="left"> 
                  <p ><a href="editProjCalendarType.do?TypeId=<%=pc.getTypeId()%>"><%=pc.getTypeId()%></a> 
                </td>
                <td align="left">
                <p ><%=pc.getDescription()%>
                 </td>
	      </tr>
			</logic:iterate> 
					  
                    </table>
                </td>
              </tr>
            </table>
         </td>
        </tr>
        
</table>
</form>
<%
request.removeAttribute("QryList");
}else{
	out.println("!!你没有相关访问权限!!");
}

		Hibernate2Session.closeSession();

%>
