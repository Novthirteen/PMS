<%@ page isErrorPage="true" %>
<%@ page import="java.io.*" %>
<%@ taglib uri="/WEB-INF/app.tld"    prefix="app" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ page contentType="text/html; charset=gb2312"%>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %><head>
<META content=no-cache http-equiv=Pragma>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/maincss.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/includes/layout_one/css/wasp.css" rel=stylesheet type=text/css>
</head>

<table width="100%" height="377">
  <tr> 
    <td height="176" vAlign="top" width="100%">&nbsp;</td>
  </tr>
  <tr> 
    <td height="287" vAlign="top" width="100%"> 
      <table border="0" cellPadding="0" cellSpacing="0" width="100%">
        <tbody> 
        <tr> 
          <td> 
            <table border="0" cellPadding="4" cellSpacing="0" width="100%">
              <tbody> 
              <tr class="wpsTableAdminHead"> 
                <td align="left" noWrap><span class="tabletext">Errors</span></td>
              </tr>
              </tbody> 
            </table>
            <table border="0" cellPadding="0" cellSpacing="4" width="100%">
              <tbody> 
              <tr height="1"> 
                <td class="wpsAdminHeadSeparator" height="1"><img alt border="0" height="1" src="images/dot.gif"></td>
              </tr>
              </tbody> 
            </table>
            <table border="0" cellPadding="0" cellSpacing="0" width="100%">
              <tbody> 
              <tr> 
                <td vAlign="top" height="89">[<a href="javascript:history.back()">Back</a>]</td>
                <td align="left" vAlign="top" height="89"> 
                  <table width='100%' border='0' cellspacing='0' cellpadding='0' class='boxbottom'>
                    <tr> 
                      <td align="left" valign="center" width='100%'> 
                        <div id="screen"> 
                          <div id="content"> 
                            <div class="error"> <html:errors/> </div>
                            <%  
							    if (exception != null) {
							        exception.printStackTrace(new java.io.PrintWriter(out));
							    } else { 
							      // out.println("请查看服务器错误日志!");
							    } 
							    %>
                          </div>
                        </div>
                      </td>
                    </tr>
                  </table>
                </td>
                <td height="89"> </td>
              </tr>
              </tbody> 
            </table>
            <table border="0" cellPadding="0" cellSpacing="4" width="100%">
              <tbody> 
              <tr height="1"> 
                <td class="wpsAdminHeadSeparator" height="1"><img alt border="0" height="1" src="images/dot.gif"></td>
              </tr>
              </tbody> 
            </table>
          </td>
        </tr>
        </tbody> 
      </table>
    </td>
  </tr>
</table>


