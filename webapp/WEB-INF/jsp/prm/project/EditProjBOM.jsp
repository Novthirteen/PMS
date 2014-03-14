<%@ page contentType="text/html; charset=gb2312" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.util.*"%>
<%@ page import="com.aof.component.prm.bid.*"%>
<%@ page import="com.aof.component.prm.project.*"%>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.util.*"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<meta http-equiv="Page-Enter" content="blendTrans(Duration=0.2)">
<meta http-equiv="Page-Exit" content="blendTrans(Duration=0.2)">
<title>AO-SYSTEM</title>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<jsp:useBean id="AOFSECURITY" type="com.aof.core.security.Security" scope="session" />
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/DialogSelection.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/parts.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/common.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/layout_one/js/dateCheck.js'></script>
<script language='javascript' type="text/javascript" src='<%=request.getContextPath()%>/includes/date/date.js'></script>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/Style2.css" rel=stylesheet type=text/css>
<link rel="stylesheet" type="text/css" href="includes/xmlTree/xmlTree.css"/>
<script type="text/javascript" src="includes/xmlTree/xmlTree.js"></script>
<%
try{
if (AOFSECURITY.hasEntityPermission("PMS", "_BOM_MAINTENANCE", session)) {%>
<script language="javascript">

	var tree = new XmlTree("includes/xmlTree");



function showBOMDetailDialog(bomid)
{
	var code,desc;
	var cid,cdesc;
	var depid,depname;
	with(document.frm1)
	{
	var param = "?formaction=dialogueView"
	if(bomid!=null)
	{
	param = param +"&masterid="+bomid;	
	}
		v = window.showModalDialog(
			"system.showDialog.do?title=helpdesk.call.actionTrack.body&editProjBOM.do"+param,
			null,
			'dialogWidth:600px;dialogHeight:600px;status:no;help:no;scroll:no');
	}
}



function ChangeVersion(obj)
{
	document.frm1.formaction.value="update";
	document.frm1.submit();	
}

function fnalert(flag)
{
	if(flag == 0)
	{
		if(!window.confirm("Are you sure to save a new version?"))
		{return;}
		document.frm1.formaction.value="editBaseLine";
	}
	else if(flag==1)
	{
		document.frm1.formaction.value="editSave";		
	}
	document.frm1.submit();
}
function Dealert(temp,reveflag)
{
	if(temp==0)
	{
		if(reveflag==0)
		{
		if(!window.confirm("Are you sure to DELETE this VERSION?"))
		{return;}
		}
		else if(reveflag == 1)
		{
		if(!window.confirm("This is the Latest version!! Are you sure to DELETE this VERSION?"))
		{return;}
		
		}
		document.frm1.formaction.value="deletecurr";
	}
	else
	{
	if(!window.confirm("Are you sure to DELETE ALL VERSIONS?"))
	{return;}
	document.frm1.formaction.value="deleteall";
	}
	document.frm1.submit();
}
function fnConfirm()
{
	document.frm1.action = "editProjType.do";
	document.frm1.formaction.value = "createST";
	document.frm1.submit();
}


function set(id)
{
	document.frm1.formaction.value='create';
	document.frm1.submit();
}

function fnAddNode(flag)
{
	var param = "?formaction=view";
	var masterId = document.getElementById("masterid").value;
	param += "&masterid=" + masterId;
	if(flag == 1)
	{
		if(tree.activeNode==null)
		{
			alert("Please select an Activity or a Milestone!");
			return;
		}
		if(tree.activeNode.parentNode._id!=null)
		param += "&parentranking=" + tree.activeNode.parentNode._id;
	}
	
		
	v = window.showModalDialog(
		"system.showDialog.do?title=prm.admin.meetingroom.dialog.title&editProjBOMNode.do" + param,
		null,
		'dialogWidth:600px;dialogHeight:200px;status:no;help:no;scroll:no');
	
	if(v!=null){
		var arr = v.split("|");
		if(arr.length==1)
		{
			alert(v.split("|")[0]);
			return;	
		}
		fnSetNewNode(arr[0],arr[1],arr[2]); //ranking,id,desc
	}
	else
		return;	
}

function fnSetNewNode(ranking,id,desc)
{
	var obj = tree.activeNode;
	if(ranking.length==3)
		tree.addNode(ranking,desc,null);	
	else
		tree.addNode(ranking,desc,ranking.substring(0,ranking.length-3))

	if(tree.activeNode!=null)
		tree.activeNode.scrollIntoView(true);			
}

function fnEditNode()
{
	var param = "?formaction=editShow";
	var masterId = document.getElementById("masterid").value;
	param += "&masterid=" + masterId;
	if(tree.activeNode==null){
		alert('Please click the task you want to modify!');
		return;
		}
	else
	{
		param += "&ranking=" + tree.activeNode.parentNode._id;		
	}	
		
	v = window.showModalDialog(
		"system.showDialog.do?title=prm.admin.meetingroom.dialog.title&editProjBOMNode.do" + param,
		null,
		'dialogWidth:600px;dialogHeight:200px;status:no;help:no;scroll:no');
	if(v!=null){
		var arr = v.split("|");
		if(arr.length==1)
		{
			alert(v.split("|")[0]);
			return;	
		}
		tree.EditNodeDesc(arr[0],arr[1],arr[2]); //ranking,id,desc
	}
	else
		return;	
}


		
</script>
<form name="frm1" action="editProjBOM.do" METHOD="post">
<input type="hidden" name="<%=PageKeys.TOKEN_PARA_NAME%>" value="<%=(String)session.getAttribute(PageKeys.TOKEN_SESSION_NAME)%>">
<%
String actionflag = (String)request.getAttribute("actionflag");
String action = (String)request.getAttribute("formaction");
ProjPlanBomMaster master = (ProjPlanBomMaster)request.getAttribute("master");
BidMaster bid = new BidMaster();
ProjectMaster pm = new ProjectMaster();
if(master!=null){
bid = master.getBid();
pm = master.getProject();
%>
<input type="hidden" name="masterid" value="<%=master.getId()%>">
<%}else{
	bid = (BidMaster)request.getAttribute("bm");
	pm = (ProjectMaster)request.getAttribute("pm");
}
StandardBOMMaster tMaster = (StandardBOMMaster)request.getAttribute("tMaster");
if(tMaster!=null){
%>
<input type="hidden" name="template_id" value="<%=tMaster.getId()%>">
<%}%>
<input type="hidden" name="formaction" value="<%=action%>">

<table border="0" cellpadding="4" cellspacing="0" align ='center'>
  <tbody align="center">
    <tr>
    <td>&nbsp;</td>
    <td class=pgheadsmall align='center'> Project BOM</td>
    <td></td>
    </tr>
  </tbody>
  <tbody align="center">
    <tr>
	<%if(bid!=null){%>

    <td>Bid No:</td>
    <td class=lblbold align='center'><input type="hidden" name="bid_id" value="<%=bid.getNo()%>"><%=bid.getNo()%>
	<input type="hidden" name="bidid" value="<%=bid.getId().longValue()%>">
    </td>
    <td>Bid Description:</td>
    <td class=lblbold align='center'><%=bid.getDescription()%>
    <%}%>
    <%if(pm!=null){%>
    <td>Project Id :</td>
    <td class=lblbold align='center'><input type="hidden" name="proj_id" value="<%=pm.getProjId()%>"><%=pm.getProjId()%>
    </td>
    <td>Project Description:</td>
    <td class=lblbold align='center'><%=pm.getProjName()%>
    <%}%>
    <%if(!action.equalsIgnoreCase("new")){%>
    <td>Version:</td>
	<td class=lblbold align='center'>
	<%
	    List versionList = (List)request.getAttribute("versionList");
	    if(versionList!=null){
	%>
   	<select name="version" onchange="javascript:ChangeVersion(this)">
    <%
    for(int i=0;i<versionList.size();i++)
    {
    int version = ((Integer)versionList.get(i)).intValue();
    %>
    <option value="<%=version%>" <%if(master.getVersion()==version) out.println("selected");%> ><%=version%>    	
    <%}
    }
   }
    %>
    </select>
    </td>
    </tr>
  </tbody>
</table>
<hr/>
<div id="tree" style="margin:5px"></div>
<br>
<%
if(!action.equalsIgnoreCase("new")){
%>
<%
	int reveConfirm = 0;
	if((master!=null)&&(master.getReveConfirm()==null)){
	reveConfirm = 1;
%>
<input type="button" name="" value="Edit" onClick="javascript:fnEditNode()" class="button">
<input type="button" name="" value="Add Activity" onClick="javascript:fnAddNode(1)" class="button">
<input type="button" name="" value="Add Milestone" onClick="javascript:fnAddNode(0)" class="button">

	<input type="button" value="Save" onclick="fnalert(1)" class="button"/>

	<input type="button" value="Save as BaseLine" onclick="fnalert(0)" class="button"/>
	<input type="button" value="Delete this Version" onclick="Dealert(0,<%=reveConfirm%>)" class="button"/>
<!-- 	<input type="button" value="Delete All Versions" onclick="Dealert(1)" class="button"/> -->
<%}
//UserLogin ul = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);
%>
<input type="button" value="Edit Service Type" onclick="fnConfirm()" class="button"/>
<input type="button" value="Preview" onclick="javascript:showBOMDetailDialog(<%=master.getId()%>)" class="button"/>
<%}else{%>
<input type="checkbox" name="email" value="y" style="border:0px;background-color:#ffffff">Send Email to ServiceLine Manager
<input type="button" value="Generate" onclick="javascript:set();" class="button">
<%}%>
<input type="button" value="Back to List" onclick="location.replace('findProjBOM.do')" class="button">
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
      <xsl:attribute name="type"><xsl:value-of select="@branchroot"/></xsl:attribute>
      <xsl:attribute name="id">D<xsl:value-of select="@id"/></xsl:attribute>
      <xsl:attribute name="_id"><xsl:value-of select="@_id"/></xsl:attribute>
      <img _src="closed.gif" width="11" height="11" align="absmiddle" style="margin-right:5px">
        <xsl:attribute name="id">I<xsl:value-of select="@id"/></xsl:attribute>
        <xsl:attribute name="_id"><xsl:value-of select="@id"/></xsl:attribute>
      </img>
	  <input type="checkbox"  style="border:0px" >
	  	<xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
	  	<xsl:attribute name="name"><xsl:value-of select="@check" /></xsl:attribute>
	  	<xsl:attribute name="value"><xsl:value-of select="@_id" /></xsl:attribute>
	  	<xsl:attribute name="onclick"><xsl:value-of select="@onclick" /></xsl:attribute>
	  	<xsl:if test="@status = 1">
    	<xsl:attribute name="checked"/>
		</xsl:if>
	  	
	  </input> 
	  <input type="hidden" >
	  	<xsl:attribute name="name"><xsl:value-of select="@parentid" /></xsl:attribute>
	  	<xsl:attribute name="value"><xsl:value-of select="@parent" /></xsl:attribute>
	  	<xsl:attribute name="onclick"><xsl:value-of select="@onclick" /></xsl:attribute>
	  </input> 
	  <input type="hidden" >
	  	<xsl:attribute name="name"><xsl:value-of select="@descid" /></xsl:attribute>
	  	<xsl:attribute name="value"><xsl:value-of select="@desc" /></xsl:attribute>
	  	<xsl:attribute name="onclick"><xsl:value-of select="@onclick" /></xsl:attribute>
	  </input> 
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
    <div class="node" >
      <xsl:attribute name="desc"><xsl:value-of select="@desc"/></xsl:attribute>
      <xsl:attribute name="type"><xsl:value-of select="@branchroot"/></xsl:attribute>
      <xsl:attribute name="id">D<xsl:value-of select="@id"/></xsl:attribute>
       <xsl:attribute name="_id"><xsl:value-of select="@_id"/></xsl:attribute>
      <img _src="doc.gif" width="11" height="11" align="absmiddle" style="margin-right:5px">
        <xsl:attribute name="id">I<xsl:value-of select="@id"/></xsl:attribute>
        <xsl:attribute name="_id"><xsl:value-of select="@id"/></xsl:attribute>
      </img>
	  <input type="checkbox" style="border:0px" >
	  	<xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
	  	<xsl:attribute name="name"><xsl:value-of select="@check" /></xsl:attribute>
	  	<xsl:attribute name="value"><xsl:value-of select="@_id" /></xsl:attribute>
	  	<xsl:attribute name="onclick"><xsl:value-of select="@onclick" /></xsl:attribute>
	  	<xsl:if test="@status = 1">
    	<xsl:attribute name="checked"/>
		</xsl:if>
	  </input> 
	  <input type="hidden" >
	  	<xsl:attribute name="name"><xsl:value-of select="@parentid" /></xsl:attribute>
	  	<xsl:attribute name="value"><xsl:value-of select="@parent" /></xsl:attribute>
	  	<xsl:attribute name="onclick"><xsl:value-of select="@onclick" /></xsl:attribute>
	  </input> 
	  <input type="hidden" >
	  	<xsl:attribute name="name"><xsl:value-of select="@descid" /></xsl:attribute>
	  	<xsl:attribute name="value"><xsl:value-of select="@desc" /></xsl:attribute>
	  	<xsl:attribute name="onclick"><xsl:value-of select="@onclick" /></xsl:attribute>
	  </input> 
     <span class="clsNormal">
        <xsl:attribute name="id">N<xsl:value-of select="@id"/></xsl:attribute>
        <xsl:attribute name="_id"><xsl:value-of select="@id"/></xsl:attribute>
        <xsl:value-of select="@desc"/>
      </span>
     </div>
  </xsl:template>
</xsl:stylesheet>
</xml>
<xml id="xslDoc">
  <%@include file="/includes/xmlTree/xmlTree2.xsl"%>
</xml>
<script language="javascript">
	tree.buildTree(document.getElementById("tree"), document.getElementById("xmlDoc"), document.getElementById("xslDoc"));
<%if(actionflag!=null){%>
var actionflag = "haha";
actionflag =  "<%=actionflag%>";
var array = actionflag.split('|');
alert(array[0]+" success!");
<%}%>
</script>
</form>
<%}else{
out.println("!!你没有相关访问权限!!");
}
}catch(Exception e){
	e.printStackTrace();
}
%>
