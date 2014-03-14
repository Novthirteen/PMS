//name of the dialog Form
var m_form = "ProjectListForm";
var m_dialogWindow = null;

function openProjectSelectDialog(callbackName, callingFormName) 
{
	var dialogForm = document.forms[m_form];
	var callingForm = document.forms[callingFormName];
	dialogForm.elements["CALLBACKNAME"].value = callbackName;
	m_dialogWindow = submitSubWindow(dialogForm.name, "showdialog", "", getPopupPosAndSize(500, 500));
}

function fnSave() {
	var dialogForm = document.forms["ProjectListForm"];	
	top.window.opener["onCloseDialog"].call(this);
	closeOwnWindow();	
}

function setValue(nameFrom, nameTo)
{
	var dialogForm = m_dialogWindow.document.forms["ProjectListForm"];
	var callingForm = document.forms["frm"];
	var textBox = dialogForm.elements[nameFrom];	
	callingForm.elements[nameTo].value = textBox.value;
}

function setProjValue(nameFrom1, nameFrom2, nameTo)
{
	var dialogForm = m_dialogWindow.document.forms["ProjectListForm"];
	var callingForm = document.forms["frm"];
	var textBox1 = dialogForm.elements[nameFrom1];	
	var textBox2 = dialogForm.elements[nameFrom2];
	var textBox = textBox1.value + ':' + textBox2.value;
	callingForm.elements[nameTo].value = textBox;
}
