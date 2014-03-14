function convertChar(str,fromChar,toChar) {
  var s='';
 
  for (var k=0; k<str.length; k++) {
    if (str.charAt(k) == fromChar)
      s += toChar
    else
      s += str.charAt(k);
  }
 
  return s;
}
 
function fmtPrice(value) {
  var result=Math.floor(value)+".";
  var decs=100*(value-Math.floor(value))+0.5;
 
  if (Math.floor(decs/10)==10)
  {
    result = Math.floor(value+1)+".00";
  } else
  {
    result += Math.floor(decs/10);
    result += Math.floor(decs%10);
  }
  
  return result;
}
 
function replaceSystemPaths(orgString) {
  orgString=replaceSubString(orgString,'^DBPATH^',webDbPath);
  orgString=replaceSubString(orgString,'^WEBPATH^',webPath); 
  orgString=replaceSubString(orgString,'^WEBGRAPHICSPATH^',webGraphicsPath); 
 
  return orgString;
}
 
function replaceMenuSystemPaths(orgString,srcDbPath) {
  if (srcDbPath!=webDbPath) {
    if (webGraphicsPath!=webDbPath+'/web/')
      orgString=replaceSubString(orgString,'^WEBGRAPHICSPATH^',webGraphicsPath)
    else
      orgString=replaceSubString(orgString,'^WEBGRAPHICSPATH^',srcDbPath+'/web/');
 
    orgString=replaceSubString(orgString,'^DBPATH^',srcDbPath);
    orgString=replaceSubString(orgString,'^WEBPATH^',webPath);
 
    return orgString;
  } 
  else {
    return replaceSystemPaths(orgString);
  }
}
 
function formatParamString() {
  var loc = document.URL;
  var refPage = '';
  var params = new Array();
 
  if (loc.indexOf('&RefPage=')!=-1) 
    {
      refPage = loc.substring(loc.indexOf('&RefPage='),loc.length);
      refPage = refPage.substring(refPage.indexOf('=') +1,refPage.length)
      loc = loc.substring(0,loc.indexOf('&RefPage='));
    }
 
  params['RefPage'] = refPage;
  var idx = loc.indexOf('&');
  if (idx != -1) 
    {
      var pairs = loc.substring(idx+1, loc.length).split('&');
      for (var i=0; i<pairs.length; i++) 
        {
          nameVal = pairs[i].split('=');
          params[nameVal[0]] = nameVal[1];
        }
    }
  return params;
}
 
function getParam(argument, params)
{
 var tmp = unescape(params[argument]);
 return (tmp=='undefined')?'':tmp;
}