/**
 * 
 */
package com.aof.webapp.action.prm.payment;

import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.crm.vendor.VendorProfile;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.payment.PaymentMasterService;
import com.aof.component.prm.payment.ProjectPaymentMaster;
import com.aof.component.prm.project.CurrencyType;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.util.UtilString;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.prm.bill.EditInvoiceAction;

/**
 * @author CN01511
 *
 */
public class EditSupplierInvoiceAction extends BaseAction {

	
	private Logger log = Logger.getLogger(EditInvoiceAction.class);

	public ActionForward perform(
			ActionMapping mapping, 
			ActionForm form, 
			HttpServletRequest request, 
			HttpServletResponse response) throws IOException, ServletException {
	
		PaymentMasterService service = new PaymentMasterService();
		UserLogin currentUser = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
	
		String action = request.getParameter("FormAction");
		String process = request.getParameter("process");
		String payCode = request.getParameter("payCode");
		String dataId = request.getParameter("DataId");
		String payAmountString = request.getParameter("payAmount");
		String payDateString = request.getParameter("payDate");
		String currencyString = request.getParameter("currency");
		String exchangeRateString = request.getParameter("exchangeRate");
		String createUserString = request.getParameter("createUser");
		String createDateString = request.getParameter("createDate");
		String vendorIdString = request.getParameter("vendorId");
		String poProjectId = request.getParameter("projId");
		//String status = request.getParameter("status");
		//String faPaymentno = request.getParameter("faPaymentno");
		String note = request.getParameter("note");
		String payType = request.getParameter("payType");
		
		if(action == null)	action = ""; 
		if(payCode == null )	payCode = "";
		else payCode = payCode.trim();
		if(dataId == null) dataId = "";
		if(process == null) process = "";
		//if(status == null) 	status = "";
		//if(faPaymentno == null) faPaymentno = "";
		if(note == null) note = "";
		if(payType == null) payType = "";
		payAmountString = UtilString.removeSymbol(payAmountString, ',');
		
		double payAmount = 
			(payAmountString == null) ? 0.0 : new Double(payAmountString).doubleValue();
		CurrencyType currency = 
			(currencyString == null)? new CurrencyType():service.getCurrency(currencyString);
		double exchangeRate = 
			(exchangeRateString == null)? 0.0 : new Float(exchangeRateString).doubleValue();
		UserLogin createUser = 
			(createUserString == null)? currentUser : service.getCreateUser(createUserString);
		Date createDate = 
			(createDateString == null)? new Date() : UtilDateTime.toDate2(createDateString + " 00:00:00.000");
		Date payDate = 
			(payDateString == null)? new Date() : UtilDateTime.toDate2(payDateString + " 00:00:00.000");
		VendorProfile vendor =
			(vendorIdString == null)? new VendorProfile() : service.getVendor(vendorIdString);
		ProjectMaster poProject = 
			(poProjectId==null)? new ProjectMaster() : service.getPoProject(poProjectId);
			
		try{
			if(action.equalsIgnoreCase("Save")){
				ProjectPaymentMaster ppm = null;
				if(process.equalsIgnoreCase("Create")){
					ppm = new ProjectPaymentMaster();
					
					if(!payCode.trim().equals(""))
						ppm.setPayCode(payCode);
					else if(dataId.equals(""))
					ppm.setPayCode(service.generateNo());
					//ppm.setFaPaymentNo(faPaymentno);
					ppm.setPayAmount(payAmount);
					ppm.setCurrency(currency);
					ppm.setExchangeRate(new Float(exchangeRate));
					ppm.setCreateUser(createUser);
					ppm.setCreateDate(createDate);
					ppm.setPayDate(payDate);
					ppm.setVendorId(vendor);	
					ppm.setPoProjId(poProject);
					ppm.setNote(note);
					ppm.setPayType(payType);
					
					if(service.checkPayCode(payCode)) {				
						request.setAttribute("ErrorMessage","Payment Code Already Exists.");
					} else{
						ppm.setPayStatus(Constants.SUPPLIER_INVOICE_PAY_STATUS_DRAFT);
						ppm.setSettleStatus(Constants.SUPPLIER_INVOICE_SETTLE_STATUS_DRAFT);
						service.insert(ppm);
					}
				}
				if(process.equalsIgnoreCase("Update")){
					ppm = service.getView(payCode);

					if (!service.isPayAmountValid(ppm, payAmount)) {
						request.setAttribute("ErrorMessage","Invoice amount can not less than settled amount.");
					} else {
						ppm.setPayAmount(payAmount);
						ppm.setCurrency(currency);
						ppm.setExchangeRate(new Float(exchangeRate));
						ppm.setCreateUser(createUser);
						ppm.setCreateDate(createDate);
						ppm.setPayDate(payDate);
						ppm.setVendorId(vendor);	
						ppm.setPoProjId(poProject);
						ppm.setNote(note);
						ppm.setPayType(payType);
						
					//	service.resetInvoiceSettleStatus(ppm);
					//	service.resetInvoicPayStatus(ppm);
						
						service.update(ppm);
					}
				}
				
				request.setAttribute("ProjectPaymentMaster",ppm);
				//request.setAttribute("RemainAmount",new Double(ppm.getRemainAmount()));
				return mapping.findForward("success");
			}
			
			if(action.equalsIgnoreCase("Edit")){
				ProjectPaymentMaster payment =  service.getView(dataId);
				if (payment != null && payment.getSettleRecords() != null) {
					payment.getSettleRecords().size();
				}
				request.setAttribute("ProjectPaymentMaster",payment);
//				double amount = 0L;
//				if(payment != null)
//					amount = payment.getRemainAmount();
//				request.setAttribute("RemainAmount",new Double(amount));
				return mapping.findForward("success");
			}
			
			if(action.equalsIgnoreCase("View") || action.equalsIgnoreCase("DialogView")){
				ProjectPaymentMaster payment =  service.getView(dataId);
				payment.getSettleRecords().size();
				request.setAttribute("ProjectPaymentMaster",payment);
				//request.setAttribute("SettlementList",service.getSettlement(payment));
				//request.setAttribute("RemainAmount",new Double(payment.getRemainAmount()));
				request.setAttribute("ViewAction", action);
				return mapping.findForward("view");
			}
			
			if(action.equalsIgnoreCase("Delete")){
				ProjectPaymentMaster payment =  service.getView(payCode);
				service.delete(payment);
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
