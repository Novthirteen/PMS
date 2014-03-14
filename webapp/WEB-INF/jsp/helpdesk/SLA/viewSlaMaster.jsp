<%@ page contentType="text/html; charset=gb2312"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<link rel="stylesheet" type="text/css" href="includes/tree/xmlTree.css"/>
<script type="text/javascript" src="includes/tree/xmlTree.js"></script>
<style>
	div.clsPriorityHead {
	  margin:1px; 
	  padding-top:2px;
	  padding-bottom:1px;
	  padding-left:6px;
	  padding-right:4px;
	  background-color:#b4d4d4;
	  border:1px solid #b4d4d4;
	}
	div.clsActivePriorityContent {
	  cursor:hand;
	  margin:1px; 
	  padding-top:2px;
	  padding-bottom:1px;
	  padding-left:6px;
	  padding-right:4px;
	  background-color:#F1F1F1;
	  border:1px solid #999999;
	}
	div.clsNormalPriorityContent {
	  cursor:hand;
	  margin:1px; 
	  padding-top:2px;
	  padding-bottom:1px;
	  padding-left:6px;
	  padding-right:4px;
	  border:1px solid #deebeb;
	}
	div.clsMouseOverPriorityContent {
	  cursor:hand;
	  margin:1px; 
	  padding-top:2px;
	  padding-bottom:1px;
	  padding-left:6px;
	  padding-right:4px;
	  background-color:#CCCCCC;
	  border:1px solid #999999;
	}
	div.clsMouseDownPriorityContent {
	  cursor:hand;
	  margin:1px; 
	  padding-top:2px;
	  padding-bottom:1px;
	  padding-left:6px;
	  padding-right:4px;
	  background-color:#999999;
	  border:1px solid #999999;
	}
</style>
<script language="javascript">
	function selectPriorityItem() {
		obj = event.srcElement;
		if (obj.tagName != 'DIV') obj = obj.parentNode;
		setActivePriorityItem(obj);
	}
	
	function setActivePriorityItem(obj) {
		if (window.activePriorityItem != null) {
			window.activePriorityItem.className="clsNormalPriorityContent";
		}
		obj.className = "clsActivePriorityContent";
		window.activePriorityItem = obj;
	}
	
	function mouseoverPriorityItem() {
		obj = event.srcElement;
		if (obj.tagName != 'DIV') obj = obj.parentNode;
		obj.className = "clsMouseOverPriorityContent";
	}

	function mouseoutPriorityItem() {
		obj = event.srcElement;
		if (obj.tagName != 'DIV') obj = obj.parentNode;
		if (obj == window.activePriorityItem) {
			obj.className = "clsActivePriorityContent";
		} else {
			obj.className = "clsNormalPriorityContent";
		}
	}

	function mousedownPriorityItem() {
		obj = event.srcElement;
		if (obj.tagName != 'DIV') obj = obj.parentNode;
		obj.className = "clsMouseDownPriorityContent";
	}

	function editSLAMaster() {
		var v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.servicelevel.master.edit.title&helpdesk.editSLAMaster.do?id=<bean:write name="X_master" property="id"/>', null, 'dialogWidth:500px;dialogHeight:160px;status:no;help:no;scroll:no');
		if (v == null) return;
		if (master_desc != null) {
			master_desc.innerText = v['desc'];
		}
		if (master_active != null) {
			master_active.innerText = v['active'];
		}
		if (master_modifyDate != null) {
			master_modifyDate.innerText = v['modifyDate'];
		}
		if (master_modifyUser != null) {
			master_modifyUser.innerText = v['modifyUser'];
		}
	}

	function deleteSLAMaster() {
		var v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.servicelevel.master.delete.title&helpdesk.confirmDeleteDialog.do?title=helpdesk.servicelevel.master.delete.title&message=helpdesk.servicelevel.master.delete.message&helpdesk.deleteSLAMaster.do?id=<bean:write name="X_master" property="id"/>', null, 'dialogWidth:300px;dialogHeight:143px;status:no;help:no;scroll:no');
		if (v == null) return;
		window.location.href = "helpdesk.listSLAMaster.do";
	}
	
	function addSLACategory() {
		var obj = window.activeNode;
		var v = null;
		if (obj == null) {
			v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.servicelevel.category.new.title&helpdesk.newSLACategory.do?masterid=<bean:write name="X_master" property="id"/>', null, 'dialogWidth:500px;dialogHeight:170px;status:no;help:no;scroll:no');
		} else {
		    v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.servicelevel.category.new.title&helpdesk.newSLACategory.do?parentId=' + window.activeNodeID, null, 'dialogWidth:500px;dialogHeight:170px;status:no;help:no;scroll:no');
		}
		if (v == null) return;
		var node = document.createElement('div');
		node.className = 'node';
		node.desc = v['desc'];
		var img = document.createElement('img');
		img.id = 'I' + v['id'];
		img._id = v['id'];
		img.src = 'includes/tree/doc.gif';
		img.width = img.height = '11';
		img.align = 'absmiddle';
		img.style.marginRight = '5px';
		node.appendChild(img);
		var span = document.createElement('span');
		span.id = 'N' + v['id'];
		span._id = v['id'];
		span.className = 'clsNormal';
		span.attachEvent('onmouseover', mouseoverItem);
		span.attachEvent('onmousedown', mousedownItem);
		span.attachEvent('onmouseout', mouseoutItem);
		span.attachEvent('onclick', selectItem);
		span.innerText = v['desc'];
		node.appendChild(span);
		if (v['parentId'] == null) {
			var root = document.getElementById('treeroot');
			root.appendChild(node);
		} else {
			var branch = document.getElementById('B' + v['parentId']);
			if (branch == null) {
				img = document.getElementById('I' + v['parentId']);
				if (img != null) {
					img.src = 'includes/tree/open.gif';
					img.attachEvent("onclick",  swapBranch);
				}
				var root = document.getElementById('N' + v['parentId']);
				if (root == null) return;
				root = root.parentNode;
				branch = document.createElement('span');
				branch.className = 'branch';
				branch.id = 'B' + v['parentId'];
				branch._id = v['parentId'];
				branch.desc = root.desc;
				if (root.nextSibling == null) {
					root.parentNode.appendChild(branch);
				} else {
					root.parentNode.insertBefore(branch, root.nextSibling);
				}
			}
			branch.appendChild(node);
		}
		setActiveItem(parseInt(v['id']));
		window.activeNode.scrollIntoView(true);			
	}
	
	function editSLACategory() {
		var obj = window.activeNode;
		if (obj == null) {
			alert('<bean:message key="helpdesk.servicelevel.category.edit.nochoice.message"/>');
			return;
		}
		var v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.servicelevel.category.edit.title&helpdesk.editSLACategory.do?id=' + window.activeNodeID, null, 'dialogWidth:500px;dialogHeight:236px;status:no;help:no;scroll:no');
		if (v == null) return;
		obj.innerText = v['desc'];
		obj.parentNode.desc = v['desc'];
		var bobj = document.getElementById('B' + window.activeNodeID);
		if (bobj != null) bobj.desc = v['desc'];
		setActiveItem(window.activeNodeID);
		var pc = document.getElementsByName('C' + window.activeNodeID);
		for (i = 0; i < pc.length; i++) {
			pc.item(i).innerText = v['desc'];
		}
	}
	
	function deleteSLACategory() {
		var obj = window.activeNode;
		if (obj == null) {
			alert('<bean:message key="helpdesk.servicelevel.category.delete.nochoice.message"/>');
			return;
		}
		var v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.servicelevel.category.delete.title&helpdesk.confirmDeleteDialog.do?title=helpdesk.servicelevel.category.delete.title&message=helpdesk.servicelevel.category.delete.message&helpdesk.deleteSLACategory.do?id=' + window.activeNodeID, null, 'dialogWidth:300px;dialogHeight:143px;status:no;help:no;scroll:no');
		if (v == null) return;
		var p = obj.parentNode;
		var pp = p.parentNode;
		var s = p.nextSibling;
		pp.removeChild(p);
		if (s != null && s.className == 'branch') {
			pp.removeChild(s);
		}
		if (pp.className == 'branch' && pp.firstChild == null) {
			var pid = pp._id;
			pp.parentNode.removeChild(pp);
			var img = document.getElementById('I' + pid);
			if (img != null) {
				img.src = 'includes/tree/doc.gif';
				img.detachEvent("onclick", swapBranch);
			}
		}
		window.activeNode = null;
		var phead = document.getElementById('PHead');
		if (phead != null) {
			p = phead.nextSibling;
			var categoryid = parseInt(window.activeNodeID);
			while (p != null) {
				var o = p.nextSibling;
				if (parseInt(p.firstChild._id) == categoryid) {
					if (p == window.activePriorityItem) window.activePriorityItem = null;
					p.parentNode.removeChild(p);
				}
				p = o;
			}
		}
		window.activeNodeID = null;
		window.activeNodeDesc = null;
	}

	function addSLAPriority() {
		var obj = window.activeNode;
		if (obj == null) {
			alert('<bean:message key="helpdesk.servicelevel.priority.add.nochoice.message"/>');
			return;
		}
		var v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.servicelevel.priority.new.title&helpdesk.newSLAPriority.do?categoryid=' + window.activeNodeID, null, 'dialogWidth:600px;dialogHeight:192px;status:no;help:no;scroll:no');
		if (v == null) return;
		var phead = document.getElementById('PHead');
		if (phead == null) return;
		var newP = phead.cloneNode(true);
		newP.className = 'clsNormalPriorityContent';
        newP.id = 'P' + v['id'];
        newP._id = v['id'];
        newP._desc = v['desc'];
        newP._restime = v['responseTime'];
        newP._soltime = v['solveTime'];
        newP._clstime = v['closeTime'];
        newP._reswtime = v['responseWarningTime'];
        newP._solwtime = v['solveWarningTime'];
        newP._clswtime = v['closeWarningTime'];
        newP.attachEvent('onclick', selectPriorityItem);
        newP.attachEvent('onmouseover', mouseoverPriorityItem);
        newP.attachEvent('onmouseout', mouseoutPriorityItem);
        newP.attachEvent('onmousedown', mousedownPriorityItem);
        var c = newP.children(0);
        c.className = null;
        c.id = 'C' + v['categoryid'];
        c._id = v['categoryid'];
        c.innerText = v['categoryDesc'];
        c = newP.children(1);
        c.className = null;
        c.id = 'P' + v['id'] + 'desc';
        c.innerText = v['desc'];
        c = newP.children(2);
        c.className = null;
        c.id = 'P' + v['id'] + 'response';
        c.innerText = v['responseWarningTime'] + '/' + v['responseTime'];
        c = newP.children(3);
        c.className = null;
        c.id = 'P' + v['id'] + 'solve';
        c.innerText = v['solveWarningTime'] + '/' + v['solveTime'];
        c = newP.children(4);
        c.className = null;
        c.id = 'P' + v['id'] + 'close';
		c.innerText = v['closeWarningTime'] + '/' + v['closeTime'];
		var p = phead;
		var categoryid = parseInt(v['categoryid']);
		while ((p = p.nextSibling) != null) {
			if (parseInt(p.firstChild._id) > categoryid) break;
		}
		if (p == null) {
			phead.parentNode.appendChild(newP);
		} else {
			phead.parentNode.insertBefore(newP, p);
		}
		setActivePriorityItem(newP);
		newP.scrollIntoView(true);
	}

	function editSLAPriority() {
		var obj = window.activePriorityItem;
		if (obj == null) {
			alert('<bean:message key="helpdesk.servicelevel.priority.edit.nochoice.message"/>');
			return;
		}
	
		var v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.servicelevel.priority.edit.title&helpdesk.editSLAPriority.do?id=' + obj._id, null, 'dialogWidth:600px;dialogHeight:281px;status:no;help:no;scroll:no');
		if (v == null) return;
		obj._desc = v['desc'];
		obj._restime = v['responseTime'];
		obj._soltime = v['solveTime'];
		obj._clstime = v['closeTime'];
		obj._reswtime = v['responseWarningTime'];
		obj._solwtime = v['solveWarningTime'];
		obj._clswtime = v['closeWarningTime'];
		var s = document.getElementById('P' + obj._id + 'desc');
		if (s != null) s.innerText = obj._desc;
		s = document.getElementById('P' + obj._id + 'response');
		if (s != null) s.innerText = obj._reswtime + '/' + obj._restime;
		s = document.getElementById('P' + obj._id + 'solve');
		if (s != null) s.innerText = obj._solwtime + '/' + obj._soltime;
		s = document.getElementById('P' + obj._id + 'close');
		if (s != null) s.innerText = obj._clswtime + '/' + obj._clstime;
	}

	function deleteSLAPriority() {
		var obj = window.activePriorityItem;
		if (obj == null) {
			alert('<bean:message key="helpdesk.servicelevel.priority.delete.nochoice.message"/>');
			return;
		}
		var v = window.showModalDialog('helpdesk.showDialog.do?title=helpdesk.servicelevel.priority.delete.title&helpdesk.confirmDeleteDialog.do?title=helpdesk.servicelevel.priority.delete.title&message=helpdesk.servicelevel.priority.delete.message&helpdesk.deleteSLAPriority.do?id=' + obj._id, null, 'dialogWidth:300px;dialogHeight:143px;status:no;help:no;scroll:no');
		if (v == null) return;
		obj.parentNode.removeChild(obj);
		window.activePriorityItem = null;
	}

</script>
<div style="height:5px"><img src="images/spacer.gif" width="1" height="1"/></div>
<table border=0 width='100%' cellspacing='0' cellpadding='0'>
<tr>
  <td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
  <td>
	<table border=0 width='100%' cellspacing='0' cellpadding='0'>
	<tr>
	  <td width='100%' height='20'>
	    <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.servicelevel.master.show.title"/></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td width='100%' bgcolor='#deebeb'>
	    <div style="margin:5px">
	      <input type="button" value="<bean:message key="button.edit"/>" onclick="editSLAMaster();"/>
	      <input type="button" value="<bean:message key="button.delete"/>" onclick="deleteSLAMaster();"/>
	      <input type="button" value="<bean:message key="helpdesk.servicelevel.master.button.backtolist"/>" onclick="window.location.href = 'helpdesk.listSLAMaster.do';"/>
	    </div>
	    <table width='100%' border='0' cellpadding='0' cellspacing='2' style="margin:5px">
	    <tr>
	      <td>
	        <span class="labeltext"><bean:message key="helpdesk.servicelevel.master.code.label"/>:</span>
	        <bean:write name="X_master" property="id"/>
	      </td>
	      <td>
	        <span class="labeltext"><bean:message key="helpdesk.servicelevel.master.desc.label"/>:</span>
	        <span id="master_desc"><bean:write name="X_master" property="desc"/></span>
	      </td>
	    </tr>
	    <tr>
	      <td>
	        <span class="labeltext"><bean:message key="helpdesk.servicelevel.master.active.label"/>:</span>
	        <span id="master_active">
	          <logic:equal name="X_master" property="active" value="Y">
	            <bean:message key="helpdesk.servicelevel.master.active.choice.yes"/>
	          </logic:equal>
	          <logic:equal name="X_master" property="active" value="N">
	            <bean:message key="helpdesk.servicelevel.master.active.choice.no"/>
	          </logic:equal>
	        </span>
	      </td>
	      <td>
	        <span class="labeltext"><bean:message key="helpdesk.servicelevel.master.customer.label"/>:</span>
	        <logic:present name="X_master" property="party">
	          <bean:write name="X_master" property="party.description"/>
	        </logic:present>
	        <logic:notPresent name="X_master" property="party">
	          <bean:message key="helpdesk.servicelevel.master.customer.choice.default"/>
	        </logic:notPresent>
	      </td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td width='100%' height='4'>
	    <table width='100%' height='4' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="bottom" align="left" bgcolor="#deebeb"><img src="images/cornerLB.gif" width="4" height="4" border="0"></td>
	      <td bgcolor="#deebeb"><img src="images/spacer.gif" width="1" height="1"/></td>
	      <td width="8" valign="bottom" align="right" bgcolor="#deebeb"><img src="images/cornerRB.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr><td height="5"><img src="images/spacer.gif" width="1" height="1"/></td></tr>
	<tr>
	  <td width='100%'>
	    <table width='100%' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width='30%'>
	        <table width='100%' height='300' border='0' cellspacing='0' cellpadding='0'>
	        <tr>
	          <td width='100%' height='20'>
	            <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	            <tr>
	              <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	              <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.servicelevel.category.show.title"/></td>
	              <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	            </tr>
	            </table>
	          </td>
	        </tr>
	        <tr valign='top'>
	          <td width='100%' bgcolor="#deebeb">
	            <div style="margin:5px">
	              <input type="button" value="<bean:message key="button.add"/>" onclick="addSLACategory();"/>
	              <input type="button" value="<bean:message key="button.edit"/>" onclick="editSLACategory();"/>
	              <input type="button" value="<bean:message key="button.delete"/>" onclick="deleteSLACategory();"/>
	            </div>
	            <table width='100%' border='0' cellspacing='0' cellpadding='0'>
	            <tr>
	              <td width='100%'>
	                <div id="tree" style="margin:5px;width:100%;height:230;overflow-X:auto;overflow-Y:scroll;scrollbar-base-color:#b4d4d4;scrollbar-3dlight-color:#deebeb;scrollbar-darkshadow-color:#deebeb">
	                </div>
	              </td>
	            </tr>
	            </table>
	          </td>
	        </tr>
	        <tr>
	          <td width='100%' heigth='4'>
	            <table width='100%' heigth='4' border='0' cellspacing='0' cellpadding='0'>
	            <tr>
	              <td width="8" valign="bottom" align="left" bgcolor="#deebeb"><img src="images/cornerLB.gif" width="4" height="4" border="0"></td>
	              <td bgcolor="#deebeb"><img src="images/spacer.gif" width="1" height="1"/></td>
	              <td width="8" valign="bottom" align="right" bgcolor="#deebeb"><img src="images/cornerRB.gif" width="4" height="4" border="0"></td>
	            </tr>
	            </table>
	          </td>
	        </tr>
	        </table>
	      </td>
	      <td width='10' valign='top'>&nbsp;</td>
	      <td width='70%' valign='top'>
	        <table width='100%' height='300' border='0' cellspacing='0' cellpadding='0'>
	        <tr>
	          <td width='100%' height='20'>
	            <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	            <tr>
	              <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	              <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.servicelevel.priority.show.title"/></td>
	              <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	            </tr>
	            </table>
	          </td>
	        </tr>
	        <tr valign='top'>
	          <td width='100%' bgcolor="#deebeb">
	            <div style="margin:5px">
	              <input type="button" value="<bean:message key="button.add"/>" onclick="addSLAPriority();"/>
	              <input type="button" value="<bean:message key="button.edit"/>" onclick="editSLAPriority();"/>
	              <input type="button" value="<bean:message key="button.delete"/>" onclick="deleteSLAPriority();"/>
	            </div>
	            <table width='100%' border='0' cellspacing='0' cellpadding='0'>
	            <tr>
	              <td width='100%'>
	                <div style="margin:5px;width:100%;height:230;overflow-X:auto;overflow-Y:scroll;scrollbar-base-color:#b4d4d4;scrollbar-3dlight-color:#deebeb;scrollbar-darkshadow-color:#deebeb">
	                  <div id="PHead" class="clsPriorityHead">
	                    <span style="width:100px" class="labeltext"><bean:message key="helpdesk.servicelevel.priority.category.label"/></span>
	                    <span style="width:250px" class="labeltext"><bean:message key="helpdesk.servicelevel.priority.description.label"/></span>
	                    <span style="width:90px" class="labeltext"><bean:message key="helpdesk.servicelevel.priority.responseTime.label"/></span>
	                    <span style="width:90px" class="labeltext"><bean:message key="helpdesk.servicelevel.priority.solveTime.label"/></span>
	                    <span style="width:90px" class="labeltext"><bean:message key="helpdesk.servicelevel.priority.closeTime.label"/></span>
	                  </div>
	                  <logic:iterate id="p" name="X_priorities" type="com.aof.component.helpdesk.servicelevel.SLAPriority">
	                  <div class="clsNormalPriorityContent" 
	                    onclick="selectPriorityItem();"
	                    onmouseover="mouseoverPriorityItem();"
	                    onmouseout="mouseoutPriorityItem();"
	                    onmousedown="mousedownPriorityItem();"
	                    id="P<bean:write name="p" property="id"/>"
	                    _id="<bean:write name="p" property="id"/>"
	                    _desc="<bean:write name="p" property="desc"/>"
	                    _restime="<bean:write name="p" property="responseTime"/>"
	                    _soltime="<bean:write name="p" property="solveTime"/>"
	                    _clstime="<bean:write name="p" property="closeTime"/>"
	                    _reswtime="<bean:write name="p" property="responseWarningTime"/>"
	                    _solwtime="<bean:write name="p" property="solveWarningTime"/>"
	                    _clswtime="<bean:write name="p" property="closeWarningTime"/>"
	                  >
	                    <span id='C<bean:write name="p" property="category.id"/>' _id=<bean:write name="p" property="category.id"/> style="width:100px"><bean:write name="p" property="category.desc"/></span>
	                    <span id='P<bean:write name="p" property="id"/>desc' style="width:250px"><bean:write name="p" property="desc"/></span>
	                    <span id='P<bean:write name="p" property="id"/>response' style="width:90px"><bean:write name="p" property="responseWarningTime"/>/<bean:write name="p" property="responseTime"/></span>
	                    <span id='P<bean:write name="p" property="id"/>solve' style="width:90px"><bean:write name="p" property="solveWarningTime"/>/<bean:write name="p" property="solveTime"/></span>
	                    <span id='P<bean:write name="p" property="id"/>close' style="width:90px"><bean:write name="p" property="closeWarningTime"/>/<bean:write name="p" property="closeTime"/></span>
	                  </div>
	                  </logic:iterate>
	                </div>
	              </td>
	            </tr>
	            </table>
	          </td>
	        </tr>
	        <tr>
	          <td width='100%' heigth='4'>
	            <table width='100%' heigth='4' border='0' cellspacing='0' cellpadding='0'>
	            <tr>
	              <td width="8" valign="bottom" align="left" bgcolor="#deebeb"><img src="images/cornerLB.gif" width="4" height="4" border="0"></td>
	              <td bgcolor="#deebeb"><img src="images/spacer.gif" width="1" height="1"/></td>
	              <td width="8" valign="bottom" align="right" bgcolor="#deebeb"><img src="images/cornerRB.gif" width="4" height="4" border="0"></td>
	            </tr>
	            </table>
	          </td>
	        </tr>
	        </table>
	      </td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr><td height="5"><img src="images/spacer.gif" width="1" height="1"/></td></tr>
	<tr>
	  <td width='100%' height='20'>
	    <table width='100%' height='20' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="top" align="left" bgcolor="#b4d4d4"><img src="images/cornerLT.gif" width="4" height="4" border="0"></td>
	      <td align=left class="wpsPortletTopTitle"><bean:message key="helpdesk.servicelevel.master.modifylog.title"/></td>
	      <td width="8" valign="top" align="right" bgcolor="#b4d4d4"><img src="images/cornerRT.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td width='100%' bgcolor="#deebeb">
	    <table width='100%' border='0' cellspacing='0' cellpadding='0' style="margin:5px">
	    <tr>
	      <td>
	        <span class="labeltext"><bean:message key="helpdesk.servicelevel.master.modifylog.createdate.label"/>:</span>
	        <bean:write name="X_master" property="modifyLog.createDate" format="yyyy-MM-dd HH:mm"/>
	      </td>
	      <td>
	        <span class="labeltext"><bean:message key="helpdesk.servicelevel.master.modifylog.createuser.label"/>:</span>
	        <logic:present name="X_master" property="modifyLog.createUser"><bean:write name="X_master" property="modifyLog.createUser.name"/></logic:present>
	      </td>
	    </tr>
	    <tr>
	      <td>
	        <span class="labeltext"><bean:message key="helpdesk.servicelevel.master.modifylog.modifydate.label"/>:</span>
	        <span id="master_modifyDate"><bean:write name="X_master" property="modifyLog.modifyDate" format="yyyy-MM-dd HH:mm"/></span>
	      </td>
	      <td>
	        <span class="labeltext"><bean:message key="helpdesk.servicelevel.master.modifylog.modifyuser.label"/>:</span>
	        <span id="master_modifyUser"><logic:present name="X_master" property="modifyLog.modifyUser"><bean:write name="X_master" property="modifyLog.modifyUser.name"/></logic:present></span>
	      <td>
	    </tr>
	    </table>
	  </td>
	</tr>
	<tr>
	  <td width='100%' height='4'>
	    <table width='100%' height='4' border='0' cellspacing='0' cellpadding='0'>
	    <tr>
	      <td width="8" valign="bottom" align="left" bgcolor="#deebeb"><img src="images/cornerLB.gif" width="4" height="4" border="0"></td>
	      <td bgcolor="#deebeb"><img src="images/spacer.gif" width="1" height="1"/></td>
	      <td width="8" valign="bottom" align="right" bgcolor="#deebeb"><img src="images/cornerRB.gif" width="4" height="4" border="0"></td>
	    </tr>
	    </table>
	  </td>
	</tr>
	</table>
  </td>
  <td width="5"><img src="images/spacer.gif" width="5" height="1"/></td>
</tr>
</table>
<xml id="xmlDoc">
  <bean:write name="X_categoryxml" filter="false"/>
</xml>
<xml id="xslDoc">
  <jsp:include page="/includes/tree/xmlTree.xsl"/>
</xml>
<script language="javascript">
	var source = new ActiveXObject("Microsoft.XMLDOM");
	var stylesheet = new ActiveXObject("Microsoft.XMLDOM");
	source.loadXML(xmlDoc.innerHTML);
	stylesheet.loadXML(xslDoc.innerHTML);
	document.getElementById("tree").innerHTML = source.transformNode(stylesheet);
</script>