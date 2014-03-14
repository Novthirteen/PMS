<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
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
if (AOFSECURITY.hasEntityPermission("COST_RATE", "_CREATE", session)) {

net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
net.sf.hibernate.Transaction tx =null;
String FormAction=request.getParameter("FormAction");
String departmentId=request.getParameter("departmentId");
String year=request.getParameter("year");

hs.flush();  
if(FormAction == null){
	FormAction = "view";
}
List depList=null;
List memList=null;
List crList=null;

	//get all the department
	PartyHelper ph = new PartyHelper();
	depList=ph.getAllOrgUnits(hs);
    memList = (List)request.getAttribute("memberResult");
    crList=(List)request.getAttribute("crResult");
	if(memList==null ){
		UserLoginHelper ulh = new UserLoginHelper();
	    memList = ulh.getAllUser(hs);
	    
	}
Date Dyear=new Date();
int Nyear=Dyear.getYear()+1900;


int count=memList.size(); 
	request.setAttribute("memList",memList);
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
function FnDetail() {
	document.EditForm.offset.value="0";
	
	document.EditForm.submit();
}
function FnNext() {
	var num=document.EditForm.offset.value;
	var n=new Number(num);
	document.EditForm.offset.value=n+15;
	document.EditForm.submit();
}
function FnPrevious() {
	var num=document.EditForm.offset.value;
	var n=new Number(num);
	document.EditForm.offset.value=n-15;
	document.EditForm.submit();
}
function FnUpdate() {
	
	document.EditForm.Action.value="save";
	document.EditForm.submit();
}
function turnPage(offSet) {
		document.EditForm.offset.value = offSet;
		document.EditForm.submit();
}
</script> 


<table width="100%" cellpadding="1" border="0" cellspacing="1">
<caption class="pgheadsmall"> Consultant Cost Maintainance </caption> 
<tr>
<td>
<%
    if(FormAction.equals("detail")){
    	//FormAction="update";
%>
<form Action="editConsultantCost.do" method="post" name="EditForm">
<input type="hidden" name="FormAction" value="detail">
<input type="hidden" name="Action" >
<input type="hidden" name="Count" value="<%=count%>">
<input type="hidden" name="offset" value="<%=offset%>">
<table width="100%">
<tr>
				<td colspan=6 valign="bottom"><hr color=red></hr></td>
			</tr>
<tr>
	<td>
		<table cellspacing="5" cellpadding="5" width=100%>
			<tr>
				<td class="lblbold">Department:</td>
				<td align="left">
				<select name="departmentId">
			    
		    	<%
		      	Iterator itd = depList.iterator();
		   	    while(itd.hasNext()){
				Party p = (Party)itd.next();
				if( p.getPartyId().equals(departmentId) ){
					out.println("<option value=\""+p.getPartyId()+"\" selected>"+p.getDescription()+"</option>");
				}else{
					out.println("<option value=\""+p.getPartyId()+"\">"+p.getDescription()+"</option>");
				}
			
		    	}
			    %>
			    </select> 
			    </td>
				<td class="lblbold">Year :</td>
				<td align="left">
				<select name="year">
				<%
			    if(year.equals(String.valueOf(Nyear-1))){
			    %>   
			       <option value="<%=Nyear-1%>" selected><%=Nyear-1%></option>
			      <option value="<%=Nyear%>"><%=Nyear%></option>
			       <option value="<%=Nyear+1%>"><%=Nyear+1%></option>
			    <%
			    }
			    else if(year.equals(String.valueOf(Nyear))){
			    %>
			        <option value="<%=Nyear-1%>" ><%=Nyear-1%></option>
			       <option value="<%=Nyear%>" selected><%=Nyear%></option>
			       <option value="<%=Nyear+1%>"><%=Nyear+1%></option>
			    <%
			    }
			    else{
			    %>
			         <option value="<%=Nyear-1%>" selected><%=Nyear-1%></option>
			      <option value="<%=Nyear%>"><%=Nyear%></option>
			       <option value="<%=Nyear+1%>" selected><%=Nyear+1%></option>
			    <%
			    }   
			    %>     
				
			    </select> 
                </td>
				<td class="lblbold"><input type="button" value="Detail Information" class="loginButton" onclick="javascript:FnDetail();"/></td>
				</td>
			
			</tr>
         
		</table>
	</td>
</tr>	
<tr>
				<td colspan=6 valign="top"><hr color=red></hr></td>
			</tr>
<TR>
    <td>
		<table border="0" cellpadding="2" cellspacing="2" width=100%>
			<tr bgcolor="#e9eee9">
				<td class="lblbold">&nbsp;Id&nbsp;</td>
				<td class="lblbold">&nbsp;Consultant&nbsp;</td>
				<td class="lblbold">&nbsp;Role&nbsp;</td>
				<td class="lblbold">&nbsp;Number&nbsp;</td>
				<td class="lblbold">&nbsp;Rate ( RMB / Day )&nbsp;</td>
				
			</tr>
			<logic:iterate id="p" indexId="indexId" offset="offset" length="length" name="memList" type="com.aof.component.domain.party.UserLogin" > 
			<tr bgcolor="#e9eee9">
			<%
			Float rate=new Float("0");
			String Id=new String("0");
			Iterator it = crList.iterator();
		   	    while(it.hasNext()){
				ConsultantCost cr = (ConsultantCost)it.next();
				if( ((UserLogin) p).getUserLoginId().equals(cr.getUser().getUserLoginId()) ){
				    rate=cr.getCost();	
				    Id=String.valueOf(cr.getId());
				    
				}
			
		    	}
			%>
			    <input type="hidden" name="Id<%=i%>" value="<%=Id%>">              
                <td align="left" width="5%"> 
                 <div class="tabletext">
                  <p align="left"><%= i%> 
                  </div>
                </td>        
                <td>
                    <div class="tabletext">
                    <p ><bean:write name="p" property="name"/>
                    <input type="hidden" name="user<%=i%>" value="<bean:write name="p" property="userLoginId"/>">
                    </div>   
                </td>
				<td>
                    <div class="tabletext">
                    <p >
                    <bean:write name="p" property="role"/>
                
                    </div>   
                </td>  
                <td>
                    <div class="tabletext">
                    <p >
                    
                   <bean:write name="p" property="tele_code"/>
                    </div>   
                </td>  
                <td>
                    <div class="tabletext">
                    <p >
                    <input type="text" name="cost<%=i++%>" value="<%=rate%>"> 
                   
                    </div>   
                </td>              
               	</tr>
               	
			</logic:iterate> 
			<tr>
				<td width="100%" colspan="16" align="right" class=lblbold>Pages&nbsp;:&nbsp;
				<%
				int recordSize = memList.size();
				System.out.println("offset"+offset);
				System.out.println("record size:"+recordSize);
				for (int j0 = 0; j0 < Math.ceil((double)recordSize / length.intValue() ); j0++){
				System.out.println(":"+offset.intValue()/length.intValue());
				System.out.println("math.ceil"+Math.ceil((double)recordSize/length.intValue()));
					if (j0 == offset.intValue() / length.intValue() ) {
				%>
				&nbsp;<font size="3"><%=j0 + 1%></font>&nbsp;
				<%
					} else {
				%>
				&nbsp;<a href="javascript:turnPage('<%=j0 * length.intValue() %>')" title="Click here to view next set of records"><%=j0 + 1%></a>&nbsp;
				<%
					}
				}
				%>
				</td>
			</tr>
					  
			
			
        <tr>
        <td align="right">
          <span class="tabletext"></span>
        </td>
        <td align="left">
		<input type="button" value="Save" class="loginButton" onclick="javascript:FnUpdate();"/>
		<input type="reset" value="Cancel" class="loginButton"/>
		
        </td>
      </tr>  
</form>      
</td></tr>
<%
	}else{
%>

<form Action="editConsultantCost.do" method="post" name="EditForm">
<table width="100%">
<input type="hidden" name="FormAction" value="detail">
<input type="hidden" name="offset" value="<%=offset%>">
<input type="hidden" name="Action" >
<tr>
				<td colspan=6 valign="bottom"><hr color=red></hr></td>
			</tr>
<tr>
	<td>
		<table cellspacing="5" cellpadding="5" width=100%>
			<tr>
				<td class="lblbold">Department :</td>
				<td align="left">
				<select name="departmentId">
			    <%
		     	Iterator itd = depList.iterator();
		   	    while(itd.hasNext()){
				Party p = (Party)itd.next();
					out.println("<option value=\""+p.getPartyId()+"\">"+p.getDescription()+"</option>");
				}
			    %>
			    </select>         
				<td class="lblbold">Year :</td>
				<td align="left">
				<select name="year">
			    
			    <option value="<%=Nyear-1%>"><%=Nyear-1%></option>
			    <option value="<%=Nyear%>" selected><%=Nyear%></option>
			    <option value="<%=Nyear+1%>"><%=Nyear+1%></option>
			    </select>           
				
                </td>
                </td>
				<td class="lblbold"><input type="button" value="Detail Information" class="loginButton" onclick="javascript:FnDetail();"/></td>
				
                </td>
			
			</tr>
			
        
      </table>
	</td>
</tr>

</form>
</td></tr>
<%
	}
%> 	
  </td>
  </tr>
    <tr><td>&nbsp;</td></tr>
</table> 
<%  
Hibernate2Session.closeSession();
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
