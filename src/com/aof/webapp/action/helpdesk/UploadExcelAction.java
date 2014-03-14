/*
 * Created on 2004-12-22
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.action.helpdesk;


import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.Party;
import com.aof.component.domain.party.PartyServices;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.domain.party.UserLoginServices;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.form.helpdesk.UploadExcelForm;

import jxl.Cell;
import jxl.LabelCell;
import jxl.Sheet;
import jxl.Workbook;
/**
 * @author yech
 *
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class UploadExcelAction extends com.shcnc.struts.action.BaseAction {
	private final static int EXCEL_COLUMN_USERID=0;
	private final static int EXCEL_COLUMN_USERNAME=1;
	private final static int EXCEL_COLUMN_EMAIL=2;
	private final static int EXCEL_COLUMN_TELEPHONE=3;
	private final static int EXCEL_COLUMN_PARTYID=4;
	
//--------------------------------------------------------- Instance
	// Variables

	// --------------------------------------------------------- Methods

	/**
	 * Method execute
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return ActionForward
	 * @throws HibernateException
	 * @throws IOException
	 * @throws InvocationTargetException
	 * @throws IllegalAccessException
	 */
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws HibernateException, IOException, IllegalAccessException,
			InvocationTargetException {
		final String action = mapping.getParameter();
		
		if (action.equals(NEW)) {
			return newUpload(mapping, form, request, response);
		}
		else if (action.equals(INSERT)) {
			return upload(mapping, form, request, response);
		}
		else
		{
			throw new UnsupportedOperationException();
		}
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 */
	private ActionForward newUpload(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		String partyId=request.getParameter("partyId");
		if(partyId==null)
		{
			this.postGlobalError("helpdesk.attachment.error.upload.noPartyId", request);
		}
		UploadExcelForm uploadExcelForm = (UploadExcelForm) this.getForm("/helpdesk.insertUploadExcel",request);
		uploadExcelForm.setPartyId(partyId);
		uploadExcelForm.setImportCustomer("0");
		return mapping.findForward("jsp");
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 */

	private ActionForward upload(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws FileNotFoundException, IOException, HibernateException,ClassCastException {
			
		try {
			final UploadExcelForm uploadExcelForm = (UploadExcelForm) form;
			if (uploadExcelForm.getFile() == null) {
				this.postGlobalError("helpdesk.attachment.error.upload.exceed.maxsize", request);
				return mapping.getInputForward();
			}
			final String fileName = uploadExcelForm.getFile().getFileName();
			if (fileName.trim().length() == 0) {
				this.postGlobalError("helpdesk.attachment.error.upload.no.file", request);
				return mapping.getInputForward();
			}
			if (uploadExcelForm.getFile().getFileSize()==0) {
				this.postGlobalError("helpdesk.attachment.error.upload.size.zero", request);
				return mapping.getInputForward();
			}
			if (!fileName.substring(fileName.length()-4).toLowerCase().equals(".xls")) {
				this.postGlobalError("helpdesk.attachment.error.upload.notExcel", request);
				return mapping.getInputForward();
			}
			String partyId=uploadExcelForm.getPartyId();
			boolean importAll=!uploadExcelForm.getImportCustomer().equals("0");
			Party party=null;
			if (!importAll) {
				PartyServices partyService=new PartyServices();
				party=partyService.getParty(partyId);
				if (party==null) {
					this.postGlobalError("helpdesk.attachment.error.upload.cannotFindParty", request);
					return mapping.getInputForward();
				}
			}
			
			Workbook book = Workbook.getWorkbook(uploadExcelForm.getFile().getInputStream());
			Sheet sheet = book.getSheet(0);
      int rows = sheet.getRows();
      
      if (importAll) {
      	importAllCustomerUser(sheet,rows);
      } else {
      	importCustomerUser(sheet,rows,party);
      }
      book.close();
      
		
			this.postGlobalMessage("helpdesk.attachment.uploadExcel.success",request);
			return mapping.getInputForward();
		} catch (Throwable e) {
			this.postGlobalError("helpdesk.attachment.uploadExcel.failed", request);
			return mapping.getInputForward();
		}

	}

	/**
	 * @param sheet
	 * @param rows
	 * @throws HibernateException
	 */
	private void importAllCustomerUser(Sheet sheet, int rows) throws HibernateException {
		UserLoginServices userLoginService=new UserLoginServices();
		PartyServices partyService=new PartyServices();
		Session sess=userLoginService.getSession();
		try {
	    for (int row = 1; row < rows; row++) {
	  		Cell cells[] = sheet.getRow(row);
	  		boolean newUser=false;
	  		if (cells[EXCEL_COLUMN_PARTYID].getContents().trim().length()!=0) {
	  			Party party=partyService.getParty(cells[EXCEL_COLUMN_PARTYID].getContents().trim(),sess);
	  			if (party!=null) {
	  				UserLogin userLogin=userLoginService.getUserLogin(cells[EXCEL_COLUMN_USERID].getContents().trim(),sess);
		  			if (userLogin==null) {
		  				newUser=true;
		  				userLogin=new UserLogin();
		  				userLogin.setUserLoginId(cells[EXCEL_COLUMN_USERID].getContents().trim());
		  			}
	  				userLogin.setName(cells[EXCEL_COLUMN_USERNAME].getContents());
		  			userLogin.setEmail_addr(cells[EXCEL_COLUMN_EMAIL].getContents());
		  			userLogin.setTele_code(cells[EXCEL_COLUMN_TELEPHONE].getContents());
			  		userLogin.setParty(party);
			  		userLoginService.importUserLogin(userLogin,sess,newUser);	
	  			}
	  		}
	    }
		} catch (Exception e) {
			e.printStackTrace();
		}
    finally{
			userLoginService.closeSession();
		}
		
	}

	/**
	 * @param sheet
	 * @param rows
	 * @param party
	 * @throws HibernateException
	 */
	private void importCustomerUser(Sheet sheet, int rows, Party party) throws HibernateException {
		UserLoginServices userLoginService=new UserLoginServices();
		Session sess=userLoginService.getSession();
		try {
	    for (int row = 1; row < rows; row++) {
	  		Cell cells[] = sheet.getRow(row);
	  		boolean newUser=false;
	  		if (cells[EXCEL_COLUMN_PARTYID].getContents().trim().equals(party.getPartyId())) {
	  			UserLogin userLogin=userLoginService.getUserLogin(cells[EXCEL_COLUMN_USERID].getContents().trim(),sess);
	  			if (userLogin==null) {
	  				newUser=true;
	  				userLogin=new UserLogin();
	  				userLogin.setUserLoginId(cells[EXCEL_COLUMN_USERID].getContents().trim());
	  			}
  				userLogin.setName(cells[EXCEL_COLUMN_USERNAME].getContents());
	  			userLogin.setEmail_addr(cells[EXCEL_COLUMN_EMAIL].getContents());
	  			userLogin.setTele_code(cells[EXCEL_COLUMN_TELEPHONE].getContents());
		  		userLogin.setParty(party);
		  		userLoginService.importUserLogin(userLogin,sess,newUser);
	  		}
	    }
		} catch (Exception e) {
			e.printStackTrace();
		}
    finally{
			userLoginService.closeSession();
		}
	}



}
