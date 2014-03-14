var m_form = "SelForm";

var m_dialogWindow = null;

function openProjectSelectDialog(callbackName, callingFormName, DataId) 
{
	var dialogForm = document.forms[m_form];
	var callingForm = document.forms[callingFormName];
	dialogForm.elements["CALLBACKNAME"].value = callbackName;
	dialogForm.elements["hiddenDataId"].value = DataId;
	m_dialogWindow = submitSubWindow(dialogForm.name, "showdialog", "", getPopupPosAndSize(600, 350));
}

function fnSave() {
	var dialogForm = document.forms["SelForm"];	
	var DataId = dialogForm["DataId"].value;
	var memberId = dialogForm["memberId"].value;
	var add = dialogForm["add"].value;	
	var DateStart=dialogForm["DateStart"].value;
	var DateEnd = dialogForm["DateEnd"].value;
	dialogForm.elements["hiddenDataId"].value = DataId;	
	dialogForm.elements["hiddenAdd"].value = add;
	dialogForm.elements["hiddenMemberId"].value = memberId;
	dialogForm.elements["hiddenDateStart"].value = DateStart;
	dialogForm.elements["hiddenDateEnd"].value = DateEnd;
    top.window.opener["onCloseDialog"].call(this);
	closeOwnWindow();	
}

function setValue(callingFormName, nameFrom, nameTo)
{
	var dialogForm = m_dialogWindow.document.forms["SelForm"];
	var callingForm = document.forms["EditForm"];
	var textBox = dialogForm.elements[nameFrom];
	callingForm.elements[nameTo].value = textBox.value;
}