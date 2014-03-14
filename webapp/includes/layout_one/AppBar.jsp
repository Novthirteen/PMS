<%@ page language="java" %>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.domain.module.*"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="java.util.*"%>
<script language='JavaScript' src='<%=request.getContextPath()%>/includes/layout_one/js/menu.js'></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/includes/layout_one/js/stm31.js'></script>
<script language="JavaScript">
//改变图片大小
function resizepic(thispic)
{
if(thispic.width>700) thispic.width=700;
}
//无级缩放图片大小
function bbimg(o)
{
  var zoom=parseInt(o.style.zoom, 10)||100;
  zoom+=event.wheelDelta/12;
  if (zoom>0) o.style.zoom=zoom+'%';
  return false;
}
//双击鼠标滚动屏幕的代码
var currentpos,timer;
function initialize()
{
timer=setInterval ("scrollwindow ()",30);
}
function sc()
{
clearInterval(timer);
}
function scrollwindow()
{
currentpos=document.body.scrollTop;
window.scroll(0,++currentpos);
if (currentpos !=document.body.scrollTop)
sc();
}
document.onmousedown=sc
document.ondblclick=initialize

//更改字体大小
var status0='';
var curfontsize=10;
var curlineheight=18;
function fontZoomA(){
  if(curfontsize>8){
    document.getElementById('fontzoom').style.fontSize=(--curfontsize)+'pt';
	document.getElementById('fontzoom').style.lineHeight=(--curlineheight)+'pt';
  }
}
function fontZoomB(){
  if(curfontsize<64){
    document.getElementById('fontzoom').style.fontSize=(++curfontsize)+'pt';
	document.getElementById('fontzoom').style.lineHeight=(++curlineheight)+'pt';
  }
}
</script>
<STYLE type=text/css>
.style20 {
	FONT-SIZE: 14px
}
.style22 {
	FONT-WEIGHT: bold; FONT-SIZE: 14px
}
.style23 {
	FONT-WEIGHT: bold; COLOR: #cc6600
}
.style24 {
	FONT-WEIGHT: bold
}
.style27 {
	FONT-WEIGHT: bold; COLOR: #d0bf9d
}
.style28 {
	FONT-SIZE: 12px
}
</STYLE>
</HEAD>
<BODY>
<TABLE border=0 cellPadding=0 cellSpacing=0 width=100% class="wpsPortletTitle">
<TR>
<td align="left" rowspan=2 width=15%><img border="0" src="<%=request.getContextPath()%>/images/logo.gif"></td>
<td align="right" vAlign="center" colspan=2>
	<%UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	%>
	<marquee DIRECTION="left" BEHAVIOR="SLIDE" SCROLLAMOUNT="2" SCROLLDELAY="50" bgcolor truespeed>
	We Are Pleased To Welcome Our Guest <%=ul.getName()%> from <%=ul.getParty().getDescription()%>. 
	</marquee>
</td>
</tr>
<tr vAlign="bottom">
<TD align="left">
<script language="JavaScript">
stm_bm(['uueoehr',400,'','<%=request.getContextPath()%>/images/blank.gif',0,'','',0,0,0,0,0,1,0,0]);
stm_bp('p0',[0,4,0,0,2,2,0,0,100,'filter:Glow(Color=#000000, Strength=3)',5,'',23,50,0,0,'#000000','transparent','',3,0,0,'#000000']);
stm_ai('p0i0',[0,'|','','',-1,-1,0,'','_self','','','','',0,0,0,'','',0,0,0,0,1,'#F1F2EE',1,'#CCCCCC',1,'','',3,3,0,0,'#FFFFF7','#FF0000','#000000','#000000','9pt Arial','9pt Arial',0,0]);
<%
try{
	List list1 = new ArrayList();
	list1 = (ArrayList)request.getSession().getAttribute(Constants.MODELS_KEY);
	ModuleServices ms = new ModuleServices();
	int i1=1;
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
			String path = m1.getRequestPath();
			if(path == null) path = "";
			if(path.equals("NULL") || path.equals("")) {
				path = "";
			} else if ((!path.endsWith(".jsp") && path.indexOf(".jsp")==-1) && (!path.endsWith(".do") && path.indexOf(".do")==-1)) {
				path = request.getContextPath()+"/"+path + ".do";
			} else {
				path = request.getContextPath()+"/"+path;
			}
			%>
stm_aix('p0i<%=i1%>','p0i0',[0,'<%=m1.getModuleName()%>','','',-1,-1,0,'<%=path%>','_self','<%=path%>','<%=m1.getDescription()%>','','',0,0,0,'','',0,0,0,0,1,'#F1F2EE',1,'#CCCCCC',1,'','',3,3,0,0,'#FFFFF7','#FF0000','#000000','#CC0000','9pt Arial','9pt Arial']);
stm_bp('p<%=i2%>',[1,4,0,0,2,3,6,7,100,'filter:Glow(Color=#000000, Strength=3)',5,'',23,50,2,4,'#999999','#ffffff','',3,1,1,'#ACA899']);
			<%List list2 = (List)map1.get(m1.getModuleId());
			Iterator it2 = list2.iterator();
			while(it2.hasNext()){
				Map map2 = (Map)it2.next();
				Set set2 = map2.keySet();
				Iterator itset2 = set2.iterator();
				while(itset2.hasNext()){
					Module m2 = (Module)itset2.next();
					path = m2.getRequestPath();
					if(path == null) path = "";
					if(path.equals("NULL") || path.equals("")) {
						path = "";
					} else if ((!path.endsWith(".jsp") && path.indexOf(".jsp")==-1) && (!path.endsWith(".do") && path.indexOf(".do")==-1)) {
						path = request.getContextPath()+"/"+path + ".do";
					} else {
						path = request.getContextPath()+"/"+path;
					}%>
					<%List list3 = (List)map2.get(m2);					
					Iterator it3 = list3.iterator();
					if (it3.hasNext()) {%>
stm_aix('p<%=i2%>i0','p0i0',[0,'<%=m2.getModuleName()%>','','',-1,-1,0,'<%=path%>','_self','<%=path%>','<%=m2.getDescription()%>','','',6,0,0,'<%=request.getContextPath()%>/images/arrow_r.gif','<%=request.getContextPath()%>/images/arrow_w.gif',7,7,0,0,1,'#F1F2EE',1,'#CCCCCC',1,'','',3,3,0,0,'#FFFFF7','#FF0000','#000000','#CC0000','9pt Arial','9pt Arial']);
stm_bpx('p<%=(i2+1)%>','p<%=i2%>',[1,2,-2,-3,2,3,0,7,100,'filter:Glow(Color=#000000, Strength=3)',5,'',23,50,2,4,'#999999','#ffffff','',3,1,1,'#ACA899']);
					<%} else {%>
stm_aix('p<%=i2%>i0','p0i0',[0,'<%=m2.getModuleName()%>','','',-1,-1,0,'<%=path%>','_self','<%=path%>','<%=m2.getDescription()%>','','',6,0,0,'','',7,7,0,0,1,'#F1F2EE',1,'#CCCCCC',1,'','',3,3,0,0,'#FFFFF7','#FF0000','#000000','#CC0000','9pt Arial','9pt Arial']);
					<%}
					it3 = list3.iterator();
					int i3=0;
					while(it3.hasNext()){
						Map map3 = (Map)it3.next();
						Set set3 = map3.keySet();
						Iterator itset3 = set3.iterator();
						while(itset3.hasNext()){
							Module m3 = (Module)itset3.next();
							path = m3.getRequestPath();
							if(path == null) path = "";
							if(path.equals("NULL") || path.equals("")) {
								path = "";
							} else if ((!path.endsWith(".jsp") && path.indexOf(".jsp")==-1) && (!path.endsWith(".do") && path.indexOf(".do")==-1)) {
								path = request.getContextPath()+"/"+path + ".do";
							} else {
								path = request.getContextPath()+"/"+path;
							}
							i3++;%>
stm_aix('p<%=(i2+1)%>i<%=i3%>','p<%=i2%>i0',[0,'<%=m3.getModuleName()%>','','',-1,-1,0,'<%=path%>','_self','<%=path%>','<%=m3.getDescription()%>','','',0,0,0,'','',0,0,0,0,1,'#F1F2EE',1,'#CCCCCC',1,'','',3,3,0,0,'#FFFFF7','#FF0000','#000000','#CC0000','9pt Arial','9pt Arial']);
						<%}
					}
					it3 = list3.iterator();
					if (it3.hasNext()) {%>
stm_ep();
					<%
					i2++;
					}
				}
			}
		}
		i1++;%>
stm_ep();
stm_aix('p0i2','p0i0',[0,'|','','',-1,-1,0,'','_self','','','','',0,0,0,'','',0,0,0,0,1,'#F1F2EE',1,'#CCCCCC',1,'','',3,3,0,0,'#FFFFF7','#FF0000','#000000','#CC0000','9pt Arial','9pt Arial']);
	<%}
}catch(Exception e){
	out.println("error"+e.getMessage());
	e.printStackTrace();
}%>
stm_em();
</script>
</td>
<td align="right">
	<TABLE border=0 cellPadding=1 cellSpacing=0 >
	<TR> 
		<TD valign="middle" > 
			<a href="<%=request.getContextPath()%>/checklogon.do">
				<IMG alt="Home" border=0 src="<%=request.getContextPath()%>/images/home.gif" title="Home">
			</a>
		</TD>
		<TD valign="middle" > 
			<a href="<%=request.getContextPath()%>/party/editUserInfo.jsp">
				<IMG align=absMiddle alt="Edit Personal Information" border=0 src="<%=request.getContextPath()%>/images/key.gif" title="Edit Personal Information"> 
			</a>
		</TD>
		<TD valign="middle">
			<a href="<%=request.getContextPath()%>/syshelp.do">
			<IMG align=absMiddle alt="Help" border=0 src="<%=request.getContextPath()%>/images/help.gif" title="Help">
			</a>
		</TD>
		<TD valign="middle" > 
		  <a href="<%=request.getContextPath()%>/logoff.do">
		  	<IMG align=absMiddle alt="Exit" border=0  src="<%=request.getContextPath()%>/images/signout.gif" title="Exit">
		  </a> 
		</TD>
	</tr>
	</table>
</td>
</tr>
<tr>
	<td class="wpsNavbarSeparator" height="1" colspan=3><img alt border="0" height="1" src="<%=request.getContextPath()%>/images/dot.gif" width="1"></td>
</tr>
</table>