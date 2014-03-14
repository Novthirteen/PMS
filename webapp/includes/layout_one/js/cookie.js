function getCookieDeleteDate()
{
   var exp = new Date();
   var expDate = exp.getTime() - (7 * 24 * 60 * 60 * 1000);
   exp.setTime(expDate);
   return exp.toGMTString();
}
 
function getCookie(name, defval)
{
   if(document.cookie)
   {
      var result = null;
      var myCookie = ' '+document.cookie+';';
      var searchName = ' ' + name + '=';
      var startOfCookie = myCookie.indexOf(searchName);
      var endOfCookie;
      if (startOfCookie != -1)
      {
        startOfCookie += searchName.length;
        endOfCookie = myCookie.indexOf(';', startOfCookie);
        result = unescape(myCookie.substring(startOfCookie, endOfCookie));
      }
      if (result != null)
      {
         return result;
      }
      else
      {
         return defval;
      }
   }
   return 0;
}
 
function setCookie(path, name, val, exp)
{
   if((exp) && (path))
   {
           document.cookie=name + "=" + escape(val) + "; expires=" + exp + "; path=" + path;
   }
   else
   if(exp)
   {
           document.cookie=name + "=" + escape(val) + "; expires=" + exp;
   }
   else
   if(path)
   {
          document.cookie=name + "=" + escape(val) + "; path=" + path;
   }
   else
  {
         document.cookie=name + "=" + escape(val);
  }
}
 
function clearCookieEntry(path, name)
{
   var deleteDate = new Date();
   deleteDate = getCookieDeleteDate();
   setCookie(path, name, '', deleteDate);
}
 
function getCookieDefaultExpire()
{
   var exp = new Date();
   var days;
   if(document.forms[0].CookieExpire)
   {
         days = document.forms[0].CookieExpire.value;
   }
   var expDate = exp.getTime() + (Number(days) * 24 * 60 * 60 * 1000);
   exp.setTime(expDate);
   return exp.toGMTString();
}
 
function getCookieFormFields()
{
   var formfields = new Array();
   if(document.forms[0].CookieFields)
   {
   formfields = document.forms[0].CookieFields.value.split(",");
   }
   return formfields;
}
 
function getCookieFromFields()
{
   if(document.cookie)
   {
      var fields = new Array();
      var count;
      var nofields;
      fields = getCookieFormFields();
      nofields = fields.length;
      for (count=0; count<nofields; count++)
      {
         document.forms[0].elements[fields[count].toString()].value = getCookie(fields[count], "No values found");
      }
      return 0;
   }
}
 
function setCookieFromFields()
{
   var fields = new Array();
   var count;
   var index;
   var nofields;
   fields = getCookieFormFields();
   nofields = fields.length;
   for (count=0; count<nofields; count++)
   {
      setCookie('/', fields[count], document.forms[0].elements[fields[count].toString()].value, getCookieDefaultExpire());
   }
}
 
function clearCookie()
{
   var deleteDate = new Date();
   var formfields = new Array();
   var nofields;
   var count;
   deleteDate = getCookieDeleteDate();
   formfields = document.forms[0].elements[0].value.split(",");
   nofields = formfields.length;
   for(count=0; count<nofields; count++)
   {
      setCookie('/', formfields[count], '', deleteDate);
   }
}