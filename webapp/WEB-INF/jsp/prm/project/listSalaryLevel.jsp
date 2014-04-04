<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
try {
//if (true) {
if (AOFSECURITY.hasEntityPermission("SALARY_LEVEL", "_VIEW", session)) {

	List result = (List)request.getAttribute("QryList");	
    String level = request.getParameter("level");
	String description = request.getParameter("description");
	String status = request.getParameter("status");

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
%>

<script language="javascript">

	function doQuery(){
		document.frm.offset.value = "0";
		document.frm.submit();
	}

	function turnPage(offSet) {
		document.frm.offset.value = offSet;
		document.frm.submit();
	}
</script>

<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align="center" class=pgheadsmall>Salary Level List</CAPTION>
<tr>
	<td colspan=8><hr color=red></hr></td>
</tr>
<tr>	
	<td>
		<form name="frm" action="findSalaryLevel.do" method="post">
			<input type="hidden" name="offset" Id="offset" value="<%=offset%>">
		    Level:
			<input type="text" name="level" value="<%=level != null ? level : ""%>">
			Description:
			<input type="text" name="description" value="<%=description != null ? description : ""%>">
			Status:
			<select name="status">
				<option value="" selected>All</option>
				<option value="1" <%="1".equals(status) ? "selected" : ""%>>Enabled</option>
				<option value="0" <%="0".equals(status) ? "selected" : ""%>>Disabeld</option>
			</select>
		    <input type="submit" value="Search" onclick="doQuery();">
		     <input type="button" value="New" onclick="document.frm1.submit();">
	    </form>
	 </td>
	 <td>   
	    <form name="frm1" action="editSalaryLevel.do" method="post">
	    </form>
	</td>
		<td width="30%"></td>
</tr>
<tr>
	<td colspan=8><hr color=red></hr></td>
</tr>
</table>

<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="topBox">
            Salary Level List
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
                  <p align="left"># 
                </td>
                        
                <td align="left" width="10%" class="bottomBox"> 
                  <p align="left">Level 
                </td>
                <td align="left" width="10%" class="bottomBox">
                    <p align="left">Description
                </td>
                <td align="left" width="10%" class="bottomBox">
                    <p align="left">Party
                </td>
                <td align="left" width="10%" class="bottomBox"> 
                  <p align="left">Status 
                </td>
              </tr>
			<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="QryList" type="com.aof.component.prm.project.SalaryLevel" >                
			<tr>  
                <td align="left"> 
                 <div class="tabletext">
                  <p align="left"><%= i++%> 
                  </div>
                </td>
			                        
                <td> 
                  <p ><a href="editSalaryLevel.do?id=<bean:write name="p" property="id"/>"><bean:write name="p" property="level"/></a> 
                </td>
                <td>
                    <div class="tabletext">
                    <p ><bean:write name="p" property="description"/>
                    </div>   
                </td>
                 <td>
                    <div class="tabletext">
                    <p ><%=p.getParty().getDescription()%>
                    </div>   
                </td>
                <td>
                    <div class="tabletext">
                    <p >
                    <%
                    	if ("0".equals(p.getStatus().toString())) {
                    		out.println("Disabled");
                    	} else {
                    		out.println("Enabled");
                    	}
                    %>
                    </div>   
                </td>
				</tr>
			</logic:iterate> 
					 <tr>
			
				<td width="100%" colspan="11" align="right" class=lblbold>Pages&nbsp;:&nbsp;
				<%
				int RecordSize = result.size();
				int l = 0;
				while ((l * length.intValue()) < RecordSize) {
					if (offset.intValue() == l*length.intValue()) {%>
					&nbsp;<%=l+1%>&nbsp;
					<%} else {%>
					&nbsp;<a href="javascript:turnPage(<%=l*length.intValue()%>)" title="Click here to view next set of records"><%=l+1%></a>&nbsp;
					<%};
					l++;
				}%>
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
} catch (Exception ex) {
	ex.printStackTrace();
}

%>