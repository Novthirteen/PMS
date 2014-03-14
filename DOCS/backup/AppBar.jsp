<%@ page language="java" %>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.domain.module.*"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="java.util.*"%>
   
<script language="JavaScript">
var mmenus    = new Array();
var misShow   = new Boolean(); 
misShow=false;
var misdown   = new Boolean();
misdown=false;
var mnumberofsub=0;
var musestatus=false;
var mpopTimer = 0;
mmenucolor='#C4C0CB';mfontcolor='#000000';mmenuoutcolor='#ebebeb';mmenuincolor='#ebebeb';mmenuoutbordercolor='#C4C0CB';
mmenuinbordercolor='#000000';mmidoutcolor='#999999';mmidincolor='#999999';mmenuovercolor='#999999';mitemedge='1';msubedge='1';
mmenuunitwidth=80;mmenuitemwidth=120;mmenuheight=5;mmenuwidth='100%';mmenuadjust=0;mmenuadjustV=0;
mfonts='font-family:Arial; font-size:9pt; color:#000000; ';mcursor='hand';
mmenu2color='#C4C0CB';mfont2color='#ebebeb';mmenuin2color="#ebebeb";

var swipeSteps = 3;
var swipemsec = 10;
var swipeArray = new Array();

var test = false;

function hideComboBox(menu){
	if (menu) {
		if (menu.intersectCombos == null) {
			menu.intersectCombos = new Array();
			caculatePosition(menu);
			var Combos = document.getElementsByTagName('SELECT');
			for (i = 0; i < Combos.length; i++) {
				if (Combos[i].style.visibility != 'hidden') {
					caculatePosition(Combos[i]);
					if (isIntersect(menu, Combos[i])) menu.intersectCombos[menu.intersectCombos.length] = Combos[i];
				}
			}
		}
		for (i = 0; i < menu.intersectCombos.length; i++) {
			menu.intersectCombos[i].style.visibility = 'hidden';
		}
	}
}
function showComboBox(menu){
	if (menu) {
		if (menu.intersectCombos) {
			for (i = 0; i < menu.intersectCombos.length; i++) {
				menu.intersectCombos[i].style.visibility = 'visible';
			}
		}
	}
}
function caculatePosition(obj) {
	if (obj) {
		if (obj.offsetTopToRoot == null) obj.offsetTopToRoot = getOffsetTopToRoot(obj)
		if (obj.offsetLeftToRoot == null) obj.offsetLeftToRoot = getOffsetLeftToRoot(obj)
	}
}
function getOffsetTopToRoot(obj) {
	if (obj) {
		return obj.offsetTop + getOffsetTopToRoot(obj.offsetParent);
	} else {
		return 0;
	}
}
function isIntersect(objA, objB) {
	var AX1 = objA.offsetLeftToRoot;
	var AX2 = AX1 + objA.offsetWidth;
	var AY1 = objA.offsetTopToRoot;
	var AY2 = AY1 + objA.offsetHeight;
	var BX1 = objB.offsetLeftToRoot;
	var BX2 = BX1 + objB.offsetWidth;
	var BY1 = objB.offsetTopToRoot;
	var BY2 = BY1 + objB.offsetHeight;
	//A at left side of B
	if (AX2 <= BX1) return false;
	//A at right side of B
	if (AX1 >= BX2) return false;
	//A at top side of B
	if (AY2 <= BY1) return false;
	//A at bottom side of B
	if (AY1 >= BY2) return false;
	//A intersect with B
	return true;
}
function getOffsetLeftToRoot(obj) {
	if (obj) {
		return obj.offsetLeft + getOffsetLeftToRoot(obj.offsetParent);
	} else {
		return 0;
	}
}
function swipe(el, dir, steps, msec) {
	if (steps == null) steps = swipeSteps;
	if (msec == null) msec = swipemsec;
	if (el.swipeIndex == null)
		el.swipeIndex = swipeArray.length;
	if (el.swipeTimer != null)
		window.clearTimeout(el.swipeTimer);
	swipeArray[el.swipeIndex] = el;
	el.style.clip = "rect(-99999, 99999, 99999, -99999)";
	if (el.swipeCounter == null || el.swipeCounter == 0) {
		el.orgLeft  = el.offsetLeft;
		el.orgTop  = el.offsetTop;
		el.orgWidth = el.offsetWidth;
		el.orgHeight  = el.offsetHeight;
	}
	el.swipeCounter = steps;
	el.style.clip = "rect(0,0,0,0)";
	window.setTimeout("repeat(" + dir + "," + el.swipeIndex + "," + steps + "," + msec + ")", msec);
}
function repeat(dir, index, steps, msec) {
	el = swipeArray[index];
	var left   = el.orgLeft;
	var top    = el.orgTop;
	var width  = el.orgWidth;
	var height = el.orgHeight;
	if (el.swipeCounter == 0) {
		el.style.clip = "rect(-99999, 99999, 99999, -99999)";
		return;
	}
	else {
		el.swipeCounter--;
		el.style.visibility = "visible";
		switch (dir) {
			case 2:
				el.style.clip = "rect(" + height*el.swipeCounter/steps + "," + width + "," + height + "," + 0 + ")";
				el.style.top  = top - height*el.swipeCounter/steps;
				break;
			case 8:
				el.style.clip = "rect(" + 0 + "," + width + "," + height*(steps-el.swipeCounter)/steps + "," + 0 + ")";
				el.style.top  = top + height*el.swipeCounter/steps;
				break;
			case 6:
				el.style.clip = "rect(" + 0 + "," + width + "," + height + "," + width*(el.swipeCounter)/steps + ")";
				el.style.left  = left - width*el.swipeCounter/steps;
				break;
			case 4:
				el.style.clip = "rect(" + 0 + "," + width*(swipeSteps - el.swipeCounter)/steps + "," + height + "," + 0 + ")";
				el.style.left  = left + width*el.swipeCounter/steps;
				break;
		}
		
		el.swipeTimer = window.setTimeout("repeat(" + dir + "," + index + "," + steps + "," + msec + ")", msec);
	}
}
var mtmpleft="";
var mtmptop="";
function hideSwipe(el) {
	window.clearTimeout(el.swipeTimer);
	el.style.visibility = "hidden";
	el.style.clip = "rect(-99999, 99999, 99999, -99999)";
	el.swipeCounter = 0;
	if(mtmpleft!="")el.style.left = mtmpleft;
	if(mtmptop!="")el.style.top = mtmptop;
}
function stoperror(){ return true;}
window.onerror=stoperror;
function mpopOut() {mpopTimer = setTimeout('mallhide()', 500);}
function getReal(el, type, value) {
	temp = el;
	while ((temp != null) && (temp.tagName != "BODY")) {
		if (eval("temp." + type) == value) {
			el = temp;
			return el;
		}
		temp = temp.parentElement;
	}
	return el;
}
function mMenuRegister(menu) 
{
	mmenus[mmenus.length] = menu
	return (mmenus.length - 1)
}

function mMenuItem(caption,command,target,isline,statustxt,level,img,sizex,sizey,pos){
	this.items = new Array();
	this.caption=caption;
	this.command=command;
	this.target=target;
	this.isline=isline;
	this.statustxt=statustxt;
	if(level!=null){mnumberofsub++;
	this.hasc=mnumberofsub;}
	this.level=level;
	this.img=img;
	this.sizex=sizex;
	this.sizey=sizey;
	this.pos=pos;
}
function mMenu(caption,command,target,img,sizex,sizey,pos){
	this.items = new Array();
	this.caption=caption;
	this.command=command;
	this.target=target;
	this.img=img;
	this.sizex=sizex;
	this.sizey=sizey;
	this.pos=pos;
	this.id=mMenuRegister(this);
}
function mMenuAddItem(item)
{
  this.items[this.items.length] = item
  item.parent = this.id;
  this.children=true;
}

mMenu.prototype.addItem = mMenuAddItem;
mMenuItem.prototype.addsubItem = mMenuAddItem;

function mtoout(src){
	src.style.borderLeftColor=mmenuoutbordercolor;
	src.style.borderRightColor=mmenuinbordercolor;
	src.style.borderTopColor=mmenuoutbordercolor;
	src.style.borderBottomColor=mmenuinbordercolor;
	src.style.backgroundColor=mmenuoutcolor;
	src.style.color=mmenuovercolor;
}
function mtoin(src){
	src.style.borderLeftColor=mmenuinbordercolor;
	src.style.borderRightColor=mmenuoutbordercolor;
	src.style.borderTopColor=mmenuinbordercolor;
	src.style.borderBottomColor=mmenuoutbordercolor;
	src.style.backgroundColor=mmenuin2color;
	src.style.color=mmenuovercolor;
}
function mnochange(src){
	src.style.borderLeftColor=mmenucolor;
	src.style.borderRightColor=mmenucolor;
	src.style.borderTopColor=mmenucolor;
	src.style.borderBottomColor=mmenucolor;
	src.style.backgroundColor='';
	src.style.color=mfontcolor;
}
function mallhide(){
	for(var nummenu=0;nummenu<mmenus.length;nummenu++){
		var themenu=document.all['mMenu'+nummenu]
		var themenudiv=document.all['mmenudiv'+nummenu]
		mnochange(themenu);
		mmenuhide(themenudiv);
	}
	for(nummenu=1;nummenu<=mnumberofsub;nummenu++){  
		var thesub=document.all['msubmenudiv'+nummenu]      
		msubmenuhide(thesub);
		mnochange(document.all['mp'+nummenu]);
		document.all["mitem"+nummenu].style.color=mfontcolor;
	}
}
function mmenuhide(menuid){
	if (menuid.style.visibility == 'hidden') return;
	menuid.style.filter='Alpha(Opacity=100)';
	hideSwipe(menuid);
	showComboBox(menuid);
	misShow=false;
}
function msubmenuhide(menuid){
	if (menuid.style.visibility == 'hidden') return;
	menuid.style.filter='Alpha(Opacity=100)';
	menuid.style.visibility='hidden';
	showComboBox(menuid);
}
function mmenushow(menuid,pid){
	if (menuid.style.visibility != 'hidden') return;
	menuid.style.filter='Alpha(Opacity=100)';
	menuid.style.left=mposflag.offsetLeft+pid.offsetLeft+mmenuadjust;menuid.style.top=mposflag.offsetTop+mmenutable.offsetHeight+mmenuadjustV;
	if(mmenuitemwidth+parseInt(menuid.style.left)>document.body.clientWidth+document.body.scrollLeft)
	menuid.style.left=document.body.clientWidth+document.body.scrollLeft-mmenuitemwidth;
	hideComboBox(menuid);
	mtmpleft=menuid.style.left;mtmptop=menuid.style.top;swipe(menuid,2,4);
	misShow=true;
}
function mshowsubmenu(menuid,pid,rid){
	if (menuid.style.visibility != 'hidden') return;
	menuid.style.filter='Alpha(Opacity=100)';
	menuid.style.left=pid.offsetWidth+rid.offsetLeft;
	menuid.style.top=pid.offsetTop+rid.offsetTop-3;
	if(mmenuitemwidth+parseInt(menuid.style.left)>document.body.clientWidth+document.body.scrollLeft)
	menuid.style.left=document.body.clientWidth+document.body.scrollLeft-mmenuitemwidth;
	hideComboBox(menuid);
	menuid.style.visibility='visible';
}
function mmenu_over(menuid,x){
	toel = getReal(window.event.toElement, "className", "coolButton");
	fromel = getReal(window.event.fromElement, "className", "coolButton");
	if (toel == fromel) return;
	if(x<0){
		misShow = false;
		mallhide();
		mtoout(eval("mMenu"+x));
	}else{
		mallhide();
		mtoin(eval("mMenu"+x));
		mmenushow(menuid,eval("mMenu"+x));
	}
	clearTimeout(mpopTimer);
}
function mmenu_out(x){
	toel = getReal(window.event.toElement, "className", "coolButton");
	fromel = getReal(window.event.fromElement, "className", "coolButton");
	if (toel == fromel) return;
	if (misShow){
		mtoin(eval("mMenu"+x));
	}else{
		mnochange(eval("mMenu"+x));
	}
	mpopOut()
}
function mmenu_down(menuid,x){
	if(misShow){
		mmenuhide(menuid);
		mtoout(eval("mMenu"+x));
	}
	else{
		mtoin(eval("mMenu"+x));
		mmenushow(menuid,eval("mMenu"+x));
		misdown=true;
	}
}
function mmenu_up(){misdown=false;}
function mmenuitem_over(menuid,item,x,j,i){
	toel = getReal(window.event.toElement, "className", "coolButton");
	fromel = getReal(window.event.fromElement, "className", "coolButton");
	if (toel == fromel) return;
	srcel = getReal(window.event.srcElement, "className", "coolButton");
	for(nummenu=1;nummenu<=mnumberofsub;nummenu++){  
		var thesub=document.all['msubmenudiv'+nummenu] 
		if(!(menuid==thesub||menuid.style.tag>=thesub.style.tag)){
			msubmenuhide(thesub);
			mnochange(document.all['mp'+nummenu]);
			document.all["mitem"+nummenu].style.color=mfontcolor;
		}
	}
	if(item)document.all["mitem"+item].style.color=mmenuovercolor;
	if(misdown||item){
		mtoin(srcel);
	}
	else{
		mtoout(srcel);
	}
	if(x==-1)mthestatus=eval("msub"+j).items[i].statustxt;
	if(j==-1)mthestatus=mmenus[x].items[i].statustxt;
	if(mthestatus!=""){
		musestatus=true;
		window.status=mthestatus;
	}
	clearTimeout(mpopTimer);
}
function mmenuitem_out(hassub){
	toel = getReal(window.event.toElement, "className", "coolButton");
	fromel = getReal(window.event.fromElement, "className", "coolButton");
	if (toel == fromel) return;
	srcel = getReal(window.event.srcElement, "className", "coolButton");
	if(!hassub)mnochange(srcel);
	if(musestatus)window.status="";
	mpopOut()
}
function mmenuitem_down(){
	srcel = getReal(window.event.srcElement, "className", "coolButton");
	mtoin(srcel)
	misdown=true;
}
function mmenuitem_up(){
	srcel = getReal(window.event.srcElement, "className", "coolButton");
	mtoout(srcel)
	misdown=false;
}
function mexec3(j,i){
	var cmd;
	if(eval("msub"+j).items[i].target=="blank"){
		cmd = "window.open('"+eval("msub"+j).items[i].command+"')";
	}else{
		cmd = eval("msub"+j).items[i].target+".location=\""+eval("msub"+j).items[i].command+"\"";
	}
	eval(cmd);
}
function mexec2(x){
	var cmd;
	if(mmenus[x].target=="blank"){
		cmd = "window.open('"+mmenus[x].command+"')";
	}else{
		cmd = mmenus[x].target+".location=\""+mmenus[x].command+"\"";
	}
	eval(cmd);
}
function mexec(x,i){
	var cmd;
	if(mmenus[x].items[i].target=="blank"){
		cmd = "window.open('"+mmenus[x].items[i].command+"')";
	}else{
		cmd = mmenus[x].items[i].target+".location=\""+mmenus[x].items[i].command+"\"";
	}
	eval(cmd);
}
function mbody_click(){
	if (misShow){
		srcel = getReal(window.event.srcElement, "className", "coolButton");
		for(var x=0;x<=mmenus.length;x++){
			if(srcel.id=="mMenu"+x) return;
		}
		for(x=1;x<=mnumberofsub;x++){
			if(srcel.id=="mp"+x) return;
		}
		mallhide();
	}
}
document.onclick=mbody_click;

function mwritetodocument(){
	var mwb=1;
	var stringx='<div id="mposflag" style="position:absolute;"></div><table  id=mmenutable border=0 cellpadding=3 cellspacing=2 width='+mmenuwidth+' height='+mmenuheight+' bgcolor='+mmenucolor+' onselectstart="event.returnValue=false"'+' style="filter:Alpha(Opacity=100);cursor:'+mcursor+';'+mfonts+' border-left: '+mwb+'px solid '+mmenuoutbordercolor+';'+' border-right: '+mwb+'px solid '+mmenuinbordercolor+'; '+'border-top: '+mwb+'px solid '+mmenuoutbordercolor+'; '+'border-bottom: '+mwb+'px solid '+mmenuinbordercolor+'; padding:0px"><tr>';
	for(var x=0;x<mmenus.length;x++){
		var thismenu=mmenus[x];
		var imgsize="";
		if(thismenu.sizex!="0"||thismenu.sizey!="0")imgsize=" width="+thismenu.sizex+" height="+thismenu.sizey;
		var ifspace="";
		if(thismenu.caption!="")ifspace=" ";
		stringx += "<td nowrap class=coolButton id=mMenu"+x+" style='border: "+mitemedge+"px solid "+mmenucolor+
		"' width="+mmenuunitwidth+"px onmouseover=mmenu_over(mmenudiv"+x+
		","+x+") onmouseout=mmenu_out("+x+
		") onmousedown=mmenu_down(mmenudiv"+x+","+x+")";
		if(thismenu.command!=""){
			stringx += " onmouseup=mmenu_up();mexec2("+x+");";
		}else{
			stringx += " onmouseup=mmenu_up()";
		}
		if(thismenu.pos=="0"){
			stringx += " align=center><img align=absmiddle src='"+thismenu.img+"'"+imgsize+">"+ifspace+thismenu.caption+"</td>";	
		}else if(thismenu.pos=="1"){
			stringx += " align=center>"+thismenu.caption+ifspace+"<img align=absmiddle src='"+thismenu.img+"'"+imgsize+"></td>";	
		}else if(thismenu.pos=="2"){
			stringx += " align=center background='"+thismenu.img+"'> "+thismenu.caption+" </td>";	
		}else{
			stringx += " align=center> "+thismenu.caption+" </td>";
		}
		stringx += "";
	}
	stringx+="<td width=*> </td></tr></table>";
	for(var x=0;x<mmenus.length;x++){
		thismenu=mmenus[x];
		if(x<0){
			stringx+='<div id=mmenudiv'+x+' style="visiable:none"></div>';
		}else{
			stringx+='<div id=mmenudiv'+x+' style="filter:Alpha(Opacity=100);cursor:'+mcursor+';position:absolute;'+'width:'+mmenuitemwidth+'px; z-index:'+(x+100);
			if(mmenuinbordercolor!=mmenuoutbordercolor&&msubedge=="0"){
				stringx+=';border-left: 1px solid '+mmidoutcolor+';border-top: 1px solid '+mmidoutcolor;}
				stringx+=';border-right: 1px solid '+mmenuinbordercolor+';border-bottom: 1px solid '+mmenuinbordercolor+';visibility:hidden" onselectstart="event.returnValue=false">\n'+'<table  width="100%" border="0" height="100%" align="center" cellpadding="0" cellspacing="2" '+'style="'+mfonts+' border-left: 1px solid '+mmenuoutbordercolor;
				if(mmenuinbordercolor!=mmenuoutbordercolor&&msubedge=="0"){
					stringx+=';border-right: 1px solid '+mmidincolor+';border-bottom: 1px solid '+mmidincolor;}
					stringx+=';border-top: 1px solid '+mmenuoutbordercolor+';padding: 4px" bgcolor='+mmenucolor+'>\n'
					for(var i=0;i<thismenu.items.length;i++){
						var thismenuitem=thismenu.items[i];
						var imgsize="";
						if(thismenuitem.sizex!="0"||thismenuitem.sizey!="0")imgsize=" width="+thismenuitem.sizex+" height="+thismenuitem.sizey;
						var ifspace="";
						if(thismenu.caption!="") ifspace=" ";
						if(thismenuitem.hasc!=null){
							stringx += "<tr><td id=mp"+thismenuitem.hasc+" class=coolButton style='border: "+mitemedge+"px solid "+mmenucolor+"' width=100% onmouseout=mmenuitem_out(true) onmouseover=\"mmenuitem_over(mmenudiv"+x+",'"+thismenuitem.hasc+"',"+x+",-1,"+i+");mshowsubmenu(msubmenudiv"+thismenuitem.hasc+",mp"+thismenuitem.hasc+",mmenudiv"+x+");\""+"><table id=mitem"+thismenuitem.hasc+" cellspacing='0' cellpadding='0' border='0' width='100%' style='"+mfonts+"'><tr><td ";
							if(thismenuitem.pos=="0"){
								stringx += "><img align=absmiddle src='"+thismenuitem.img+"'"+imgsize+">"+ifspace+thismenuitem.caption+"</td><td";	
							}else if(thismenuitem.pos=="1"){
								stringx += ">"+thismenuitem.caption+ifspace+"<img align=absmiddle src='"+thismenuitem.img+"'"+imgsize+"></td><td";
							}else if(thismenuitem.pos=="2"){
								stringx += "background='"+thismenuitem.img+"'>"+thismenuitem.caption+"</td><td background='"+thismenuitem.img+"'";	
							}else{
								stringx += ">"+thismenuitem.caption+"</td><td";
							}
							stringx += " align=right width='1'><font face='Webdings' style='font-size: 6pt'>4</font></td></tr></table></td></tr>\n";
						}else if(!thismenuitem.isline){
							stringx += "<tr><td class=coolButton style='border: "+mitemedge+"px solid "+mmenucolor+"' width=100% height=15px onmouseover=\"mmenuitem_over(mmenudiv"+x+",false,"+x+",-1,"+i+");\" onmouseout=mmenuitem_out() onmousedown=mmenuitem_down() onmouseup=";
							stringx += "mmenuitem_up();mexec("+x+","+i+"); ";
							if(thismenuitem.pos=="0"){
								stringx += "><img align=absmiddle src='"+thismenuitem.img+"'"+imgsize+">"+ifspace+thismenuitem.caption+"</td></tr>";	
							}else if(thismenuitem.pos=="1"){
								stringx += ">"+thismenuitem.caption+ifspace+"<img align=absmiddle src='"+thismenuitem.img+"'"+imgsize+"></td></tr>";	
							}else if(thismenuitem.pos=="2"){
								stringx += "background='"+thismenuitem.img+"'>"+thismenuitem.caption+"</td></tr>";	
							}else{
								stringx += ">"+thismenuitem.caption+"</td></tr>";
							}
						}else{
							stringx+='<tr><td height="1" background="/images/hr.gif" onmousemove="clearTimeout(mpopTimer);"><img height="1" width="1" src="none.gif" border="0"></td></tr>\n';
						}
					}
					stringx+='</table>\n</div>'
				}
			}
			for(var j=1;j<=mnumberofsub;j++){     
				thisitem=eval("msub"+j);
				stringx+='<div id=msubmenudiv'+j+' style="filter:Alpha(Opacity=100);tag:'+thisitem.level+';cursor:'+mcursor+';position:absolute;'+'width:'+mmenuitemwidth+'px; z-index:'+(j+200);
				if(mmenuinbordercolor!=mmenuoutbordercolor&&msubedge=="0"){
					stringx+=';border-left: 1px solid '+mmidoutcolor+';border-top: 1px solid '+mmidoutcolor;}
					stringx+=';border-right: 1px solid '+mmenuinbordercolor+';border-bottom: 1px solid '+mmenuinbordercolor+';visibility:hidden" onselectstart="event.returnValue=false">\n'+'<table  width="100%" border="0" height="100%" align="center" cellpadding="0" cellspacing="2" '+'style="'+mfonts+' border-left: 1px solid '+mmenuoutbordercolor;
					if(mmenuinbordercolor!=mmenuoutbordercolor&&msubedge=="0"){
						stringx+=';border-right: 1px solid '+mmidincolor+';border-bottom: 1px solid '+mmidincolor;}
						stringx+=';border-top: 1px solid '+mmenuoutbordercolor+';padding: 4px" bgcolor='+mmenucolor+'>\n'
						for(var i=0;i<thisitem.items.length;i++){
							var thismenuitem=thisitem.items[i];
							var imgsize="";
							if(thismenuitem.sizex!="0"||thismenuitem.sizey!="0")imgsize=" width="+thismenuitem.sizex+" height="+thismenuitem.sizey;
							var ifspace="";
							if(thismenu.caption!="")ifspace=" ";
							if(thismenuitem.hasc!=null){
							stringx += "<tr><td id=mp"+thismenuitem.hasc+" class=coolButton style='border: "+mitemedge+"px solid "+mmenucolor+"' width=100% onmouseout=mmenuitem_out(true) onmouseover=\"mmenuitem_over(msubmenudiv"+j+",'"+thismenuitem.hasc+"',-1,"+j+","+i+");mshowsubmenu(msubmenudiv"+thismenuitem.hasc+",mp"+thismenuitem.hasc+",msubmenudiv"+j+");\""+"><table id=mitem"+thismenuitem.hasc+" cellspacing='0' cellpadding='0' border='0' width='100%' style='"+mfonts+"'><tr><td ";
							if(thismenuitem.pos=="0"){
								stringx += "><img align=absmiddle src='"+thismenuitem.img+"'"+imgsize+">"+ifspace+thismenuitem.caption+"</td><td";	
							}else if(thismenuitem.pos=="1"){
								stringx += ">"+thismenuitem.caption+ifspace+"<img align=absmiddle src='"+thismenuitem.img+"'"+imgsize+"></td><td";
							}else if(thismenuitem.pos=="2"){
								stringx += "background='"+thismenuitem.img+"'>"+thismenuitem.caption+"</td><td background='"+thismenuitem.img+"'";	
							}else{
								stringx += ">"+thismenuitem.caption+"</td><td";
							}
								stringx += " align=right width='1'><font face='Webdings' style='font-size: 6pt'>4</font></td></tr></table></td></tr>\n";
                     		}else if(!thismenuitem.isline){
                     			stringx += "<tr><td  style='border: "+mitemedge+"px solid "+mmenucolor+"' width=100% height=15px onmouseover=\"mmenuitem_over(msubmenudiv"+j+",false,-1,"+j+","+i+");\" onmouseout=mmenuitem_out() onmousedown=mmenuitem_down() onmouseup=";
                     			stringx += "mmenuitem_up();mexec3("+j+","+i+"); ";
								if(thismenuitem.pos=="0"){
									stringx += "><img align=absmiddle src='"+thismenuitem.img+"'"+imgsize+">"+ifspace+thismenuitem.caption+"</td></tr>";	
								}else if(thismenuitem.pos=="1"){
									stringx += ">"+thismenuitem.caption+ifspace+"<img align=absmiddle src='"+thismenuitem.img+"'"+imgsize+"></td></tr>";	
								}else if(thismenuitem.pos=="2"){
									stringx += "background='"+thismenuitem.img+"'>"+thismenuitem.caption+"</td></tr>";	
								}else{
									stringx += ">"+thismenuitem.caption+"</td></tr>";
								}
							}else{
								stringx+='<tr><td height="1" background="/images/hr.gif" onmousemove="clearTimeout(mpopTimer);"><img height="1" width="1" src="none.gif" border="0"></td></tr>\n';
							}
						}
						stringx+='</table>\n</div>'
					}
					document.write("<div align='center' id='JsMenuCSS'>"+stringx+"</div>");
				}
<%
try{
	UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	List list1 = new ArrayList();
	list1 = (ArrayList)request.getSession().getAttribute(Constants.MODELS_KEY);
	ModuleServices ms = new ModuleServices();
	int i1=2;
	int i2=1;
	Iterator it1 = list1.iterator();
	while(it1.hasNext()){
		Map  map1 = (TreeMap) it1.next();
		Set set1 = map1.keySet();
		Iterator itset1 = set1.iterator();
		String moduleId = null;
		while(itset1.hasNext()){
			moduleId = itset1.next().toString();
			Module m1 = ms.getModuleByModuleId(moduleId);
			if( m1.getRequestPath()!=null && m1.getRequestPath().equals("NULL") ){%>
				mpmenu<%=i1%>=new mMenu('<%out.print(m1.getModuleName());%>','','self','','','','');	
			<%}else{%>
				mpmenu<%=i1%>=new mMenu('<%out.print(m1.getModuleName());%>','<%=m1.getRequestPath()+".do"%>','self','','','','');	
			<%}
			List list2 = (List)map1.get(m1.getModuleId());
			Iterator it2 = list2.iterator();
			while(it2.hasNext()){
				Map map2 = (Map)it2.next();
				Set set2 = map2.keySet();
				Iterator itset2 = set2.iterator();
				while(itset2.hasNext()){
					Module m2 = (Module)itset2.next();
					if( m2.getRequestPath()!=null && m2.getRequestPath().equals("NULL") ){%>
						msub<%=i2%>=new mMenuItem('<%=m2.getModuleName()%>','','self',false,'','','','','','');
					<%}else{
						String path=m2.getRequestPath();
						if ((!path.endsWith(".jsp") && path.indexOf(".jsp")==-1) && (!path.endsWith(".do") && path.indexOf(".do")==-1)) {
							path = path + ".do";
						}
					%>
						msub<%=i2%>=new mMenuItem('<%=m2.getModuleName()%>','<%=request.getContextPath()%>/<%=path%>','self',false,null,'','','','','');
					<%}%>
					<%
						List list3 = (List)map2.get(m2);					
						Iterator it3 = list3.iterator();
						while(it3.hasNext()){
							Map map3 = (Map)it3.next();
							Set set3 = map3.keySet();
							Iterator itset3 = set3.iterator();
							while(itset3.hasNext()){
								Module m3 = (Module)itset3.next();
								String path3 = m3.getRequestPath();
								if ((!path3.endsWith(".jsp") && path3.indexOf(".jsp")==-1) && (!path3.endsWith(".do") && path3.indexOf(".do")==-1)) {
									path3 = path3 + ".do";
								}%>
								msub<%=i2%>.addsubItem(new mMenuItem('<%=m3.getModuleName()%>','<%=request.getContextPath()%>/<%=path3%>','self',false,'',null,'','','',''));
							<%
						}
					}%>
					mpmenu<%=i1%>.addItem(msub<%=i2%>);	
					<%i2++;
				}
			}
		}
	}
}catch(Exception e){
	out.println("error"+e.getMessage());
	e.printStackTrace();
}%>
mwritetodocument();
</script>

