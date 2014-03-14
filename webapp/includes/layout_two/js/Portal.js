function doMaxMinAll(flag) {
  var expDate = new Date();
  expDate.setTime(expDate.getTime()+(10*365*24*60*60*1000));
  
  var FrameListStr,FrameList;
  var i;
  FrameListStr=document.all["Web_IDList"].value;
  FrameList=FrameListStr.split(";");

  if (flag==false || flag=='false') {
    for (i=0;i<FrameList.length;i++)
    {
      if (FrameList[i]!="") {
        setCookie('',FrameList[i],true,expDate.toGMTString());
        if (browser.isIE) {
          document.all[FrameList[i]].style.display='none';
          frameStatus[FrameList[i]]=true;
          document.images['imgM_'+FrameList[i]].src='IMG/maximize.gif';
          document.images['imgM_'+FrameList[i]].alt='Maximize';
        } else {
          location.reload(true);
        }
      }
    }
  } else {
    for (i=0;i<FrameList.length;i++)
    {
      if (FrameList[i]!="") {
        setCookie('',FrameList[i],false,expDate.toGMTString());
        if (browser.isIE) {
          document.all[FrameList[i]].style.display='inline';
          frameStatus[FrameList[i]]=false;
          document.images['imgM_'+FrameList[i]].src='IMG/minimize.gif';
          document.images['imgM_'+FrameList[i]].alt='Minimize';
        } else {
          location.reload(true);
        }
      }
    }
  }
}

function Fullwin( winid , coluid , newwin)
{
  var IDListStr,IDList;
  var FrameListStr,FrameList;
  var FrameHeightStr,FrameHeight;
  var FrameWidthStr,FrameWidth;
  var i,Loc;
  var expDate = new Date();
  expDate.setTime(expDate.getTime()+(10*365*24*60*60*1000));
  
  var MAXWidth;
  var MAXHeight;
  MAXWidth=this.screen.availWidth-100;
  MAXHeight=this.screen.availHeight-200;
  FrameListStr=document.all["Web_Http_Frame_list"].value;
  FrameList=FrameListStr.split(";");
  FrameHeightStr=document.all["Web_Http_Height_list"].value;
  FrameHeight=FrameHeightStr.split(";");
  FrameWidthStr=document.all["Web_Http_Width_list"].value;
  FrameWidth=FrameWidthStr.split(";");
  Loc=-1;
  for (i=0;i<FrameList.length;i++)
  {
    if (FrameList[i]=="F_ID_"+winid)
    {
      Loc=i;
    };
  };
 if  ((Loc != -1) && (newwin=="Yes"))
  {    window.open(document.all["F_ID_"+winid].src,"NewWin");
  }
  else
  {
    IDListStr=document.all["Web_IDList"].value;
    IDList=IDListStr.split(";");
  };
  if (frameStatus["ID_"+winid]==false || frameStatus["ID_"+winid]=='false')
  {
      frameStatus["ID_"+winid]=true;
      for (i=0;i<IDList.length;i++)
      {
        if ((IDList[i]!=winid)&&(IDList[i]!="")&&(IDList[i]!=coluid))
        {
          document.all["ID_"+IDList[i]].style.display="inline";
        };
      };
      if (Loc!=-1) 
      {
        document.all["F_ID_"+winid].style.height=FrameHeight[Loc];
        document.all["F_ID_"+winid].style.width=FrameWidth[Loc];
      }
      document.all["imgM_Z_"+winid].src="IMG/ZoomOut.gif";
    }
    else
  {
      frameStatus["ID_"+winid]=false;
      for (i=0;i<IDList.length;i++)
      {
        if ((IDList[i]!=winid)&&(IDList[i]!="")&&(IDList[i]!=coluid))
        {
          document.all["ID_"+IDList[i]].style.display="none";
        }
      };
      if (Loc!=-1) 
      {
        document.all["F_ID_"+winid].style.height=MAXHeight;
        document.all["F_ID_"+winid].style.width=MAXWidth;
      }
      document.all["imgM_Z_"+winid].src="IMG/Restore.gif";
  };
}
 
function doRemove(id,title,unId) {
  if (window.confirm('Are you sure, you want to remove '+title+'?'))
    location=webDbPath+'/.AppWAPortalRemoveContent?OpenAgent&Content='+id+'&UnId='+unId+'&RefPage='+location.href;
}
 
function doRemovePage(unId) {
  if (window.confirm('Are you sure, you want to remove this page?'))
    location=webDbPath+'/.AppWAPortalRemovePage?OpenAgent&UnId='+unId;
}
 
function doSetDefaultPage(page) {
  if (window.confirm('Are you sure, you want to make this your default page?'))
    location=webDbPath+'/.AppWAPortalSetDefaultPage?OpenAgent&Page='+page+'&RefPage='+location.href;
}

function doMaxMin(id) {
  var expDate = new Date();
  expDate.setTime(expDate.getTime()+(10*365*24*60*60*1000));
  if (frameStatus[id]==true || frameStatus[id]=='true') {
    setCookie('',id,false,expDate.toGMTString());
    if (browser.isIE) {
      document.all[id].style.display='';
      frameStatus[id]=false;
      document.images['imgM_'+id].src='IMG/minimize.gif';
      document.images['imgM_'+id].alt='Minimize';
    } else {
      location.reload(true);
    }
  } else {
    setCookie('',id,true,expDate.toGMTString());
    if (browser.isIE) {
      document.all[id].style.display='none';
      frameStatus[id]=true;
      document.images['imgM_'+id].src='IMG/maximize.gif';
      document.images['imgM_'+id].alt='Maximize';
    } else {
      location.reload(true);
    }
  }
}

function doMinMax(id) {
  var expDate = new Date();
  expDate.setTime(expDate.getTime()+(10*365*24*60*60*1000));

  if (frameStatus[id]==true || frameStatus[id]=='true') {
    setCookie('',id,false,expDate.toGMTString());
    if (browser.isIE) {
      document.all[id].style.display='';
      frameStatus[id]=false;
      document.images['imgM_'+id].src='IMG/minimize.gif';
      document.images['imgM_'+id].alt='Minimize';
    } else {
      location.reload(true);
    }
  } else {
    setCookie('',id,true,expDate.toGMTString());
    if (browser.isIE) {
      document.all[id].style.display='none';
      frameStatus[id]=true;
      document.images['imgM_'+id].src='IMG/maximize.gif';
      document.images['imgM_'+id].alt='Maximize';
    } else {
      location.reload(true);
    }
  }
}
 
function showPortalTime() {
  if (browser.isIE) {
    var Digital=new Date();
    var days=Digital.getDate();
    var months=Digital.getHours();
    var years=Digital.getYear();
    var hours=Digital.getMonth();
    var minutes=Digital.getMinutes();
    var seconds=Digital.getSeconds();
    if (minutes<=9)
      minutes="0"+minutes;
    if (seconds<=9)
      seconds="0"+seconds;
 
    myclock=years+"-"+months+"-"+days+" "+hours+":"+minutes+":"+seconds;
 
    PortalTime.innerHTML=myclock;
    setTimeout("showPortalTime()",900);
 }
}

function OpenApp(path){
    var WshShell = new ActiveXObject("WScript.Shell");
    WshShell.Run (path);
}

function WriteURLContent(ContentURL,ContentHeight,HttpID) {
    document.all["Web_Http_Frame_list"].value=document.all["Web_Http_Frame_list"].value+";F_ID_"+HttpID;
    document.all["Web_Http_Height_list"].value=document.all["Web_Http_Height_list"].value+";"+ContentHeight;
    document.all["Web_Http_Width_list"].value=document.all["Web_Http_Width_list"].value+";"+"000";
    document.writeln("<IFRAME ID='F_ID_"+HttpID+"' SRC='"+ContentURL+"' WIDTH='100%' Height="+ContentHeight+" FRAMEBORDER=0>");
    document.writeln('<SPAN CLASS="Content"><CENTER>Sorry - your browser does not support this feature.</CENTER></SPAN></IFRAME>');
    document.writeln('<CENTER>Please specify an URL.</CENTER>');
}

function WriteURLImageLink(ContentURL,IMGURL,ContentHeight,ContentWidth,HttpID) {
    document.all["Web_Http_Frame_list"].value=document.all["Web_Http_Frame_list"].value+";F_ID_"+HttpID;
    document.all["Web_Http_Height_list"].value=document.all["Web_Http_Height_list"].value+";"+ContentHeight;
    document.all["Web_Http_Width_list"].value=document.all["Web_Http_Width_list"].value+";"+ContentWidth;
    document.writeln("<A href='"+ContentURL+"'><IMG ID='F_ID_"+HttpID+"' SRC='"+IMGURL+"' WIDTH='"+ContentWidth+"' Height="+ContentHeight+" BORDER=0></A>");
}

function WriteContentHeaderHidden(HttpID,ContentDesc,ColumnID) {
   document.all["Web_IDList"].value=document.all["Web_IDList"].value+';'+HttpID;
   document.writeln("<TABLE ID='ID_"+HttpID+"' WIDTH=100% CELLPADDING=2 CELLSPACING=0 BORDER=0 CLASS='Frame'>");
   document.writeln("<TR CLASS='Frame'><TD WIDTH=75% VALIGN=TOP CLASS='Title'>"+ContentDesc);
   document.writeln("</TD><TD WIDTH=25% ALIGN=RIGHT VALIGN=TOP CLASS='Title'>");
   document.writeln("<A HREF=\"javaScript:doMaxMin('"+HttpID+"');\"><IMG SRC='IMG/minimize.gif' BORDER=0 ALT='Minimize' NAME='imgM_"+HttpID+"'></A>");
   // document.writeln("<A HREF=\"javaScript:Fullwin('"+HttpID+"','ID_"+ColumnID+"',' ');\"><IMG SRC='IMG/ZoomOut.gif' BORDER=0 ALT='Zoom to Full Window' NAME='imgM_Z_"+HttpID+"'></A>");
   document.writeln("</TD></TR><TR><TD COLSPAN=2 VALIGN=TOP><DIV ID='"+HttpID+"'>");
   document.writeln("<TABLE CELLPADDING=2 CELLSPACING=0 BORDER=0 WIDTH=100% CLASS='Win'><TR>");
   document.writeln("<TD>");
}

function WriteContentHeader(HttpID,ContentDesc,ColumnID) {
   document.all["Web_IDList"].value=document.all["Web_IDList"].value+';'+HttpID;
   document.writeln("<TABLE ID='ID_"+HttpID+"' WIDTH=100% CELLPADDING=2 CELLSPACING=0 BORDER=0 CLASS='Frame'>");
   document.writeln("<TR CLASS='Frame'><TD WIDTH=75% VALIGN=TOP CLASS='Title'>"+ContentDesc);
   document.writeln("</TD><TD WIDTH=25% ALIGN=RIGHT VALIGN=TOP CLASS='Title'>");
   document.writeln("<A HREF=\"javaScript:doMinMax('"+HttpID+"');\"><IMG SRC='IMG/minimize.gif' BORDER=0 ALT='Minimize' NAME='imgM_"+HttpID+"'></A>");
   document.writeln("<A HREF=\"javaScript:Fullwin('"+HttpID+"','ID_"+ColumnID+"',' ');\"><IMG SRC='IMG/ZoomOut.gif' BORDER=0 ALT='Zoom to Full Window' NAME='imgM_Z_"+HttpID+"'></A>");
   document.writeln("</TD></TR><TR><TD COLSPAN=2 VALIGN=TOP><DIV ID='"+HttpID+"'>");
   document.writeln("<TABLE CELLPADDING=2 CELLSPACING=0 BORDER=0 WIDTH=100% CLASS='Win'><TR>");
   document.writeln("<TD>");
}

function WriteContentFooter(ColumnID) {
   document.writeln("</TD></TR></TABLE>");
   document.writeln("</DIV></TD></TR></TABLE><TABLE ID='"+ColumnID+"' HEIGHT=5 WIDTH=100%><TR><TD></TD></TR></TABLE>");
}