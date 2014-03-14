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

if (AOFSECURITY.hasEntityPermission("PROJECT_EVENT_TYPE", "_VIEW", session)) {

	List result = null;	
	String text = request.getParameter("text");
	if(text!=null && text.length()>1){
		result = Hibernate2Session.currentSession().createQuery("select pet from ProjectEventType as pet where (pet.petName like '%"+ text +"%')").list();
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
	<td>Search Project Event Type:</td>
	<td>
		<form name="" action="listCustProjectEventType.do" method="post">
			<input type="text" name="text" value="" class="">
		    <input type="submit" value="Query" class="">
	    </form>
	 </td>
	 <td>   
	    <form name="" action="editCustProjectEventType.do" method="post">
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
            Project Event Type List
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
                    <p align="left">Description
                </td>
                <td align="left" width="10%" class="bottomBox">
                    <p align="left">Open Project
                </td>
              </tr>
			<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="QryList" type="com.aof.component.prm.project.ProjectType" >                
			<tr>  
                <td align="left"> 
                 <div class="tabletext">
                  <p align="left"><%= i++%> 
                  </div>
                </td>
			                        
                <td> 
                  <p ><a href="editCustProjectEventType.do?DataId=<bean:write name="p" property="ptId"/>"><bean:write name="p" property="ptId"/></a> 
                </td>
                <td>
                    <div class="tabletext">
                    <p ><bean:write name="p" property="ptName"/>
                    </div>   
                </td>
                <td>
                    <div class="tabletext">
                    <p ><bean:write name="p" property="openProject"/>
                    </div>   
                </td>
				</tr>
						</logic:iterate> 
					  <tr class="bottomBox">
					  <td width="100%" colspan="7" align="right">
						<%if(offset.intValue()>0){%>
						<a href="listCustProjectEventType.do?offset=<%=offset.intValue()-length.intValue()%>"><image src="<%=request.getContextPath()%>/images/pre.gif" border="0"></a>
						<%}%>
						<a href="listCustProjectEventType.do?offset=<%=offset.intValue()+length.intValue()%>"><image src="<%=request.getContextPath()%>/images/next.gif"  border="0"></a>                      
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
