/*
 * Created on 2005-6-6
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.prm.payment;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.Region;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.Bill.BillTransactionDetail;
import com.aof.component.prm.Bill.ProjectBill;
import com.aof.component.prm.Bill.TransactionServices;
import com.aof.component.prm.payment.PaymentInstructionService;
import com.aof.component.prm.payment.PaymentTransactionDetail;
import com.aof.component.prm.payment.ProjPaymentTransaction;
import com.aof.component.prm.payment.ProjectPayment;
import com.aof.component.prm.payment.ProjectPaymentMaster;
import com.aof.component.prm.project.ProjectMaster;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.webapp.action.ActionErrorLog;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.action.prm.report.ReportBaseAction;
import com.aof.webapp.form.prm.payment.EditPaymentInstructionForm;

/**
 * @author gus
 *
 */
public class EditPaymentInstructionAction extends  ReportBaseAction{

	
	private Logger log = Logger.getLogger(EditPaymentInstructionAction.class);
	
	public ActionForward perform(ActionMapping mapping,
								 ActionForm form,
								 HttpServletRequest request,
								 HttpServletResponse response) {
		
		Transaction transaction = null; 
		
		try {
			EditPaymentInstructionForm epiForm = (EditPaymentInstructionForm)form;
			
			String action = epiForm.getAction();
			if (request.getAttribute("action") != null) {
				action = (String)request.getAttribute("action");
			} 
			String category = epiForm.getCategory();
			if (category == null || category.trim().length() == 0) {
				category = Constants.TRANSACATION_CATEGORY_CAF;
				epiForm.setCategory(category);
			}
			Session session = Hibernate2Session.currentSession();
			transaction = session.beginTransaction();

			if (action.equals("view")) {
				String payId = epiForm.getPayId();
				if (request.getAttribute("payId") != null) {
					payId = (String)request.getAttribute("payId");
				}
				doView(session, request, payId, category);
			}
			
			if (action.equals("dialogView")) {
				String payId = request.getParameter("payId");
				doView(session, request, payId, category);
				return mapping.findForward("dialogView");
			}
			
			if (action.equals("new")) {
				Long payId = doNew(session, request, epiForm);
				//return refreshPage(mapping, request, String.valueOf(payId));
				doView(session, request, String.valueOf(payId), category);
			}
			
			if (action.equals("delete")) {
				doDelete(epiForm);
				return mapping.findForward("list");
			}
			
			if (action.equals("updateHead")) {
				doUpdateHead(session, epiForm);
				//return refreshPage(mapping, request, epiForm.getBillId());
				doView(session, request, epiForm.getPayId(), category);
			}
			
			if (action.equals("addTransaction")) {
				doAddTransaction(session, epiForm);
				//return refreshPage(mapping, request, epiForm.getBillId());
				doView(session, request, epiForm.getPayId(), category);
			}
			
			if (action.equals("removeTransaction")) {
				doRemoveTransaction(session, epiForm);
				//return refreshPage(mapping, request, epiForm.getBillId());
				doView(session, request, epiForm.getPayId(), category);
			}
			
			if (action.equals("close")) {
				doClose(session, epiForm);
				return mapping.findForward("list");
			}
			
			//payment settlement
			if(action.equals("removeSupplierInvoice")){
				removeSupplierInvoice(session, Long.parseLong(request.getParameter("paymentId")));
				doView(session, request, epiForm.getPayId(), category);
			}
			
			if(action.equals("post")){			
				String postIds[] = request.getParameterValues("chk");
				
				postPaymentSettle(session, epiForm.getPayId(), postIds);
				doView(session, request, epiForm.getPayId(), category);
			}
			
			if(action.equals("ExportToExcel")){
				doExport(session, request, response, epiForm);
				return null;
			}
			
		} catch (Exception e) {
			try {
				if (transaction != null) {
					transaction.rollback();
				}
			} catch (HibernateException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
			log.error(e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (transaction != null) {
					transaction.commit();
				}
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			} catch (SQLException e1) {
				log.error(e1.getMessage());
				e1.printStackTrace();
			}
		}
		
		return mapping.findForward("success");
	}
	
	private void doView(Session session, HttpServletRequest request, String payId, String category) throws HibernateException {
		if (payId != null && payId.trim().length() != 0) {
			//show edit payment instruction page
			long id = Long.parseLong(payId);
			
			String payStatement = "from ProjectPayment as pp where pp.Id = ?";
			Query query = session.createQuery(payStatement);
			query.setLong(0, id);
			
			List list = query.list();
			
			if (list != null && list.size() > 0) {
				ProjectPayment payment = (ProjectPayment)list.get(0);
				//set payment instruction in request
				request.setAttribute("ProjectPayment", payment);
				
				//set transaction detail list that can be add to payment instruction in request
				String projectId = payment.getProject().getProjId();
				TransactionServices ts = new TransactionServices();
				
				/*
				if (category.equals(Constants.TRANSACATION_CATEGORY_EXPENSE)) {
					List tranExpenseList = ts.findPaymentTransactionList(projectId, Constants.TRANSACATION_CATEGORY_EXPENSE);
					//List tranCostList = ts.findBillingTransactionList(projectId, Constants.TRANSACATION_CATEGORY_OTHER_COST);
					if (tranExpenseList == null) {
						tranExpenseList = new ArrayList();
					}
					//if (tranCostList != null) {
					//	tranExpenseList.addAll(tranCostList);
					//}
					request.setAttribute("ExpenseTransactionList", tranExpenseList);
				}
				*/
				
				if (category.equals(Constants.TRANSACATION_CATEGORY_CAF)) {
					List tranCAFList = ts.findPaymentTransactionList(projectId, Constants.TRANSACATION_CATEGORY_CAF);
					request.setAttribute("CAFTransactionList", tranCAFList);
				}
				
				//if (category.equals(Constants.TRANSACATION_CATEGORY_ALLOWANCE)) {
				//	List tranAllowanceList = ts.findPaymentTransactionList(projectId, Constants.TRANSACATION_CATEGORY_ALLOWANCE);
				//	request.setAttribute("AllowanceTransactionList", tranAllowanceList);
				//}
				
				List tranPaymentList = null;
				if (category.equals(Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE) && payment.getProject().getContractType().equals("FP")) {
					//if the project's contract type is "FP" then the project have payment acceptance
					tranPaymentList = ts.findPaymentTransactionList(projectId, Constants.TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE);
					request.setAttribute("PaymentTransactionList", tranPaymentList);
				}
				
				if (category.equals(Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT)) {
					List tranCreditList = ts.findPaymentTransactionList(projectId, Constants.TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT);
					request.setAttribute("CreditDownPaymentList", tranCreditList);
				}
//				for load trasaction, and invoice
				if (payment.getDetails() != null) {
					payment.getDetails().size();
				}
				if (payment.getSettleRecords() != null) {
					payment.getSettleRecords().size();
				}
			}
		} else {
			//show new payment instruction display page
			//it seems we shall do not do anything here!!
		}
	}
	
	private ProjectPayment convertFormToPayment(Session session, EditPaymentInstructionForm epiForm, ProjectPayment pp) throws HibernateException {
		String projectId = epiForm.getProjId();
		String payAddrId = epiForm.getPayAddr();
		ProjectMaster project = null;
		com.aof.component.crm.vendor.VendorProfile vendor = null;
		if (projectId != null && projectId.trim().length() != 0) {
			project = (ProjectMaster)session.load(ProjectMaster.class, projectId);
		}
		if (payAddrId != null && payAddrId.trim().length() != 0) {
			vendor = (com.aof.component.crm.vendor.VendorProfile)session.load(com.aof.component.crm.vendor.VendorProfile.class, payAddrId);
		}
		
		//set payment id
		//if (epiForm.getBillId() != null && epiForm.getBillId().trim().length() != 0) {
			//Long id = new Long(epiForm.getBillId());
			//pb.setId(id);
		//}
		
		//set payment code 
		if (epiForm.getPayCode() != null && epiForm.getPayCode().trim().length() != 0) {
			pp.setPaymentCode(epiForm.getPayCode());
		} 
		
		//set payment type
		pp.setType(epiForm.getPayType());
		
		//set project
		if (project != null) {
			pp.setProject(project);
		}
		
		//set payment address
		if (vendor != null) {
			pp.setPayAddress(vendor);
		}
		
		//set status
		if (epiForm.getStatus() != null) {
			pp.setStatus(epiForm.getStatus());
		}
		
		//set note
		if (epiForm.getNote() != null) {
			pp.setNote(epiForm.getNote().trim());
		}

		return pp;
	}
	
	private Long doNew(Session session, HttpServletRequest request, EditPaymentInstructionForm epiForm) throws HibernateException {
		
		ProjectPayment pp = new ProjectPayment();
		convertFormToPayment(session, epiForm, pp);

		//set payment code 
		if (pp.getPaymentCode() == null || pp.getPaymentCode().trim().length() == 0) {
			//if user not input the payment code, system would generate one for it
			PaymentInstructionService paymentInstructionService = new PaymentInstructionService();
			pp.setPaymentCode(paymentInstructionService.generatePaymentCode(pp.getProject().getProjId()));
		}
		
		//set payment type
		pp.setType(Constants.PAYMENT_TYPE_NORMAL);
		
		//set payment status
		pp.setStatus(Constants.PAYMENT_STATUS_DRAFT);
		
		//set create date
		pp.setCreateDate(new Date());
		
		//set create user
		pp.setCreateUser((UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY));
		
		//set calculation amount
		pp.setCalAmount(new Double(0L));
		
		//set settled amount
		pp.setSettledAmount(new Double(0L));
		
		Long payId = (Long)session.save(pp);
		
		return payId;
	}
	
	private void doDelete(EditPaymentInstructionForm epiForm) throws HibernateException {
		Long payId  = new Long(epiForm.getPayId());
		PaymentInstructionService paymentInstructionService = new PaymentInstructionService(); 
		paymentInstructionService.deletePaymentInstruction(payId);
	}
	
	private void doUpdateHead(Session session, EditPaymentInstructionForm epiForm) throws HibernateException {
		Long payId = new Long(epiForm.getPayId());
		ProjectPayment pp = (ProjectPayment)session.load(ProjectPayment.class, payId);
		convertFormToPayment(session, epiForm, pp);
		session.update(pp);
	}
	
	private void doAddTransaction(Session session, EditPaymentInstructionForm epiForm) throws HibernateException {
		String[] transactionId = epiForm.getTransactionId();
		Long payId = new Long(epiForm.getPayId());
		ProjectPayment pp = (ProjectPayment)session.load(ProjectPayment.class, payId);
		
		PaymentInstructionService paymentInstructionService = new PaymentInstructionService();
		for (int i0 =0; transactionId != null && i0 < transactionId.length; i0++) {
			long id = Long.parseLong(transactionId[i0]);
			paymentInstructionService.addPaymentTransaction(pp, id);
		}

		session.update(pp);
	}
	
	private void doRemoveTransaction(Session session, EditPaymentInstructionForm epiForm) throws HibernateException {
		Long payId = new Long(epiForm.getPayId());
		String[] payDetailId = epiForm.getPayDetailId();
		ProjectPayment pp = (ProjectPayment)session.load(ProjectPayment.class, payId);

		PaymentInstructionService paymentInstructionService = new PaymentInstructionService();
		for (int i0 =0; payDetailId != null && i0 < payDetailId.length; i0++) {
			long id = Long.parseLong(payDetailId[i0]);
			paymentInstructionService.removePaymentTransaction(id);
		}

		session.update(pp);
		//reCalculatepaymentingAmount(session, payId);
	}
	
	private void doClose(Session session, EditPaymentInstructionForm epiForm) throws HibernateException {
		Long payId = new Long(epiForm.getPayId());
		ProjectPayment pp = (ProjectPayment)session.load(ProjectPayment.class, payId);
		pp.setStatus(Constants.PAYMENT_STATUS_COMPLETED);
		session.update(pp);
	}
	
	private void removeSupplierInvoice(Session session, long id) throws HibernateException{
		Long paymentId = new Long(id);
		ProjPaymentTransaction ppt = (ProjPaymentTransaction)session.load(ProjPaymentTransaction.class, paymentId);
		PaymentInstructionService paymentInstructionService = new PaymentInstructionService();
		paymentInstructionService.removePaymentSettlement(ppt);
		
	}
	
	public void postPaymentSettle(Session session, String payId, String postIds[]) throws HibernateException{
		Transaction transaction = null;
		try {
			transaction = session.beginTransaction();
			
			ProjectPayment pp = (ProjectPayment)session.load(ProjectPayment.class, new Long(Long.parseLong(payId)));
		
			if (pp != null && pp.getSettleRecords() != null) {
				Iterator iterator = pp.getSettleRecords().iterator();
				while (iterator.hasNext()) {
					ProjPaymentTransaction ppt = (ProjPaymentTransaction)iterator.next();
					for (int i0 = 0; i0 < postIds.length; i0++) {
						if (ppt.getId().toString().equalsIgnoreCase(postIds[i0])) {
							ppt.setPostStatus(Constants.POST_PAYMENT_TRANSACTION_STATUS_POST);
							ppt.setPostDate(new Date());
							session.update(ppt);
						}
					}
				}
			}
			session.flush();
		} catch (Exception e) {
			try {
				transaction.rollback();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			try {
				transaction.commit();
			} catch (HibernateException e1) {
				e1.printStackTrace();
			}
		}
	}
	protected ActionErrors errors = new ActionErrors();
	protected ActionErrorLog actionDebug = new ActionErrorLog();
	public ActionForward doExport(Session session, HttpServletRequest request, HttpServletResponse response, EditPaymentInstructionForm epiForm){
		try {
			ActionErrors errors = this.getActionErrors(request.getSession());
			
			String payId = epiForm.getPayId();
			String category = epiForm.getCategory();
			if ((payId == null) || (payId.length() < 1))
				actionDebug.addGlobalError(errors,"error.context.required");
			if (!errors.empty()) {
				saveErrors(request, errors);
				return null;
			}
			DateFormat df = new SimpleDateFormat("dd-MM-yy", Locale.ENGLISH);
			NumberFormat numFormater = NumberFormat.getInstance();
			numFormater.setMaximumFractionDigits(2);
			numFormater.setMinimumFractionDigits(2);
			//Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) return null;
			
			//Fetch related Data
			net.sf.hibernate.Session hs = Hibernate2Session.currentSession();
			ProjectPayment pp = (ProjectPayment)hs.load(ProjectPayment.class, new Long(payId));
			if (pp == null) return null;
			
			List CAFList  = pp.getCAFDetails();
			List AcceptanceList = pp.getPaymentDetails();
			List CreditDownPaymentList = pp.getDownPaymentDetails();
			
			double CAFAmt = pp.getCAFAmount();
			double AcceptanceAmt = pp.getPaymentAmount();
			double DownPaymentAmt = pp.getDownPaymentAmount();
			//for downpayment
			
			//Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\""+ SaveToFileName + "\"");
			response.setContentType("application/octet-stream");
			
			//Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath+"\\"+ExcelTemplate));
			
			//Select the first worksheet
			String ct = "";
			if (pp.getProject().getContractType().equals("FP"))
			{
				ct = "Fixed Price";
			}else{
				ct = "Time & Material";
			}
			int ExcelRow = ListStartRow;

//			CAF	---------------------------------------------------------------------------	
			if (CAFAmt!=0){
				HSSFSheet CAFsheet = wb.getSheet(FormSheetCAF); 
				HSSFCell CAFCell = null;

			///////////////////////	
				CAFCell = CAFsheet.getRow(2).getCell((short)2);
				CAFCell.setCellValue(pp.getProject().getProjId() + " : " +pp.getProject().getProjName());
				
				CAFCell = CAFsheet.getRow(2).getCell((short)7);
				CAFCell.setCellValue(pp.getPaymentCode());
				
				CAFCell = CAFsheet.getRow(3).getCell((short)2);
				CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
				CAFCell.setCellValue(pp.getPayAddress().getChineseName()==null ? pp.getPayAddress().getDescription() : pp.getPayAddress().getChineseName());
				
				CAFCell = CAFsheet.getRow(3).getCell((short)7);
				CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
				CAFCell.setCellValue(pp.getProject().getVendor().getChineseName()==null ? pp.getProject().getVendor().getDescription() : pp.getProject().getVendor().getChineseName() );
				
				ProjectPaymentMaster ppm = null;
				ProjPaymentTransaction ppt =null;
				int i =0;
				String tempInvocecode="";
				String tempInvoceDate="";
				Iterator it = pp.getSettleRecords().iterator();
				while (it.hasNext()){
					ppt = (ProjPaymentTransaction)it.next();	
					ppm = (ProjectPaymentMaster)ppt.getInvoice();	
					if (i==0){
						tempInvocecode = ppm.getPayCode();
						tempInvoceDate = df.format(ppm.getPayDate());
					}else{
						tempInvocecode = tempInvocecode+" , "+ppm.getPayCode();
						tempInvoceDate = tempInvoceDate+" , "+df.format(ppm.getPayDate());
					}
					i++;
				}
				
				CAFCell = CAFsheet.getRow(4).getCell((short)2);
				CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
				CAFCell.setCellValue(tempInvocecode);

				CAFCell = CAFsheet.getRow(4).getCell((short)7);
				CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
				CAFCell.setCellValue(tempInvoceDate);
					
				CAFCell = CAFsheet.getRow(5).getCell((short)2);
				CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
				CAFCell.setCellValue(pp.getProject().getParentProject().getProjId()+" : "+pp.getProject().getParentProject().getProjName());
				
				CAFCell = CAFsheet.getRow(6).getCell((short)2);
				CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
				CAFCell.setCellValue(pp.getProject().getParentProject().getCustomer().getDescription());
				
				HSSFRow CAFHRow = null;
				if (CAFList != null && CAFList.size() > 0) {
					HSSFCellStyle Style1 = CAFsheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
					HSSFCellStyle Style2 = CAFsheet.getRow(ListStartRow).getCell((short)6).getCellStyle();
					HSSFCellStyle Style3 = CAFsheet.getRow(ListStartRow).getCell((short)7).getCellStyle();
					HSSFCellStyle Style4 = CAFsheet.getRow(ListStartRow).getCell((short)8).getCellStyle();
					HSSFCellStyle sig_style = CAFsheet.getRow(ListStartRow-3).getCell((short)9).getCellStyle();
					int CAFCount = 0;
					double CAFTotal = 0;
					double dayTotal = 0;
					for (int i0 = 0; i0 < CAFList.size(); i0++) {
						PaymentTransactionDetail ptd = (PaymentTransactionDetail)CAFList.get(i0);
						CAFHRow = CAFsheet.createRow(ExcelRow);
						CAFsheet.addMergedRegion(new Region(ExcelRow, (short) 0, ExcelRow, (short) 2));
						CAFCell = CAFHRow.createCell((short)0);
						CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						CAFCell.setCellValue(ptd.getTransactionUser() != null ? ptd.getTransactionUser().getName() : "");
						CAFCell.setCellStyle(Style1);
						
						CAFCell = CAFHRow.createCell((short)1);
						CAFCell.setCellStyle(Style1);
						CAFCell = CAFHRow.createCell((short)2);
						CAFCell.setCellStyle(Style1);
						
						CAFsheet.addMergedRegion(new Region(ExcelRow, (short) 3, ExcelRow, (short) 5));
						CAFCell = CAFHRow.createCell((short)3);
						CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						CAFCell.setCellValue(ptd.getDesc2() != null ? ptd.getDesc2() : "");
						
						CAFCell.setCellStyle(Style1);
						CAFCell = CAFHRow.createCell((short)4);
						CAFCell.setCellStyle(Style1);
						CAFCell = CAFHRow.createCell((short)5);
						CAFCell.setCellStyle(Style1);
						
						CAFCell = CAFHRow.createCell((short)6);
						CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						CAFCell.setCellValue(ptd.getTransactionDate() != null ? df.format(ptd.getTransactionDate()) : "");
						CAFCell.setCellStyle(Style2);
						
						double totalDay =ptd.getTransactionNum1().doubleValue();
						dayTotal = totalDay + dayTotal;
						CAFCell = CAFHRow.createCell((short)7);
						CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						CAFCell.setCellValue(ptd.getTransactionNum1() != null ? numFormater.format(ptd.getTransactionNum1()) : "");
						CAFCell.setCellStyle(Style3);
						
						CAFCell = CAFHRow.createCell((short)8);
						CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						CAFCell.setCellValue(ptd.getTransactionNum2() != null ? numFormater.format(ptd.getTransactionNum2()) : "");
						CAFCell.setCellStyle(Style4);
						
						CAFCell = CAFHRow.createCell((short)9);
						CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						CAFCell.setCellValue(ptd.getAmount() != null ? numFormater.format(ptd.getAmount()) : "");
						CAFCell.setCellStyle(Style4);
						
						double total1 = ptd.getAmount().doubleValue();
						CAFTotal = total1 + CAFTotal;
						CAFCount = i0+1;			
						ExcelRow++;
					}
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount);
					CAFCell = CAFHRow.createCell((short)6);
					CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					CAFCell.setCellValue("Total :");
					CAFCell.setCellStyle(Style1);
					CAFCell = CAFHRow.createCell((short)7);
					CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					CAFCell.setCellValue(dayTotal/8 + " days");
					CAFCell.setCellStyle(Style4);
					
					CAFCell = CAFHRow.createCell((short)8);
					CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断

					CAFCell.setCellStyle(Style4);
					
					
					CAFCell = CAFHRow.createCell((short)9);
					CAFCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
					CAFCell.setCellValue(CAFTotal);
					CAFCell.setCellStyle(Style4);
					
//					tail
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount+2);
					CAFCell = CAFHRow.createCell((short)0);
					CAFCell.setCellValue("Prepared By:");
					CAFCell.setCellStyle(sig_style);
					
					UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount+2);
					CAFCell = CAFHRow.createCell((short)1);
					CAFCell.setCellValue(ul.getName());
					CAFCell.setCellStyle(sig_style);
					
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount+2);
					CAFCell = CAFHRow.createCell((short)4);
					CAFCell.setCellValue("Date:");
					CAFCell.setCellStyle(sig_style);
					
					CAFsheet.addMergedRegion(new Region(ListStartRow+CAFCount+2, (short) 5, ListStartRow+CAFCount+2, (short) 6));
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount+2);
					CAFCell = CAFHRow.createCell((short)5);
					CAFCell.setCellValue(df.format(new Date()));
					CAFCell.setCellStyle(sig_style);
					
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount+4);
					CAFCell = CAFHRow.createCell((short)0);
					CAFCell.setCellValue("Verified By SL Mgr:");
					CAFCell.setCellStyle(sig_style);
					
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount+4);
					CAFCell = CAFHRow.createCell((short)4);
					CAFCell.setCellValue("Date:");
					CAFCell.setCellStyle(sig_style);
					
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount+6);
					CAFCell = CAFHRow.createCell((short)0);
					CAFCell.setCellValue("Checked By F&A:");
					CAFCell.setCellStyle(sig_style);
					
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount+6);
					CAFCell = CAFHRow.createCell((short)4);
					CAFCell.setCellValue("Date:");
					CAFCell.setCellStyle(sig_style);
					
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount+8);
					
					CAFCell = CAFHRow.createCell((short)0);
					CAFCell.setCellValue("Approved By:");
					CAFCell.setCellStyle(sig_style);
					
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount+8);
					CAFCell = CAFHRow.createCell((short)4);
					CAFCell.setCellValue("Date:");
					CAFCell.setCellStyle(sig_style);
					
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount+10);
					CAFCell = CAFHRow.createCell((short)0);
					CAFCell.setCellValue("Paid By:");
					CAFCell.setCellStyle(sig_style);
					
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount+10);
					CAFCell = CAFHRow.createCell((short)4);
					CAFCell.setCellValue("Date:");
					CAFCell.setCellStyle(sig_style);
					
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount+12);
					CAFCell = CAFHRow.createCell((short)0);
					CAFCell.setCellValue("Amount Received By:");
					CAFCell.setCellStyle(sig_style);
					
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount+12);
					CAFCell = CAFHRow.createCell((short)4);
					CAFCell.setCellValue("Date:");
					CAFCell.setCellStyle(sig_style);
					
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount+14);
					CAFCell = CAFHRow.createCell((short)0);
					CAFCell.setCellValue("Update to PAS:");
					CAFCell.setCellStyle(sig_style);
					
					CAFHRow = CAFsheet.createRow(ListStartRow+CAFCount+14);
					CAFCell = CAFHRow.createCell((short)4);
					CAFCell.setCellValue("Date:");
					CAFCell.setCellStyle(sig_style);
				}
				
			}else{
				//wb.removeSheetAt(0);
			}
				
//Acceptance	---------------------------------------------------------------------------	
				if (AcceptanceAmt!=0){
					HSSFSheet acceptanceSheet = wb.getSheet(FormSheetAcceptance); 
					HSSFCell acceptanceCell = null;

				///////////////////////	
					acceptanceCell = acceptanceSheet.getRow(2).getCell((short)2);
					acceptanceCell.setCellValue(pp.getProject().getProjId() + " : " +pp.getProject().getProjName());
					
					acceptanceCell = acceptanceSheet.getRow(2).getCell((short)7);
					acceptanceCell.setCellValue(pp.getPaymentCode());
					
					acceptanceCell = acceptanceSheet.getRow(3).getCell((short)2);
					acceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					acceptanceCell.setCellValue(pp.getPayAddress().getChineseName()==null ? pp.getPayAddress().getDescription() : pp.getPayAddress().getChineseName());
					
					acceptanceCell = acceptanceSheet.getRow(3).getCell((short)7);
					acceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					acceptanceCell.setCellValue(pp.getProject().getVendor().getChineseName()==null ? pp.getProject().getVendor().getDescription() : pp.getProject().getVendor().getChineseName() );
					
			//---------------------------------------
					ProjectPaymentMaster ppm = null;
					ProjPaymentTransaction ppt =null;
					int i =0;
					String tempInvocecode="";
					String tempInvoceDate="";
					Iterator it = pp.getSettleRecords().iterator();
					while (it.hasNext()){
						ppt = (ProjPaymentTransaction)it.next();	
						ppm = (ProjectPaymentMaster)ppt.getInvoice();	
						if (i==0){
							tempInvocecode = ppm.getPayCode();
							tempInvoceDate = df.format(ppm.getPayDate());
						}else{
							tempInvocecode = tempInvocecode+" , "+ppm.getPayCode();
							tempInvoceDate = tempInvoceDate+" , "+df.format(ppm.getPayDate());
						}
						i++;
					}
					acceptanceCell = acceptanceSheet.getRow(4).getCell((short)2);
					acceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					acceptanceCell.setCellValue(tempInvocecode);
	
					acceptanceCell = acceptanceSheet.getRow(4).getCell((short)7);
					acceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					acceptanceCell.setCellValue(tempInvoceDate);
	
				//--------------------
					acceptanceCell = acceptanceSheet.getRow(5).getCell((short)2);
					acceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					acceptanceCell.setCellValue(pp.getProject().getParentProject().getProjId()+" : "+pp.getProject().getParentProject().getProjName());
							
					acceptanceCell = acceptanceSheet.getRow(6).getCell((short)2);
					acceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					acceptanceCell.setCellValue(pp.getProject().getParentProject().getCustomer().getDescription());
					
					HSSFRow acceptanceRow = null;
					if (AcceptanceList != null && AcceptanceList.size() > 0) {
						
						HSSFCellStyle textStyle = acceptanceSheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
						HSSFCellStyle dateStyle = acceptanceSheet.getRow(ListStartRow).getCell((short)3).getCellStyle();
						HSSFCellStyle numStyle = acceptanceSheet.getRow(ListStartRow).getCell((short)5).getCellStyle();
						HSSFCellStyle sig_style = acceptanceSheet.getRow(ListStartRow-3).getCell((short)9).getCellStyle();
						int acceptanceCount = 0;
						double acceptanceTotal = 0;
						for (int i0 = 0; i0 < AcceptanceList.size(); i0++) {
							PaymentTransactionDetail ptd = (PaymentTransactionDetail)AcceptanceList.get(i0);
							acceptanceRow = acceptanceSheet.createRow(ExcelRow);
							
							acceptanceCell = acceptanceRow.createCell((short)0);
							acceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							acceptanceCell.setCellValue(ptd.getDesc1() != null ? ptd.getDesc1(): "");
							acceptanceCell.setCellStyle(textStyle);
							
							acceptanceCell = acceptanceRow.createCell((short)3);
							acceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							acceptanceCell.setCellValue(ptd.getTransactionDate() != null ? df.format(ptd.getTransactionDate()) : "");
							acceptanceCell.setCellStyle(dateStyle);
							
							acceptanceCell = acceptanceRow.createCell((short)5);
							acceptanceCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							acceptanceCell.setCellValue(numFormater.format(ptd.getAmount().doubleValue()));
							acceptanceCell.setCellStyle(numStyle);
							
							double totalValue = ptd.getAmount().doubleValue();
							acceptanceTotal = totalValue + acceptanceTotal;
							acceptanceCount++;
							ExcelRow++;
						}
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount);
						acceptanceCell = acceptanceRow.createCell((short)5);
						acceptanceCell.setCellValue(numFormater.format(acceptanceTotal));
						acceptanceCell.setCellStyle(numStyle);
		
						//tail
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount+2);
						acceptanceCell = acceptanceRow.createCell((short)0);
						acceptanceCell.setCellValue("Prepared By:");
						acceptanceCell.setCellStyle(sig_style);
						
						UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount+2);
						acceptanceCell = acceptanceRow.createCell((short)1);
						acceptanceCell.setCellValue(ul.getName());
						acceptanceCell.setCellStyle(sig_style);
						
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount+2);
						acceptanceCell = acceptanceRow.createCell((short)4);
						acceptanceCell.setCellValue("Date:");
						acceptanceCell.setCellStyle(sig_style);
						
						acceptanceSheet.addMergedRegion(new Region(ListStartRow+acceptanceCount+2, (short) 5, ListStartRow+acceptanceCount+2, (short) 6));
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount+2);
						acceptanceCell = acceptanceRow.createCell((short)5);
						acceptanceCell.setCellValue(df.format(new Date()));
						acceptanceCell.setCellStyle(sig_style);
						
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount+4);
						acceptanceCell = acceptanceRow.createCell((short)0);
						acceptanceCell.setCellValue("Verified By SL Mgr:");
						acceptanceCell.setCellStyle(sig_style);
						
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount+4);
						acceptanceCell = acceptanceRow.createCell((short)4);
						acceptanceCell.setCellValue("Date:");
						acceptanceCell.setCellStyle(sig_style);
						
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount+6);
						acceptanceCell = acceptanceRow.createCell((short)0);
						acceptanceCell.setCellValue("Checked By F&A:");
						acceptanceCell.setCellStyle(sig_style);
						
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount+6);
						acceptanceCell = acceptanceRow.createCell((short)4);
						acceptanceCell.setCellValue("Date:");
						acceptanceCell.setCellStyle(sig_style);
						
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount+8);
						acceptanceCell = acceptanceRow.createCell((short)0);
						acceptanceCell.setCellValue("Approved By:");
						acceptanceCell.setCellStyle(sig_style);
						
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount+8);
						acceptanceCell = acceptanceRow.createCell((short)4);
						acceptanceCell.setCellValue("Date:");
						acceptanceCell.setCellStyle(sig_style);
						
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount+10);
						acceptanceCell = acceptanceRow.createCell((short)0);
						acceptanceCell.setCellValue("Paid By:");
						acceptanceCell.setCellStyle(sig_style);
						
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount+10);
						acceptanceCell = acceptanceRow.createCell((short)4);
						acceptanceCell.setCellValue("Date:");
						acceptanceCell.setCellStyle(sig_style);
						
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount+12);
						acceptanceCell = acceptanceRow.createCell((short)0);
						acceptanceCell.setCellValue("Amount Received By:");
						acceptanceCell.setCellStyle(sig_style);
						
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount+12);
						acceptanceCell = acceptanceRow.createCell((short)4);
						acceptanceCell.setCellValue("Date:");
						acceptanceCell.setCellStyle(sig_style);
						
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount+14);
						acceptanceCell = acceptanceRow.createCell((short)0);
						acceptanceCell.setCellValue("Update to PAS:");
						acceptanceCell.setCellStyle(sig_style);
						
						acceptanceRow = acceptanceSheet.createRow(ListStartRow+acceptanceCount+14);
						acceptanceCell = acceptanceRow.createCell((short)4);
						acceptanceCell.setCellValue("Date:");
						acceptanceCell.setCellStyle(sig_style);
					}
				}else{
					//wb.removeSheetAt(1);
				}

//				CreditDownPayment	---------------------------------------------------------------------------	
				if (DownPaymentAmt!=0){
					HSSFSheet CDPsheet = wb.getSheet(FormSheetCreditDownPayment); 
					HSSFCell CDPCell = null;

				///////////////////////	
					CDPCell = CDPsheet.getRow(2).getCell((short)2);
					CDPCell.setCellValue(pp.getProject().getProjId() + " : " +pp.getProject().getProjName());
					
					CDPCell = CDPsheet.getRow(2).getCell((short)7);
					CDPCell.setCellValue(pp.getPaymentCode());
					
					CDPCell = CDPsheet.getRow(3).getCell((short)2);
					CDPCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					CDPCell.setCellValue(pp.getPayAddress().getChineseName()==null ? pp.getPayAddress().getDescription() : pp.getPayAddress().getChineseName());
					
					CDPCell = CDPsheet.getRow(3).getCell((short)7);
					CDPCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					CDPCell.setCellValue(pp.getProject().getVendor().getChineseName()==null ? pp.getProject().getVendor().getDescription() : pp.getProject().getVendor().getChineseName() );
					
					CDPCell = CDPsheet.getRow(4).getCell((short)2);
					CDPCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					ProjectPaymentMaster ppm = null;
					ProjPaymentTransaction ppt =null;
					int i =0;
					String tempInvocecode="";
					String tempInvoceDate="";
					Iterator it = pp.getSettleRecords().iterator();
					while (it.hasNext()){
						ppt = (ProjPaymentTransaction)it.next();	
						ppm = (ProjectPaymentMaster)ppt.getInvoice();	
						if (i==0){
							tempInvocecode = ppm.getPayCode();
							tempInvoceDate = df.format(ppm.getPayDate());
						}else{
							tempInvocecode = tempInvocecode+" , "+ppm.getPayCode();
							tempInvoceDate = tempInvoceDate+" , "+df.format(ppm.getPayDate());
						}
						i++;
					}
					CDPCell.setCellValue(tempInvocecode);

					CDPCell = CDPsheet.getRow(4).getCell((short)7);
					CDPCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					CDPCell.setCellValue(tempInvoceDate);
						
					CDPCell = CDPsheet.getRow(5).getCell((short)2);
					CDPCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					CDPCell.setCellValue(pp.getProject().getParentProject().getProjId()+" : "+pp.getProject().getParentProject().getProjName());
					
					CDPCell = CDPsheet.getRow(6).getCell((short)2);
					CDPCell.setEncoding(HSSFCell.ENCODING_UTF_16); //设置cell编码解决中文高位字节截断
					CDPCell.setCellValue(pp.getProject().getParentProject().getCustomer().getDescription());
					
					HSSFRow CDPRow = null;
					if (CreditDownPaymentList != null && CreditDownPaymentList.size() > 0) {
						HSSFCellStyle textStyle = CDPsheet.getRow(ListStartRow).getCell((short)0).getCellStyle();
						HSSFCellStyle dateStyle = CDPsheet.getRow(ListStartRow).getCell((short)3).getCellStyle();
						HSSFCellStyle numStyle = CDPsheet.getRow(ListStartRow).getCell((short)5).getCellStyle();
						HSSFCellStyle sig_style = CDPsheet.getRow(ListStartRow-3).getCell((short)9).getCellStyle();
						int CDPCount = 0;
						double CDPTotal = 0;
						for (int i0 = 0; i0 < CreditDownPaymentList.size(); i0++) {
							PaymentTransactionDetail ptd = (PaymentTransactionDetail)CreditDownPaymentList.get(i0);
							CDPRow = CDPsheet.createRow(ExcelRow);
							CDPCell = CDPRow.createCell((short)0);
							CDPCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							CDPCell.setCellValue(ptd.getDesc2() != null ? ptd.getDesc2() : "");
							CDPCell.setCellStyle(textStyle);
														
							CDPCell = CDPRow.createCell((short)3);
							CDPCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							CDPCell.setCellValue(ptd.getTransactionDate() != null ? df.format(ptd.getTransactionDate()) : "");
							CDPCell.setCellStyle(dateStyle);
							
							CDPCell = CDPRow.createCell((short)5);
							CDPCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
							CDPCell.setCellValue(ptd.getAmount() != null ? numFormater.format(ptd.getAmount()) : "");
							CDPCell.setCellStyle(numStyle);
							
							double total1 = ptd.getAmount().doubleValue();
							CDPTotal = total1 + CDPTotal;
							CDPCount = i0+1;
							ExcelRow++;
						}
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount);
						CDPCell = CDPRow.createCell((short)5);
						CDPCell.setEncoding(HSSFCell.ENCODING_UTF_16);//设置cell编码解决中文高位字节截断
						CDPCell.setCellValue(numFormater.format(CDPTotal));
						CDPCell.setCellStyle(numStyle);
						
//						tail
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount+2);
						CDPCell = CDPRow.createCell((short)0);
						CDPCell.setCellValue("Prepared By:");
						CDPCell.setCellStyle(sig_style);
						
						UserLogin ul = (UserLogin)request.getSession().getAttribute(Constants.USERLOGIN_KEY);
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount+2);
						CDPCell = CDPRow.createCell((short)1);
						CDPCell.setCellValue(ul.getName());
						CDPCell.setCellStyle(sig_style);
						
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount+2);
						CDPCell = CDPRow.createCell((short)4);
						CDPCell.setCellValue("Date:");
						CDPCell.setCellStyle(sig_style);
						
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount+2);
						CDPCell = CDPRow.createCell((short)5);
						CDPCell.setCellValue(df.format(new Date()));
						CDPCell.setCellStyle(sig_style);
						
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount+4);
						CDPCell = CDPRow.createCell((short)0);
						CDPCell.setCellValue("Verified By SL Mgr:");
						CDPCell.setCellStyle(sig_style);
						
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount+4);
						CDPCell = CDPRow.createCell((short)4);
						CDPCell.setCellValue("Date:");
						CDPCell.setCellStyle(sig_style);
						
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount+6);
						CDPCell = CDPRow.createCell((short)0);
						CDPCell.setCellValue("Checked By F&A:");
						CDPCell.setCellStyle(sig_style);
						
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount+6);
						CDPCell = CDPRow.createCell((short)4);
						CDPCell.setCellValue("Date:");
						CDPCell.setCellStyle(sig_style);
						
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount+8);
						
						CDPCell = CDPRow.createCell((short)0);
						CDPCell.setCellValue("Approved By:");
						CDPCell.setCellStyle(sig_style);
						
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount+8);
						CDPCell = CDPRow.createCell((short)4);
						CDPCell.setCellValue("Date:");
						CDPCell.setCellStyle(sig_style);
						
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount+10);
						CDPCell = CDPRow.createCell((short)0);
						CDPCell.setCellValue("Paid By:");
						CDPCell.setCellStyle(sig_style);
						
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount+10);
						CDPCell = CDPRow.createCell((short)4);
						CDPCell.setCellValue("Date:");
						CDPCell.setCellStyle(sig_style);
						
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount+12);
						CDPCell = CDPRow.createCell((short)0);
						CDPCell.setCellValue("Amount Received By:");
						CDPCell.setCellStyle(sig_style);
						
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount+12);
						CDPCell = CDPRow.createCell((short)4);
						CDPCell.setCellValue("Date:");
						CDPCell.setCellStyle(sig_style);
						
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount+14);
						CDPCell = CDPRow.createCell((short)0);
						CDPCell.setCellValue("Update to PAS:");
						CDPCell.setCellStyle(sig_style);
						
						CDPRow = CDPsheet.createRow(ListStartRow+CDPCount+14);
						CDPCell = CDPRow.createCell((short)4);
						CDPCell.setCellValue("Date:");
						CDPCell.setCellStyle(sig_style);
					}
					
				}else{
					//wb.removeSheetAt(0);
				}
				
				if(DownPaymentAmt!=0){
					
				}else{
					//wb.removeSheetAt(2);
				}
			
			
			
//			写入Excel工作表
			wb.write(response.getOutputStream());
//			关闭Excel工作薄对象
			response.getOutputStream().close();
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	private final static String DownPayExcelTemplate = "DownPaymentPaymentInstructionExcelForm.xls";
	private final static String ExcelTemplate="PaymentInstructionExcelForm.xls";
	private final static String FormSheetCAF="CAFForm";
	private final static String FormSheetAcceptance="AcceptanceForm";
	private final static String FormSheetDownPayment="DownPaymentForm";
	private final static String FormSheetCreditDownPayment="DownPaymentForm";
	private final static String SaveToFileName="Payment Instruction Excel Form.xls";
	private final int ListStartRow = 9;
}
