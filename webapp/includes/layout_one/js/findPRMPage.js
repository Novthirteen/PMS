//name of the dialog Form
var m_form = "ProjectListForm";
var m_dialogWindow = null;

function openStaffSelectDialog(callbackName, callingFormName,partyId) 
{
	var dialogForm = document.forms["UserListForm"];
	var callingForm = document.forms[callingFormName];
	dialogForm.elements["partyId"].value = partyId;
	m_dialogWindow = submitSubWindow(dialogForm.name, "showdialog", "", getPopupPosAndSize(400, 450));
}

function fnSave_staff() {
	var dialogForm = document.forms["UserListForm"];	
	top.window.opener["onCloseDialog"].call(this);
	closeOwnWindow();
}
function setValue(nameFrom, nameTo)
{
	var dialogForm = m_dialogWindow.document.forms["UserListForm"];
	var callingForm = document.forms["FindPRMForm"];
	var textBox = dialogForm.elements[nameFrom];	
	callingForm.elements[nameTo].value = textBox.value;
}

