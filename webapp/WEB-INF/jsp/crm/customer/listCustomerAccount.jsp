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

if (AOFSECURITY.hasEntityPermission("CUST_ACCOUNT", "_VIEW", session)) {

	List result = null;	
	String text = request.getParameter("text");
	if(text!=null && text.length()>1){
		result = Hibernate2Session.currentSession().createQuery("select acc from CustomerAccount as acc where (acc.Description like '%"+ text +"%')").list();
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
%>
<table>
<tr>
	<td>Search Customer Group:</td>
	<td>
		<form name="" action="listCustomerAccount.do" method="post">
			<input type="text" name="text" value="" class="">
		    <input type="submit" value="Search" class="">
	    </form>
	 </td>
	 <td>   
	    <form name="" action="editCustomerAccount.do" method="post">
		    <input type="submit" value="New" class="">
	    </form>
	</td>
</tr>
</table>

	
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="topBox">
            Customer Group List
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
                <td align="left" width="10%" class="bottomBox">
                    <p align="left">Name
                </td>
                <td align="left" width="10%" class="bottomBox">
                    <p align="left">Abbreviation
                </td>
                <td align="left" width="10%" class="bottomBox">
                    <p align="left">Type
                </td>
             </tr>
			<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="QryList" type="com.aof.component.crm.customer.CustomerAccount" >                
			<tr>  
                <td align="left"><%= i++%></td>
                <td><a href="editCustomerAccount.do?DataId=<%=((CustomerAccount) p).getAccountId()%>"><%=((CustomerAccount) p).getDescription()%></a> 
                </td>
                <td><%=((CustomerAccount) p).getAbbreviation()%></td>
                <td><%if (((CustomerAccount) p).getType().equals("L")) {
                	out.print("Local");
                } else {
                	out.print("Global");
                }%></td>
            </tr>
			</logic:iterate> 
			<tr class="bottomBox">
			<td width="100%" colspan="4" align="right">
			<%if(offset.intValue()>0){%>
			<a href="listCustomerAccount.do?offset=<%=offset.intValue()-length.intValue()%>"><image src="<%=request.getContextPath()%>/images/pre.gif" border="0"></a>
			<%}%>
			<a href="listCustomerAccount.do?offset=<%=offset.intValue()+length.intValue()%>"><image src="<%=request.getContextPath()%>/images/next.gif"  border="0"></a>                      
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
