/**
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 */

package com.aof.webapp.action.prm.bill;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import com.aof.component.crm.customer.CustomerProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.ProjectReceiptMaster;
import com.aof.component.prm.Bill.ReceiptService;
import com.aof.component.prm.project.CurrencyType;
import com.aof.component.prm.util.EmailService;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.util.UtilString;
import com.aof.webapp.action.BaseAction;

/**
 * @author stanley
 * @version 2005-07-27
 */

public class EditReceiptMasterAction extends BaseAction{
	
	private Logger log = Logger.getLogger(EditInvoiceAction.class);

	public ActionForward perform(
			ActionMapping mapping, 
			ActionForm form, 
			HttpServletRequest request, 
			HttpServletResponse response) throws IOException, ServletException {
		
		Locale locale = getLocale(request);
		MessageResources messages = getResources();
		ReceiptService service = new ReceiptService();
		ProjectReceiptMaster prm;
		
		UserLogin currentUser = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
		SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-mm-dd");
		
		
		String action = request.getParameter("FormAction");
		String receiptNo = request.getParameter("receiptNo");
		String dataId = request.getParameter("DataId");
		String process = request.getParameter("process");
		String receiptAmountString = request.getParameter("receiptAmount");
		String currencyString = request.getParameter("currency");
		String exchangeRateString = request.getParameter("exchangeRate");
		String createUserString = request.getParameter("createUser");
		String createDateString = request.getParameter("createDate");
		String receiptDateString = request.getParameter("receiptDate");
		String customerIdString = request.getParameter("customerId");
		String status = request.getParameter("status");
		String faReceiptno = request.getParameter("faReceiptno");
		String note = request.getParameter("note");
		String location = request.getParameter("location");
		String receiptType = request.getParameter("receiptType");
		
		if(action == null)	action = ""; 
		if(receiptNo == null )	receiptNo = "";
		else receiptNo = receiptNo.trim();
		if(dataId == null) dataId = "";
		if(process == null) process = "";
		if(status == null) 	status = "";
		if(faReceiptno == null) faReceiptno = "";
		if(note == null) note = "";
		if(location == null) location = "";
		if(receiptType == null) receiptType = "";

		receiptAmountString = UtilString.removeSymbol(receiptAmountString,',');
		
		double receiptAmount = 
			(receiptAmountString == null) ? 0.0 : new Double(receiptAmountString).doubleValue();
		CurrencyType currency = 
			(currencyString == null)? new CurrencyType():service.getCurrency(currencyString);
		double exchangeRate = 
			(exchangeRateString == null)? 0.0 : new Double(exchangeRateString).doubleValue();
		UserLogin createUser = 
			(createUserString == null)? currentUser : service.getCreateUser(createUserString);
		Date createDate = 
			(createDateString == null)? new Date() : UtilDateTime.toDate2(createDateString + " 00:00:00.000");
		Date receiptDate = 
			(receiptDateString == null)? new Date() : UtilDateTime.toDate2(receiptDateString + " 00:00:00.000");
		CustomerProfile customer =
			(customerIdString == null)? new CustomerProfile() : service.getCustomer(customerIdString);
			
			prm = new ProjectReceiptMaster();
			if(!receiptNo.trim().equals(""))
				prm.setReceiptNo(receiptNo);
			else if(dataId.equals(""))
				prm.setReceiptNo(service.generateNo());
			prm.setFaReceiptNo(faReceiptno);
			prm.setReceiptAmount(new Double(receiptAmount));
			prm.setCurrency(currency);
			prm.setExchangeRate(new Float(exchangeRate));
			prm.setCreateUser(createUser);
			prm.setCreateDate(createDate);
			prm.setReceiptDate(receiptDate);
			prm.setCustomerId(customer);	
			prm.setNote(note);
			prm.setLocation(location);
			prm.setReceiptType(receiptType);
			
		try{
			if(action.equalsIgnoreCase("Save")){
				if(process.equalsIgnoreCase("Create")){
					if(service.checkReceiptNo(receiptNo))
						request.setAttribute("ErrorMessage","Receipt No. Already Exists.");
					else{
						prm.setReceiptStatus(Constants.RECEIPT_STATUS_DRAFT);
						service.insert(prm);
						if(request.getParameter("notify")!= null && request.getParameter("notify").equals("yes")){
							EmailService.notifyUser(prm, location);
						}
					}
				}
				if(process.equalsIgnoreCase("Update")){
					//if(!service.checkReceiptNo(receiptNo)){
					//	request.setAttribute("ErrorMessage","Can't Find Receipt");
					//}
					//else{
						prm.setReceiptStatus(status);
						service.update(prm);
					//}
				}
				
				request.setAttribute("ProjectReceiptMaster",prm);
				request.setAttribute("RemainAmount",service.getRemainAmount(prm));
				return mapping.findForward("success");
			}
			
			if(action.equalsIgnoreCase("Edit")){
				ProjectReceiptMaster receipt =  service.getView(dataId);
				request.setAttribute("ProjectReceiptMaster",receipt);
				request.setAttribute("RemainAmount",service.getRemainAmount(receipt));
				return mapping.findForward("success");
			}
			
			if(action.equalsIgnoreCase("View")){
				ProjectReceiptMaster receipt =  service.getView(dataId);
				request.setAttribute("ProjectReceiptMaster",receipt);
				request.setAttribute("ReceiptSettlementList",service.getSettlement(receipt));
				request.setAttribute("RemainAmount",service.getRemainAmount(receipt));
				return mapping.findForward("view");
			}
			
			if(action.equalsIgnoreCase("Delete")){
				service.delete(prm);
				return mapping.findForward("list");
			}
			
			if(action.equalsIgnoreCase("Back")){
				return mapping.findForward("list");
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			service.closeSession();
		}

		return null;
	}

}
