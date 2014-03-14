<%@ page language="java" %>
<%@ page import="com.aof.component.domain.party.*"%>
<%@ page import="com.aof.component.domain.module.*"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page import="java.util.*"%>
<script language='JavaScript' src='<%=request.getContextPath()%>/includes/layout_one/js/menu.js'></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/includes/layout_one/js/stm31.js'></script>
<script language="JavaScript">
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
<HEAD>
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
<td align="right" vAlign="center" colspan=2 rowspan=2>
	<%UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	%>
	<marquee DIRECTION="left" BEHAVIOR="SLIDE" SCROLLAMOUNT="2" SCROLLDELAY="50" bgcolor truespeed>
	We Are Pleased To Welcome Our Guest <%=ul.getName()%> from <%=ul.getParty().getDescription()%>. 
	</marquee>
</td>
</tr>
</table>