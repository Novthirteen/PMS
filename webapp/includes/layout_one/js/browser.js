function getBrowser() {
  this.navigator=navigator;
 
  this.isIE=(navigator.appName=='Microsoft Internet Explorer');
  this.isNS=(navigator.appName=='Netscape');
  this.isMac=(navigator.appVersion.indexOf("Mac")!=-1);
  this.version=parseInt(navigator.appVersion);
 
  if (this.isIE) {
    this.ie4=(this.navigator.userAgent.indexOf('MSIE 4')>0);
    this.ie5=(this.navigator.userAgent.indexOf('MSIE 5')>0);
 
    if (this.ie5)
      this.version=5;
  }
  
  if (this.isNS) {
    this.ns4=(this.version==4);
    this.ns5=(this.version==5);
  }
}
 
browser = new getBrowser();