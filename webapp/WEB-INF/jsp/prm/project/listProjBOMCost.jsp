<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.core.security.Security"%>
<%@ page import="com.aof.core.persistence.jdbc.SQLResults"%>
<%@ page import="com.aof.util.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<%
if (AOFSECURITY.hasEntityPermission("PMS", "_Precal_MAINTENANCE", session)) {

%>
<script language="Javascript">
	function fnSubmit1(start) {
		with (document.frm1) {
			offSet.value=start;
			submit();
		}
	}

</script>

<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>Project BOM List(Cost Confirm)</CAPTION>
<tr>
	<td colspan=8><hr color=red></hr></td>
</tr>
<tr>	
	<td>
	<%
		String offSetStr = request.getParameter("offSet");
		int offSet = 0;
		if (offSetStr != null && offSetStr.trim().length() != 0) {
			offSet = Integer.parseInt(offSetStr);
		}
		final int recordPerPage = 10;
		String dep = (String)request.getAttribute("dpt");
		String projectid = (String)request.getAttribute("proj_id");
		String proj_name = (String)request.getAttribute("proj_name");
		String bid = (String)(request.getAttribute("bid_id"));
	
	%>
		<form name="frm" action="findProjBOM.do" method="post">
		    Bid ID
			<input type="text" name="bid_id" value="<%if(bid!=null)out.println(bid);%>" class="inputbox" size="15">
		    Project ID
			<input type="text" name="proj_id" value="<%if(projectid!=null)out.println(projectid);%>" class="inputbox" size="15">
			Project Name:
			<input type="text" name="proj_name" value="<%if(proj_name!=null)out.println(proj_name);%>" class="inputbox" size="15">
		    Department:
		    <select name="dpt" >
		    <option value="0">---All Related to You---
		    <%
		    SQLResults sr = (SQLResults)request.getAttribute("partyresult");
		    if(sr!=null)
		    {
		    for(int i=0;i<sr.getRowCount();i++)
		    {
		    String dep_id = sr.getString(i,"dep_id");
		    String dep_name = sr.getString(i,"dep_name");
		    %>
		    <option value="<%=dep_id%>" <%if((dep!=null)&&(dep.equalsIgnoreCase(dep_id)))out.println("selected");%>><%=dep_name%>		    
		    <%
		    }
		    }
		    %>
		    </select> 
		    <input type="hidden" name="formaction" id="formaction" value="listcost">
		    <input type="submit" value="Search" class="button">
	    </form>
	 </td>
	 <td>   
	</td>
		<td width="15%"></td>
</tr>
<tr>
	<td colspan=8><hr color=red></hr></td>
</tr>
</table>

<form action="findProjBOM.do" method="post" name="frm1">
<TABLE border=0 width='100%' cellspacing='0' cellpadding='0' class='boxoutside'>
  <TR>
    <TD width='100%'>
      <table width='100%' border='0' cellspacing='0' cellpadding='0'>
        <tr>
          <TD align=left width='90%' class="topBox">
            Project BOM List
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
                  <p align="left">Bid ID 
                </td>
                <td align="left" width="10%" class="bottomBox">
                    <p align="left">Bid Description
                </td>
                <td align="left" width="8%" class="bottomBox"> 
                  <p align="left">Project ID 
                </td>
                <td align="left" width="10%" class="bottomBox">
                    <p align="left">Description
                </td>
                <td align="left" width="10%" class="bottomBox">
                    <p align="left">Version
                </td>
              </tr>
              <%
            sr = (SQLResults)request.getAttribute("bomresult");
		    if(sr==null)
              	out.println("<tr><td><font colour='red'>no records</font></td></tr>");
		    else{
				for(int i = offSet; (i < (offSet + recordPerPage)) && (i < sr.getRowCount()); i++){
		    String proj_id = sr.getString(i,"proj_id");
		    String version = sr.getString(i,"version");
		    String pname = sr.getString(i,"proj_name");
			long bid_id = sr.getLong(i,"bid_id");
//		    String pm = sr.getString(i,"name");
		    long mst_id = sr.getLong(i,"mst_id");
 		    String bname = sr.getString(i,"bid_description");
 
          %>
              	<tr>
              	<td><p align="left"><%=(i+1)%></td>
              	<td><p align="left">
              	<a href="editProjBOMCost.do?masterid=<%=mst_id%>&formaction=view"><%=bid_id%></a></td>
              	<td><p align="left"><%=bname%></td>
              	<td><p align="left"><%=proj_id == null ? "" : proj_id %></td>
              	<td><p align="left"><%=pname==null ? "" : pname %></td>
              	<td><p align="left"><%=version%></td>
              	</tr>
			<%}
              %>
                				<tr>
					<td width="100%" colspan="11" align="right" class=lblbold>Pages&nbsp;:&nbsp;
					<input type="hidden" name="offSet" Id="offset" value="<%=offSet%>">
						<%
							int RecordSize = sr.getRowCount();
							int l = 0;
							while ((l * recordPerPage) < RecordSize) {
								if (offSet == l * recordPerPage) {
							%>
							&nbsp;<%= l+1 %>&nbsp;
							<%
								} else {
							%>
							&nbsp;<a href="javascript:fnSubmit1(<%=l*recordPerPage%>)" title="Click here to view next set of records"><%= l+1 %></a>&nbsp;
							<%
								}
								l++;
							}
						%>
					</td>
				</tr>
              <%
              }
              %>
                    </table>
                </td>
              </tr>
            </table>
         </td>
        </tr>
</table>
</form>
<%
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
