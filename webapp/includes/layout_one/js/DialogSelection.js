var m_dialogWindow = null;

function openStaffSelectDialog(callbackName, callingFormName) 
{
	var dialogForm = document.forms["UserListForm"];
	var callingForm = document.forms[callingFormName];
	dialogForm.elements["CALLBACKNAME"].value = callbackName;
	m_dialogWindow = submitSubWindow(dialogForm.name, "showdialog", "", getPopupPosAndSize(500, 500));
}

function fnSave_staff() {
	var dialogForm = document.forms["UserListForm"];	
	top.window.opener["onCloseDialog"].call(this);
	closeOwnWindow();
}
function setStaffValue(nameFrom, nameTo, callingFormName)
{
	var dialogForm = m_dialogWindow.document.forms["UserListForm"];
	var callingForm = document.forms[callingFormName];
	var textBox = dialogForm.elements[nameFrom];	
	callingForm.elements[nameTo].value = textBox.value;
}