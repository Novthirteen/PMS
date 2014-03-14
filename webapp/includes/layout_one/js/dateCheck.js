function dataCheck(dateFirst,dateSecond){
      var d = new Date();
	  var currentYear = d.getYear();
	  var currentMonth = d.getMonth()+1;
	  var currentDay = d.getDate();
	
	var datafirst = dateFirst.value;
	var datasecond = dateSecond.value;
	
    //check datafirst
    //ÅÐ¶Ï¸ñÊ½
      if((datafirst.length>10) || (datafirst.length<8)){
         alert("Incorrect Date Format");
         dateFirst.focus();
		 return false;
      }
	  var one = datafirst.indexOf("-");
	  var two = datafirst.lastIndexOf("-");
	  if(one != 4){
	      alert("Incorrect Date Format");
	      dateFirst.focus();
		  return false;
	  }
	  if((two!= 6) && (two != 7)){
	       alert("Incorrect Date Format");
	       dateFirst.focus();
		   return false;
	  }
	//ÅÐ¶ÏÊÇ·ñÎªÊý×Ö  
	  for (var i = 0;i <4 ;i++){
		     if((datafirst.charAt(i)< '0')||(datafirst.charAt(i)> '9')){
		       alert("Incorrect Date Format");
		       dateFirst.focus();
		       return false;
		     }
		   }
      for (var i = 5;i <two ;i++){
		     if((datafirst.charAt(i)< '0')||(datafirst.charAt(i)> '9')){
		       alert("Incorrect Date Format");
		       dateFirst.focus();
		       return false;
		     }
		   }
      for (var i = two+1;i <datafirst.length ;i++){
		     if((datafirst.charAt(i)< '0')||(datafirst.charAt(i)> '9')){
		       alert("Incorrect Date Format");
		       dateFirst.focus();
		       return false;
		     }
		   }
	 //ÅÐ¶ÏÊÇ·ñ³¬³ö·¶Î§  
	  var year1 = parseInt(datafirst.substring(0,one),'10');
	  var month1 = parseInt(datafirst.substring(one+1,two),'10');
	  var day1 = parseInt(datafirst.substring(two+1), '10');
	
	  if ((year1<1900) || (month1<=0) || (month1>12) || (day1<=0) ||(day1>31)){
           alert("Incorrect Date");
           dateFirst.focus();
		   return false;  	  
	  }
          if((year1%4 ==0 && year1%100!=0)||(year1%400==0)){//ÈòÄê
            if(month1==2){
               if(day1>28){
                 alert("Incorrect Date");
                 dateFirst.focus();
                 return false;
               }
            }
          }else
            if(month1==2){
              if(day1>28){
                alert("Incorrect Date");
                dateFirst.focus();
                 return false;
              }
            }
          if(month1==4 || month1==6 || month1==9 || month1==11){
             if(day1==31){
                alert("Incorrect Date");
                dateFirst.focus();
                return false;
             }
          }
          
	//check datasecond
	  if(datasecond.length>10 || datasecond.length<8){
         alert("Incorrect Date Format");
         dateSecond.focus();
		 return false;
      }
	  one = datasecond.indexOf("-");
	  two = datasecond.lastIndexOf("-");
	  
	  if(one != 4){
	      alert("Incorrect Date Format");
	      dateSecond.focus();
		  return false;
	  }
	  if((two!= 6) && (two != 7)){
	       alert("Incorrect Date Format");
	       dateSecond.focus();
		   return false;
	  }
	  
	  for (var i = 0;i <4 ;i++){
		     if((datasecond.charAt(i)< '0')||(datasecond.charAt(i)> '9')){
		       alert("Incorrect Date Format");
		       dateSecond.focus();
		       return false;
		     }
		   }
      for (var i = 5;i <two ;i++){
		     if((datasecond.charAt(i)< '0')||(datasecond.charAt(i)> '9')){
		       alert("Incorrect Date Format");
		       dateSecond.focus();
		       return false;
		     }
		   }
      for (var i = two+1;i <datasecond.length ;i++){
		     if((datasecond.charAt(i)< '0')||(datasecond.charAt(i)> '9')){
		       alert("Incorrect Date Format");
		       dateSecond.focus();
		       return false;
		     }
		   }
	   
	  var year2 = parseInt(datasecond.substring(0,one),'10');
	  var month2 = parseInt(datasecond.substring(one+1,two),'10');
	  var day2 = parseInt(datasecond.substring(two+1),'10');
	  
	  if ((year2<1900) || (month2<=0) || (month2>12) || (day2<=0) ||(day2>31)){
           alert("Incorrect Date");
           dateSecond.focus();
		   return false;  	  
	  }
	  if((year2%4 ==0 && year2%100!=0)||(year2%400==0)){
            if(month2==2){
               if(day2>29){
                 alert("Incorrect Date");
                 dateSecond.focus();
                 return false;
               }
            }
          }else
            if(month2==2){
              if(day2>28){
                alert("Incorrect Date");
                dateSecond.focus();
                 return false;
              }
            }
          
          if(month2==4 || month2==6 || month2==9 || month2==11){
             if(day2==31){
                alert("Incorrect Date");
                dateSecond.focus();
                return false;
             }
          }
      //two data compare
      if (year1>year2){
          alert("End Date cannot be earlier than Start Date");
          dateSecond.focus();
          return false;
      }
      if (year1==year2)
         if(month1>month2){
            alert("End Date cannot be earlier than Start Date");
            dateSecond.focus();
            return false;
         }else {
           if(month1 == month2)
             if(day1>day2){
                alert("End Date cannot be earlier than Start Date");
                dateSecond.focus();
                return false;
             } }
             
      return true;
      
}

function dataOneCheck(dateFirst){
   var datafirst = dateFirst.value;
	
    //check datafirst
    //ÅÐ¶Ï¸ñÊ½
      if((datafirst.length>10) || (datafirst.length<8)){
         alert("Incorrect Date Format");
         dateFirst.focus();
		 return false;
      }
	  var one = datafirst.indexOf("-");
	  var two = datafirst.lastIndexOf("-");
	  if(one != 4){
	      alert("Incorrect Date Format");
	      dateFirst.focus();
		  return false;
	  }
	  if((two!= 6) && (two != 7)){
	       alert("Incorrect Date Format");
	       dateFirst.focus();
		   return false;
	  }
	//ÅÐ¶ÏÊÇ·ñÎªÊý×Ö  
	  for (var i = 0;i <4 ;i++){
		     if((datafirst.charAt(i)< '0')||(datafirst.charAt(i)> '9')){
		       alert("Incorrect Date Format");
		       dateFirst.focus();
		       return false;
		     }
		   }
      for (var i = 5;i <two ;i++){
		     if((datafirst.charAt(i)< '0')||(datafirst.charAt(i)> '9')){
		       alert("Incorrect Date Format");
		       dateFirst.focus();
		       return false;
		     }
		   }
      for (var i = two+1;i <datafirst.length ;i++){
		     if((datafirst.charAt(i)< '0')||(datafirst.charAt(i)> '9')){
		       alert("Incorrect Date Format");
		       dateFirst.focus();
		       return false;
		     }
		   }
	 //ÅÐ¶ÏÊÇ·ñ³¬³ö·¶Î§  
	  var year1 = parseInt(datafirst.substring(0,one),'10');
	  var month1 = parseInt(datafirst.substring(one+1,two),'10');
	  var day1 = parseInt(datafirst.substring(two+1), '10');
	
	  if ((year1<1900) || (month1<=0) || (month1>12) || (day1<=0) ||(day1>31)){
           alert("Incorrect Date");
           dateFirst.focus();
		   return false;  	  
	  }
          if((year1%4 ==0 && year1%100!=0)||(year1%400==0)){//ÈòÄê
            if(month1==2){
               if(day1>28){
                 alert("Incorrect Date");
                 dateFirst.focus();
                 return false;
               }
            }
          }else
            if(month1==2){
              if(day1>28){
                alert("Incorrect Date");
                dateFirst.focus();
                 return false;
              }
            }
          if(month1==4 || month1==6 || month1==9 || month1==11){
             if(day1==31){
                alert("Incorrect Date");
                dateFirst.focus();
                return false;
             }
          }
      return true;
}