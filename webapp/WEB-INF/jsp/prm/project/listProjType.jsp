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
if (AOFSECURITY.hasEntityPermission("PMS", "_ST_MAINTENANCE", session)) {
try{
%>
<script language="Javascript">
	function fnSubmit1(start) {
		with (document.frm1) {
			offSet.value=start;
			submit();
		}
	}
function fnSelect(obj)
{
var button = document.getElementById("labelExport");
button.style.display = "block";
}
function fnClick()
{
document.frm1.actionType.value = 'export';
document.frm1.submit();
}
</script>

<form name="frm1" action="findProjBOM.do?formaction=listtype" method="post">
<table width=100% cellpadding="1" border="0" cellspacing="1">
<CAPTION align=center class=pgheadsmall>Project Precal Basic Data List</CAPTION>
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

		String dep = request.getParameter("dpt");
		if(dep == null) dep = "";
		String projectid = request.getParameter("proj_id");
		String proj_name = request.getParameter("proj_name");
		String bid = request.getParameter("bid_id");
	
	%>
		    Bid ID:</td>
		    <td>
			<input type="text" name="bid_id" value="<%if(bid!=null)out.println(bid);%>" class="inputbox" size="30"></td>
			<td> Department:</td>
		    <td><select name="dpt" class="selectbox">
		    <option value="">--All Related to You--
		    <%
		    
		    List depList = (List)request.getAttribute("depList");
		    SQLResults sr = (SQLResults)request.getAttribute("partyresult");
		    for(int i=0;i<depList.size();i++)
		    {
			Party p = (Party)depList.get(i);
		    %>
		    <option value="<%=p.getPartyId()%>" <%if(dep.equals(p.getPartyId()))out.println("selected");%>><%=p.getDescription()%>		    
		    <% } %>
		    </select> 
	 </td>
	 <td colspan=2/> 
</tr>
<tr>
	<td>Project ID:</td>
	<td><input type="text" name="proj_id" value="<%if(projectid!=null)out.println(projectid);%>" class="inputbox" size="30"></td>
	<td>Project Name:</td>
	<td><input type="text" name="proj_name" value="<%if(proj_name!=null)out.println(proj_name);%>" class="inputbox" size="30"></td>		
	<td><input type="hidden" name="formaction" value="list">
		<input type="submit" value="Search" class="button">
		</td>
	 <td>   
	 <div id="labelExport" style="display:none">
	 <input type="button" value="Export Project BOM" onClick="javascript:fnClick()" class="button">
	 <input type="hidden" name="actionType" ></div>
	</td>
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
            Project Precal Basic Data List
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
                  <p align="left">&nbsp;
                </td>
                        
                <td align="left" width="4%" class="bottomBox"> 
                  <p align="left"># 
                </td>
                <td align="left" width="8%" class="bottomBox"> 
                  <p align="left">BOM No
                </td>
                <td align="left" width="12%" class="bottomBox"> 
                  <p align="left">Customer 
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
                    <p align="left">Project Description
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
			long Bom_no = sr.getLong(i,"bom_no");
			int len = (String.valueOf(Bom_no)).length();
			String bom_link = ""+Bom_no;
			for(int j=len;j<8;j++)
			{
				bom_link = "0"+bom_link;
			}
			bom_link = "P"+bom_link;

		    String proj_id = sr.getString(i,"proj_id");
		    String version = sr.getString(i,"version");
		    String pname = sr.getString(i,"proj_name");
		    long mst_id = sr.getLong(i,"mst_id");
			String bid_no = sr.getString(i,"bid_no");
		    String bname = sr.getString(i,"bid_description");
		    String cust1 = sr.getString(i,"cust1");
		    String cust2 = sr.getString(i,"cust2");
          %>
              	<tr>
              	<td><p align="left"><input type="radio" name="radioid" value="<%=mst_id%>"
              		style="border:0px;background-color:#ffffff" onclick="javascript:fnSelect(this);">
              	</td>
              	<td><p align="left"><%=(i+1)%></td>
              	<td><p align="left"><a href="editProjType.do?masterid=<%=mst_id%>&formaction=other"><%=bom_link%></a></td>
              	<td><p align="left"><%=cust1 == null? cust2:cust1%></td>
              	<td><p align="left"><%=bid_no == null? "":bid_no%></td>
              	<td><p align="left"><%=bname == null ? "" :bname%></td>
              	<td><p align="left"><%if(proj_id!=null)out.println(proj_id);%></td>
              	<td><p align="left"><%if(pname!=null)out.println(pname);%></td>
              	<td><p align="left"><%=version%></td>
              	</tr>
 		  <%}%>
      				<tr>
					<td width="100%" colspan="11" align="right" class=lblbold>Pages&nbsp;:&nbsp;
					<input type=hidden name="offSet" value="<%=offSet%>">
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
}
catch(Exception e)
{
e.printStackTrace();
}
}else{
	out.println("!!你没有相关访问权限!!");
}
%>
