<%@ page import="com.aof.component.domain.party.UserLogin"%>
<%@ page import="com.aof.util.Constants"%>
<%@ page contentType="text/html; charset=gb2312"%>
<%
UserLogin ul = (UserLogin)session.getAttribute(Constants.USERLOGIN_KEY);
String partyId = ul.getParty().getPartyId();
%>
<TABLE border=0 cellPadding=0 cellSpacing=0 width=100% class="wpsPortletTitle">
  <TBODY> 
  <TR> 
    <TD rowSpan=2 height="1" width="10%"></TD>
    <TD width="70%"> </TD>
    <td width="20%"> 
      <div align="right"> 
        <TABLE border=0 cellPadding=1 cellSpacing=0 >
   	       <TR> 
            <TD valign="middle" > 
            	<a href="<%=request.getContextPath()%>/checklogon.do">
            	<IMG alt="??" border=0 src="<%=request.getContextPath()%>/images/home.gif" title="??">
            	</a>
            </TD>   
			<%if(partyId!=null && partyId.equals("10000001")){%>
            <TD valign="middle" > 
            	<a href="<%=request.getContextPath()%>/tools/MonitorMain.jsp" target="_blank">
            	<IMG alt="????" border=0 src="<%=request.getContextPath()%>/images/monitor.gif" title="????">
            	</a>
            </TD>   
			<%}%>
            <TD valign="middle" > 
            	<a href="<%=request.getContextPath()%>/party/editUserInfo.jsp">
            	<IMG align=absMiddle alt="??????" border=0 src="<%=request.getContextPath()%>/images/key.gif" title="????"> 
            	</a>
            </TD>
            <TD valign="middle" >
            	<a href="<%=request.getContextPath()%>/help.do">
				<IMG align=absMiddle alt="??" border=0 src="<%=request.getContextPath()%>/images/help.gif" title="??"> 
				</a>
            </TD>
            <TD valign="middle" > 
              <a href="<%=request.getContextPath()%>/logoff.do">
              <IMG align=absMiddle alt="??" border=0  src="<%=request.getContextPath()%>/images/signout.gif" title="??">
              </a> 
            </TD>
          </tr>
        </table>
      </div>
    </td>
  </TR>
  </tbody>
</TABLE>