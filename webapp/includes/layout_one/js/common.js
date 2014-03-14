var window_current = window;

function funcInit() {
	tagOnLoad();
	//initDate(document.header.date);
	//initTime(document.header.tm);
}

function funcUnLoad() {
	destroy();
}

var childWindow = new Array();


function openCommonWindow(path, option) {
	return top.openWindow("common", path, option);
}

function openSubWindow(path, option) {
	return top.openWindow("sub", path, option);
}

function openPrintWindow(path, option) {
	return top.openWindow("print", path, option);
}

function openHelpWindow(path, option) {
	return top.openWindow("help", path, option);
}

function openWindow(name, path, option) {
	if (childWindow[name] != null &&
		!(childWindow[name].closed)) {
//		childWindow[name].close();
		return;
	}
	
	childWindow[name] =
		window.open(path, childName(name), option);
	window_current = childWindow[name];
	
	return childWindow[name];
}


function childName(name) {
	return window.name + "_" + name;
}


function subWindowName() {
	return childName("sub");
}


function destroy() {
	for (var i in childWindow) {
		if (childWindow[i] != null) {
			childWindow[i].close();
			childWindow[i] = null;
		}
	}
}


function closeOwnWindow() {
    if( isChildClosed() ){
        top.window.onblur = null;
        var parentWindow = top.window.opener;
        if (parentWindow != null) {
            top.window.opener.focus();
        }
        top.window.close();
    }
}

function getPopupPosAndSize(ww, wh) {
	var wx = (screen.width - ww) / 2;
	var wy = (screen.height - wh) / 2;
	return "left=" + wx + ",top=" + wy + ",width=" + ww + ",height=" + wh;
}


function errorWindow(path) {

	openCommonWindow(path,"scrollbars=no,resizable=no," + getPopupPosAndSize(540, 300));
	
}

function setFocus(elementObj) {
	
	if (elementObj.type == "hidden") {
		return;
	}
	
	elementObj.focus();
	
	if (elementObj.type == "text" ||
		elementObj.type == "password" ||
		elementObj.type == "file" ||
		elementObj.type == "textarea")
	{
		elementObj.select();
	}
}

function funcCheck(form, property, trueValue) {
	formObj = document.forms[form];
	elementObj = formObj[property];
	if (elementObj.value != "") {
		elementObj.value = "";
	} else {
		elementObj.value = trueValue;
	}
}



var eraNames = new Array("明治", "大正", "昭和", "平成");

var changeEra = new Array(
	new Date(1868, 8, 8),
	new Date(1912, 6, 30),
	new Date(1926, 11, 25),
	new Date(1989, 0, 8));

var minDate = new Date(1873, 0, 1);

var nowEdited = null;
var nowEditedType = 0;

function startEdit(target, editType) {
	
	if (editType <= 4) {
		startDateEdit(target, editType);
	} else if (editType <= 6) {
		startTimeEdit(target, editType - 4);
	}

	nowEdited = target;
	nowEditedType = editType;

}


function endEdit(target, editType) {
	
	if (target == null) {
		if (nowEdited == null) {
			return;
		} else {
			target = nowEdited;
			editType = nowEditedType;
		}
	}
		
	if (editType <= 4) {
		endDateEdit(target, editType);
	} else if (editType <= 6) {
		endTimeEdit(target, editType - 4);
	}

	nowEdited = null;
	nowEditedType = 0;
	
}

function startDateEdit(target, type) {
	var val = target.value;

	var editDate = "";

	if (val != null && val != "") {
		var work = type == 1 ? val.split("年度") : val.split("年");
		var era = work[0].substring(0, 2);
		var year = parseInt(work[0].substring(2), 10);

		for (var i=0; i<eraNames.length; i++) {
			if (eraNames[i] == era) {
				editDate += (year += changeEra[i].getFullYear() - 1);
			}
		}

		if (type > 2) {
			work = work[1].split("月");
			var month = parseInt(work[0], 10);
			editDate += month > 9 ? month : "0" + month;
		}

		if (type > 3) {
			var day = parseInt(work[1].split("日"), 10);
			editDate += day > 9 ? day : "0" + day;
		}
	}

	target.value = editDate;
	target.select(0, target.value.lenght-1);
}


function endDateEdit(target, type) {
	var val = target.value;

	var checkLen = 0;
	switch (type) {
	case 1:	checkLen = 4; break;
	case 2:	checkLen = 4; break;
	case 3:	checkLen = 6; break;
	case 4:	checkLen = 8; break;
	}

	var jpnDate = "";

	if (val.length == checkLen && !(isNaN(parseInt(val, 10))) ) {
		var year = 0, month = 0, day = 1;

		year = parseInt(val.substring(0, 4), 10);
		if (type > 2) {
			month = parseInt(val.substring(4, 6), 10) - 1;
		}
		if (type > 3) {
			day = parseInt(val.substring(6), 10);
		}
		var inputDate = new Date(year, month, day);

		if (inputDate.getTime() >= minDate.getTime() &&
			inputDate.getFullYear() == year &&
			inputDate.getMonth() == month &&
			inputDate.getDate() == day) {

			for (var i=changeEra.length-1; i>=0; i--) {
				if (changeEra[i].getTime() <= inputDate.getTime()) {
					var changeEraYear = changeEra[i].getFullYear();
					var jpnYear = inputDate.getFullYear() - changeEraYear + 1;
					jpnDate = eraNames[i] + jpnYear;
					jpnDate += type == 1 ? "年度" : "年";
					if (type > 2) {
						jpnDate += (inputDate.getMonth()+1) + "月";
					}
					if (type > 3) {
						jpnDate += inputDate.getDate() + "日";
					}
					break;
				}
			}
		}
	}

	target.value = jpnDate;
}


function startTimeEdit(target, type) {
	var val = target.value;

	var editTime = "";
	target.value = "";

	var AM = type == 1 ? "AM" : "午前";
	var PM = type == 1 ? "PM" : "午後";
	var SEP1 = type == 1 ? ":" : "時";

	var work = val.split(" ");
	if (work.length != 2 && work[0] != AM && work[0] != PM) {
		return;
	}
	var AMPM = work[0];

	work = work[1].split(SEP1);
	if (work.length != 2) {
		return;
	}

	var hour = parseInt(work[0]);
	var min = work[1].substring(0, 2);

	if (!(isNaN(hour)) && hour <= 11 && hour >= 0) {
		if (hour == 0) {
			editTime += AMPM == AM ? "00" : "12";
		}
		else if (AMPM == PM) {
			editTime += new String(hour + 12);
		}
		else {
			editTime += hour > 9 ? hour : "0" + hour;
		}
		
		if (!(isNaN(parseInt(min, 10))) && min <= 59 && min >= 0) {
			editTime += min;
		}
	}


	target.value = editTime;
	target.select(0, target.value.lenght-1);
}


function endTimeEdit(target, type) {
	var val = target.value;

	var viewTime = "";
	target.value = "";

	if (val.length != 4) {
		return;
	}

	var hour = parseInt(val.substring(0, 2), 10);
	var min = parseInt(val.substring(2, 4), 10);
	if (isNaN(hour) || hour > 24 || hour < 0) {
		return;
	}
	if (isNaN(min) || min > 59 || min < 0) {
		return;
	}

	var AM = type == 1 ? "AM " : "午前 ";
	var PM = type == 1 ? "PM " : "午後 ";
	var SEP1 = type == 1 ? ":" : "時";
	var SEP2 = type == 1 ? "" : "分";

	viewTime += Math.floor(hour / 12) == 1 ? PM : AM;
	hour = hour % 12;
	viewTime += hour + SEP1;
	viewTime += min > 9 ? min : "0" + min;
	viewTime += SEP2;

	target.value = viewTime;
}


function callScriptCalendar(contextpath, formname, query) {
	
	formname = getPathFromPopupWindow(formname);
	query = "?formname="+ formname +"&"+ query;
	var path = contextpath +"/common/calendar/init.do"+ query;
	var status = getPopupPosAndSize(280, 280)
		+ ",scrollbars=no,location=no,menubar=no,resizable=no,status=no,toolbar=no";

	openCommonWindow(path, status);
	
}

function getPathFromPopupWindow(formname) {
	var wnd = self;
	var path = "";

	while (true) {
		if (wnd == top.window) {
			path = "top.window.opener" + path;
			path += ".document." + formname;
			break;
		} else {
			path = "." + wnd.name + path;
			wnd = wnd.parent;
		}
	}
	return path;
}


function dateFormat(date) {	
	yy = date.getYear();
	if (yy < 2000) { yy += 1900; }
	
	mm = date.getMonth() + 1;
	if (mm < 10) { mm = "0" + mm; }
	
	dd = date.getDate();
	if (dd < 10) { dd = "0" + dd; }
	
	day = date.getDay();
	dayStr = new Array(7);
	dayStr[0] = "日";
	dayStr[1] = "月";
	dayStr[2] = "火";
	dayStr[3] = "水";
	dayStr[4] = "木";
	dayStr[5] = "金";
	dayStr[6] = "土";
	
	return (yy + "年" + mm + "月" + dd + "日(" +dayStr[day]+")");

}


function timeFormat(date) {	

	hour = date.getHours();
	if (hour < 10) { hour = "0" + hour; }
	
	min = date.getMinutes();
	if (min < 10) { min = "0" + min; }
	
	sec = date.getSeconds();
	if (sec < 10) { sec = "0" + sec; }
	
	return (hour + ":" + min + ":" + sec);

}


function initDate(dateField) {
	
	date = new Date();
	dateField.value = dateFormat(date);	
}

var tmField = null;

function initTime(tmFieldA) {
	
	tmField = tmFieldA;
	updateTime();
}

function updateTime() {
	
	date = new Date();
	tmField.value = timeFormat(date);
	window.setTimeout("updateTime()", 1000);

}

function winCheck(){
    if( !isChildClosed() ){
        event.cancelBubble = true;
        event.returnValue = false;
        window_current.focus();
        return false;
    }
    return true;

}

function isChildClosed(){
    if( window_current != window &&  !(window_current.closed) ){
        return false;
    }else{
        return true;
    }
}
//window.document.onclick=winCheck;
