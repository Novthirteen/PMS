var NN = (navigator.appName.indexOf("Netscape") == 0 && navigator.appVersion.charAt(0) == 4);
var IE = (navigator.appName.indexOf("Microsoft") == 0);
var NN6 = (navigator.appName.indexOf("Netscape") == 0 && navigator.appVersion.charAt(0) > 4);

if(NN){
	var _w = window.innerWidth
	var _h = window.innerHeight
	setInterval("if(window.innerWidth != _w || window.innerHeight != _h) location.reload()",1000)
}


var hideClassName = "trHidden";
var divPrefix = "P";
var indent = 0;
var treeSelected;
var styleNormal;
var styleSelect;

function treeOnLoad(){

	var divobj = null;
	var i,j;

	if(IE){
		divobj = document.all.tags("DIV");
		for(i=0;i<divobj.length;i++){
			if(divobj[i].className == hideClassName){
				divobj[i].style.display = "none";
			}
		}
		
	}else if(NN6){
		divobj = document.getElementsByTagName("DIV");
		for(i=0;i<divobj.length;i++){
			if(divobj[i].className == hideClassName){
				divobj[i].style.display = "none";
			}
		}
	}else if(NN){
		divobj = document.layers;
		getAllLayer(divobj);
		setheight(document,1);
		setInterval('var o=getObject("ED");document.height=o.pageY+o.clip.height+20',1000);
	}
	
	if (!NN && treeSelected) {
		clickTreeText(treeSelected);
	}
	
}

function onTree(name){
	var obj = getObject(name);
	if(obj == null){
		return;
	}
	var i=0;
	if(IE || NN6){
		if(obj.style.display == ""){
			obj.style.display = "none";
		}else{
			obj.style.display = (obj.style.display == "block") ? "none" : "block";
		}
	}else if(NN){
		var b,h,p
		obj.visibility = ((b=(obj.visibility!="hide"))?"hide":"inherit")
		h = realheight(obj)
		while(1){
			p = obj.parentLayer
			for(var i=1,f=1;i<p.document.layers.length;i++){
				if(f&&p.document.layers[i-1].id!=obj.id){
					continue;
				}
				f=0
				p.document.layers[i].top += h*(b?-1:1)
			}
			if(p==window){
				break
			}
			p.clip.height += h*(b?-1:1)
			obj = p
		}
	}
}

function getObject(id){
	if(NN){
		var i,j;
		var list = document.layers;
		return search(id);
	}else if(IE){
		return document.all(id);
	}else if(NN6){
		return document.getElementById(id);
	}
	return null;
}

function clickTreeText(id) {
	if (NN) {
		return;
	}
	if (treeSelected) {
		getObject(treeSelected).className = styleNormal;
	}
	getObject(id).className = styleSelect;
	treeSelected = id;
}

var lay = [];
var layCount = 0;
function getAllLayer(child){
	var j;
	if(child == null){
		return;
	}else{
		for(j=0;j<child.length;j++){
			lay[layCount] = child[j];
			layCount++;
			var gchild = child[j].layers;
			if(gchild != null){
				getAllLayer(gchild);
			}
		}
	}
}

function search(id){
	var i;
	for(i=0;i<lay.length;i++){
		if(lay[i].name == id){
			return lay[i];
		}
	}
	return null;
}

function realheight(o){
	var h=o.document.height
	for(var i=0;i<o.document.layers.length;i++){
		if(o.document.layers[i].visibility!="hide"){
			h+=realheight(o.document.layers[i])
		}
	}
	o.document.height=o.clip.height=h
	o.document.width=o.clip.width=window.innerWidth-o.pageX-4
	return h
}

var _num=[]
function setheight(d,x){
	var i = ( x>1 ? 0:1),h = 0,o
	for(;i<d.layers.length;i++){
		o = d.layers[i]
		setheight(o.document,x+1)
		if(x==1){
			_num[o.id] = i
		}
		if(!o.id.match(/_js_layer_/)){
			o.left += indent
		}
		o.top += h
		if(o.id=="ED"){
			break;
		}
		if(o.visibility!="hide"){
			h += realheight(o)
		}
	}
}



var tagPrefix = "D";
var taglay = [];
var taglayCount = 0;

function getName(obj){
	if(NN){
		return obj.name;
	}
	if(NN6 || IE){
		return obj.id;
	}
}

function click(num)
{
	var i = 0;
	var obj = null;
	var prefix = tagPrefix;
	for(i=0;i<taglayCount;i++){
		obj = taglay[i];
		posi = (getName(obj)).indexOf(prefix);

		if(posi >= 0 && (getName(obj)).substring(posi+1,(getName(obj)).length) == num){
			if(NN){
				obj.visibility = "show";
			}
			if(IE || NN6){
				obj.style.visibility = "visible";
			}
		}else if(posi >= 0){
			if(NN){
				obj.visibility = "hide";
			}
			if(IE || NN6){
				obj.style.visibility = "hidden";
			}
		}
	}
}

function getAllTagMenuLayer(child){
	var j;
	if(child == null){
		return;
	}else{
		for(j=0;j<child.length;j++){
			if(child[j].name.indexOf(tagPrefix) == 0)
			taglay[taglayCount] = child[j];
			taglayCount++;
			var gchild = child[j].layers;
			if(gchild != null && gchild.length > 0){
				getAllLayer(gchild);
			}
		}
	}
}

function tagOnLoad(){

	var divobj = null;
	var i,j;

	if(IE){
		divobj = document.all.tags("DIV");
		for(i=0;i<divobj.length;i++){
			if(divobj[i].id.indexOf(tagPrefix) == 0){
				taglay[taglayCount] = divobj[i];
				taglayCount++;
			}
		}
		
	}else if(NN6){
		divobj = document.getElementsByTagName("DIV");
		for(i=0;i<divobj.length;i++){
			if(divobj[i].id.indexOf(tagPrefix) == 0){
				taglay[taglayCount] = divobj[i];
				taglayCount++;
			}
		}
	}else if(NN){
		divobj = document.layers;
		getAllTagMenuLayer(divobj);
	}
}

var bCancel = false;

var cancelProperty = "org.apache.struts.taglib.html.CANCEL";

var defaultTarget = new Array();

var executed = false;

function funcSubmit(formName, submitName, page) {
	
	endEdit();
	if (funcValidate(formName) == false) {
		return;
	}
	commonSubmit(formName, submitName, true, page);
	
}


function funcCancel(formName, submitName) {
	
	endEdit();
	commonSubmit(formName, submitName, false);
	if (executed == true){
		executed = false;
	}
	
}

function funcCancel_prev(formName, submitName) {
	endEdit();
	var inputs = document.forms[formName].elements;
	inputs['syozokukensaku_no_prev'].disabled='disabled';
	commonSubmit(formName, submitName, false);
	if (executed == true){
		executed = false;
	}
	
}

function funcCancel_next(formName, submitName) {
	endEdit();
	var inputs = document.forms[formName].elements;
	inputs['syozokukensaku_no_next'].disabled='disabled';
	commonSubmit(formName, submitName, false);
	if (executed == true){
		executed = false;
	}
	
}

function executeSubmit(formName, submitName, page) {
	
	commonSubmit(formName, submitName, true, page);
	
}


function executeCancel(formName, submitName) {
	
	commonSubmit(formName, submitName, false);
	
}


function commonSubmit(formObj, submitName, validate, page, targetValue, windowKind) {
	
	if (!formObj.action) {
		formObj = document.forms[formObj];
	}
	if (defaultTarget[formObj.name] == null) {
		defaultTarget[formObj.name] = formObj.target;
	}
	if (!targetValue) {
		targetValue = defaultTarget[formObj.name];
	}
	
//	if (targetValue == "") {
//		if (executed) {
//			return;
//		} else {
//			executed = true;
//			setTimeout("executed = false;", 3000000);
//		}
//	}
	
	formObj.target = targetValue;
	
//	if (formObj['_CANCEL']) {
//		if (validate || validate == null) {
//			formObj['_CANCEL'].name = "_CANCEL";
//		} else {
//			formObj['_CANCEL'].name = cancelProperty;
//		}
//	}
//	if (formObj['page']) {
//		if (page) {
//			formObj['page'].value = page;
//		} else {
//			formObj['page'].value = "";
//		}
//	}
//	if (formObj['_WINDOW_KIND']) {
//		if (windowKind) {
//			formObj['_WINDOW_KIND'].value = windowKind;
//		} else {
//			formObj['_WINDOW_KIND'].value = "";
//		}
//	}
//	if (formObj['_SUBMIT'] == "" || formObj['_SUBMIT'] == null) {
//	} else {
//		formObj['_SUBMIT'].value = submitName;
//	
//		formObj.submit();
//	}
	formObj.submit();
}


function funcValidate(formName) {
	
	endEdit();
	var validateName = "validate" + 
		formName.substring(0, 1).toUpperCase() +
		formName.substring(1, formName.length);
		
	var formObj = document.forms[formName];
	return eval(validateName + "(formObj)");
	
}


function funcReset(formName) {
	endEdit();
	document.forms[formName].reset();
}


function submitSubWindow(formName, submitName, page, option) {
	return submitOtherWindow(formName, submitName, page, option, "sub", true);
}

function cancelSubWindow(formName, submitName, option) {
	return submitOtherWindow(formName, submitName, null, option, "sub", false);
}
function submitPrintWindow(formName, submitName, page, option) {
	return submitOtherWindow(formName, submitName, page, option, "print", true);
}

function cancelPrintWindow(formName, submitName, option) {
	return submitOtherWindow(formName, submitName, null, option, "print", false);
}

function submitOtherWindow(formName, submitName, page, option, windowType, isValidate) {
	
	endEdit();
	var windowObj = top.openWindow(windowType, "", option);
	commonSubmit(formName, submitName, isValidate, page, windowObj.name, windowType);
	return windowObj;
	
}


function funcButtonChange(objId, imageName) {
	if (IE) {
		document.all.item(objId).style.backgroundImage = "url('" + imageName + "')";
	}
}


function funcImageButtonChange(objId, imageName) {
	document.images[objId].src = imageName;
}

function funcEval() {
	var args = funcEval.arguments;
	if (!args || args.length==0) {
		return false;
	}
	if (!confirm(args[0])) {
		return false;
	}
	for (var i=1; i<args.length; i++) {
		eval(args[i]);
	}
}