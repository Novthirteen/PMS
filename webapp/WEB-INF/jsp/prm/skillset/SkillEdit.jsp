<%@ page language="java" contentType="text/html; charset=gb2312"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.aof.component.prm.skillset.Skill" %>

<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />

<link rel="stylesheet" type="text/css" href="includes/xmlTree/xmlTree.css"/>
<script type="text/javascript" src="includes/xmlTree/xmlTree.js"></script>

<%
try{
	if (AOFSECURITY.hasEntityPermission("SKILL_SET", "_MAINTENANCE", session)) {
	
	  List valueList = (List)request.getAttribute("valueList");
	  if(valueList == null){
	  	valueList = new ArrayList();
	  }
	  
	  String certCount = (String)request.getAttribute("certCount");
	  if(certCount == null || certCount.equals("")){
	  	certCount = "0";
	  }
	  
	  String exCount = (String)request.getAttribute("exCount");
	  if(exCount == null || exCount.equals("")){
	  	exCount = "0";
	  }
%>

<script language="javascript">

	var tree = new XmlTree("includes/xmlTree");

	function fnSave(){
		editForm.submit();
	}
	
	function clearRadio(pid) {
		var pids = document.getElementsByName(pid);
		for (var i = 0; i < pids.length; i++) {
			pids[i].checked = false;
		}
	}
	
	function fnCert(){		
		var param = "?formAction=cert";		
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.cert.dialog.title&skillAction.do" + param,
			null,
			'dialogWidth:800px;dialogHeight:500px;status:no;help:no;scroll:no');

		if (v !=null){
			document.getElementById("countCert").innerHTML=v;			
		}
	}
	
	function fnEx(){		
		var param = "?formAction=ex";		
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.experience.dialog.title&skillAction.do" + param,
			null,
			'dialogWidth:800px;dialogHeight:500px;status:no;help:no;scroll:no');

		if (v !=null){
			document.getElementById("countEx").innerHTML=v;			
		}
	}
	
	function fnComment(){		
		var param = "?formAction=comment";		
		v = window.showModalDialog(
			"system.showDialog.do?title=prm.comment.dialog.title&skillAction.do" + param,
			null,
			'dialogWidth:650px;dialogHeight:400px;status:no;help:no;scroll:no');
	}

</script>

<table width=100% cellpadding="1" border="0" cellspacing="1">
	<caption align=center class=pgheadsmall>Skill Set View</caption>
	<tr><td>
		<form name="editForm" action="skillAction.do" method="post">
			<table width="100%">
				<tr><td colspan=5><hr color=red></hr></td></tr>
				<tr>
					<TD width ="13%"><B>Personal Certification</B>&nbsp;</TD>
					<td  align="left" colspan=4>
						<a style="cursor:hand" onclick="fnCert()"> <U>You have &nbsp;<div style="display:inline" id="countCert"><b><font color=blue><%=certCount%></font></b></div>&nbsp; records for personal certifications</u></a> 
					</td>
				</tr>
				<tr>
					<TD><B>Project Experience</B>&nbsp;</TD>
					<td  align="left" colspan=4>
						<a style="cursor:hand" onclick="fnEx()"><u>You have &nbsp;<div style="display:inline" id="countEx"><b><font color=blue><%=exCount%></font></b></div>&nbsp; records for projects experience</u> </a> 
					</td>
				</tr>
				<tr>
					<TD><B>Suggestions </B>&nbsp;</TD>
					<td  align="left" colspan=4>
						<a style="cursor:hand" onclick="fnComment()"><u>We would be very honored if you make suggestions to us</u></a>
					</td>
				</tr>

				<tr>
					<td align="center" >&nbsp;</td>
					<td align="right">
			    		<input type="button"  name="btnSave"  value="Save" class="button" onclick="fnSave()">&nbsp;&nbsp;&nbsp;
			    		<input type="reset"  name="btnReset"  value="Reset All" class="button">
			    	</td>
				</tr>
				<tr><td colspan=5 valign="top"><hr color=red></hr></td></tr>
			</table>
			
			<div id="tree" style="margin:5px"></div>
			
			<xml id="xmlDoc">
				<%=request.getAttribute("tree")%>
			</xml>
			
			<xml id="xslDoc">
  				<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  			<xsl:output method="html"></xsl:output>

  			<xsl:template match="tree">
    			<div id="treeroot">
    				<xsl:apply-templates/>
    			</div>
  			</xsl:template>

  			<xsl:template match="branch">
    			<div class="node">
      				<xsl:attribute name="desc"><xsl:value-of select="@desc"/></xsl:attribute>
      				<img _src="closed.gif" width="11" height="11" align="absmiddle" style="margin-right:5px">
        				<xsl:attribute name="id">I<xsl:value-of select="@id"/></xsl:attribute>
        				<xsl:attribute name="_id"><xsl:value-of select="@id"/></xsl:attribute>
      				</img>
      				<span class="clsNormal">
        				<xsl:attribute name="id">N<xsl:value-of select="@id"/></xsl:attribute>
        				<xsl:attribute name="_id"><xsl:value-of select="@id"/></xsl:attribute>
        				<xsl:value-of select="@desc"/>
      				</span>
    			</div>
    			<span class="branch">
      				<xsl:attribute name="id">B<xsl:value-of select="@id"/></xsl:attribute>
      				<xsl:attribute name="_id"><xsl:value-of select="@id"/></xsl:attribute>
      				<xsl:attribute name="desc"><xsl:value-of select="@desc"/></xsl:attribute>
      				<xsl:apply-templates/>
    			</span>
  			</xsl:template>

  			<xsl:template match="leaf">
  				<table><tr>
  					<input type="hidden" name="cat" id="cat">
  						<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
  					</input>
					<td width="195">
	    			<div class="node">
	    				<xsl:attribute name="name">cat</xsl:attribute>
	    				<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
	      				<xsl:attribute name="desc"><xsl:value-of select="@desc"/></xsl:attribute>
				      	<img _src="doc.gif" width="11" height="11" align="absmiddle" style="margin-right:5px">
				        	<xsl:attribute name="id">I<xsl:value-of select="@id"/></xsl:attribute>
				        	<xsl:attribute name="_id"><xsl:value-of select="@id"/></xsl:attribute>
					    </img>
					    <span class="clsNormal">
					    	<xsl:attribute name="id">N<xsl:value-of select="@id"/></xsl:attribute>
				        	<xsl:attribute name="_id"><xsl:value-of select="@id"/></xsl:attribute>
				        	<xsl:value-of select="@desc"/>
				      	</span>
	     			</div>
					</td>
					<%
					// 如果该员工没有填写skill set，则显示空的技能树
					if(valueList == null || valueList.size() <= 0){
					%>
					<input type="hidden" name="formAction" id="formAction" value="create"/>
					
					<td>
      					<input type="radio" style="border:0px;background-color:#ffffff">      						
      						<xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
      						<xsl:attribute name="value"><xsl:value-of select="@levelId01" /></xsl:attribute>
      					</input>
      				</td>
      				<td width="145">
      					<xsl:value-of select="@levelDesc01"/>
      				</td>
	      			<td>
	      				<input type="radio" style="border:0px;background-color:#ffffff">
	      					<xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute>
	      					<xsl:attribute name="value"><xsl:value-of select="@levelId02" /></xsl:attribute>
	      				</input>
	      			</td>
	      			<td width="145">
      					<xsl:value-of select="@levelDesc02"/>
      				</td>
	      			<td>
						<input type="radio" style="border:0px;background-color:#ffffff">
							<xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of select="@levelId03"/></xsl:attribute>
						</input>
					</td>
					<td width="145">
      					<xsl:value-of select="@levelDesc03"/>
      				</td>
					<td>
						<input type="radio" style="border:0px;background-color:#ffffff">
							<xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of select="@levelId04"/></xsl:attribute>
						</input>
	      			</td>
	      			<td width="145">
      					<xsl:value-of select="@levelDesc04"/>
      				</td>
	      			<td>
	      				<input type="button" name="Clear" value="Clear">
	      					<xsl:attribute name="onclick"><xsl:value-of select="@onclick" /></xsl:attribute>
	      				</input>
	      			</td>
	      			<%
	      			} else {
	      				// 如果填写了skill set，则check对应的radio
	      				int size = valueList.size();
	      			%>
	      			<input type="hidden" name="formAction" id="formAction" value="update"/>
	      			<xsl:variable name="haveData">
	      				<xsl:choose>
	      				<%
	      				// 判断valueList中是否含有该leaf对应的category的值，
	      				// 设置名为haveDate的变量做为flag；
	      				// 如果有，设置flag为y；如果没有，设置为n
	      				for(int j = 0; j < size; j++){
	      					Skill tmp = (Skill)valueList.get(j);
	      					String tmpId = tmp.getSkillCat().getCatId();
	      				%>
                  			<xsl:when test="<%=tmpId%>=@id">
                          		<xsl:value-of select="'y'"/>
                  			</xsl:when>
                  		<%
                  		}
                  		%>
                			<xsl:otherwise>
                				<xsl:value-of select="'n'"/>
                			</xsl:otherwise>
                		</xsl:choose>
                	</xsl:variable>
	      			<%
	      				// 显示valueList的内容，将对应的skill level checked
	      				for(int i = 0; i < size; i++){
	      					Skill tmpValue = (Skill)valueList.get(i);
	      					String catId = tmpValue.getSkillCat().getCatId();
	      					String levelId = tmpValue.getSkillLevel().getLevelId();
	      			%>
	      			<xsl:if test="<%=catId%>=@id">
	      			<td>
      					<input type="radio" style="border:0px;background-color:#ffffff">      						
      						<xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
      						<xsl:attribute name="value"><xsl:value-of select="@levelId01" /></xsl:attribute>
      						<xsl:if test="<%=levelId%>=@levelId01">
      							<xsl:attribute name="checked"></xsl:attribute>
      						</xsl:if>
      					</input>
      				</td>
      				<td width="145">
      					<xsl:value-of select="@levelDesc01"/>
      				</td>
	      			<td>
	      				<input type="radio" style="border:0px;background-color:#ffffff">
	      					<xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute>
	      					<xsl:attribute name="value"><xsl:value-of select="@levelId02" /></xsl:attribute>
	      					<xsl:if test="<%=levelId%>=@levelId02">
      							<xsl:attribute name="checked"></xsl:attribute>
      						</xsl:if>
	      				</input>
	      			</td>
	      			<td width="145">
      					<xsl:value-of select="@levelDesc02"/>
      				</td>
	      			<td>
						<input type="radio" style="border:0px;background-color:#ffffff">
							<xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of select="@levelId03"/></xsl:attribute>
							<xsl:if test="<%=levelId%>=@levelId03">
      							<xsl:attribute name="checked"></xsl:attribute>
      						</xsl:if>
						</input>
					</td>
					<td width="145">
      					<xsl:value-of select="@levelDesc03"/>
      				</td>
					<td>
						<input type="radio" style="border:0px;background-color:#ffffff">
							<xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of select="@levelId04"/></xsl:attribute>
							<xsl:if test="<%=levelId%>=@levelId04">
      							<xsl:attribute name="checked"></xsl:attribute>
      						</xsl:if>
						</input>
	      			</td>
	      			<td width="145">
      					<xsl:value-of select="@levelDesc04"/>
      				</td>
	      			<td>
	      				<input type="button" name="Clear" value="Clear">
	      					<xsl:attribute name="onclick"><xsl:value-of select="@onclick" /></xsl:attribute>
	      				</input>
	      			</td>	      			
	      			</xsl:if>	      			
	      			<%
	      				}
	      				// loop结束，如果valueList在该leaf对应的category下没有值，则显示空的radio
	      			%>
	      			<xsl:if test="$haveData='n'">
	      				<td>
      					<input type="radio" style="border:0px;background-color:#ffffff">      						
      						<xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
      						<xsl:attribute name="value"><xsl:value-of select="@levelId01" /></xsl:attribute>
      					</input>
      				</td>
      				<td width="145">
      					<xsl:value-of select="@levelDesc01"/>
      				</td>
	      			<td>
	      				<input type="radio" style="border:0px;background-color:#ffffff">
	      					<xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute>
	      					<xsl:attribute name="value"><xsl:value-of select="@levelId02" /></xsl:attribute>
	      				</input>
	      			</td>
	      			<td width="145">
      					<xsl:value-of select="@levelDesc02"/>
      				</td>
	      			<td>
						<input type="radio" style="border:0px;background-color:#ffffff">
							<xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of select="@levelId03"/></xsl:attribute>
						</input>
					</td>
					<td width="145">
      					<xsl:value-of select="@levelDesc03"/>
      				</td>
					<td>
						<input type="radio" style="border:0px;background-color:#ffffff">
							<xsl:attribute name="name"><xsl:value-of select="@id" /></xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of select="@levelId04"/></xsl:attribute>
						</input>
	      			</td>
	      			<td width="145">
      					<xsl:value-of select="@levelDesc04"/>
      				</td>
	      			<td>
	      				<input type="button" name="Clear" value="Clear">
	      					<xsl:attribute name="onclick"><xsl:value-of select="@onclick" /></xsl:attribute>
	      				</input>
	      			</td>
	      			</xsl:if>
	      			<%	      			
	      			}
	      			%>
     			</tr></table>
  			</xsl:template>
		</xsl:stylesheet>
	</xml>

	<xml id="xslDoc">
  		<%@include file="/includes/xmlTree/xmlTree.xsl"%>
	</xml>
	<script language="javascript">
		tree.buildTree(document.getElementById("tree"), document.getElementById("xmlDoc"), document.getElementById("xslDoc"));
	</script>
		</form>
	</td></tr>
</table>
<%	
	}else{
		out.println("!!你没有相关访问权限!!");
	}
}catch(Exception e){
	e.printStackTrace();
}
%>