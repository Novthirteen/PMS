/*
  Validation file for all Javascript Validations
*/
//#######################################################
function fnSubmit2(start,first,curr,nolink,pgCnt)
 {
	var Cnt,ModCnt;
	if (curr<=0)
	{
		alert("Please enter a valid Page No");
		return ;
	}
	else if (curr>pgCnt)
	{
		alert("Page No is more than total no of pages");
		return ;
	}
	else
	{ 
		Cnt=parseInt(curr/nolink);
		
		if (curr<=5)
		{
		  document.frm1.startpage.value=1
		  document.frm1.firstpage.value=1
		  document.frm1.currpage.value=curr
		}    
    
		if (Cnt>=1 && curr>5)
		{
		  ModCnt=curr%5;
		  if (ModCnt==0)
		  {
			 document.frm1.startpage.value=(nolink*(Cnt-1))+1;
			 document.frm1.firstpage.value=(nolink*(Cnt-1))+1;
		  }
		  else
		  {
			 document.frm1.startpage.value=(nolink*Cnt)+1;
			 document.frm1.firstpage.value=(nolink*Cnt)+ 1;
		  }
		  document.frm1.currpage.value=curr;
		  
		}
	}
   //alert(document.frm1.startpage.value);
   //alert(document.frm1.firstpage.value);
   //alert(document.frm1.currpage.value);
  document.frm1.submit()
 }
 //#############################################################
 
//FUNCTION FOR TEXT WITH SPECIAL CHARACTERS
//#########################################

function checkTextWithSpChar(field,falert,mandateflag,fieldName)
{		
     	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
        
	field.value = field.value.replace(/[\'\"\&\!\|\?\#\=\>\<\%\~\\]/g,'');
	removeMultiSpaces(field);
		
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if
	else
	{
		return true;	
	}//end of else
}


//FUNCTION FOR TEXT WITH NO SPECIAL CHARACTERS
//############################################

function checkTextWithNoSpChar(field,falert,mandateflag,fieldName)
{	

	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
        field.value = field.value.replace(/[^a-z0-9\s\.]/gi,'');
	removeMultiSpaces(field);
	
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if
	else
	{
		return true;	
	}
}


//ALLOWS NUMBER ALPHABETS AND UNDERSCORE
function checkTextWithNoSpCharDb(field,falert,mandateflag,fieldName)
{	
 
	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
        field.value = field.value.replace(/[^a-z0-9_]/gi,'');
	removeMultiSpaces(field);
	
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if
	else
	{
		return true;	
	}
}


//FUNCTION FOR PINCODE
//####################

function checkZipcode(field,falert,mandateflag,fieldName)
{
  	
	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
        field.value = field.value.replace(/\s/g,'');
	
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if

	if(falert == 1 && field.value.length > 0)
	{
		var Zipexp=/[^a-z0-9]/i;
		fieldName = fieldName.charAt(0).toLowerCase()+fieldName.substring(1,fieldName.length);
		if(Zipexp.test(field.value))
		{
			alert("Not a valid " + fieldName);
			field.focus();
			return false;
		}//end of if
		else
		{
			return true;
		}
	}//end of if
}

//FUNCTION FOR PHONE AND FAX
//##########################


function checkTelFax(field,falert,mandateflag,fieldName)
{
  	
	removeMultiSpaces(field);
	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if
	
	if(falert == 1 && field.value.length > 0)
	{
		//var TelFaxexp=/[^0-9\(\)\+\,\/\-\s]/
		var TelFaxexp=/[^0-9\(\)\+\/\-\s]/
		var TF1=/\(\)/
		var TF2=/\-\-/
		var TF3=/\+\+/
		var TF4=/\,\,/
		var TF5=/\(\(/
		var TF6=/\)\)/
		var TF7=/\(\)/
		if (TelFaxexp.test(field.value) || TF1.test(field.value) 
		   || TF2.test(field.value) || TF3.test(field.value) 
		   || TF4.test(field.value) || TF5.test(field.value) 
		   || TF6.test(field.value) || TF7.test(field.value))
		{
			fieldName = fieldName.charAt(0).toLowerCase()+fieldName.substring(1,fieldName.length);
                        alert("Not a valid " + fieldName)
			field.focus();
			return false;
		}//end of if
		else
		{
			return true;
		}//end of if
		
	}//end of if
	
}

//FUNCTION FOR EMAIL
//##################

function checkEmailID(field,falert,mandateflag,fieldName)
{	
  
	field.value = field.value.replace(/[\"\'\s\&\#\?\|\=]/g,'');
        fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if
	
	if(falert == 1 && field.value.length > 0)
	{
		//declate a regular expression
		var dotexp=/\.\./
		var underscoreexp=/__/
		var Comb1=/\._/
		var Comb2=/_\./
		var Atcheck1=/@\./
		var Atcheck2=/\.@/
		var emailexp =/^[a-z][a-z_0-9\.]*@[a-z_0-9\.]*\.[a-z]{2,3}$/i
		
		if (dotexp.test(field.value) || underscoreexp.test(field.value) || Comb1.test(field.value) || 
			Comb2.test(field.value)  || Atcheck1.test(field.value) || Atcheck2.test(field.value) || 
			(!(emailexp.test(field.value))))
		{
			fieldName = fieldName.charAt(0).toLowerCase()+fieldName.substring(1,fieldName.length);
                        alert("Not a valid " + fieldName);
			field.focus()
			return false;
		}
		else
		{
			return true;
		}//end of else
	}//end of if;
}

//FUNCTION FOR DECIMAL NUMBER
//###########################

function checkDeciNumber(field,falert,mandateflag,fieldName,minNum,maxNum)
{
   
 	
	field.value=field.value.replace(/\s/g,'');
    
	field.value=field.value.replace(/[^0-9\.]/g,'');
	field.value=field.value.replace(/^0*/,'');
	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if

	if(field.value.length > 0 && falert == 1)
	{
		var exp0 = /\./;
	
		if (exp0.test(field.value))
		{
			myArray = field.value.match(exp0);
			var ant = myArray.input.substring(0, myArray.index)
			var pre = myArray.input.substring(myArray.index+1, myArray.index+3);
			
			if (exp0.test(pre))
			{
				alert("Not a valid amount");
				field.focus();
				return false;
			}
			if (pre.length == 1)
				pre= pre + "0";
			if (pre.length == 0)
				pre= "00";
			if (ant.length == 0)
				ant = "0";
			field.value = ant + "." + pre;
		}//end of if
	
		if (parseFloat(field.value) > maxNum || parseFloat(field.value) < minNum)
		{	
			alert(fieldName +" out of range (" + minNum + " to " + maxNum +")");
			field.focus();
			return false;
		}
		return true;
	}//end of if;
}

//allows zero
//###########

function checkDeciNumber1(field,falert,mandateflag,fieldName,minNum,maxNum)
{
	
	field.value=field.value.replace(/\s/g,'');
	field.value=field.value.replace(/[^0-9\.]/g,'');
	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
	
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert("You can only type number!");
		field.value="0";
		field.focus();
		//return false;
	}//end of if
   
	if(field.value.length > 0 && falert == 1)
	{
		var exp0 = /\./;
	
		if (exp0.test(field.value))
		{
			myArray = field.value.match(exp0);
			var ant = myArray.input.substring(0, myArray.index)
			var pre = myArray.input.substring(myArray.index+1, myArray.index+3);
			
			if (exp0.test(pre))
			{
				alert("Not a valid amount");
				field.focus();
				return false;
			}
			if (pre.length == 1)
				pre= pre + "0";
			if (pre.length == 0)
				pre= "00";
			if (ant.length == 0)
				ant = "0";
			field.value = ant + "." + pre;
		}//end of if
	
		if (parseFloat(field.value) > maxNum || parseFloat(field.value) < minNum)
		{	
			alert(" out of range (" + minNum + " to " + maxNum +")");
			field.focus();
			field.value="0";
		}
		return true;
	}//end of if;

}

//Allow negative values

function checkDeciNumber2(field,falert,mandateflag,fieldName,minNum,maxNum) 
{
 field.value=field.value.replace(/\s/g,'');
 field.value=field.value.replace(/[^0-9\.\-]/g,'');  
 fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
 if(field.value.length <= 0 && mandateflag == 1 && falert == 1) 
 { 
	alert(fieldName + " cannot be ignored"); 
	field.focus(); 
	return false; 
 }//end of if 
if(field.value.length > 0 && falert == 1) 
{ 
	var exp0 = /\./; 
	if (exp0.test(field.value)) 
	{ 
		myArray = field.value.match(exp0); 
		var ant = myArray.input.substring(0, myArray.index) 
		var pre = myArray.input.substring(myArray.index+1, myArray.index+3); 
		if (exp0.test(pre)) 
		{ 
			alert("Not a valid amount"); 
			field.focus(); 
			return false; 
		} 
		if (pre.length == 1) pre= pre + "0"; 
		if (pre.length == 0) pre= "00"; 
		if (ant.length == 0) ant = "0"; 
	field.value = ant + "." + pre; 
	}//end of if 
	if (parseFloat(field.value) > maxNum || parseFloat(field.value) < minNum) 
	{ 
		alert(fieldName +" out of range (" + minNum + " to " + maxNum +")"); 
		field.focus(); 
		return false; 
	} 
	return true; 
}//end of if; 
} 

//Allow negative values

function checkDeciNumber3(field,falert,mandateflag,fieldName,minNum,maxNum, pecision) 
{
 field.value=field.value.replace(/\s/g,'');
 field.value=field.value.replace(/[^0-9\.\-]/g,'');  
 fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
 if(field.value.length <= 0 && mandateflag == 1 && falert == 1) 
 { 
	alert(fieldName + " cannot be ignored"); 
	field.focus(); 
	return false; 
 }//end of if 
if(field.value.length > 0 && falert == 1) 
{ 
	var exp0 = /\./; 
	if (exp0.test(field.value)) 
	{ 
		var pec = 3;
		if (pecision != null) {
			pec = pec - 2 + pecision;
		}
		myArray = field.value.match(exp0); 
		var ant = myArray.input.substring(0, myArray.index) 
		var pre = myArray.input.substring(myArray.index+1, myArray.index+pec); 
		if (exp0.test(pre)) 
		{ 
			alert("Not a valid amount"); 
			field.focus(); 
			return false; 
		} 
		if (pre.length == 1) pre= pre + "0"; 
		if (pre.length == 0) pre= "00"; 
		if (ant.length == 0) ant = "0"; 
	field.value = ant + "." + pre; 
	}//end of if 
	if (parseFloat(field.value) > maxNum || parseFloat(field.value) < minNum) 
	{ 
		alert(fieldName +" out of range (" + minNum + " to " + maxNum +")"); 
		field.focus(); 
		return false; 
	} 
	return true; 
}//end of if; 
} 


//FUNCTION FOR DATE 
//#################

function checkDate(dateStrObj,chkWthDD,chkWthMM,chkWthYYYY,typeCheck,falert,mandateFlag,fieldName)
{

	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
        if(falert == 1 && mandateFlag == 1 && dateStrObj.value.length <= 0)
	{
		alert(fieldName + " cannot be ignored");
		//dateStrObj.focus();
		return false;
	}

	if (falert == 1 && dateStrObj.value.length > 0)
	{
		var datePat	= /^(\d{1,2})(\/)(\d{1,2})\2(\d{4})$/;
		var matchArray	= dateStrObj.value.match(datePat);

		if (matchArray == null)
		{
			alert(fieldName + " is invalid");
			//dateStrObj.focus();
			return false;
		}
	
		//parse date into variables
  		matchedDay	= matchArray[1];	
		matchedMonth	= matchArray[3];
		matchedYear 	= matchArray[4];
				
		if (matchedDay < 1 || matchedDay > 31) 
		{
			alert("Invalid day");
			//dateStrObj.focus();
			return false;
		}
		
		if (matchedMonth < 1 || matchedMonth > 12) 
		{ 
			// check month range
			alert("Invalid month");
			//dateStrObj.focus();
			return false;
		}
		
		if ((matchedMonth==4 || matchedMonth==6 || matchedMonth==9 || matchedMonth==11) && matchedDay==31) 
		{
			alert("Invalid days in that month")
			//dateStrObj.focus();
			return false
		}
		
		if (matchedMonth == 2) 
		{ 
			// check for february 29th
			var isleap = (matchedYear % 4 == 0 && (matchedYear % 100 != 0 || matchedYear % 400 == 0));
			if (matchedDay>29 || (matchedDay==29 && !isleap)) 
			{
				alert("Invalid days in that month");
				//dateStrObj.focus();
				return false;
			}
		}
		
		if (matchedYear < (chkWthYYYY-98) || matchedYear > (chkWthYYYY+98))
		{
			alert("Year should be with 98 years of range");
			//dateStrObj.focus();
			return false;
		}
		
		fromYYYY	= parseInt(matchedYear,10);
		fromMM		= parseInt(matchedMonth,10);
		fromDD		= parseInt(matchedDay,10);
	
		toDD		= parseInt(chkWthDD,10);
		toMM		= parseInt(chkWthMM,10);
		toYYYY		= parseInt(chkWthYYYY,10);

		
	        switch(typeCheck)
    		{
			case 1:
				if (validateDatewith(fromDD, fromMM, fromYYYY, toDD, toMM, toYYYY, 1))
					return true;
				else
					alert(fieldName + " should be less than system date");
				//dateStrObj.focus();
				return false;
				break;
			case 2:
				if (validateDatewith(fromDD, fromMM, fromYYYY, toDD, toMM, toYYYY, 1) || validateDatewith(fromDD, fromMM, fromYYYY, toDD, toMM, toYYYY, 2))
					 return true;
				else
					alert(fieldName + " should be less than or equal to system date");
				//dateStrObj.focus();
				return false;
				break;
			case 3:
				if (validateDatewith(fromDD, fromMM, fromYYYY, toDD, toMM, toYYYY, 2))
					return true;
				else
					alert(fieldName + " should be equal to system date");
				//dateStrObj.focus();
				return false;
				break;
			case 4:
				if (validateDatewith(fromDD, fromMM, fromYYYY, toDD, toMM, toYYYY, 3) || validateDatewith(fromDD, fromMM, fromYYYY, toDD, toMM, toYYYY, 2))
					return true;
				else
					alert(fieldName + " should be greater than or equal to system date");
				//dateStrObj.focus();
				return false;
				break;
			case 5:
				if (validateDatewith(fromDD, fromMM, fromYYYY, toDD, toMM, toYYYY, 3))
					return true;
				else
					alert(fieldName + " should be greater than system date");
				//dateStrObj.focus();
				return false;
				break;
			case 6:
				return true;
				break;
			default:
				alert("Invalid type of checking");
				return false;
    		}//end of switch

	}//end of if

}

function checkDate1(dateStrObj,chkWthDD,chkWthMM,chkWthYYYY,typeCheck,falert,mandateFlag,fieldName)
{
  	
	if (falert == 1 && dateStrObj.value.length > 0)
	{
		var datePat	= /^(\d{1,2})(\/)(\d{1,2})\2(\d{4})$/;
		var matchArray	= dateStrObj.value.match(datePat);

		if (matchArray == null)
		{
			alert(fieldName + " is invalid");
			dateStrObj.focus();
			return false;
		}
	
		//parse date into variables
  		matchedDay	= matchArray[1];	
		matchedMonth	= matchArray[3];
		matchedYear 	= matchArray[4];
				
		if (matchedDay < 1 || matchedDay > 31) 
		{
			alert("Invalid day");
			dateStrObj.focus();
			return false;
		}
		
		if (matchedMonth < 1 || matchedMonth > 12) 
		{ 
			// check month range
			alert("Invalid month");
			dateStrObj.focus();
			return false;
		}
		
		if ((matchedMonth==4 || matchedMonth==6 || matchedMonth==9 || matchedMonth==11) && matchedDay==31) 
		{
			alert("Invalid days in that month")
			dateStrObj.focus();
			return false
		}
		
		if (matchedMonth == 2) 
		{ 
			// check for february 29th
			var isleap = (matchedYear % 4 == 0 && (matchedYear % 100 != 0 || matchedYear % 400 == 0));
			if (matchedDay>29 || (matchedDay==29 && !isleap)) 
			{
				alert("Invalid days in that month");
				dateStrObj.focus();
				return false;
			}
		}
		
		if (matchedYear < (chkWthYYYY-98) || matchedYear > (chkWthYYYY+98))
		{
			alert("Year should be with 98 years of range");
			dateStrObj.focus();
			return false;
		}
		
		fromYYYY	= parseInt(matchedYear,10);
		fromMM		= parseInt(matchedMonth,10);
		fromDD		= parseInt(matchedDay,10);
		toDD		= parseInt(chkWthDD,10);
		toMM		= parseInt(chkWthMM,10);
		toYYYY		= parseInt(chkWthYYYY,10);

		var fromDate = new Date(fromYYYY,fromMM-1,fromDD);
    		var toDate   = new Date(toYYYY,toMM-1,toDD);

        	fromDate	= fromDate.valueOf();
		toDate		= toDate.valueOf();

	        switch(typeCheck)
    		{
			case 1:
				if (validateDatewith(fromDD, fromMM, fromYYYY, toDD, toMM, toYYYY, 1))
					return true;
				else
					alert(fieldName + " should be less than system date");
				dateStrObj.focus();
				return false;
				break;
			case 2:
				if (validateDatewith(fromDD, fromMM, fromYYYY, toDD, toMM, toYYYY, 1) || validateDatewith(fromDD, fromMM, fromYYYY, toDD, toMM, toYYYY, 2))
					 return true;
				else
					alert(fieldName + " should be less than or equal to system date");
				dateStrObj.focus();
				return false;
				break;
			case 3:
				if (validateDatewith(fromDD, fromMM, fromYYYY, toDD, toMM, toYYYY, 2))
					return true;
				else
					alert(fieldName + " should be equal to system date");
				dateStrObj.focus();
				return false;
				break;
			case 4:
				if (validateDatewith(fromDD, fromMM, fromYYYY, toDD, toMM, toYYYY, 3) || validateDatewith(fromDD, fromMM, fromYYYY, toDD, toMM, toYYYY, 2))
					return true;
				else
					alert(fieldName + " should be greater than or equal to system date");
				dateStrObj.focus();
				return false;
				break;
			case 5:
				if (validateDatewith(fromDD, fromMM, fromYYYY, toDD, toMM, toYYYY, 3))
					return true;
				else
					alert(fieldName + " should be greater than system date");
				dateStrObj.focus();
				return false;
				break;
			case 6:
				return true;
				break;
			default:
				alert("Invalid type of checking");
				return false;
    		}//end of switch
    		
	}//end of if
    return true;
}

//checking the date range
//#######################

function validateDatewith(fromDay, fromMonth, fromYear, toDay, toMonth, toYear, typeCheck)
{
	switch (typeCheck)
	{
		case 1:  // from date lessthan to date
		{
			if (fromYear > toYear)
				return false;
			else if(fromYear == toYear)
			{
				if(fromMonth > toMonth)
					return false;
				else if(fromMonth == toMonth)
				{
					if(fromDay > toDay)
						return false;
					else 
						return true;
				}
				else
					return true;
			}
			else
				return true;

			break;

		}//end of case1

		case 2:  // from date equal to to date
		{
			if(fromYear == toYear && fromMonth == toMonth && fromDay == toDay)
				return true;
			else
				return false
			break;

		}//end of case2

		case 3:  // from date greaterthan to date
		{
			if (fromYear < toYear)
				return false;
			else if(fromYear == toYear)
			{
				if(fromMonth < toMonth)
					return false;
				else if(fromMonth == toMonth)
				{
					if(fromDay < toDay)
						return false;
					else 
						return true;
				}
				else
					return true;
			}
			else
				return true;

			break;

		}//end of case3
		
	}//end of switch
}


function checkDateRange(fromDate,toDate,toFieldName,fromFieldName,typeCheck)
{
	if(!checkIsValidDate(fromDate, fromFieldName))
	{
		return false;
	}
	if(!checkIsValidDate(toDate, toFieldName) && typeCheck != 6)
	{
		return false;
	}
	
	var datePat  = /^(\d{1,2})(\/)(\d{1,2})\2(\d{4})$/;
	matchArray1  = fromDate.match(datePat); 
	matchArray2  = toDate.match(datePat);

	fromMonth    = parseInt(matchArray1[3],10); // parse date into variables
	fromDay      = parseInt(matchArray1[1],10);
	fromYear     = parseInt(matchArray1[4],10);

	toMonth      = parseInt(matchArray2[3],10); // parse date into variables
	toDay        = parseInt(matchArray2[1],10);
	toYear       = parseInt(matchArray2[4],10);	
	
	//var fromDate = new Date(fromYear,fromMonth,fromDay);
    	//var toDate   = new Date(toYear,toMonth,toDay);

	//fromDate	= fromDate.valueOf();
	//toDate		= toDate.valueOf();

	switch(typeCheck)
    	{
			case 1:
				if (validateDatewith(fromDay, fromMonth, fromYear, toDay, toMonth, toYear, 1))
					return true;
				else
					alert(fromFieldName + " value should be less than "+ toFieldName);
					return false;
				break;
			case 2:
				if (validateDatewith(fromDay, fromMonth, fromYear, toDay, toMonth, toYear, 1) || validateDatewith(fromDay, fromMonth, fromYear, toDay, toMonth, toYear, 2))
					 return true;
				else
					alert(fromFieldName + " value should be less than or equal to "+ toFieldName);
				return false;
				break;
			case 3:
				if (validateDatewith(fromDay, fromMonth, fromYear, toDay, toMonth, toYear, 2))
					return true;
				else
					alert(fromFieldName + " value should be equal to "+ toFieldName);
				return false;
				break;
			case 4:
				if (validateDatewith(fromDay, fromMonth, fromYear, toDay, toMonth, toYear, 3) || validateDatewith(fromDay, fromMonth, fromYear, toDay, toMonth, toYear, 2))
					return true;
				else
					alert(fromFieldName + " value should be greater than or equal to "+ toFieldName);
				return false;
				break;
			case 5:
				if (validateDatewith(fromDay, fromMonth, fromYear, toDay, toMonth, toYear, 3))
					return true;
				else
					alert(fromFieldName + " value should be greater than "+ toFieldName);
				return false;
				break;
			case 6:
				return true;
				break;
			default:
				alert("Invalid type of checking");
				return false;
    	}//end of switch

	return true;
}


function checkIsValidDate(dateStr,fieldName)
{
	var datePat = /^(\d{1,2})(\/)(\d{1,2})\2(\d{4})$/;
	var matchArray = dateStr.match(datePat); // is the format ok?
    	if (matchArray == null)
	{
		alert(fieldName + " is not valid")
       		return false;
    	}
    
    	// parse date into variables
  	day = matchArray[1];	
	month = matchArray[3];
    	year = matchArray[4];
    
    	if (month < 1 || month > 12) 
    	{ 
		// check month range
        	alert(fieldName + " month must be selected");
        	return false;
    	}
 
    	if (day < 1 || day > 31) 
    	{
		alert(fieldName + " day must be selected");
        	return false;
    	}

    	if ((month==4 || month==6 || month==9 || month==11) && day==31) 
    	{
		alert(fieldName + " month " + month + " doesn't have 31 days!")
        	return false
    	}

    	if (month == 2) 
    	{ 
		// check for february 29th
        	var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
        	if (day>29 || (day==29 && !isleap)) 
        	{
			alert(fieldName + " february " + year + " doesn't have " + day + " days!");
            		return false;
        	}
    	}
    
	// date is valid
    	return true;
}

//FUNCTION FOR TEXTAREA
//#####################

function checkTextArea(field,maxN,falert,mandateflag,fieldName)
{
 	field.value = field.value.replace(/[^()*+-.$/0123456789:;@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]\^_abcdefghijklmnopqrstuvwxyz ]/g,'');
        removeMultiSpaces(field);
	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if

	if(field.value.length > maxN && falert == 1)
	{

		var check = (confirm("Remarks: " + fieldName + " exceeded " + maxN + " characters. Excess will be truncated"));
		if (check == true)
		{
			field.value = field.value.substr(0,maxN);
			return true;
		}
		else
		{
			field.focus();
			return false;
		}//end of else
	}//end of if	
	else
		return true;
}


//FUNCTION FOR TEXTAREA1
//#####################

function checkTextArea1(field,maxN,falert,mandateflag,fieldName)
{
 	field.value = field.value.replace(/[^()<>!='*+-.$/0123456789:;@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]\^_abcdefghijklmnopqrstuvwxyz ]/g,'');
        removeMultiSpaces(field);
	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if

	if(field.value.length > maxN && falert == 1)
	{

		var check = (confirm("Remarks: " + fieldName + " exceeded " + maxN + " characters. Excess will be truncated"));
		if (check == true)
		{
			field.value = field.value.substr(0,maxN);
			return true;
		}
		else
		{
			field.focus();
			return false;
		}//end of else
	}//end of if	
	else
		return true;
}


function checkTextArea2(field,maxN,falert,mandateflag,fieldName)
{
 	field.value = field.value.replace(/[^()=,< '*>+-.$/0123456789:;@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]\^_abcdefghijklmnopqrstuvwxyz ]/g,'');
        removeMultiSpaces(field);
	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if

	if(field.value.length > maxN && falert == 1)
	{

		var check = (confirm("Remarks: " + fieldName + " exceeded " + maxN + " characters. Excess will be truncated"));
		if (check == true)
		{
			field.value = field.value.substr(0,maxN);
			return true;
		}
		else
		{
			field.focus();
			return false;
		}//end of else
	}//end of if	
	else
		return true;
}

//FUNCTION FOR NUMBER
//###################

function checkIntNumber(field,falert,mandateflag,fieldName,minNum,maxNum)
{
  
	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
        field.value=field.value.replace(/\s/g,'');
	field.value=field.value.replace(/[^0-9\.]/g,'');
	field.value=field.value.replace(/^0*/,'');
	
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if
	if (falert == 1 && field.value.length > 0)
	{
		var exp = /\./;
	
		if (exp.test(field.value))
		{
			alert("Not a valid number");
			field.focus();
			return false;
		}
		
		if (parseInt(field.value,10) > maxNum || parseInt(field.value,10)< minNum)
		{	
			alert(fieldName + " out of range (" + minNum + " to " + maxNum +")");
			field.focus();
			return false;
		}
                return true;
	}//end of if;
}

//alows zero
//##########

function checkIntNumber1(field,falert,mandateflag,fieldName,minNum,maxNum)
{	
  	
	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
        field.value=field.value.replace(/\s/g,'');
	field.value=field.value.replace(/[^0-9\.]/g,'');
	
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if
		
	if (falert == 1 && field.value.length > 0)
	{
		var exp = /\./;
	
		if (exp.test(field.value))
		{
			alert("Not a valid number");
			field.focus();
			return false;
		}
		
		if (parseInt(field.value,10) > maxNum || parseInt(field.value,10)< minNum)
		{	
			alert(fieldName + " out of range (" + minNum + " to " + maxNum +")");
			field.focus();
			return false;
		}
		
		return true;
	}//end of if;
}


function checkIntNumber2(field,falert,mandateflag,fieldName,minNum,maxNum)
{

	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
        field.value=field.value.replace(/\s/g,'');
	field.value=field.value.replace(/[^0-9\.]/g,'');
	field.value=field.value.replace(/^0*/,'');
	
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if
	if (falert == 1 && field.value.length > 0)
	{
		var exp = /\./;
	
		if (exp.test(field.value))
		{
			alert("Not a valid number");
			field.focus();
			return 1;
		}
		
		if (parseInt(field.value,10) > maxNum || parseInt(field.value,10)< minNum)
		{	
			alert(fieldName + " out of range (" + minNum + " to " + maxNum +")");
			field.focus();
			return 1;
		}
                return 0;
	}//end of if;
}

function addComma(field, inD, outD, sep)
{
	var nStr = field.value;
	nStr += '';
	var dpos = nStr.indexOf(inD);
	var nStrEnd = '.00';
	if (dpos != -1) {
		nStrEnd = outD + nStr.substring(dpos + 1, nStr.length);
		nStr = nStr.substring(0, dpos);
	}
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(nStr)) {
		nStr = nStr.replace(rgx, '$1' + sep + '$2');
	}

	field.value = (nStr + nStrEnd);

}

function removeComma(obj) {
	if (obj != null) {
		obj.value = obj.value.replace(/,/g, "");
	}
}

//This method checks the list box for value selected
//##################################################

function checkSelectBox(field,fieldName)
{
 
	if(field.selectedIndex <= 0||field[field.selectedIndex].value=='$')
	{
		var response = "Choose a " +' ' + fieldName ;
		alert(response);
		field.focus();
		return false;
	}
	else
	{
		return true;
	}
}



function checkMultiSelectBox(field,fieldName)
{
 
	if(field.selectedIndex <= 0)
	{
		var response = "Choose a " +' ' + fieldName ;
		alert(response);
		//field[0].selected=true;
		return false;
	}
	else
	{
		return true;
	}
}

//This method checks the url 
//##########################

function checkURL(field,falert,mandateflag,fieldName)
{	
 
	field.value = field.value.replace(/[^a-z0-9\&\_\.\?\-\#\=\+\/]/gi,'');
	removeMultiSpaces(field);
	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if
	else
	{
		return true;	
	}
}

//COMMON FUNCTION
//###############

function removeMultiSpaces(field)
{
	var remexp=/[\s][\s]+/	
	var trimexp1=/^[\s].*[\s]$/
	var trimexp2=/.*[\s]$/
	var trimexp3=/^[\s].*$/
	while(remexp.test(field.value))
	{
		field.value=field.value.replace(/[\s][\s]+/," ")
	}
	if(trimexp1.test(field.value))
	{
		field.value=field.value.substr(1,(field.value.length-2))	
	}	
	if(trimexp2.test(field.value))
	{
		field.value=field.value.substr(0,field.value.length-1)	
	}	
	if(trimexp3.test(field.value))
	{
		field.value=field.value.substr(1,field.value.length)	
	}	
}

//Making round of number
//######################

function makeRoundOff(value)
{
        value = "" + value //convert value to string
        precision = 2;
	var result;

        var whole = "" + Math.round(value * Math.pow(10, precision));

        var decPoint = whole.length - precision;

        if(decPoint != 0)
        {
                result = whole.substring(0, decPoint);
                result += ".";
                result += whole.substring(decPoint, whole.length);
        }
        else
        {
                result = whole;
        }
        return result;
} 


//###########Added by ABK to check for selection in a group of radio buttons and list box
//###########pass mode=0 for group of radio buttons and other for list box

function checkRadioOption(field,fieldName,mode)
{
  	var count = 0;
  	var fldType;
  
	if(mode == 0)
  	{
   		fldType = "field[i].checked"
  	}
  	else
  	{
   		fldType = "field[i].selected"
  	}
  	
	for(var i=0; i<field.length; i++)
  	{
    		if(eval(fldType))
    		{
     			count++;
    		} 
  	}

  	if(count <= 0)
  	{	
    		var response = "Choose a " +' ' + fieldName ;
    		alert(response);
    	
		if(mode == 0)
    		{
     			field[0].focus();
    		}
    		else
    		{
     			field.focus();
    		}
    		return false;
  	}
  	else
  	{
    		return true;
  	}
}

//Function for code and Name
//FUNCTION FOR TEXT WITH NO SPECIAL CHARACTERS
//############################################

function checkTextWithNoSpChar1(field,falert,mandateflag,fieldName)
{
  	field.value = field.value.replace(/[^a-z0-9\s]/gi,'');
  	removeMultiSpaces(field);
  
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
  	{
    		alert(fieldName + " cannot be ignored");
    		field.focus();
    		return false;
  	}//end of if
  	else
  	{
    		return true;	
  	}
}

//function to check all the elements on click of top check box 
//and uncheck them on click of top check box
//###########################################

function checkUncheckAllBox(topBox,checkBox)
{
  	if(topBox.checked)
  	{
    		
    	if (checkBox != null) {
			if(checkBox.length)
	    		{
	     			for(var i=0; i<checkBox.length; i++)
	     			{
	     			    if(checkBox[i].disabled==false)
	     			    {
	       				 checkBox[i].checked = true;
	       				} 
	     			}   
	    		}
	    		else
	    		{
	       			checkBox.checked = true;
	    		}
	    }
  	}
  	else
  	{
    		 
    	if (checkBox != null) {  
			if(checkBox.length)
	    		{
	      			for(var i=0; i<checkBox.length; i++)
	      			{
	      			    if(checkBox[i].disabled==false)
	      			    {
	      				 checkBox[i].checked = false;
	      				} 
	      			}   
	    		}
	    		else
	    		{
	      			checkBox.checked = false;
	    		}
	    }
 	}
}

//#######Function to change the checked property of the top box based on the status of all the other check boxes
//###############################################################################################################

function checkTopBox(topBox,checkBox)
{
    if(checkBox.length)
  	{
    		var count=0;
    		for(var i=0;i<checkBox.length;i++)
    		{
      			if(checkBox[i].checked==true)
      			{
        			count++;
      			}
    		}
    
		if(count==checkBox.length && topBox.checked==false)
    		{
       			topBox.checked=true
       		}
    		else
    		{
       			topBox.checked=false
       		}
  	}
  	else
  	{
    
    		if(checkBox.checked && topBox.checked==false)
    		{
      			topBox.checked=true;
       		}
    		if(checkBox.checked==false && topBox.checked)
    		{
    		  topBox.checked=false;
    		}
  	}
}


//####on body load change the status of top check box based on the status of all other check boxes
//#################################################################################################

function checkTopOnLoad(topBox,element)
{
  	var count=0;
  
	if(element.length)
  	{
    		var count=0;
    		
		for(var i=0;i<element.length;i++)
    		{
      			if(element[i].checked==true)
      			{
        			count++;
      			}
    		}
    
		if(count==element.length && topBox.checked==false)
    		{
       			topBox.checked=true
       			if(topBox.title)
       			{
         			topBox.title='Check to unselect all'
       			}
    		}
  	}
  	else
  	{
    		if(element.checked && topBox.checked==false)
    		{
      			topBox.checked=true;
      			if(topBox.title)
       			{
         			topBox.title='Check to unselect all'
       			}
    		}
  	}
}

//####to refresh the page on click of back button in case of dynamic add operations
//##################################################################################

function bdload()
{
 	if(parseInt(document.frm1.hid1.value,10)>0)
 	{
  		document.frm1.hid1.value='0';
  		window.location.reload(true);
 	}
}

//####to dynamically populate another list box on change of the option in another box
//populate the value of the option of first checkbox using firstbox.value!secondbox.value,secondbox.desc|.....|
//################################################################################################################

function changeOption(firstbox,secondbox,name)
{
 if(firstbox.selectedIndex!=0)
 {
   var test=new Array();
   test=firstbox[firstbox.selectedIndex].value.split("!");
   if(test[1]=="")
   {
     secondbox.length=1;
     secondbox.options[0].value='$'
     secondbox.options[0].text="All Countries" 
   }
   else
   {
    var test1=test[1].split("|");
    secondbox.length=test1.length;
    //secondbox.selectedIndex=0;
    secondbox.options[0].value='$'
    secondbox.options[0].text="All Countries" 
    for(var i=0;i<test1.length-1;i++)
    {
     var test2=test1[i].split(",")
     secondbox.options[i+1].value=test2[0]
     secondbox.options[i+1].text=test2[1] 
    }
   }
 }
 else
 {
  secondbox.length=1;
  secondbox.options[0].value='$'
  secondbox.options[0].text="All Countries" 
 }
}



//####to dynamically populate another list box on change of the option in another box
//populate the value of the option of first checkbox using firstbox.value!secondbox.value,secondbox.desc|.....|
//################################################################################################################
//takes in the parameters as the delimiter first entry, it's value & second entry it's value(optional - pass the empty string)
function changeOptionGeneric(firstbox,secondbox, delimiter, delimiter2, delimiter3, FirstEntry,FirstEntryValue,SecondEntry,SecondEntryValue)
{
 if(firstbox.selectedIndex!=0)
 {
   var test=new Array();
     if (SecondEntry!="" && FirstEntry!="")
     {
       secondbox.length=2;
       secondbox.options[0].value=FirstEntryValue
       secondbox.options[0].text=FirstEntry
       secondbox.options[0].value=SecondEntryValue
       secondbox.options[0].text=SecondEntry
     }
     else if (FirstEntry!="")
     {
       secondbox.length=1;
       secondbox.options[0].value=FirstEntryValue
       secondbox.options[0].text=FirstEntry 
     }
   test=firstbox[firstbox.selectedIndex].value.split(delimiter);
   if(test[1]!="")
   {
    var test1=test[1].split(delimiter2);
    secondbox.length=test1.length;
    for(var i=0;i<test1.length-1;i++)
    {
     var test2=test1[i].split(delimiter3)
     secondbox.options[i+1].value=test2[0]
     secondbox.options[i+1].text=test2[1] 
    }
   }
 }
}


//####to dynamically populate another list box on change of the option in another box (for multiple selection in first listbox)
//populate the value of the option of first checkbox using firstbox.value!secondbox.value,secondbox.desc|.....|
//################################################################################################################

function changeOptionMultiple(firstbox,secondbox,name)
{
	var optCodeArr = new Array();
	var optDescArr = new Array();
	
	optCodeArr[0] = -1;
	optDescArr[0] = "Choose the users";
		
	var a = 1;
	var count = 0;
	
	for(i=1;i<firstbox.length;i++)
	{
		if(firstbox.options[i].selected == true)	
		{		  
			var test = firstbox.options[i].value.split("!");
//			alert(test)
			firstbox.options[i].value = test[0];
		
			var best = test[1].split("|");
			for (k=0;k<best.length-1;k++)
			{
				var west = best[k].split(",");
				optCodeArr[a] = west[0];
				optDescArr[a] = west[1];
				a++;
			}
		}
	}
	
	var len = optCodeArr.length;
	secondbox.length = 0;
	secondbox.length = len;
	
	for (var j=0; j<len; j++)
	{
		secondbox[j].value = optCodeArr[j];
		secondbox[j].text = optDescArr[j];
	}
	secondbox[0].selected = true;
	
}



//###################################################On change of radio
function changeOption1(firstbox,secondbox,name)
{
   var test=new Array();
   test=firstbox.value.split("!");
   if(test[1]=="")
   {
     secondbox.length=1;
     secondbox.options[0].value=''
     secondbox.options[0].text="Choose a "+name 
   }
   else
   {
    var test1=test[1].split("|");
    secondbox.length=test1.length;
    secondbox.selectedIndex=0;
    secondbox.options[0].value=''
    secondbox.options[0].text="Choose a "+name 
    for(var i=0;i<test1.length-1;i++)
    {
     var test2=test1[i].split(",")
     secondbox.options[i+1].value=test2[0]
     secondbox.options[i+1].text=test2[1] 
    }
   }
}

//############Variation
function changeOption2(firstbox,secondbox,name)
{
   var test=new Array();
   test=firstbox.value.split("!");
   if(test[1]=="")
   {
     secondbox.length=1;
     secondbox.options[0].value=''
     secondbox.options[0].text="Choose a "+name 
   }
   else
   {
    var test1=test[1].split("|");
    secondbox.length=test1.length;
    secondbox.selectedIndex=0;
    secondbox.options[0].value=''
    secondbox.options[0].text="Choose a "+name 
    for(var i=0;i<test1.length-1;i++)
    {
     var test2=test1[i].split("#")
     secondbox.options[i+1].value=test2[0]
     secondbox.options[i+1].text=test2[1] 
    }
   }
}
//############################################changeOption3 function#########
function changeOption3(firstbox,secondbox,name)
{
   if(firstbox.value!="")
   {
    var test=new Array();
    test=firstbox.value.split("!");
    if(test[1]=="")
    { 
     secondbox.length=0
     secondbox.length=1;
     secondbox.options[0].value=''
     secondbox.options[0].text="Select.."
     //secondbox.options[1].value='$'
     //secondbox.options[1].text="(new)" 
    }
    else
    {
     var test1=test[1].split("|");
     secondbox.length=0;
     secondbox.length=test1.length;
     secondbox.selectedIndex=0;
     secondbox.options[0].value=''
     secondbox.options[0].text="Select..."
     //secondbox.options[1].value='$'
     //secondbox.options[1].text="(new)" 
     for(var i=0;i<test1.length-1;i++)
     {
      var test2=test1[i].split("#")
      secondbox.options[i+1].value=test2[0]
      secondbox.options[i+1].text=test2[1] 
     }
    }
   }
   else
   {
    secondbox.length=0
    secondbox.length=1;
    secondbox.options[0].value=''
    secondbox.options[0].text="Select.."
   } 
}

//#####################################################################
//to change the value of the first box in case of dynamic population
//#####################################################################

function changeValue(optionBox)
{
  var test=optionBox[optionBox.selectedIndex].value.split("!");
  optionBox[optionBox.selectedIndex].value=test[0];
}

//to handle the esc key press in a text field to prevent it from clearing the text field
//#######################################################################################

function deescback()
{
 if(event.keyCode == 13)
  return false;
}

//###################################################################

function checkTextWithNoSpChar1(field,falert,mandateflag,fieldName)
{	
 field.value = field.value.replace(/[^a-z0-9\s\.-]/gi,'');
 removeMultiSpaces(field);
 fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
 if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
 {
  alert(fieldName + " cannot be ignored");
  field.focus();
  return false;
 }//end of if
 else
 {
  return true;	
 }
}

//###################################################################

function checkTextWithNoSpChar2(field,falert,mandateflag,fieldName)
{
  field.value = field.value.replace(/[^a-z0-9]/gi,'');
  //field.value=field.value.replace(/[^&#*$]/gi,'');
  removeMultiSpaces(field);
  fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
  if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
  {
   alert(fieldName + " cannot be ignored");
   field.focus();
   return false;
  }//end of if
  else
  {
   return true;	
  } 
}

//####################################################################

function checkTextWithNoSpChar3(field,falert,mandateflag,fieldName)
{
  field.value = field.value.replace(/[^a-z\_\-0-9]/gi,'');
  removeMultiSpaces(field);
  fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
  if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
  {
   alert(fieldName + " cannot be ignored");
   field.focus();
   return false;
  }//end of if
  else
  {
   return true;	
  } 
}


//####################################################################

function checkTextWithNoSpChar4(field,falert,mandateflag,fieldName)
{
  field.value = field.value.replace(/[^a-z0-9]/gi,'');
  removeMultiSpaces(field);
  fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
  if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
  {
   alert(fieldName + " cannot be ignored");
   field.focus();
   return false;
  }//end of if
  else
  {
   return true;	
  } 
}



function getParameter(by)
{
	str  = window.document.location.search.split("?");
	str1 = str[1].split("&");
	
	switch(by)
	{
		case 1:
			return paramSplit(str1[0]);
		
		default:
		{
			var n = by - 1;
			return paramSplit(str1[n]);
		}
	}
}

function paramSplit(param)
{
	par = param.split("=");
	return par[1];	
}
//###################################################################
function checkTextWithNoSpChar5(field,falert,mandateflag,fieldName)
{
  field.value = field.value.replace(/[^a-z0-9]/gi,'');
  var regexp=/[a-zA-Z]/;
  removeMultiSpaces(field);
  fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
  if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
  {
   alert(fieldName + " cannot be ignored");
   field.focus();
   return false;
  }//end of if
  if((!regexp.test(field.value.charAt(0))) && falert==1 && mandateflag==1)
  {
    alert(fieldName + " is invalid");
    field.focus();
    return false;
  }
  return true
}
//#######################################################################
function checkTextWithNoSpChar6(field,falert,mandateflag,fieldName)
{

  field.value = field.value.replace(/[^0-9\s]/gi,'');
  removeMultiSpaces(field);
  fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
  if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
  {
   alert(fieldName + " cannot be ignored");
   field.focus();
   return false;
  }//end of if
  else
  {
   return true;	
  } 
}
//#######################################################################
function checkTextWithSpChar7(field,falert,mandateflag,fieldName)
{		
     	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
        field.value = field.value.replace(/[\']/g,'');
	removeMultiSpaces(field);
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if
	else
	{
		return true;	
	}//end of else
}
//#####################################################################################
//#####################################################################################
function checkDate2(dateStrObj,chkWthDD,chkWthMM,chkWthYYYY,typeCheck,falert,mandateFlag,fieldName)
{
  	
	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
        /*if(falert == 1 && mandateFlag == 1 && dateStrObj.value.length <= 0)
	{
		alert(fieldName + " cannot be ignored");
		//dateStrObj.focus();
		return false;
	}*/

	if (falert == 1 && dateStrObj.value.length > 0)
	{
		var datePat	= /^(\d{1,2})(\/)(\d{1,2})\2(\d{4})$/;
		var matchArray	= dateStrObj.value.match(datePat);

		if (matchArray == null)
		{
			alert(fieldName + " is invalid");
			//dateStrObj.focus();
			return false;
		}
		//parse date into variables
  		matchedDay	= matchArray[1];	
		matchedMonth	= matchArray[3];
		matchedYear 	= matchArray[4];
		if (matchedDay < 1 || matchedDay > 31) 
		{
			alert("Invalid day");
			//dateStrObj.focus();
			return false;
		}
		if (matchedMonth < 1 || matchedMonth > 12) 
		{ 
			// check month range
			alert("Invalid month");
			//dateStrObj.focus();
			return false;
		}
		if ((matchedMonth==4 || matchedMonth==6 || matchedMonth==9 || matchedMonth==11) && matchedDay==31) 
		{
			alert("Invalid days in that month")
			//dateStrObj.focus();
			return false
		}
		if (matchedMonth == 2) 
		{ 
			// check for february 29th
			var isleap = (matchedYear % 4 == 0 && (matchedYear % 100 != 0 || matchedYear % 400 == 0));
			if (matchedDay>29 || (matchedDay==29 && !isleap)) 
			{
				alert("Invalid days in that month");
				//dateStrObj.focus();
				return false;
			}
		}
		if (matchedYear < (chkWthYYYY-98) || matchedYear > (chkWthYYYY+98))
		{
			alert("Year should be with 98 years of range");
			//dateStrObj.focus();
			return false;
		}
		
		fromYYYY	= parseInt(matchedYear,10);
		fromMM		= parseInt(matchedMonth,10);
		fromDD		= parseInt(matchedDay,10);
	
		toDD		= parseInt(chkWthDD,10);
		toMM		= parseInt(chkWthMM,10);
		toYYYY		= parseInt(chkWthYYYY,10);
	
		var fromDate = new Date(fromYYYY,fromMM-1,fromDD);
    		var toDate   = new Date(toYYYY,toMM-1,toDD);
                           
		fromDate	= fromDate.valueOf();
		toDate		= toDate.valueOf();
                if(fromDate < toDate)
                {
                      return 1;
                }
            } 
}
//#####################################################################################
//#####################################################################################

function checkDeciNumber(field,falert,mandateflag,fieldName,minNum,maxNum)
{
   
 	
	field.value=field.value.replace(/\s/g,'');
       

	field.value=field.value.replace(/[^0-9\.]/g,'');
	field.value=field.value.replace(/^0*/,'');
	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if

	if(field.value.length > 0 && falert == 1)
	{
		var exp0 = /\./;
	
		if (exp0.test(field.value))
		{
			myArray = field.value.match(exp0);
			var ant = myArray.input.substring(0, myArray.index)
			var pre = myArray.input.substring(myArray.index+1, myArray.index+3);
			
			if (exp0.test(pre))
			{
				alert("Not a valid amount");
				field.focus();
				return false;
			}
			if (pre.length == 1)
				pre= pre + "0";
			if (pre.length == 0)
				pre= "00";
			if (ant.length == 0)
				ant = "0";
			field.value = ant + "." + pre;
		}//end of if
	
		if (parseFloat(field.value) > maxNum || parseFloat(field.value) < minNum)
		{	
			alert(fieldName +" out of range (" + minNum + " to " + maxNum +")");
			field.focus();
			return false;
		}
		return true;
	}//end of if;
}


function checkDeciNumber2(field,falert,mandateflag,fieldName,minNum,maxNum)
{
 	
	field.value=field.value.replace(/\s/g,'');
	field.value=field.value.replace(/[^-0-9\.]/g,'');
	fieldName = fieldName.charAt(0).toUpperCase()+fieldName.substring(1,fieldName.length);
	
	if(field.value.length <= 0 && mandateflag == 1 && falert == 1)
	{
		alert(fieldName + " cannot be ignored");
		field.focus();
		return false;
	}//end of if

	if(field.value.length > 0 && falert == 1)
	{
		var exp0 = /\./;
	
		if (exp0.test(field.value))
		{
			myArray = field.value.match(exp0);
			var ant = myArray.input.substring(0, myArray.index)
			var pre = myArray.input.substring(myArray.index+1, myArray.index+3);
			
			if (exp0.test(pre))
			{
				alert("Not a valid amount");
				field.focus();
				return false;
			}
			if (pre.length == 1)
				pre= pre + "0";
			if (pre.length == 0)
				pre= "00";
			if (ant.length == 0)
				ant = "0";
			field.value = ant + "." + pre;
		}//end of if
	
		if (parseFloat(field.value) > maxNum || parseFloat(field.value) < minNum)
		{	
			alert(fieldName +" out of range (" + minNum + " to " + maxNum +")");
			field.focus();
			return false;
		}
		return true;
	}//end of if;
}
		
		
function GetCookie (name) 
{ 

	var arg = name + "="; 
	var alen = arg.length; 
	var clen = document.cookie.length; 
	var i = 0; 

	while (i < clen) 
	{
		var j = i + alen; 
		if (document.cookie.substring(i, j) == arg) 
			return getCookieVal (j); 
		i = document.cookie.indexOf(" ", i) + 1; 
		if (i == 0) break; 
	} 

	return null;
}


function SetCookie (name, value) 
{ 
	var argv = SetCookie.arguments; 
	var argc = SetCookie.arguments.length; 
	var expires = (argc > 2) ? argv[2] : null; 
	var path = (argc > 3) ? argv[3] : null; 
	var domain = (argc > 4) ? argv[4] : null; 
	var secure = (argc > 5) ? argv[5] : false; 
	document.cookie = name + "=" + escape (value) + 
	((expires == null) ? "" : ("; expires=" + expires.toGMTString())) + 
	((path == null) ? "" : ("; path=" + path)) + 
	((domain == null) ? "" : ("; domain=" + domain)) + 
	((secure == true) ? "; secure" : "");
}

	
function DeleteCookie (name) 
{ 
	var exp = new Date(); 
	exp.setTime (exp.getTime() - 1); 
	var cval = GetCookie (name); 
	document.cookie = name + "=" + cval + "; expires=" + exp.toGMTString();
}

function getCookieVal(offset) 
{
	var endstr = document.cookie.indexOf (";", offset);
	if (endstr == -1)
	endstr = document.cookie.length;
	return unescape(document.cookie.substring(offset, endstr));
}	



function getParameter(by)
{
	str  = window.document.location.search.split("?");
	str1 = str[1].split("&");
	
	switch(by)
	{
		case 1:
			return paramSplit(str1[0]);
		
		default:
		{
			var n = by - 1;
			return paramSplit(str1[n]);
		}
	}
}	

function checkCountryDesig(firstbox,secondbox)
{
 var count;
 count=0;
 for(var i=1;i<secondbox.length;i++)
 {
  if(secondbox.options[i].selected)
  {
   count++;
  }
 }
 //alert("count=" + secondbox.length)
 if(firstbox.value > 2 && count>1)
 {
  alert("The user cannot belong to multiple countries")
  for(var i=0;i<secondbox.length;i++)
  {
   secondbox.options[i].selected=false;
  }
  return false;
 }
 else
 {
  return true;
 }
}


//########################################################
function changeOption5(firstbox,secondbox,name)
{
 
 if(firstbox.selectedIndex!=0)
 {
   var test=new Array();
   test=firstbox[firstbox.selectedIndex].value.split("!");
   if(test[1]=="")
   {
     secondbox.length=1;
     secondbox.options[0].value='$'
     secondbox.options[0].text="All Countries" 
   }
   else
   {
    var test1=test[1].split("|");   
    secondbox.length=test1.length;
    //secondbox.selectedIndex=0;
    secondbox.options[0].value='$'
    secondbox.options[0].text="All Countries" 
    for(var i=0;i<test1.length-1;i++)
    {
     var test2=test1[i].split(",")
     secondbox.options[i+1].value=test2[0]
     secondbox.options[i+1].text=test2[1] 
     if(parseInt(test2[2],10)==1)
     {
      secondbox.options[i+1].selected=true
     }
    }
   
   }
 }
 else
 {
  secondbox.length=1;
  secondbox.options[0].value='$'
  secondbox.options[0].text="All Countries" 
 }
}
