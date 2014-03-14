function MapVIN(QueryVIN, ListVIN)
{
	var VINColPos,VINStrLen,StartPos;
	VINStrLen = QueryVIN.length;
	StartPos = ListVIN.length-VINStrLen;
	if (StartPos >= 0)
	{
		if ((ListVIN.substr(StartPos)) == QueryVIN)
		{
			return 1;
		}
	}
	return (0);
}

function QuerySKUData(ActionFlag)
{
	var V_Row_Count;
	var VINColPos,VINStrLen,FindPos,StartPos;
	var QueryVIN,ListVIN,FindVIN;
	var i;
	
	V_Row_Count = document.all.Sel_Options_Row_Count.value;
	
	if (document.OrderForm.AddCol_VIN_Code1.value != "")
	{
		FindPos = -1;
		QueryVIN = document.OrderForm.AddCol_VIN_Code1.value;
		for (i=1; i<= V_Row_Count; i++)
		{
			ListVIN = document.all["Sel_List_"+i.toString()+"_VIN_Code1"].value;
			if (MapVIN(QueryVIN, ListVIN))
			{
				if (FindPos == -1)
				{
					FindPos = i;
					FindVIN = ListVIN;
				}
				else
				{
					alert("有多个匹配的识别号存在，请输入更完整的号码来帮助查询！");
					document.OrderForm.AddCol_VIN_Code1.focus();
					return(0);
				};
			}
		}
		if (FindPos == -1)
		{
			alert("没有匹配的识别号存在，请输入准确的号码来帮助查询！");
			document.OrderForm.AddCol_VIN_Code1.select();
			return(-1);
		}
		else
		{
			if (CheckInListDataRow(FindVIN,"VIN_Code1"))
			{
				alert("该识别号已经在单据行行中存在，请输入准确的号码来帮助查询！");
				document.OrderForm.AddCol_VIN_Code1.select();
				return(-1);
			}else{
				switch (ActionFlag){
					case "QUERYSKU":
						DisplayFindDataRow(FindPos);
						document.OrderForm.AddCol_VIN_Code1.focus();
						break;
					case "ADDSKU":
						AddDataRow(FindPos);
						document.OrderForm.AddCol_VIN_Code1.focus();
						break;
					case "Accept":
						ChangeDataRowFlag(FindPos,"Accept");
						document.OrderForm.AddCol_VIN_Code1.focus();
						break;
					case "Exception":
						ChangeDataRowFlag(FindPos,"Exception");
						document.OrderForm.AddCol_VIN_Code1.focus();
						break;
					default:
				}
			}
		}
	}
	else 
	{
		FindPos = -1;
		QueryVIN = document.OrderForm.AddCol_VIN_Code2.value;
		for (i=1; i<= V_Row_Count; i++)
		{
			ListVIN = document.all["Sel_List_"+i.toString()+"_VIN_Code2"].value;
			if (MapVIN(QueryVIN, ListVIN))
			{
				if (FindPos == -1)
				{
					FindPos = i;
					FindVIN = ListVIN;
				}
				else
				{
					alert("有多个匹配的识别号存在，请输入更完整的号码来帮助查询！");
					document.OrderForm.AddCol_VIN_Code2.focus();
					return(0);
				};
			}
		}
		if (FindPos == -1)
		{
			alert("没有匹配的识别号存在，请输入准确的号码来帮助查询！");
			document.OrderForm.AddCol_VIN_Code2.select();
			return(-1);
		}
		else
		{
			if (CheckInListDataRow(FindVIN,"VIN_Code2"))
			{
				alert("该识别号已经在单据行行中存在，请输入准确的号码来帮助查询！");
				document.OrderForm.AddCol_VIN_Code2.select();
				return(-1);
			}else{
				switch (ActionFlag){
					case "QUERYSKU":
						DisplayFindDataRow(FindPos);
						document.OrderForm.AddCol_VIN_Code2.focus();
						break;
					case "ADDSKU":
						AddDataRow(FindPos);
						document.OrderForm.AddCol_VIN_Code2.focus();
						break;
					case "Accept":
						ChangeDataRowFlag(FindPos,"Accept");
						document.OrderForm.AddCol_VIN_Code2.focus();
						break;
					case "Exception":
						ChangeDataRowFlag(FindPos,"Exception");
						document.OrderForm.AddCol_VIN_Code2.focus();
						break;
					default:
				}
			}
		}
	};
}

function CheckInListDataRow(FindVIN,FindCol)
{
	var ListObj;
	var i;
	
	for (i=1; i<=document.OrderForm.In_List_Row_Count.value;i++)
	{
		ListObj = document.OrderForm.all["In_List_"+i+"_"+FindCol];
		if (ListObj!=null)
		{
			if (FindVIN==ListObj.value)
			{
				return 1;
			}
		}
	}
	return 0;
}

function DeleteDataRow()
{
	document.all.DataSetTable.deleteRow(document.activeElement.parentElement.parentElement.rowIndex);
}

function DisplayFindDataRow(FindPos)
{
	var Array_Sel_Options_Col_Display;
	var V_Col_Count;
	var ListStr;
	
	var i;
	
	ListStr=document.all.Sel_Options_AddCol_Display.value;
	Array_Sel_Options_Col_Display = ListStr.split("$");
	
	V_Col_Count = Array_Sel_Options_Col_Display.length;
	
	for (i=0; i<V_Col_Count;i++)
	{
		if (document.OrderForm.all["AddCol_"+Array_Sel_Options_Col_Display[i]].tagName=="DIV")
		{
			document.OrderForm.all["AddCol_"+Array_Sel_Options_Col_Display[i]].innerText=document.all["Sel_List_"+FindPos+"_"+Array_Sel_Options_Col_Display[i]].value;
		}
		else{
			document.OrderForm.all["AddCol_"+Array_Sel_Options_Col_Display[i]].value=document.all["Sel_List_"+FindPos+"_"+Array_Sel_Options_Col_Display[i]].value;
		}
	};
}

function AddDataRow(FindPos)
{
	var AddRow,AddCell;
	var Array_Sel_Options_Col_Display;
	var V_Col_Count;
	var ListStr;
	var AddStr;
	var i;
	var List_Row_Count;

	ListStr=document.all.Sel_Options_Col_Display.value;
	Array_Sel_Options_Col_Display = ListStr.split("$");
	
	V_Col_Count = Array_Sel_Options_Col_Display.length;
	
	List_Row_Count=parseInt(document.OrderForm.all.In_List_Row_Count.value) + 1;
	document.OrderForm.all.In_List_Row_Count.value = List_Row_Count.toString();
	AddRow=document.all.DataSetTable.insertRow();
	for (i=0; i<V_Col_Count;i++)
	{
		AddCell= AddRow.insertCell();
		AddStr=document.all["Sel_List_"+FindPos+"_"+Array_Sel_Options_Col_Display[i]].value;
		AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	};
	AddCell= AddRow.insertCell();
	AddCell.insertAdjacentHTML("AfterBegin","<a href='Javascript:DeleteDataRow()'>删除</a>");
	
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_Product_name' value='"+ document.all["Sel_List_"+FindPos+"_Product_name"].value+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_Product_Id' value='"+ document.all["Sel_List_"+FindPos+"_Product_Id"].value+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_VIN_Code1' value='"+ document.all["Sel_List_"+FindPos+"_VIN_Code1"].value+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_VIN_Code2' value='"+ document.all["Sel_List_"+FindPos+"_VIN_Code2"].value+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_facility_Id' value='"+ document.all["Sel_List_"+FindPos+"_facility_Id"].value+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_location_id' value='"+ document.all["Sel_List_"+FindPos+"_location_id"].value+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_PRODUCT_TYPE' value='"+ document.all["Sel_List_"+FindPos+"_PRODUCT_TYPE"].value+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_PRODUCT_COLOR' value='"+ document.all["Sel_List_"+FindPos+"_PRODUCT_COLOR"].value+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);

	ClearQueryData();
}

function AddFullDataRow()
{
	var AddRow,AddCell;
	var Array_Sel_Options_Col_Display;
	var V_Col_Count;
	var ListStr;
	var AddStr;
	var i;
	var List_Row_Count;
	var ProdList,LocList;
	
	ListStr=document.all.Sel_Options_Col_Display.value;
	Array_Sel_Options_Col_Display = ListStr.split("$");
	
	V_Col_Count = Array_Sel_Options_Col_Display.length;
	
	List_Row_Count=parseInt(document.OrderForm.all.In_List_Row_Count.value) + 1;
	document.OrderForm.all.In_List_Row_Count.value = List_Row_Count.toString();
	
	AddRow=document.all.DataSetTable.insertRow();
	for (i=0; i<V_Col_Count;i++)
	{
		AddCell= AddRow.insertCell();
		if (document.all["AddCol_"+Array_Sel_Options_Col_Display[i]].tagName == "SELECT")
		{
			AddStr=document.all["AddCol_"+Array_Sel_Options_Col_Display[i]].options[document.all["AddCol_"+Array_Sel_Options_Col_Display[i]].selectedIndex].text;
		} else {
			AddStr=document.all["AddCol_"+Array_Sel_Options_Col_Display[i]].value;
		}
		AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	};
	
	AddCell= AddRow.insertCell();
	AddCell.insertAdjacentHTML("AfterBegin","<a href='Javascript:DeleteDataRow()'>删除</a>");
	
	ListStr = document.all["AddCol_Product_name"].value;
	ProdList = ListStr.split("$");
	ListStr = document.all["AddCol_location_description"].value;
	LocList = ListStr.split("$");
	
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_Product_name' value='"+ ProdList[0]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_Product_Id' value='"+ document.all["AddCol_VIN_Code1"].value+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_VIN_Code1' value='"+ document.all["AddCol_VIN_Code1"].value+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_VIN_Code2' value='"+ document.all["AddCol_VIN_Code2"].value+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_facility_Id' value='"+ LocList[1]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_location_id' value='"+ LocList[0] +"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_PRODUCT_TYPE' value='"+ ProdList[1]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_PRODUCT_COLOR' value='"+ ProdList[2]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
}

function ClearQueryData()
{
	var Array_Sel_Options_Col_Display,Array_Sel_Options_Col_Value;
	var V_Col_Count;
	var ListStr;
	
	var i;
	
	ListStr=document.all.Sel_Options_AddCol_Display.value;
	Array_Sel_Options_Col_Display = ListStr.split("$");
	
	V_Col_Count = Array_Sel_Options_Col_Display.length;
	for (i=0; i<V_Col_Count;i++)
	{
		if (document.OrderForm.all["AddCol_"+Array_Sel_Options_Col_Display[i]].tagName=="DIV")
		{
			document.OrderForm.all["AddCol_"+Array_Sel_Options_Col_Display[i]].innerText="";
		}
		else{
			document.OrderForm.all["AddCol_"+Array_Sel_Options_Col_Display[i]].value="";
		}
	};
}

function ChangeDataRowFlag(FindPos,ToFlag)
{
	var ChangeRow,ChangeCell;
	var i;
	var Find_Item_Id;
	var Add_Str;
	var List_Row_Count;
	var ToFlag_Display;
	
	switch(ToFlag){
		case "Accept":
			ToFlag_Display = "接收";
			break;
		case "Exception":
			ToFlag_Display = "异常接收";
			break;
		default:
			ToFlag_Display = "";
	}
	
	Find_Item_Id = document.all["Sel_List_"+FindPos+"_Order_Item_Id"].value;
	ChangeCell = document.OrderForm.all["DataSet_"+Find_Item_Id+"_Note"];
	ChangeCell.innerHTML = ToFlag_Display;
	
	ChangeCell = document.OrderForm.all["DataSet_"+Find_Item_Id+"_Operation"];
	ChangeCell.innerHTML = "";
	
	List_Row_Count=parseInt(document.OrderForm.all.In_List_Row_Count.value) + 1;
	document.OrderForm.all.In_List_Row_Count.value = List_Row_Count.toString();

	ChangeCell.insertAdjacentHTML("AfterBegin","<a href='Javascript:DeleteDataRowFlag()'>清除</a>");
	
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_Order_Item_Id' value='"+ document.all["Sel_List_"+FindPos+"_Order_Item_Id"].value+"'>";
	ChangeCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_Product_name' value='"+ document.all["Sel_List_"+FindPos+"_Product_name"].value+"'>";
	ChangeCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_Product_Id' value='"+ document.all["Sel_List_"+FindPos+"_Product_Id"].value+"'>";
	ChangeCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_VIN_Code1' value='"+ document.all["Sel_List_"+FindPos+"_VIN_Code1"].value+"'>";
	ChangeCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_VIN_Code2' value='"+ document.all["Sel_List_"+FindPos+"_VIN_Code2"].value+"'>";
	ChangeCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_facility_Id' value='"+ document.all["Sel_List_"+FindPos+"_facility_Id"].value+"'>";
	ChangeCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_location_id' value='"+ document.all["Sel_List_"+FindPos+"_location_id"].value+"'>";
	ChangeCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_PRODUCT_TYPE' value='"+ document.all["Sel_List_"+FindPos+"_PRODUCT_TYPE"].value+"'>";
	ChangeCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_PRODUCT_COLOR' value='"+ document.all["Sel_List_"+FindPos+"_PRODUCT_COLOR"].value+"'>";
	ChangeCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_Note' value='"+ ToFlag+"'>";
	ChangeCell.insertAdjacentHTML("AfterBegin",AddStr);
	ClearQueryData();
}

function DeleteDataRowFlag()
{
	var DelCell;
	var DelCell_Id;
	DelCell = document.activeElement.parentElement;
	DelCell.innerHTML = "";
	DelCell_Id = DelCell.id;
	DelCell_Id = DelCell_Id.replace("_Operation","_Note");
	DelCell = document.OrderForm.all[DelCell_Id];
	DelCell.innerHTML = "";
}

function SetSecondOption(SelLevel,SelectedValue,SecondName,SecondObject,DefaultVal)
{
	var SecondSelDescList,SecondSelDescStr;
	var SecondSelValueList,SecondSelValueStr;
	var SecondLevel;
	var i;
	var oOption;
	var defOption;
	
	SecondLevel = (SelLevel + 1);
	
	SecondSelDescStr = document.all["HidSelList_" + SecondLevel.toString() + "_" + SecondName + "_Desc_" + SelectedValue].value;
	SecondSelDescList = SecondSelDescStr.split("$");
	
	SecondSelValueStr = document.all["HidSelList_" + SecondLevel.toString() + "_" + SecondName + "_Value_" + SelectedValue].value;
	SecondSelValueList = SecondSelValueStr.split("$");
	
	if (SecondSelDescList.length>0)
	{
		if (SecondObject.options.length > 0)
		{
			for (i=0; i< SecondObject.options.length+3; i++)
			{
				SecondObject.options.remove(0);
			};
		};
		if (SecondObject.options.length > 0)
		{
			for (i=0; i< SecondObject.options.length+3; i++)
			{
				SecondObject.options.remove(0);
			};
		};
		defOption = 0;
		for (i=0; i< SecondSelDescList.length; i++)
		{
			oOption = document.createElement("OPTION");
			oOption.text=SecondSelDescList[i];
			oOption.value=SecondSelValueList[i];
			SecondObject.options.add(oOption);
			if (DefaultVal == SecondSelValueList[i]){
				defOption = i;
			}
		};
		SecondObject.options(defOption).selected = true;
	}
	else
	{
		alert("没有下级选择项！");
	};
}

function AddItemInVinList()
{
	var AddRow,AddCell;
	var Array_Sel_Options_Col_Display;
	var V_Col_Count;
	var ListStr;
	var AddStr;
	var i;
	var List_Row_Count;
	
	if (document.all.AddCol_VIN_Code2.value == ""){
		alert ("没有完整地输入数据！");
		document.all.AddCol_VIN_Code2.select();
		return 0;
	}
	if (document.all.AddCol_VIN_Code1.value == ""){
		alert ("没有完整地输入数据！");
		document.all.AddCol_VIN_Code1.select();
		return 0;
	}
	
	FindVIN = document.all.AddCol_VIN_Code1.value;
	if (CheckInListDataRow(FindVIN,"VIN_Code1")){
		alert("该识别号已经在单据行行中存在，请输入准确的号码来帮助查询！");
		document.all.AddCol_VIN_Code1.select();
		return 0;
	}
	var FindURL = "components/order/FindItemList/findItemInVinPool.jsp?VinCode1=" + document.all.AddCol_VIN_Code1.value + "&VinCode2=" +document.all.AddCol_VIN_Code2.value;
		
	RetValue = window.showModalDialog(FindURL,"Dialog Arguments Value","dialogHeight: 300px; dialogWidth: 400px; dialogTop: 400px; dialogLeft: 300px; center: no; help: no"); 
	
	if (RetValue == "0"){
		alert ("数据输入错误！");
		document.all.AddCol_VIN_Code1.select();
		return 0;
	}
	
	ListStr = RetValue;
	Array_Sel_Options_Col_Display = ListStr.split("$");
	
	V_Col_Count = Array_Sel_Options_Col_Display.length;
	
	List_Row_Count=parseInt(document.all.In_List_Row_Count.value) + 1;
	document.all.In_List_Row_Count.value = List_Row_Count.toString();

	AddRow=document.all.DataSetTable.insertRow();
	
	for (i=0; i<V_Col_Count;i++)
	{
		AddCell= AddRow.insertCell();
		AddStr=Array_Sel_Options_Col_Display[i];
		AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	};
	AddCell= AddRow.insertCell();
	AddStr=document.all.AddCol_location_description.options[document.all.AddCol_location_description.selectedIndex].text;
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
		
	AddCell= AddRow.insertCell();
	AddCell.insertAdjacentHTML("AfterBegin","<a href='Javascript:DeleteDataRow()'>删除</a>");
	
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_Product_name' value='"+ Array_Sel_Options_Col_Display[0]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_Product_Id' value='"+ Array_Sel_Options_Col_Display[1]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_VIN_Code1' value='"+ Array_Sel_Options_Col_Display[2]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_VIN_Code2' value='"+ Array_Sel_Options_Col_Display[3]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_PRODUCT_TYPE' value='"+ Array_Sel_Options_Col_Display[4]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_PRODUCT_COLOR' value='"+ Array_Sel_Options_Col_Display[5]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	ListStr = document.all.AddCol_location_description.value;
	Array_Sel_Options_Col_Display = ListStr.split("$");
	
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_facility_Id' value='"+ Array_Sel_Options_Col_Display[1]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_location_id' value='"+ Array_Sel_Options_Col_Display[0]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	
	document.all.AddCol_VIN_Code1.value = "";
	document.all.AddCol_VIN_Code2.value = "";
}

function AddItemInSalesOrderList()
{
	var AddRow,AddCell;
	var Array_Sel_Options_Col_Display;
	var V_Col_Count;
	var ListStr;
	var AddStr;
	var i;
	var List_Row_Count;
	
	if (document.all.AddCol_VIN_Code2.value == ""){
		alert ("没有完整地输入数据！");
		document.all.AddCol_VIN_Code2.select();
		return 0;
	}
	if (document.all.AddCol_VIN_Code1.value == ""){
		alert ("没有完整地输入数据！");
		document.all.AddCol_VIN_Code1.select();
		return 0;
	}
	
	FindVIN = document.all.AddCol_VIN_Code1.value;
	if (CheckInListDataRow(FindVIN,"VIN_Code1")){
		alert("该识别号已经在单据行行中存在，请输入准确的号码来帮助查询！");
		document.all.AddCol_VIN_Code1.select();
		return 0;
	}
	var FindURL = "components/order/FindItemList/findItemInSalesOrder.jsp?VinCode1=" + document.all.AddCol_VIN_Code1.value + "&VinCode2=" +document.all.AddCol_VIN_Code2.value + "&Party_Id=" +document.all.Party_Id.value;
		
	RetValue = window.showModalDialog(FindURL,"Dialog Arguments Value","dialogHeight: 400px; dialogWidth: 900px; dialogTop: 100px; dialogLeft: 100px; center: no; help: no"); 
	
	if (RetValue == "0"){
		alert ("数据输入错误！");
		document.all.AddCol_VIN_Code1.select();
		return 0;
	}
	
	if (RetValue == "1"){
		document.all.AddCol_VIN_Code1.select();
		return 0;
	}
	
	ListStr = RetValue;
	Array_Sel_Options_Col_Display = ListStr.split("$");
	
	V_Col_Count = Array_Sel_Options_Col_Display.length;
	
	List_Row_Count=parseInt(document.all.In_List_Row_Count.value) + 1;
	document.all.In_List_Row_Count.value = List_Row_Count.toString();

	AddRow=document.all.DataSetTable.insertRow();
	
	for (i=0; i<(V_Col_Count-2);i++)
	{
		AddCell= AddRow.insertCell();
		AddStr=Array_Sel_Options_Col_Display[i];
		AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	};
	AddCell= AddRow.insertCell();
	AddCell.insertAdjacentHTML("AfterBegin","<a href='Javascript:DeleteDataRow()'>删除</a>");
	
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_Product_name' value='"+ Array_Sel_Options_Col_Display[0]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_Product_Id' value='"+ Array_Sel_Options_Col_Display[1]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_VIN_Code1' value='"+ Array_Sel_Options_Col_Display[2]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_VIN_Code2' value='"+ Array_Sel_Options_Col_Display[3]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_PRODUCT_TYPE' value='"+ Array_Sel_Options_Col_Display[4]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_PRODUCT_COLOR' value='"+ Array_Sel_Options_Col_Display[5]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_facility_Id' value='"+ Array_Sel_Options_Col_Display[8]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	AddStr="<input type=hidden name='In_List_" + document.all.In_List_Row_Count.value + "_location_id' value='"+ Array_Sel_Options_Col_Display[9]+"'>";
	AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	
	document.all.AddCol_VIN_Code1.value = "";
	document.all.AddCol_VIN_Code2.value = "";
}

function AddAddtionalItemInInvTypeOrder(ActionFlag)
{
	var List_Row_Count;
	var DataSet_Row_count,DataSet_Col_count;
	var DataSet_Curr_Row;
	var AddStr,Val_Get;
	var AddRow,AddCell;
	
	List_Row_Count=document.all.In_List_Row_Count.value;
	QuerySKUData(ActionFlag);
	if (List_Row_Count!=document.all.In_List_Row_Count.value){
		List_Row_Count=document.all.In_List_Row_Count.value;
		DataSet_Row_count = document.all.DataSetTable.rows.length;
		DataSet_Curr_Row = document.all.DataSetTable.rows(DataSet_Row_count-1);
		DataSet_Col_count = DataSet_Curr_Row.cells.length;
		AddCell = DataSet_Curr_Row.cells(DataSet_Col_count-1);
		AddStr="<input type=hidden name='In_List_" + List_Row_Count + "_to_facility_Id' value='F"+ document.all.Party_Id.value+"'>";
		AddCell.insertAdjacentHTML("AfterBegin",AddStr);
		Val_Get = document.all["In_List_"+ List_Row_Count + "_location_id"].value;
		AddStr="<input type=hidden name='In_List_" + List_Row_Count + "_to_location_id' value='F"+ document.all.Party_Id.value+"_S'>";
		AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	}
}

function AddAddtionalItemInInvTransferOrder(ActionFlag)
{
	var List_Row_Count;
	var DataSet_Row_count,DataSet_Col_count;
	var DataSet_Curr_Row;
	var AddStr,Val_Get;
	var AddRow,AddCell;
	List_Row_Count=document.all.In_List_Row_Count.value;
	QuerySKUData(ActionFlag);
	if (List_Row_Count!=document.all.In_List_Row_Count.value){
		List_Row_Count=document.all.In_List_Row_Count.value;
		DataSet_Row_count = document.all.DataSetTable.rows.length;
		DataSet_Curr_Row = document.all.DataSetTable.rows(DataSet_Row_count-1);
		DataSet_Col_count = DataSet_Curr_Row.cells.length;
		AddCell = DataSet_Curr_Row.cells(DataSet_Col_count-1);
		AddStr="<input type=hidden name='In_List_" + List_Row_Count + "_to_facility_Id' value='F"+ document.all.To_Party_Id.value+"'>";
		AddCell.insertAdjacentHTML("AfterBegin",AddStr);
		Val_Get = document.all["In_List_"+ List_Row_Count + "_location_id"].value;
		AddStr="<input type=hidden name='In_List_" + List_Row_Count + "_to_location_id' value='F"+ document.all.To_Party_Id.value+"_"+Val_Get.substr(Val_Get.length-1)+ "'>";
		AddCell.insertAdjacentHTML("AfterBegin",AddStr);
	}
}