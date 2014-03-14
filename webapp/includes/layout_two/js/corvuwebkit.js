// **************************************************************************
// File: CorVuWebKit.js
// Description:
//   This is the JavaScript companion file for the CorVu Web Kit, Ver 4.00.45
// **************************************************************************
// * Copyright (c) 1999, CorVu Corporation, Inc., Edina, MN 55435, USA
// * Copyright (c) 1999, CorVu PTY, Ltd., North Sydney, NSW 2060, Australia
// * Copyright (c) 1999, CorVu PLC, London, W1H3PJ, United Kingdom
// *
// * All Rights Reserved
// **********************

    // Do NOT edit above this line.

// **************************************************************************
// Per Site Settings:
// These can be edited here, or in the HTML page.
// **************************************************************************
// LicensePack: JUST the FILENAME, ie. "mylicense.lpk"
var LicensePack="";
// LPKURL: MUST be a RELATIVE PATH URL, ie. "../lpkfiles"
var LPKURL="";
// XPIURL: MUST be an ABSOLUTE PATH URL, ie. "http://www.foo.com/xpifiles"
var XPIURL="";
// JarURL: MUST be an ABSOLUTE PATH URL, ie. "http://www.foo.com/jarfiles"
var JarURL="";
// DLLJar: MUST be an ABSOLUTE PATH URL, ie. "http://www.foo.com/jarfiles"
var DLLJar="";


    // Do NOT edit below this line.

// **************************************************************************
// Per Object Settings (Only override these in the HTML page)...
//   The below settings are defaults...
// **************************************************************************
var CorVuFile="";       // ABSOLUTE OR RELATIVE URL to the object file.
var CorVuBorder="0";    // Border around your object, 0 specifies none.
var CorVuWidth="200";   // Number of pixels wide (percentages accepted).
var CorVuHeight="200";  // Number of pixels tall (percentages accepted).
// AutoWorkWith - TRUE will show the object in the CorVu Web client.
// AutoWorkWith - FALSE The object will only show in the Web browser unless
//                OnlyWorkWith is also set.
var AutoWorkWith="";
// OnlyWorkWith - TRUE will show the object in the CorVu Web client ONLY.
// OnlyWorkWith - FALSE will show the object in the Web browser.
var OnlyWorkWith="";
// EmbedWorkWith - TRUE will show the object in embedded corvu frame window.
// EmbedWorkWith - FALSE will show the object in the Web browser.
var EmbedWorkWith="";
// Inactive - TRUE the object will do nothing until called by loadobject().
// Inactive - FALSE the object will show normally.
var Inactive="";
// Invisible: only makes sense if OnlyWorkWith is set.
// Invisible - TRUE the ActiveX control is not visible in the browser.
// Invisible - FALSE the ActiveX control is always visible in the browser.
// Invisible - AFTERDOWNLOAD the ActiveX control disapears once the object
//             is active.
var Invisible="";
// Directories: set to the URL of supporting data files.
var Directories="";
var CloseIfNoHistory="";
var CloseOnLoad="";
// CloseOnLoad - TRUE will close the browser window after corvu object is running
// CloseOnload - FALSE 
// CGIServers: set to identify cgi server details.
// specify the cgi servername=host:script:port:secure(TRUE OR FALSE);repeat
// format is "jegado=jegado.corvu.com.au:cgisrv/cvsgisrv.exe:80:FALSE;specify another if needed"
var CGIServers="";
// DrillDirect - TRUE will drill directly to a corvu object
// DrillDirect - FALSE will drill via a web page that loads the object (old behaviour)
var DrillDirect="";
// InstallDirs - Parameter passed to the oleserver installation progrma to supply defdir and tmpdir 
var InstallDirs="";
// NoSplash - Parameter passed to the oles server. Set it to true to suppress corvu splash screen
var NoSplash="";
// CustomPackage - URl passed for the active x control to download bitmap package from
// the active x control will check the version against the version in the corvu directory
// on the client and if newer will download and install files from package
var CustomPackage="";
// PackageRequired - Set to true if you want to force download of the customization package
var PackageRequired="";
// Prompts - "prompt1 name=response1;prompt2=response2"
// = and ; in strings should be doubled to quote them
var Prompts="";
// LangFiles - "ENU=http://fred/enu;JPN=http://fred/jpn"
// = and ; in strings should be doubled to quote them
var LangFiles="";


//set this on a per site basis if empty ole server shutds down in 15 seconds
var ShutdownSeconds = "15";

    // There are NO USER MAINTAINABLE settings after this line.


    // STANDARD Settings (Do not edit or override)...
var PluginVer="4.1.0.35";
var ControlVer="1,0,0,40";
var MajorVer="4";
var MinorVer="20.177";

    // Really annoying, and only for experts.
var CorVuDebug = 0;

    // Internal
var TestPlug=0;
var TestVar=0;
//var TheCorVuPlugin = self;
var BrowserMajVer=0;
var BrowserVer=0;
var BrowserPlatform="";
var PluginOK = 0;
var ForceInstall = 0;
var InstallDone  = 0;


function testplugin()
{
    if (1 == TestPlug)
    {
        return;
    }

    if (CorVuDebug)
        alert("DEBUG:\ntestplugin()");

    TestPlug = 1;

    if (1 != verifyAllVariables())
    {
	if (CorVuDebug)
		alert ("DEBUG:\VerifyAlVariables failed?");
        TestPlug = -1;
        return;
    }

    if (navigator.javaEnabled()  && navigator.appName == "Netscape")
    {
        if (5 <= BrowserVer)
        {
            if (InstallTrigger.enabled())
            { 
if (CorVuDebug)
	alert ("DEBUG:\InstallTrigger enabled");
                my_ok = 0;

                if (ForceInstall == 1)
                {
if (CorVuDebug)
	alert ("DEBUG:\ForeceInstall");
                    if (confirm("You need to install the CorVu Plugin\nPress ok to perform the installation"))
                    {
                        my_ok = 1;
                    }
                    else
                        TestPlug = -1;
                }
		else if (InstallTrigger.getVersion("CorVu Plugin") == null)
                {
if (CorVuDebug)
	alert ("DEBUG:\Plugin not installed");
                    if (confirm("You need to install the CorVu Plugin\nPress ok to perform the installation"))
                    {
                        my_ok = 1;
                    }
                    else
                        TestPlug = -1;
                }
		else
                {
		    if (navigator.userAgent.indexOf("Netscape6/6.0") != -1)
		    {
if (CorVuDebug)
	alert ("DEBUG:\Netscape 6.0");
		    	// Version checking method for Netscape 6.0
		        var installedVersion = new InstallVersion();
		        installedVersion.init(InstallTrigger.getVersion("CorVu Plugin"));
		    
		        if (installedVersion.compareTo(PluginVer)<0)
		        {
if (CorVuDebug)
	alert ("DEBUG:\Upgrade needed, installed version="+installedVersion.toString());
                            if (confirm("You need to upgrade the CorVu Plugin\nPress ok to perform the upgrade"))
                            {
                                my_ok = 1;
                            }
                            else
                                TestPlug = -1;
		    	}
		        else
		    	{
if (CorVuDebug)
	alert ("DEBUG:\Upgrade not needed, installed version="+installedVersion.toString());
	                    PluginOK = 1;
		        }
		    }
		    else
		    {
if (CorVuDebug)
	alert ("DEBUG:\Netscape 6.1 or higher");
			    // Version checking method for Netscape 6.1
			    if (InstallTrigger.compareVersion("CorVu Plugin", PluginVer)<0)
			    {
if (CorVuDebug)
	alert ("DEBUG:\Upgrade needed, installed version="+InstallTrigger.getVersion("CorVu Plugin"));
				if (confirm("You need to upgrade the CorVu Plugin\nPress ok to perform the upgrade"))
				{
				    my_ok = 1;
				}
				else
				    TestPlug = -1;
			    }
			    else
			    {
if (CorVuDebug)
	alert ("DEBUG:\Upgrade not needed, installed version="+InstallTrigger.getVersion("CorVu Plugin"));
				PluginOK = 1;
			    }
		    }
                }
		
                if (my_ok == 1)
                {
if (CorVuDebug)
	alert ("DEBUG:\Installing plugin now");
                    my_msg = "Navigator may need to be shutdown and restarted after installation of the Plugin.";
                    alert(my_msg);
		    InstallDone = 1;
                    xpi={'CorVu Plugin':XPIURL+'/cvpiinst.xpi'};
                    InstallTrigger.install(xpi);
                }
            }
	    else
	    {
		if (CorVuDebug)
			alert ("DEBUG:\InstallTrigger NOT enabled");
	    }
        }
	else if (4.5 <= BrowserVer)
	{
if (CorVuDebug)
	alert ("DEBUG:\Netscape 4.5 or 4.7");
            trigger = netscape.softupdate.Trigger; 
            if (trigger.UpdateEnabled())
            { 
                my_ok = 0;
                installed_version = trigger.GetVersionInfo("CorVu Plugin");
                var version_no = new netscape.softupdate.VersionInfo(PluginVer);
		
                if (ForceInstall == 1)
                {
                    if (confirm("You need to install the CorVu Plugin\nPress ok to perform the installation"))
                    {
                        my_ok = 1;
                    }
                    else
                        TestPlug = -1;
                }
		else if (installed_version == null)
                {
                    if (confirm("You need to install the CorVu Plugin\nPress ok to perform the installation"))
                    {
                        my_ok = 1;
                    }
                    else
                        TestPlug = -1;
                }
                else if (installed_version.compareTo(version_no) < 0)
                {
                    if (confirm("You need to upgrade the CorVu Plugin\nPress ok to perform the upgrade"))
                    {
                        my_ok = 1;
                    }
                    else
                        TestPlug = -1;
                }
		else
	                PluginOK = 1;
		
                if (my_ok == 1)
                {
                    my_msg = "Navigator may need to be shutdown and restarted after installation of the Plugin.";
                    alert(my_msg);
		    InstallDone = 1;
                    trigger.StartSoftwareUpdate(JarURL + "/cvpiinst.jar", trigger.DEFAULT_MODE);
                }
            }
	}
	else
	{
		if (CorVuDebug)
			alert ("DEBUG:\BrowserVer = " + BrowserVer);
	        PluginOK = 1;
        // IF Navigator is less than 4.5 but greater than 4.0
        // Do nothing.  Cannot find the plugin via
        // JavaScript, a limitation of the older browser.
        // This is true, even though Netscape's JavaScript 
        // guides say otherwise.
	}
    }
    else
    {
	if (CorVuDebug)
	{
		if (navigator.javaEnabled())
			alert ("DEBUG:\AppName = " + navigator.appName);
		else
			alert ("DEBUG:\Java NOT enabled!");
	}
        PluginOK = 1;
	// IF MS Internet Explorer, nothing is done in a special way.
	// The object tag deals with any oddities.
    }
}
 
function verifyAllVariables()
{
    var paraMsg = "";
    var browMsg = "";

    if (0 != TestVar)
    {
        return (TestVar);
    }

    if (CorVuDebug)
        alert("DEBUG:\nverifyAllVariables()");

    TestVar=1;

    BrowserMajVer = parseInt(navigator.appVersion); 
    BrowserVer = parseFloat(navigator.appVersion); 
    BrowserType = navigator.appName; 
    if (null != navigator.platform)
    {
        BrowserPlatform = navigator.platform;
    }

    // Test Browser compliance...
    if ("Win" != BrowserPlatform.substr(0, 3))
    {
        browMsg = "You are running in the \"";
        browMsg += BrowserPlatform + "\"environment.\n";
        browMsg += "The CorVu ActiveX Control, requires ";
        browMsg += "a Microsoft Windows OS, and will not work.";

        TestVar = -1;
    }
    else if (4 > BrowserMajVer)
    {
        browMsg = "Your Browser version is \"";
        browMsg += BrowserVer + "\",\nwhich ";
        browMsg += "is not supported.\n";
        browMsg += "The CorVu ActiveX Control, requires ";
        browMsg += "version 4.0 or greater, and will not work.";

        TestVar = -1;
    }

    // Start my_msg, in case I need to use it.
    paraMsg = "There are missing parameter(s) in\n";
    paraMsg += "the CorVu Object definition...\n";

    // These are the only Varables that there are not acceptable 
    // defaults for...
    if ("" == CorVuFile)
    {
        paraMsg += "CorVuFile ";
        TestVar = -1;
    }
    if ("" == LicensePack)
    {
        paraMsg += "LicensePack ";
        TestVar = -1;
    }
    if ("" == LPKURL)
    {
        paraMsg += "LPKURL ";
        TestVar = -1;
    }
    if (navigator.appName == "Netscape" && 5 <= BrowserVer)
    {
        if ("" == XPIURL)
	{
	    paraMsg += "XPIURL ";
	    TestVar = -1;
	}
    }
    else
    {
        if ("" == JarURL)
        {
	    paraMsg += "JarURL ";
	    TestVar = -1;
	}
    }
    // Checking the rest of the variables costs very little time...
    if ("" == CorVuBorder)
        CorVuBorder == "0";
    if ("" == CorVuHeight)
        CorVuHeight == "200";
    if ("" == CorVuWidth)
        CorVuWidth == "200";

    if (-1 == TestVar)
    {
        if ("" == browMsg)
            alert(paraMsg);
        else
            alert(browMsg);
    }

    return (TestVar);
}


function loadobject()
{
    var thisTime = 0
    
    
    if (CorVuDebug)
        alert("DEBUG:\nloadobject()");

    if (0 == TestPlug) // The test has not run
    {
        testplugin();
        thisTime = 1;
    }
    if (1 == TestPlug)
    {    
        if (navigator.javaEnabled()  && navigator.appName == "Netscape")
        {
	
            if (document.CorVuPlugin == undefined)
            {
	        if (InstallDone == 0)
		{
                    PluginOK = 0;
                    ForceInstall = 1;
        	    TestPlug = 0;
        	    testplugin();
		}
	        else
                    alert("Please reload the frame");
        	return;
            }
	
            if (CorVuDebug)
        	    alert("Plugin is " + document.CorVuPlugin);
	    
	    if (document.CorVuPlugin != undefined)
	    {
                if (PluginOK == 1)
                    document.CorVuPlugin.ShowEmbControl(self.location.href);
            }
        }
        else
        {
            CorVuControl.ShowEmbControl();
        }
    }
    else if (((-1 == TestVar) || (-1 == TestPlug)) && (0 == thisTime))
    {
        my_msg = "This is not a supported browser, or\n";
        my_msg += "the ActiveX Control was not updated.";
        alert(my_msg);
    }
        
}


function writeLPKObject()
{

    testplugin();
    
    if (PluginOK == 1)
    {
            if (1 != verifyAllVariables())
            {
                return;
            }

            if (CorVuDebug)
                alert("DEBUG:\nwriteLPKObject()");

            self.document.write("<OBJECT CLASSID = \"clsid:5220cb21-c88d-11cf-b347-00aa00a28331\"\n");
            self.document.write("    border=0 width=\"0\" height=\"0\" hidden>\n");
            self.document.write("    <PARAM NAME=\"LPKPath\" VALUE=\"" + LPKURL + "/" + LicensePack + "\">\n");
            self.document.write("    <EMBED type=\"application/x-CorVu-Plugin\"\n");
	    if (navigator.appName == "Netscape" && 5 <= BrowserVer)
	    {
                self.document.write("        pluginspage=\"" + XPIURL + "/cvpiinst.xpi\"\n");
                self.document.write("        pluginurl=\"" + XPIURL + "/cvpiinst.xpi\"\n");
	    }
	    else
	    {
                self.document.write("        pluginspage=\"" + JarURL + "/cvpiinst.jar\"\n");
                self.document.write("        pluginurl=\"" + JarURL + "/cvpiinst.jar\"\n");
	    }
            self.document.write("        width=\"0\" height=\"0\" hidden\n");
            self.document.write("        lpkpath=\"" + LPKURL + "/" + LicensePack + "\">\n");
            self.document.write("    </EMBED>\n");
            self.document.write("</OBJECT>\n");
    }
}

function writeCorVuObject()
{
    if (PluginOK == 1)
    {
            if (1 != verifyAllVariables())
            {
                self.document.write("<b>CorVuObject; Not Supported.<br></b>");
                return;
            }

            if (CorVuDebug)
                alert("DEBUG:\nwriteCorVuObject()");

                    // Internet Explorer object starts here....
            self.document.write("<OBJECT classid=\"clsid:0633E8D0-F7DE-11D0-A3CA-00001B3A2D0B\"\n");
            self.document.write("  codebase=\"" + JarURL + "/cvaxapp.dll#VERSION=" + ControlVer + "\"\n");
            self.document.write("  border=\"" + CorVuBorder + "\"\n");
            self.document.write("  width=\"" + CorVuWidth + "\"\n");
            self.document.write("  height=\"" + CorVuHeight + "\"\n");
            self.document.write("  name=\"CorVuControl\">\n");
            self.document.write("  <param name=\"EmbCodeBase\" value=\"" + JarURL + "/cvsxos32.exe\">\n");
            self.document.write("  <param name=\"CVMajorVer\" value=\"" + MajorVer + "\">\n");
            self.document.write("  <param name=\"CVMinorVer\" value=\"" + MinorVer + "\">\n");
                    // Internet Explorer USER parameters start here....
            self.document.write("  <param name=\"AppDataSrc\" value=\"" + CorVuFile + "\">\n");
            if ("" != OnlyWorkWith)
            {
                self.document.write("  <param name=\"OnlyWorkWith\" value=\"" + OnlyWorkWith + "\">\n");
            }
            if ("" != EmbedWorkWith)
            {
                self.document.write("  <param name=\"EmbedWorkWith\" value=\"" + EmbedWorkWith + "\">\n");
            }
            if ("" != CloseIfNoHistory)
            {
	        if (history.length < 1)
                        self.document.write("  <param name=\"CloseOnLoad\" value=\"" + "TRUE" + "\">\n");
            }
            if ("" != AutoWorkWith)
            {
                self.document.write("  <param name=\"AutoWorkWith\" value=\"" + AutoWorkWith + "\">\n");
            }
            if ("" != Inactive)
            {
                self.document.write("  <param name=\"Inactive\" value=\"" + Inactive + "\">\n");
            }
            if ("" != Invisible)
            {
                self.document.write("  <param name=\"Invisible\" value=\"" + Invisible + "\">\n");
            }
            if ("" != Directories)
            {
                self.document.write("  <param name=\"Directories\" value=\"" + Directories + "\">\n");
            }
            if ("" != ShutdownSeconds)
            {
                self.document.write("  <param name =\"ShutdownSeconds\" value=\"" + ShutdownSeconds + "\">\n");
            }
            if ("" != CGIServers)
            {
                self.document.write("  <param name =\"CGIServers\" value=\"" + CGIServers + "\">\n");
            }
            if ("" != DrillDirect)
            {
                self.document.write("  <param name =\"DrillDirect\" value=\"" + DrillDirect + "\">\n");
            }
            if ("" != InstallDirs)
            {
                self.document.write("  <param name =\"InstallDirs\" value=\"" + InstallDirs + "\">\n");
            }
            if ("" != NoSplash)
            {
                self.document.write("  <param name =\"NoSplash\" value=\"" + NoSplash + "\">\n");
            }
            if ("" != CustomPackage)
            {
                self.document.write("  <param name =\"CustomPackage\" value=\"" + CustomPackage + "\">\n");
            }
            if ("" != PackageRequired)
            {
                self.document.write("  <param name =\"PackageRequired\" value=\"" + PackageRequired + "\">\n");
            }
            if ("" != Prompts)
            {
                self.document.write("  <param name =\"Prompts\" value=\"" + Prompts + "\">\n");
            }
            if ("" != LangFiles)
            {
                self.document.write("  <param name =\"LangFiles\" value=\"" + LangFiles + "\">\n");
            }

                    // Netscape Communicator embed starts here....
            self.document.write("<EMBED type=application/x-CorVu-Plugin name=\"CorVuPlugin\"\n");
	    if (navigator.appName == "Netscape" && 5 <= BrowserVer)
	    {
                self.document.write("  pluginspage=\"" + XPIURL + "/cvpiinst.xpi\"\n");
                self.document.write("  pluginurl=\"" + XPIURL + "/cvpiinst.xpi\"\n");
	    }
	    else
            {
                self.document.write("  pluginspage=\"" + JarURL + "/cvpiinst.xpi\"\n");
                self.document.write("  pluginurl=\"" + JarURL + "/cvpiinst.xpi\"\n");
	    }
	    self.document.write("  DLLUpdateJar=\"" + DLLJar + "\"\n");
            self.document.write("  border=\"" + CorVuBorder + "\"\n");
            self.document.write("  width=\"" + CorVuWidth + "\"\n");
            self.document.write("  height=\"" + CorVuHeight + "\"\n");
	    if (navigator.appName == "Netscape" && 5 <= BrowserVer)
                self.document.write("  embcodebase=\"" + XPIURL + "/cvsxos32.xpi\"\n");
	    else
                self.document.write("  embcodebase=\"" + JarURL + "/cvsxos32.jar\"\n");
            self.document.write("  CVMajorVer=\"" + MajorVer + "\"\n");
            self.document.write("  CVMinorVer=\"" + MinorVer + "\"\n");
                    // Netscape Communicator USER parameters start here....
            self.document.write("  AppDataSrc=\"" + CorVuFile + "\"\n");
            if ("" != OnlyWorkWith)
            {
                self.document.write("  OnlyWorkWith=\"" + OnlyWorkWith + "\"\n");
            }
            if ("" != AutoWorkWith)
            {
                self.document.write("  AutoWorkWith=\"" + AutoWorkWith + "\"\n");
            }
            if ("" != EmbedWorkWith)
            {
                self.document.write("  EmbedWorkWith=\"" + EmbedWorkWith + "\"\n");
            }
            if ("" != Inactive)
            {
                self.document.write("  Inactive=\"" + Inactive + "\"\n");
            }
            if ("" != Invisible)
            {
                self.document.write("  Invisible=\"" + Invisible + "\"\n");
            }
            if ("" != Directories)
            {
                self.document.write("  Directories=\"" + Directories + "\"\n");
            }
            if ("" != ShutdownSeconds)
            {
                self.document.write("  ShutdownSeconds=\"" + ShutdownSeconds + "\"\n");
            }
            if ("" != CloseIfNoHistory)
            {
	        if (document.referrer == "")
                        self.document.write("  CloseOnLoad=\"" + "TRUE" + "\"\n");
            }
            if ("" != CGIServers)
            {
                self.document.write("  CGIServers=\"" + CGIServers + "\"\n");
            }
            if ("" != DrillDirect)
            {
                self.document.write("  DrillDirect=\"" + DrillDirect + "\"\n");
            }
            if ("" != InstallDirs)
            {
                self.document.write("  InstallDirs=\"" + InstallDirs + "\"\n");
            }
            if ("" != NoSplash)
            {
                self.document.write("  NoSplash=\"" + NoSplash + "\"\n");
            }
            if ("" != CustomPackage)
            {
                self.document.write("  CustomPackage=\"" + CustomPackage + "\"\n");
            }
            if ("" != PackageRequired)
            {
                self.document.write("  PackageRequired=\"" + PackageRequired + "\"\n");
            }
            if ("" != Prompts)
            {
                self.document.write("  Prompts=\"" + Prompts + "\"\n");
            }
            if ("" != LangFiles)
            {
                self.document.write("  LangFiles=\"" + LangFiles + "\"\n");
            }
	    
            //finish the embed tag
	    
            self.document.write("  >\n");
            self.document.write("</EMBED>\n");
            self.document.write("</OBJECT>\n");

            if ("FALSE" == Inactive)
            {
                if (navigator.javaEnabled() && ("Netscape" == navigator.appName))
                {
                    testplugin();
                    // TheCorVuPlugin.ShowEmbControl(self.location.href);
                }
            }
        }
}

// functions for forcing logon to cgi server
// on your web page you need to define the four functions that are called from
// doResult you need to place a corvu command script on your web page which lhas the following line
// LoginToCGI servername
// the server can be configured with the CGIServers parameter for the control

function waitForCGILogon()
{
	if ("Netscape" == navigator.appName)
	{
		if (self.document.CorVuPlugin.GetCorVuStatus() == -1)
			setTimeout("waitForCGILogon()", 1000);
		else
			checkStatus();
	}
	else
	{
		if (CorVuControl.CorVuStatus == -1)
			setTimeout("waitForCGILogon()", 1000);
		else
			checkStatus();
	}
}

function checkStatus()
{
	if ("Netscape" == navigator.appName)
	{
		if (self.document.CorVuPlugin.GetCorVuStatus() == 2)
			setTimeout("checkStatus()", 1000);
		else
			doResult();
	}
	else
	{
		if (CorVuControl.CorVuStatus == 2)
			setTimeout("checkStatus()", 1000);
		else
			doResult();
	}
}

function doResult()
{
	var iStatus;

	if ("Netscape" == navigator.appName)
		iStatus = self.document.CorVuPlugin.GetCorVuStatus();
	else
		iStatus = CorVuControl.CorVuStatus;

	if (iStatus == 0)
	{
		if (CorVuDebug)
			alert ("DEBUG:\CGI Logon OK!");
		CGILogon_OK();
		//define your fuction name as above
	}
	else if (iStatus == 3)
	{
		if (CorVuDebug)
			alert ("DEBUG:\CGI Logon Failed - Access Denied");
		CGILogon_AccessDenied();
		//define your fuction name as above
	}
	else if (iStatus == 4)
	{
		if (CorVuDebug)
			alert ("DEBUG:\CGI Logon Failed - Server Not Found");
		CGILogon_ServerNotFound();
		//define your fuction name as above
	}
	else
	{
		if (CorVuDebug)
			alert ("DEBUG:\CGI Logon failed!");
		CGILogon_Failed();
		//define your fuction name as above
	}
}

// EOF WebKit.js
