<%	net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
	Date currDate = new Date();
		
	String statement1 = 
			"select fm from FMonth as fm " +
			" where ? between fm.DateFrom and fm.DateTo";
	net.sf.hibernate.Query query1 = hs.createQuery(statement1);
	query1.setDate(0, currDate);
		
	List list1 = query1.list();
		
	if (list1 != null && list1.iterator().hasNext()) {
		FMonth currFMonth = (FMonth)list1.iterator().next();
		int currentYear = currFMonth.getYear().intValue();
		int currentMonth = currFMonth.getMonthSeq();
		
		int yearFrom = currentYear;
		int monthFrom = currentMonth - 6;
		int yearTo = currentYear;
		int monthTo = currentMonth + 6;
		
		if (monthFrom < 0) {
			yearFrom = yearFrom - 1;
			monthFrom = monthFrom + 12;
		}
		
		if (monthTo > 11) {
			yearTo = yearTo + 1;
			monthTo = monthTo - 12;
		}
		
		String statement2 = 
			"select fm from FMonth as fm " +
			" where (fm.Year * 100 + fm.MonthSeq) between ? and ? " +
			" order by fm.Year, fm.MonthSeq";
		
		net.sf.hibernate.Query query2 = hs.createQuery(statement2);
		query2.setInteger(0, yearFrom * 100 + monthFrom);
		query2.setInteger(1, yearTo * 100 + monthTo);
		
		List list2 = query2.list();
		
		request.setAttribute("QryList", list2);
	}
%>
 <%@ include file="listFisCalendar.jsp" %>