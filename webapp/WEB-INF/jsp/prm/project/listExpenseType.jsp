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

if (AOFSECURITY.hasEntityPermission("EXPENSE_TYPE", "_VIEW", session)) {
 net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush(); 

	List result = null;	
	String text = request.getParameter("text");
	if (text == null) text = "";
	
	if(!text.trim().equals("")){
		Query q=Hibernate2Session.currentSession().createQuery("select et from ExpenseType as et where (et.expDesc like '%"+ text +"%') or (et.expCode like '%"+ text +"%')");
		result = q.list();
		request.setAttribute("QryList",result);	
	}else{
		Query q=Hibernate2Session.currentSession().createQuery("select et from ExpenseType as et");
		result = q.list();
		request.setAttribute("QryList",result);	
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
    
List expTypeList = null;
try{
	// get expense type
	ProjectHelper ph = new ProjectHelper();
	expTypeList = ph.getAllExpenseType(hs);
	
}catch(Exception e){
	out.println(e.getMessage());
}    
%>
<script language="Javascript">
function fnSubmit1(start) {
	document.getElementById("offset").value=start;
	document.frm.submit();
}
</script>

<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>Expense Type List</CAPTION>
<tr>
	<td colspan=8><hr color=red></hr></td>
</tr>
<form name="frm" action="listExpenseType.do" method="post">
<tr>
	
	<td>		
			<input type=hidden name="offset" value="<%=offset%>">
			Expense Name:
			<input type="text" name="text" value="<%=text%>">
	</td>
	</tr><tr>
	<td>
			<input type="submit" value="Search" class="button"> 
	 		<input type="button" value="New" class="button" onclick="location.replace('editExpenseType.do')">
	</td>
	<td width ="60%"></td>
</tr>
</form>
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
           Expense Type List
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
                        
                <td align="left" width="1%" class="bottomBox"> 
                  <p align="left">#
                </td>
                <td align="left" width="10%" class="bottomBox"> 
                  <p align="left">Account Code(Paid by Customer)
                </td>
<!--                 <td align="left" width="10%" class="bottomBox"> 
                  <p align="left">Account Description(Paid by Customer)
                </td>
-->                <td align="left" width="10%" class="bottomBox">
                    <p align="left">Account Code(Paid by Company)
                </td>
<!--                 <td align="left" width="10%" class="bottomBox">
                    <p align="left">Account Description(Paid by Company)
                </td>
-->
                <td align="left" width="10%" class="bottomBox">
                    <p align="left">Expense Description
                </td>
             </tr>
			<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="QryList" type="com.aof.component.prm.project.ExpenseType" >                
			<tr>
			  		   
                <td align="left"> 
                 <div class="tabletext">
                  <p align="left"><%=i++%> 
                  </div>
                </td>
                <td>
                	<a href="editExpenseType.do?DataId=<bean:write name="p" property="expId"/>"><bean:write name="p" property="expCode"/></a>
                </td>
<!--                 <td>
                	<a href="editExpenseType.do?DataId=<bean:write name="p" property="expId"/>"><bean:write name="p" property="expAccDesc"/></a>
                </td>
-->                <td>
                	<a href="editExpenseType.do?DataId=<bean:write name="p" property="expId"/>"><bean:write name="p" property="expBillCode"/></a>
                </td>
<!--                 <td>
                	<a href="editExpenseType.do?DataId=<bean:write name="p" property="expId"/>"><bean:write name="p" property="expBillAccDesc"/></a>
                </td>
-->
                <td>
                	<a href="editExpenseType.do?DataId=<bean:write name="p" property="expId"/>"><bean:write name="p" property="expDesc"/></a>
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
					&nbsp;<a href="javascript:fnSubmit1(<%=l*length.intValue()%>)" title="Click here to view next set of records"><%=l+1%></a>&nbsp;
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

		Hibernate2Session.closeSession();

%>
