<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.domain.security.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%

if (AOFSECURITY.hasEntityPermission("CUST_CONTACT", "_VIEW", session)) {

	List result = null;	
	//out.println("userLogins="+request.getAttribute("userLogins"));
	String text = request.getParameter("text");
	if(text!=null && text.length()>1){
		result = Hibernate2Session.currentSession().createQuery("select ul from UserLogin as ul inner join ul.party as p inner join p.partyRoles as pr where pr.roleTypeId = 'CUSTOMER' and (ul.userLoginId like '%"+ text +"%' or ul.name like '%"+ text +"%')").list();
		request.setAttribute("userLogins",result);	
	}else{
		if(request.getAttribute("userLogins")==null){
			result = new ArrayList();
			request.setAttribute("userLogins",result);
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
<form name="" action="listCustUserLogin.do" method="post">
<table>
<tr>
	<td><bean:message key="System.UserLogin.object2"/>:</td>
	<td>
		<input type="text" name="text" value="" class="">
	    <input type="submit" value="<bean:message key="button.query"/>" class=""><input type="button" value="<bean:message key="button.new"/>" class="" onclick="location.replace('editCustUserLogin.do')">
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
            <bean:message key="System.UserLogin.object2"/> <bean:message key="System.Keyword.list"/>
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
                <td align="left" width="8%" class="bottomBox"> 
                  <p align="left"><bean:message key="System.UserLogin.userLoginId"/>
                </td>
                <td align="left" width="10%" class="bottomBox">
                    <p align="left"><bean:message key="System.UserLogin.name"/>
                </td>
                <td align="left" width="10%" class="bottomBox">
                    <p align="left"><bean:message key="System.UserLogin.party"/>
                </td>
                <td align="center" width="8%" class="bottomBox"> 
                  <p align="center"><bean:message key="System.UserLogin.enable"/>
                </td>
                <td align="center" width="10%" class="bottomBox"> 
                  <p align="center"><bean:message key="System.UserLogin.tele_code"/>
                </td>
                <td align="center" width="10%" class="bottomBox"> 
                  <p align="center"><bean:message key="System.UserLogin.email_addr"/>
                </td>
              </tr>
			<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="userLogins" type="com.aof.component.domain.party.UserLogin" > 
			<%Party ulParty = ((UserLogin) p).getParty();
			request.setAttribute("ulParty", ulParty);%>                    
			<tr>  
                <td align="left"> 
                 <div class="tabletext">
                  <p align="left"><%= i++%> 
                  </div>
                </td>
			                        
                <td> 
                  <p ><a href="editCustUserLogin.do?userLoginId=<bean:write name="p" property="userLoginId"/>"><bean:write name="p" property="userLoginId"/></a> 
                </td>
                <td>
                    <div class="tabletext">
                    <p ><bean:write name="p" property="name"/>
                    </div>   
                </td>
				<td>
                    <div class="tabletext">
                    <p >
                    <bean:write name="ulParty" property="description"/> 
                    </div>   
                </td>               
                <td align="center"> 
                  <div class="head4">                   
                    <p ><bean:write name="p" property="enable"/> 
                  </div>
                  </td> 
                <td>
                    <div class="head4">
                    <p ><bean:write name="p" property="tele_code"/>
                    </div>
                </td> 
                <td>
                    <div class="head4">
                    <p ><bean:write name="p" property="email_addr"/>
                    </div>
                </td>
				</tr>
						</logic:iterate> 
					  <tr class="bottomBox">
					  <td width="100%" colspan="7" align="right">
						<%if(offset.intValue()>0){%>
						<a href="listCustUserLogin.do?offset=<%=offset.intValue()-length.intValue()%>"><image src="<%=request.getContextPath()%>/images/pre.gif" border="0"></a>
						<%}%>
						<a href="listCustUserLogin.do?offset=<%=offset.intValue()+length.intValue()%>"><image src="<%=request.getContextPath()%>/images/next.gif"  border="0"></a>                      
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
request.removeAttribute("userLogins");
}else{
	out.println("!!你没有相关访问权限!!");
}

		Hibernate2Session.closeSession();

%>
