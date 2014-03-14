<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="com.aof.core.persistence.hibernate.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<%
if (AOFSECURITY.hasEntityPermission("CUST_PROJECT_CTC", "_VIEW", session)) {

	List result = null;	
	String text = request.getParameter("text");
	if(text!=null && text.length()>1){
		result = Hibernate2Session.currentSession().createQuery("select p from ProjectMaster as p where (p.projId like '%"+ text +"%' or p.projName like '%"+ text +"%')").list();
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

	String SecId = request.getParameter("SecId");
	if (SecId == null) SecId = "1";
	String EditURL = "";
	if (SecId.equals("1")) {
		EditURL = "editPrjCTC.do";
	}
	if (SecId.equals("2")) {
		EditURL = "editPrjPTC.do";
	}
%>
<table width=100% cellpadding="1" border="0" cellspacing="1" >
<CAPTION align=center class=pgheadsmall>  Project Cost To Complete Forecast List </CAPTION>
<tr>
	<td>
		<TABLE width="100%">
			<tr>
				<td colspan=6><hr color=red></hr></td>
			</tr>
<table>
<tr>
	<td>Search Project:</td>
	<td>
	<form name="" action="findPrjFCPage.do" method="post">
		<input type="text" name="text" value="" class="">
	    <input type="submit" value="Query" class="">
    </form>
	</td>
</tr>
</table>
<tr>
<td colspan=6><hr color=red></hr></td>
</tr>
</td>
</tr>
<TABLE>
	
<TABLE border=0 width='100%' cellspacing='1' cellpadding='1' >
  <TR>
		<TD width='100%'>
			<table width='100%' border='0' cellspacing='0' cellpadding='0'>
				<tr>
					<TD align=left width='90%' class="wpsPortletTopTitle">Project List For CTC Forecast</TD>
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
                      <tr bgcolor="#e9eee9">
                        
                <td align="left" width="4%" class="lblbold"> 
                  <p align="left">Seq 
                </td>
                        
                <td align="left" width="8%" class="lblbold"> 
                  <p align="left">Code 
                </td>
                <td align="left" width="10%" class="lblbold">
                    <p align="left">Name
                </td>
                <td align="left" width="10%" class="lblbold">
                    <p align="left">Contract Type
                </td>
                <td align="left" width="8%" class="lblbold"> 
                  <p align="left">Customer 
                </td>
                <td align="left" width="8%" class="lblbold"> 
                  <p align="left">Department 
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
                  <p ><a href="<%=EditURL%>?DataId=<bean:write name="p" property="projId"/>"><bean:write name="p" property="projId"/></a> 
                </td>
                <td>
                    <div class="tabletext">
                    <p ><bean:write name="p" property="projName"/>
                    </div>   
                </td>            
                <td align="left"> 
                  <div class="head4"><%String ContractType = ((ProjectMaster) p).getContractType();
					if (ContractType.equals("FP")) {
						out.println("Fixed Price");
					} else {
						out.println("Time & Material");
					}%>
                  </div>
                </td>
                 
                <td align="left">
                    <div class="head4">
                    <p ><%=((ProjectMaster) p).getCustomer().getDescription()%>
                    
                    </div>
                </td>
                <td align="left">
                    <div class="head4">
                    <p > <%=((ProjectMaster) p).getDepartment().getDescription()%> 
                  
                    </div>
                </td>
				</tr>
				</logic:iterate> 		
					  <tr class="bottomBox">
					  <td width="100%" colspan="7" align="right">
						<%if(offset.intValue()>0){%>
						<a href="findPrjFCPage.do?offset=<%=offset.intValue()-length.intValue()%>"><image src="<%=request.getContextPath()%>/images/pre.gif" border="0"></a>
						<%}%>
						<a href="findPrjFCPage.do?offset=<%=offset.intValue()+length.intValue()%>"><image src="<%=request.getContextPath()%>/images/next.gif"  border="0"></a>                      
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
