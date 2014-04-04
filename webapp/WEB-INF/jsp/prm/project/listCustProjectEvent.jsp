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
try {
if (AOFSECURITY.hasEntityPermission("PROJECT_EVENT", "_VIEW", session)) {
 net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;

hs.flush(); 
	List result = null;	
	String text = request.getParameter("text");
	if (text==null) text="";
	String texttype = request.getParameter("texttype");
	if((text!=null && text.length()>1)||(texttype!=null && texttype.length()>1)){
	    Query q=Hibernate2Session.currentSession().createQuery("select pe from ProjectEvent as pe inner join pe.pt as pt where (((pe.peventName like '%"+ text +"%') or (pe.peventCode like '%"+ text +"%')) and (pt.ptId like '%"+ texttype +"%') )");
		result = q.list();
		request.setAttribute("QryList",result);	
	}else{
		Query q=Hibernate2Session.currentSession().createQuery("select pe from ProjectEvent as pe inner join pe.pt as pt ");
		result = q.list();
		request.setAttribute("QryList",result);	
		if(request.getAttribute("QryList")==null){
			result = new ArrayList();
			request.setAttribute("QryList",result);
		}
	}
	if (texttype == null) {
		texttype = "";
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

<script language="Javascript">
function fnSubmit1(start) {
	document.getElementById("offset").value=start;
	document.frm.submit();
}
</script>

<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>Project Event List</CAPTION>
<tr>
	<td colspan=8><hr color=red></hr></td>
</tr>
<tr>
	
	<td>
		<form name="frm" action="listCustProjectEvent.do" method="post">
			<input type="hidden" name="offset" Id="offset" value="<%=offset%>">
			Event Name:
			<input type="text" name="text" value="<%=text%>" class="">
		    Event Category:
	    <select name="texttype">
	       <option value="" >All</option>
	      <%
			Iterator itt = ptList.iterator();
			while(itt.hasNext()){
				ProjectType pt = (ProjectType)itt.next();
				String s = "";
				if (texttype.equals(pt.getPtName())) s="Selected";
				%>
				<option value="<%=pt.getPtId()%>"  <%=s%>><%=pt.getPtName()%> </option>		
			<%}
			%>
			</select>  
		    <input type="submit" value="Search" class="">
	    </form>
	</td>
	<td>
		<form name="" action="editCustProjectEvent.do" method="post">
		    <input type="submit" value="New" class="">
           
	    </form>
	</td>
	<td width="52%"></td>
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
            Project Event List
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
                    <p align="left">Event Category
                </td>
                 <td align="left" width="10%" class="bottomBox">
                    <p align="left">Billable
                </td>
              </tr>
			<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="QryList" type="com.aof.component.prm.project.ProjectEvent" >                
			<tr>  
                <td align="left"> 
                 <div class="tabletext">
                  <p align="left"><%=i++%>
                  </div>
                </td>
			                        
                <td> 
                  <p ><a href="editCustProjectEvent.do?DataId=<bean:write name="p" property="peventId"/>"><bean:write name="p" property="peventCode"/></a> 
                </td>
                <td>
                    <div class="tabletext">
                    <p ><bean:write name="p" property="peventName"/>
                    </div>   
                </td>
                 <td>
                    <div class="tabletext">
                    <p ><%=((ProjectEvent)p).getPt().getPtName()%> 
                    </div>   
                </td>
                <td>
                    <div class="tabletext">
                    <p ><bean:write name="p" property="billable"/>
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
} catch (Exception ex) {
	ex.printStackTrace();
}
%>
