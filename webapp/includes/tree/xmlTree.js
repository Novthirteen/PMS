var openImg = new Image();
var closedImg = new Image();

openImg.src = "includes/tree/open.gif";
closedImg.src = "includes/tree/closed.gif";
   
function showBranch(objBranch) {
    if (objBranch.style.display != "block") {
        objBranch.style.display="block";
        objImg = document.getElementById('I' + objBranch._id);
        objImg.src = openImg.src;
    }
}

function swapBranch() {
	var id = event.srcElement._id;
    var objBranch = document.getElementById('B' + id).style;
    if (objBranch.display == "block")
        objBranch.display="none";
    else
        objBranch.display="block";
    swapFolder('I' + id);
}

function swapFolder(img) {
    objImg = document.getElementById(img);
    if (objImg.src == closedImg.src)
        objImg.src = openImg.src;
    else
        objImg.src = closedImg.src;
}

function selectItem() {
	var obj = event.srcElement;
	if (obj == null) return;
    var p = obj.parentNode;
    var desc = getDesc(p);
	setActiveNode(obj);
    window.activeNodeID = obj._id;
    window.activeNodePathDesc = desc;
}

function setActiveItem(id) {
	var obj = document.getElementById('N' + id);
	if (obj == null) return;
    var p = obj.parentNode;
    var desc = getDesc(p);
	setActiveNode(obj);
    window.activeNodeID = id;
    window.activeNodePathDesc = desc;
}
    
function getDesc(o) {
    var p = o.parentNode;
    if (p.className == "branch") {
    	showBranch(p);
        return getDesc(p) + "\\" + o.desc;
    } else {
        return o.desc;
    }
}

function setActiveNode(obj) {
    if (window.activeNode != null) {
    	window.activeNode.className = "clsNormal";
    }
    obj.className = "clsActive";
    window.activeNode = obj;
}

function mouseoverItem() {
	event.srcElement.className = "clsMouseOver";
}

function mousedownItem(obj) {
	event.srcElement.className = "clsMouseDown";
}

function mouseoutItem() {
	var obj = event.srcElement;
	if (obj == window.activeNode) {
		obj.className = "clsActive";
	} else {
		obj.className = "clsNormal";
	}
}