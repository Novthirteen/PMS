//name of the dialog Form
var m_form = "ProjectSelectForm";

var m_dialogWindow = null;

function openProjectSelectDialog(callbackName, callingFormName) 
{
	var dialogForm = document.forms[m_form];
	var callingForm = document.forms[callingFormName];
	dialogForm.elements["CALLBACKNAME"].value = callbackName;
	m_dialogWindow = submitSubWindow(dialogForm.name, "showdialog", "", getPopupPosAndSize(500, 200));
}

function fnSave() {
	var dialogForm = document.forms["ProjectSelectForm"];	
	var projectCode = dialogForm["projectSelect"].value;

	var eventCode = dialogForm["eventSelect"].value;
	
	var ServiceTypeSelect = dialogForm["ServiceTypeSelect"].value;
	
	var descriptionSelect = "";
	if (dialogForm["descriptionSelect"] != null) {
		descriptionSelect = dialogForm["descriptionSelect"].value;
	}
	dialogForm.elements["hiddenProjectCode"].value = projectCode;	
	dialogForm.elements["hiddenEventCode"].value = eventCode;
	dialogForm.elements["hiddenServiceType"].value = ServiceTypeSelect;
	if (dialogForm.elements["hiddenDescription"] != null) {
		dialogForm.elements["hiddenDescription"].value = descriptionSelect;
	}
	//var callbackName = dialogForm.elements["CALLBACKNAME"].value;
	//top.window.opener[callbackName].call(this);

	top.window.opener["onCloseDialog"].call(this);

	closeOwnWindow();	
}
function setValue(callingFormName, nameFrom, nameTo)
{
	var dialogForm = m_dialogWindow.document.forms["ProjectSelectForm"];
	var callingForm = document.forms["EditTimeSheetForm"];
	var textBox = dialogForm.elements[nameFrom];	
	callingForm.elements[nameTo].value = textBox.value;
}

