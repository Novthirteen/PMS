<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.crm.customer.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%

if (AOFSECURITY.hasEntityPermission("INDUSTRY", "_VIEW", session)) {

	List result = null;	
	String text = request.getParameter("text");
	if(text!=null && text.length()>1)
	{
		result = Hibernate2Session.currentSession().createQuery("select ind from Industry as ind where (ind.Description like '%"+ text +"%')").list();
		request.setAttribute("QryList",result);	
	}
	else
	{
		result = Hibernate2Session.currentSession().createQuery("select ind from Industry as ind").list();
		request.setAttribute("QryList",result);	
		
		if(request.getAttribute("QryList")==null)
		{
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
%>

<script language="Javascript">
function fnSubmit1(start) {
	document.getElementById("offset").value=start;
	document.frm.submit();
}
</script>

<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>Industry List</CAPTION>
	<tr>
	<td colspan=8><hr color=red></hr></td>
	</tr>
	<form name="frm" action="listIndustry.do" method="post">
	<input type="hidden" name="offset" id="offset" value="<%=offset%>">
	<tr>
		<td>			
			Industry:</td><td>   <select name="text">
	        <option value="" >All</option>
	        <%
	        	for(int j=0; j<result.size(); j++){
	        		Industry ind = (Industry)result.get(j);
					out.println("<option value='"+ind.getDescription()+"'>"+ ind.getDescription() +"</option>");
				}
			%>				
			</select>
		 </td>
		   
		<td>   
			<input type="submit" value="Search" class=""></form></td>
		
		<td>	
			<form name="" action="editIndustry.do" method="post">
		    <input type="submit" value="New" class=""></form>
		</td>
		<td width ="80%"></td>
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
            Industry List
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
                    <p align="left">Description
                </td>
             </tr>
			<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="QryList" type="com.aof.component.crm.customer.Industry" >                
			<tr>  
                <td align="left"><%= i++%></td>
                <td><a href="editIndustry.do?DataId=<%=((Industry) p).getId()%>"><%=((Industry) p).getDescription()%></a> 
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
