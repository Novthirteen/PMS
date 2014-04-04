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

<%if (AOFSECURITY.hasEntityPermission("PROJECT_TYPE", "_VIEW", session)) {
net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush();
	List result = null;	
    String textcode = request.getParameter("textcode");
	String text = request.getParameter("text");
	String textstatus = request.getParameter("textstatus");
	if((textcode!=null && textcode.length()>1)||(text!=null && text.length()>1)||(textstatus!=null && textstatus.length()>1)){
	
		Query q= Hibernate2Session.currentSession().createQuery("select pt from ProjectType as pt where ((pt.ptId like '%"+ textcode +"%') and (pt.ptName like '%"+ text +"%') and (pt.openProject like '%"+ textstatus +"%'))");
		result=q.list();
		request.setAttribute("QryList",result);	
	}else{
		Query q= Hibernate2Session.currentSession().createQuery("select pt from ProjectType as pt");
		result=q.list();
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
%>
<script language="Javascript">
function fnSubmit1(start) {
	document.getElementById("offset").value=start;
	document.frm.submit();
}
</script>

<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>Event Category List</CAPTION>
<tr>
	<td colspan=8><hr color=red></hr></td>
</tr>
<tr>	
	<td>
		<form name="frm" action="listCustProjectType.do" method="post">
			<input type="hidden" name="offset" Id="offset" value="<%=offset%>">
		    Event Category Code:
			<input type="text" name="textcode" Id="textcode" value="" class="">
			Event Category Name:
			<input type="text" name="text" Id="text" value="" class="">
		    Open:
		    <select name="textstatus" >
	    <option value=""></option>
	    <option value="Yes">Yes</option>
	    <option value="No">No</option>
	    </select> 
		    <input type="submit" value="Search" class="">
	    </form>
	 </td>
	 <td>   
	    <form name="" action="editCustProjectType.do" method="post">
		    <input type="submit" value="New" class="">
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
            Event Category List
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
                  <p align="left">Code 
                </td>
                <td align="left" width="10%" class="bottomBox">
                    <p align="left">Description
                </td>
                <td align="left" width="10%" class="bottomBox">
                    <p align="left">OpenProject
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
                  <p ><a href="editCustProjectType.do?DataId=<bean:write name="p" property="ptId"/>"><bean:write name="p" property="ptId"/></a> 
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
