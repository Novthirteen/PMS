package com.aof.webapp.action.prm.skillset;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

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
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.skillset.Skill;
import com.aof.component.prm.skillset.SkillCategory;
import com.aof.component.prm.skillset.SkillCert;
import com.aof.component.prm.skillset.SkillComment;
import com.aof.component.prm.skillset.SkillEx;
import com.aof.component.prm.skillset.SkillLevel;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.Constants;
import com.aof.util.UtilDateTime;
import com.aof.webapp.action.prm.report.ReportBaseAction;

public class SkillAction extends ReportBaseAction {

	public ActionForward perform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {

	//	Logger log = Logger.getLogger(EditPreSaleProjectAction.class.getName());
		String action = request.getParameter("formAction");
	//	log.info("action=" + action);

		if (action == null) {
			action = "view";
		}

		UserLogin employee = (UserLogin) request.getSession().getAttribute(Constants.USERLOGIN_KEY);

		try {
			Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;

			if (action.equals("create")) {

				String catId[] = request.getParameterValues("cat");

				if (catId != null && catId.length > 0) {

					tx = hs.beginTransaction();

					int rowSize = java.lang.reflect.Array.getLength(catId);
					String addData = "no";

					for (int i = 0; i < rowSize; i++) {

						String levelId = request.getParameter(catId[i]);

						if (levelId != null && !(levelId.equals(""))) {

							Skill tmpValue = new Skill();
							SkillCategory tmpCat = new SkillCategory();
							SkillLevel tmpLevel = new SkillLevel();

							tmpCat = (SkillCategory) hs.load(SkillCategory.class, catId[i]);
							tmpLevel = (SkillLevel) hs.load(SkillLevel.class, levelId);

							tmpValue.setEmployee(employee);
							tmpValue.setSkillCat(tmpCat);
							tmpValue.setSkillLevel(tmpLevel);

							hs.save(tmpValue);
							hs.flush();

							addData = "yes";
						}
					}
					tx.commit();
					request.getSession().setAttribute("skillFlag", addData);
				}
			}

			if (action.equals("update")) {

				String catId[] = request.getParameterValues("cat");

				List valueList = null;

				tx = hs.beginTransaction();

				Query query = null;

				query = hs
						.createQuery("from Skill as s where s.employee=:userlogin order by s.skillCat");
				query.setParameter("userlogin", employee);
				valueList = query.list();

				for (int i = 0; i < valueList.size(); i++) {
					Skill valueDelete = (Skill) valueList.get(i);
					hs.delete(valueDelete);
					hs.flush();
				}

				if (catId != null && catId.length > 0) {

					int rowSize = java.lang.reflect.Array.getLength(catId);
					String addData = "no";

					for (int i = 0; i < rowSize; i++) {

						Skill tmpValue = new Skill();
						SkillCategory tmpCat = new SkillCategory();
						SkillLevel tmpLevel = new SkillLevel();

						String levelId = request.getParameter(catId[i]);

						if (levelId != null && !(levelId.equals(""))) {

							tmpCat = (SkillCategory) hs.load(SkillCategory.class, catId[i]);
							tmpLevel = (SkillLevel) hs.load(SkillLevel.class, levelId);

							tmpValue.setEmployee(employee);
							tmpValue.setSkillCat(tmpCat);
							tmpValue.setSkillLevel(tmpLevel);

							hs.save(tmpValue);
							hs.flush();

							addData = "yes";
						}
					}
					tx.commit();
					request.getSession().setAttribute("skillFlag", addData);
				}
			}

			if (action.equals("list")) {

				String pCatId = null;
				pCatId = request.getParameter("pCat");
				String subCatId = null;
				String descId = null;

				if (pCatId != null && !(pCatId.equals(""))) {
					if (pCatId.equals("001") || pCatId.equals("005") || pCatId.equals("006")) {
						descId = request.getParameter("desc" + pCatId);
					} else {
						subCatId = request.getParameter("subCat" + pCatId);
						if (subCatId != null && !(subCatId.equals(""))) {
							descId = request.getParameter("desc" + subCatId);
						}
					}
				}
				List valueList = null;

				tx = hs.beginTransaction();
				Query query = null;

				if (descId != null && !(descId.equals(""))) {

					SkillCategory tmpCat = (SkillCategory) hs.load(SkillCategory.class, descId);
					query = hs
							.createQuery("from Skill as s where s.skillCat=:cat order by s.employee");
					query.setParameter("cat", tmpCat);
					valueList = query.list();
					request.setAttribute("valueList", valueList);

				} else if (subCatId != null && !(subCatId.equals(""))) {

					query = hs
							.createQuery("from Skill as s where s.skillCat.catId like ? order by s.employee");
					query.setString(0, subCatId + "%");
					valueList = query.list();
					request.setAttribute("valueList", valueList);

				} else if (pCatId != null) {

					if (!(pCatId.equals(""))) {

						query = hs
								.createQuery("from Skill as s where s.skillCat.catId like ? order by s.employee");
						query.setString(0, pCatId + "%");
						valueList = query.list();
						request.setAttribute("valueList", valueList);

					} else if (pCatId.equals("")) {

						query = hs.createQuery("from Skill as s order by s.skillCat");
						valueList = query.list();
						request.setAttribute("valueList", valueList);
					}
				}

				List catList = null;
				List levelList = null;

				if (pCatId != null) {
					if (!(pCatId.equals(""))) {

						query = hs
								.createQuery("from SkillCategory as sc where sc.catId like ? order by sc.catId");
						query.setString(0, pCatId + "%");
						catList = query.list();
						request.setAttribute("catList", catList);

						query = hs
								.createQuery("from SkillLevel as sl where sl.catId=? order by sl.levelId");
						query.setString(0, pCatId);
						levelList = query.list();
						request.setAttribute("levelList", levelList);

					} else if (pCatId.equals("")) {

						query = hs.createQuery("from SkillCategory as sc order by sc.catId");
						catList = query.list();
						request.setAttribute("catList", catList);

						query = hs.createQuery("from SkillLevel as sl order by sl.levelId");
						levelList = query.list();
						request.setAttribute("levelList", levelList);
					}
				}

				hs.flush();
				tx.commit();

				return mapping.findForward("list-success");
			}

			if (action.equals("query")) {

				String catId = request.getParameter("catId");
				String levelId = request.getParameter("levelId");

				tx = hs.beginTransaction();

				List valueList = null;

				Query query = null;
				query = hs
						.createQuery("from Skill as s where s.skillCat.catId = ? and s.skillLevel.levelId = ? order by s.employee");
				query.setString(0, catId);
				query.setString(1, levelId);

				valueList = query.list();

				hs.flush();
				tx.commit();

				request.setAttribute("valueList", valueList);
				request.setAttribute("catId", catId);
				request.setAttribute("levelId", levelId);

				return mapping.findForward("query-success");
			}

			if (action.equals("export")) {

				String catId = request.getParameter("catId");
				String levelId = request.getParameter("levelId");

				if (catId != null && !catId.equals("") && levelId != null && !levelId.equals("")) {

					List valueList = null;
					String catName = null;
					String levelName = null;

					tx = hs.beginTransaction();

					SkillCategory catValue = (SkillCategory) hs.load(SkillCategory.class, catId);
					catName = catValue.getCatName();

					SkillLevel levelValue = (SkillLevel) hs.load(SkillLevel.class, levelId);
					levelName = levelValue.getLevelDesc();

					Query query = null;
					query = hs
							.createQuery("from Skill as s where s.skillCat.catId = ? and s.skillLevel.levelId = ? order by s.employee");
					query.setString(0, catId);
					query.setString(1, levelId);

					valueList = query.list();

					hs.flush();
					tx.commit();

					return exportToExcel(mapping, request, response, catName, levelName, valueList);
				}

				return null;
			}

			if (action.equals("view") || action.equals("create") || action.equals("update")) {

				tx = hs.beginTransaction();

				List valueList = null;

				String certCount = "";
				String exCount = "";

				Query query = null;

				query = hs
						.createQuery("from Skill as s where s.employee=:userlogin order by s.skillCat");
				query.setParameter("userlogin", employee);
				valueList = query.list();
				request.setAttribute("valueList", valueList);

				query = hs
						.createQuery("select count(*) from SkillCert as sc where sc.employee=:userlogin");
				query.setParameter("userlogin", employee);

				certCount = String.valueOf((Integer) query.list().get(0));
				request.setAttribute("certCount", certCount);

				query = hs
						.createQuery("select count(*) from SkillEx as se where se.employee=:userlogin");
				query.setParameter("userlogin", employee);
				exCount = String.valueOf((Integer) query.list().get(0));
				request.setAttribute("exCount", exCount);

				hs.flush();
				tx.commit();

				String xmlTree = buildTree();

				request.setAttribute("tree", xmlTree);
			}

			if (action.equals("cert")) {

				String command = request.getParameter("command");
				if (command == null) {
					command = "viewCert";
				}

				if (command.equals("createCert")) {
					String certDesc = request.getParameter("iCertDesc");
					String dateGrant = request.getParameter("iDateGrant");
					Date tmpDate = UtilDateTime.toDate2(dateGrant + " 00:00:00.000");

					SkillCert tmpValue = new SkillCert();

					tmpValue.setEmployee(employee);
					tmpValue.setCertDesc(certDesc);
					tmpValue.setDateGrant(tmpDate);

					tx = hs.beginTransaction();

					hs.save(tmpValue);

					hs.flush();
					tx.commit();
				}

				if (command.equals("removeCert")) {

					Long id = Long.valueOf(request.getParameter("certId"));

					tx = hs.beginTransaction();

					SkillCert tmpValue = (SkillCert) hs.load(SkillCert.class, id);
					hs.delete(tmpValue);

					hs.flush();
					tx.commit();
				}

				if (command.equals("queryCert")) {

					String staffId = request.getParameter("staffId");

					tx = hs.beginTransaction();

					List certList = null;

					Query query = null;

					query = hs
							.createQuery("select from SkillCert as sc where sc.employee.userLoginId=? order by sc.dateGrant");
					query.setString(0, staffId);
					certList = query.list();

					request.setAttribute("staffId", staffId);
					request.setAttribute("certList", certList);

					hs.flush();
					tx.commit();

					return mapping.findForward("queryCert-success");
				}

				if (command.equals("exportCert")) {

					String staffId = request.getParameter("staffId");

					tx = hs.beginTransaction();

					List certList = null;

					Query query = null;

					query = hs
							.createQuery("select from SkillCert as sc where sc.employee.userLoginId=? order by sc.dateGrant");
					query.setString(0, staffId);
					certList = query.list();

					UserLogin staff = (UserLogin) hs.load(UserLogin.class, staffId);

					hs.flush();
					tx.commit();

					return exportCertToExcel(mapping, request, response, staff, certList);
				}

				if (command.equals("viewCert") || command.equals("createCert")
						|| command.equals("removeCert")) {

					tx = hs.beginTransaction();

					List valueList = null;

					Query query = null;

					query = hs
							.createQuery("select from SkillCert as sc where sc.employee=:userlogin order by sc.dateGrant");
					query.setParameter("userlogin", employee);
					valueList = query.list();
					request.setAttribute("valueList", valueList);

					hs.flush();
					tx.commit();
				}
				return mapping.findForward("viewCert-success");
			}

			if (action.equals("ex")) {

				String command = request.getParameter("command");
				if (command == null) {
					command = "viewEx";
				}

				if (command.equals("createEx")) {

					String exDesc = request.getParameter("iExDesc");
					String exExp = request.getParameter("iExExp");

					SkillEx tmpValue = new SkillEx();

					tmpValue.setExDesc(exDesc);
					tmpValue.setEmployee(employee);
					tmpValue.setExExp(exExp);

					tx = hs.beginTransaction();

					hs.save(tmpValue);

					hs.flush();
					tx.commit();
				}

				if (command.equals("removeEx")) {

					Long id = Long.valueOf(request.getParameter("exId"));

					tx = hs.beginTransaction();

					SkillEx tmpValue = (SkillEx) hs.load(SkillEx.class, id);
					hs.delete(tmpValue);

					hs.flush();
					tx.commit();
				}

				if (command.equals("queryEx")) {

					String staffId = request.getParameter("staffId");

					tx = hs.beginTransaction();

					List exList = null;

					Query query = null;

					query = hs
							.createQuery("select from SkillEx as se where se.employee.userLoginId=?");
					query.setString(0, staffId);
					exList = query.list();

					request.setAttribute("staffId", staffId);
					request.setAttribute("exList", exList);

					hs.flush();
					tx.commit();

					return mapping.findForward("queryEx-success");
				}

				if (command.equals("exportEx")) {

					String staffId = request.getParameter("staffId");

					tx = hs.beginTransaction();

					List exList = null;

					Query query = null;

					query = hs
							.createQuery("select from SkillEx as se where se.employee.userLoginId=?");
					query.setString(0, staffId);
					exList = query.list();

					UserLogin staff = (UserLogin) hs.load(UserLogin.class, staffId);

					hs.flush();
					tx.commit();

					return exportExToExcel(mapping, request, response, staff, exList);
				}

				if (command.equals("viewEx") || command.equals("createEx")
						|| command.equals("removeEx")) {

					tx = hs.beginTransaction();

					List valueList = null;

					Query query = null;

					query = hs
							.createQuery("select from SkillEx as se where se.employee=:userlogin");
					query.setParameter("userlogin", employee);
					valueList = query.list();
					request.setAttribute("valueList", valueList);

					hs.flush();
					tx.commit();
				}
				return mapping.findForward("viewEx-success");
			}

			if (action.equals("comment")) {

				String command = request.getParameter("command");
				if (command == null) {
					command = "viewComment";
				}

				if (command.equals("createComment")) {

					String commentDesc = request.getParameter("iCommentDesc");

					SkillComment tmpValue = new SkillComment();

					tmpValue.setEmployee(employee);
					tmpValue.setCommentDesc(commentDesc);

					tx = hs.beginTransaction();

					hs.save(tmpValue);

					hs.flush();
					tx.commit();
				}

				if (command.equals("removeComment")) {

					Long id = Long.valueOf(request.getParameter("commentId"));

					tx = hs.beginTransaction();

					SkillComment tmpValue = (SkillComment) hs.load(SkillComment.class, id);
					hs.delete(tmpValue);

					hs.flush();
					tx.commit();
				}

				if (command.equals("queryComment")) {

					tx = hs.beginTransaction();

					List commentList = null;

					Query query = null;

					query = hs.createQuery("select from SkillComment as sc order by sc.employee");
					commentList = query.list();

					request.setAttribute("commentList", commentList);

					hs.flush();
					tx.commit();

					return mapping.findForward("queryComment-success");
				}

				if (command.equals("viewComment") || command.equals("createComment")
						|| command.equals("removeComment")) {

					tx = hs.beginTransaction();

					List valueList = null;

					Query query = null;

					query = hs
							.createQuery("select from SkillComment as sc where sc.employee=:userlogin");
					query.setParameter("userlogin", employee);
					valueList = query.list();
					request.setAttribute("valueList", valueList);

					hs.flush();
					tx.commit();
				}
				return mapping.findForward("viewComment-success");
			}
		} catch (Exception e) {
			e.printStackTrace();
	//		log.error(e.getMessage());
			return (mapping.findForward("view-success"));
		} finally {
			try {
				Hibernate2Session.closeSession();
			} catch (HibernateException e1) {
		//		log.error(e1.getMessage());
				e1.printStackTrace();
			} catch (SQLException e1) {
		//		log.error(e1.getMessage());
				e1.printStackTrace();
			}
		}
		return mapping.findForward("view-success");
	}

	private String buildTree() {

		String level001Desc = "levelDesc01='Junior: Understand basic terms and process' levelId01='001001' levelDesc02='Experienced: Familiar with the business process' levelId02='001002' levelDesc03='Senior: Process Optimization' levelId03='001003' levelDesc04='Expert: Industry expert' levelId04='001004'";

		String level002Desc = "levelDesc01='Junior: Operation as per work instruction' levelId01='002001' levelDesc02='Experienced: Trouble shooting' levelId02='002002' levelDesc03='Senior: Performance mgt and Tuning' levelId03='002003' levelDesc04='Expert: Professional solution consultancy' levelId04='002004'";

		String level003Desc = "levelDesc01='Coding and Test capability' levelId01='003001' levelDesc02='System Analysis' levelId02='003002' levelDesc03='System Architect' levelId03='003003' levelDesc04='Technical Project Management' levelId04='003004'";

		String level004Desc = "levelDesc01='Junior: 0-2 years direct experience' levelId01='004001' levelDesc02='Experienced: 3-5 years direct experience' levelId02='004002' levelDesc03='Senior: 6-10 years direct experience' levelId03='004003' levelDesc04='Expert: more than 10 years direct experience' levelId04='004004'";

		String level005Desc = "levelDesc01='Junior: 0-2 years direct experience' levelId01='005001' levelDesc02='Experienced: 3-5 years direct experience' levelId02='005002' levelDesc03='Senior: 6-10 years direct experience' levelId03='005003' levelDesc04='Expert: more than 10 years direct experience' levelId04='005004'";

		String level006Desc = "levelDesc01='Basic Understanding' levelId01='006001' levelDesc02='Daily Basic Conversation' levelId02='006002' levelDesc03='Business Fluency' levelId03='006003' levelDesc04='Mother Tongue' levelId04='006004'";

		String xml = "<tree>" + "<branch desc='Industrial Knowledge' id='001'>"
				+ "<leaf desc='Manufacturing: General' id='001001' " + level001Desc
				+ " onclick='javascript:clearRadio(\"001001\")'>" + "</leaf>"
				+ "<leaf desc='Manufacturing: Automobile' id='001002' " + level001Desc
				+ " onclick='javascript:clearRadio(\"001002\")'>" + "</leaf>"
				+ "<leaf desc='Manufacturing: Electronics' id='001003' " + level001Desc
				+ " onclick='javascript:clearRadio(\"001003\")'>" + "</leaf>"
				+ "<leaf desc='Manufacturing: Pharmacy' id='001004' " + level001Desc
				+ " onclick='javascript:clearRadio(\"001004\")'>" + "</leaf>"
				+ "<leaf desc='Manufacturing: Petro' id='001005' " + level001Desc
				+ " onclick='javascript:clearRadio(\"001005\")'>" + "</leaf>"
				+ "<leaf desc='Retailer' id='001006' " + level001Desc
				+ " onclick='javascript:clearRadio(\"001006\")'>" + "</leaf>"
				+ "<leaf desc='Banking: Credit Card' id='001007' " + level001Desc
				+ " onclick='javascript:clearRadio(\"001007\")'>" + "</leaf>"
				+ "<leaf desc='Finance: Risk management' id='001008' " + level001Desc
				+ " onclick='javascript:clearRadio(\"001008\")'>" + "</leaf>"
				+ "<leaf desc='Banking: Core Banking' id='001009' " + level001Desc
				+ " onclick='javascript:clearRadio(\"001009\")'>" + "</leaf>"
				+ "<leaf desc='Banking: Timebargain' id='001010' " + level001Desc
				+ " onclick='javascript:clearRadio(\"001010\")'>" + "</leaf>"
				+ "<leaf desc='Insurance' id='001011' " + level001Desc
				+ " onclick='javascript:clearRadio(\"001011\")'>" + "</leaf>"
				+ "<leaf desc='Energy: Nuclear' id='001012' " + level001Desc
				+ " onclick='javascript:clearRadio(\"001012\")'>" + "</leaf>"
				+ "<leaf desc='Oil and Gas' id='001013' " + level001Desc
				+ " onclick='javascript:clearRadio(\"001013\")'>" + "</leaf>"
				+ "<leaf desc='Securities' id='001014' " + level001Desc
				+ " onclick='javascript:clearRadio(\"001014\")'>" + "</leaf>" + "</branch>"
				+ "<branch desc='Technical Skills: Service Delivery' id='002'>"
				+ "<branch desc='Networking operation' id='002001'>"
				+ "<leaf desc='WAN' id='002001001' " + level002Desc
				+ " onclick='javascript:clearRadio(\"002001001\")'>" + "</leaf>"
				+ "<leaf desc='Lease Line' id='002001002' " + level002Desc
				+ " onclick='javascript:clearRadio(\"002001002\")'>" + "</leaf>"
				+ "<leaf desc='Router Configuration' id='002001003' " + level002Desc
				+ " onclick='javascript:clearRadio(\"002001003\")'>" + "</leaf>"
				+ "<leaf desc='Network Security' id='002001004' " + level002Desc
				+ " onclick='javascript:clearRadio(\"002001004\")'>" + "</leaf>" + "</branch>"
				+ "<branch desc='System Administration' id='002002'>"
				+ "<leaf desc='Windows server(win 2000/2003)' id='002002001' " + level002Desc
				+ " onclick='javascript:clearRadio(\"002002001\")'>" + "</leaf>"
				+ "<leaf desc='HP Unix' id='002002002' " + level002Desc
				+ " onclick='javascript:clearRadio(\"002002002\")'>" + "</leaf>"
				+ "<leaf desc='Sun Solaris' id='002002003' " + level002Desc
				+ " onclick='javascript:clearRadio(\"002002003\")'>" + "</leaf>"
				+ "<leaf desc='Linux' id='002002004' " + level002Desc
				+ " onclick='javascript:clearRadio(\"002002004\")'>" + "</leaf>"
				+ "<leaf desc='IBM AS400' id='002002005' " + level002Desc
				+ " onclick='javascript:clearRadio(\"002002005\")'>" + "</leaf>"
				+ "<leaf desc='IBM OS390' id='002002006' " + level002Desc
				+ " onclick='javascript:clearRadio(\"002002006\")'>" + "</leaf>" + "</branch>"
				+ "<branch desc='Database Administration' id='002003'>"
				+ "<leaf desc='Oracle' id='002003001' " + level002Desc
				+ " onclick='javascript:clearRadio(\"002003001\")'>" + "</leaf>"
				+ "<leaf desc='DB2' id='002003002' " + level002Desc
				+ " onclick='javascript:clearRadio(\"002003002\")'>" + "</leaf>"
				+ "<leaf desc='SQL Server' id='002003003' " + level002Desc
				+ " onclick='javascript:clearRadio(\"002003003\")'>" + "</leaf>"
				+ "<leaf desc='QAD progress' id='002003004' " + level002Desc
				+ " onclick='javascript:clearRadio(\"002003004\")'>" + "</leaf>"
				+ "<leaf desc='SAP Basis' id='002003005' " + level002Desc
				+ " onclick='javascript:clearRadio(\"002003005\")'>" + "</leaf>" + "</branch>"
				+ "</branch>"
				+ "<branch desc='Technical Skills: Systems Development and Maintenance' id='003'>"
				+ "<branch desc='Application Platform' id='003001'>"
				+ "<leaf desc='IBM Websphere' id='003001001' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003001001\")'>" + "</leaf>"
				+ "<leaf desc='Microsoft sharepoint' id='003001002' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003001002\")'>" + "</leaf>" + "</branch>"
				+ "<branch desc='Database platform' id='003002'>"
				+ "<leaf desc='Oracle' id='003002001' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003002001\")'>" + "</leaf>"
				+ "<leaf desc='DB2' id='003002002' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003002002\")'>" + "</leaf>"
				+ "<leaf desc='SQL' id='003002003' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003002003\")'>" + "</leaf>"
				+ "<leaf desc='QAD progress' id='003002004' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003002004\")'>" + "</leaf>" + "</branch>"
				+ "<branch desc='Development platform' id='003003'>"
				+ "<leaf desc='.net' id='003003001' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003003001\")'>" + "</leaf>"
				+ "<leaf desc='COBOL' id='003003002' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003003002\")'>" + "</leaf>"
				+ "<leaf desc='J2EE' id='003003003' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003003003\")'>" + "</leaf>"
				+ "<leaf desc='Progress for 4GL' id='003003004' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003003004\")'>" + "</leaf>"
				+ "<leaf desc='SAP ABAP4' id='003003005' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003003005\")'>" + "</leaf>"
				+ "<leaf desc='SMALLTALK' id='003003006' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003003006\")'>" + "</leaf>"
				+ "<leaf desc='Rule Engineer' id='003003007' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003003007\")'>" + "</leaf>"
				+ "<leaf desc='Workflow' id='003003008' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003003008\")'>" + "</leaf>"
				+ "<leaf desc='Report Engine' id='003003009' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003003009\")'>" + "</leaf>" + "</branch>"
				+ "<branch desc='Data Warehouse' id='003004'>"
				+ "<leaf desc='ETC: Extract/Transfer/Load' id='003004001' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003004001\")'>" + "</leaf>"
				+ "<leaf desc='Modeling' id='003004002' " + level003Desc
				+ " onclick='javascript:clearRadio(\"003004002\")'>" + "</leaf>" + "</branch>"
				+ "</branch>" + "<branch desc='Application Knowledge' id='004'>"
				+ "<branch desc='ERP' id='004001'>" + "<leaf desc='QAD' id='004001001' "
				+ level004Desc + " onclick='javascript:clearRadio(\"004001001\")'>" + "</leaf>"
				+ "<leaf desc='BAAN' id='004001002' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004001002\")'>" + "</leaf>"
				+ "<leaf desc='SAP Basic' id='004001003' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004001003\")'>" + "</leaf>"
				+ "<leaf desc='SAP FI' id='004001004' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004001004\")'>" + "</leaf>"
				+ "<leaf desc='SAP CO' id='004001005' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004001005\")'>" + "</leaf>"
				+ "<leaf desc='SAP AM' id='004001006' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004001006\")'>" + "</leaf>"
				+ "<leaf desc='SAP SD' id='004001007' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004001007\")'>" + "</leaf>"
				+ "<leaf desc='SAP MM' id='004001008' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004001008\")'>" + "</leaf>"
				+ "<leaf desc='SAP PP' id='00400109' " + level004Desc
				+ " onclick='javascript:clearRadio(\"00400109\")'>" + "</leaf>"
				+ "<leaf desc='SAP HR' id='004001010' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004001010\")'>" + "</leaf>"
				+ "<leaf desc='SAP PM' id='004001011' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004001011\")'>" + "</leaf>"
				+ "<leaf desc='SAP QM' id='004001012' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004001012\")'>" + "</leaf>"
				+ "<leaf desc='SAP PS' id='004001013' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004001013\")'>" + "</leaf>"
				+ "<leaf desc='SAP OC' id='004001014' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004001014\")'>" + "</leaf>"
				+ "<leaf desc='SAP IS' id='004001015' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004001015\")'>" + "</leaf>"
				+ "<leaf desc='Oracle - Distribution' id='004001016' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004001016\")'>" + "</leaf>"
				+ "<leaf desc='Oracle - Manufacturing' id='004001017' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004001017\")'>" + "</leaf>"
				+ "<leaf desc='Oracle - Finance' id='004001018' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004001018\")'>" + "</leaf>" + "</branch>"
				+ "<branch desc='Credit Cards Mgt System' id='004002'>"
				+ "<leaf desc='Essentis' id='004002001' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004002001\")'>" + "</leaf>"
				+ "<leaf desc='Cardlink' id='004002002' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004002002\")'>" + "</leaf>"
				+ "<leaf desc='SemaCard' id='004002003' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004002003\")'>" + "</leaf>"
				+ "<leaf desc='COSES' id='004002004' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004002004\")'>" + "</leaf>"
				+ "<leaf desc='IST' id='004002005' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004002005\")'>" + "</leaf>"
				+ "<leaf desc='Switch' id='004002006' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004002006\")'>" + "</leaf>"
				+ "<leaf desc='Work Bench' id='004002007' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004002007\")'>" + "</leaf>" + "</branch>"
				+ "<branch desc='Risk Management' id='004003'>"
				+ "<leaf desc='AXIOM' id='004003001' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004003001\")'>" + "</leaf>" + "</branch>"

				+ "<branch desc='Core Banking' id='004004'>" + "<leaf desc='CW' id='004004001' "
				+ level004Desc + " onclick='javascript:clearRadio(\"004004001\")'>" + "</leaf>"
				+ "<leaf desc='Siglo21' id='004004002' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004004002\")'>" + "</leaf>" + "</branch>"

				+ "<branch desc='SCADA' id='004005'>" + "<leaf desc='HP Unix' id='004005001' "
				+ level004Desc + " onclick='javascript:clearRadio(\"004005001\")'>" + "</leaf>"
				+ "<leaf desc='ADACS' id='004005002' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004005002\")'>" + "</leaf>"
				+ "<leaf desc='LYNX' id='004005003' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004005003\")'>" + "</leaf>" + "</branch>"
				+ "<branch desc='Business Intelligence(BI) product' id='004006'>"
				+ "<leaf desc='CorVu' id='004006001' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004006001\")'>" + "</leaf>"
				+ "<leaf desc='Business Object' id='004006002' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004006002\")'>" + "</leaf>"
				+ "<leaf desc='Cognos' id='004006003' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004006003\")'>" + "</leaf>"
				+ "<leaf desc='Crystal Report' id='004006004' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004006004\")'>" + "</leaf>" + "</branch>"
				+ "<branch desc='Output Solution' id='004007'>"
				+ "<leaf desc='OPTIO' id='004007001' " + level004Desc
				+ " onclick='javascript:clearRadio(\"004007001\")'>" + "</leaf>" + "</branch>"
				+ "</branch>" + "<branch desc='Project management' id='005'>"
				+ "<leaf desc='Project Administration/Officer' id='005001' " + level005Desc
				+ " onclick='javascript:clearRadio(\"005001\")'>" + "</leaf>"
				+ "<leaf desc='Project Manager' id='005002' " + level005Desc
				+ " onclick='javascript:clearRadio(\"005002\")'>" + "</leaf>" + "</branch>"
				+ "<branch desc='Language' id='006'>" + "<leaf desc='Chinese' id='006001' "
				+ level006Desc + " onclick='javascript:clearRadio(\"006001\")'>" + "</leaf>"
				+ "<leaf desc='English' id='006002' " + level006Desc
				+ " onclick='javascript:clearRadio(\"006002\")'>" + "</leaf>"
				+ "<leaf desc='Japanese' id='006003' " + level006Desc
				+ " onclick='javascript:clearRadio(\"006003\")'>" + "</leaf>"
				+ "<leaf desc='Korean' id='006004' " + level006Desc
				+ " onclick='javascript:clearRadio(\"006004\")'>" + "</leaf>"
				+ "<leaf desc='Cantonese' id='006005' " + level006Desc
				+ " onclick='javascript:clearRadio(\"006005\")'>" + "</leaf>" + "</branch>"
				+ "</tree>";
		return xml;
	}

	private ActionForward exportToExcel(ActionMapping mapping, HttpServletRequest request,
			HttpServletResponse response, String catName, String levelName, List valueList) {

		try {
			// Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) {
				return null;
			}

			// Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\"" + SaveToFileName
					+ "\"");
			response.setContentType("application/octet-stream");

			// Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath + "\\"
					+ ExcelTemplate));
			// Select the first worksheet
			HSSFSheet sheet = wb.getSheet(FormSheetName);

			// Header
			HSSFRow row = null;
			HSSFCell cell = null;

			row = sheet.getRow(3);
			cell = row.getCell((short) 1); // Category Name.
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
			cell.setCellValue(catName);

			cell = sheet.getRow(4).getCell((short) 1); // Level Name
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(levelName);

			// List
			int excelRow = ListStartRow;
			// Style
			HSSFCellStyle textStyle = sheet.getRow(ListStartRow).getCell((short) 0).getCellStyle();

			for (int i = 0; i < valueList.size(); i++) {

				UserLogin tmpValue = ((Skill) valueList.get(i)).getEmployee();
				row = sheet.getRow(excelRow);

				String partyDesc = tmpValue.getParty().getDescription();
				cell = row.createCell((short) 0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				if (partyDesc == null || partyDesc.length() <= 0) {
					cell.setCellValue("");
				} else {
					cell.setCellValue(partyDesc);
				}
				cell.setCellStyle(textStyle);

				cell = row.createCell((short) 1);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(tmpValue.getUserLoginId() == null ? "" : tmpValue
						.getUserLoginId());
				cell.setCellStyle(textStyle);

				cell = row.createCell((short) 2);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(tmpValue.getName() == null ? "" : tmpValue.getName());
				cell.setCellStyle(textStyle);

				String staffType = tmpValue.getType();
				cell = row.createCell((short) 3);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				if (staffType == null || staffType.length() <= 0) {
					cell.setCellValue("");
				} else {
					cell.setCellValue(staffType);
				}
				cell.setCellStyle(textStyle);

				String tel = tmpValue.getTele_code();
				cell = row.createCell((short) 4);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				if (tel == null || tel.length() <= 0) {
					cell.setCellValue("");
				} else {
					cell.setCellValue(tel);
				}
				cell.setCellStyle(textStyle);

				String email = tmpValue.getEmail_addr();
				cell = row.createCell((short) 5);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				if (email == null || email.length() <= 0) {
					cell.setCellValue("");
				} else {
					cell.setCellValue(email);
				}
				cell.setCellStyle(textStyle);

				excelRow++;
			}
			// 写入Excel工作表
			wb.write(response.getOutputStream());
			// 关闭Excel工作薄对象
			response.getOutputStream().close();
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private ActionForward exportCertToExcel(ActionMapping mapping, HttpServletRequest request,
			HttpServletResponse response, UserLogin staff, List certList) {

		try {
			// Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) {
				return null;
			}

			// Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\"" + CertSaveToFileName
					+ "\"");
			response.setContentType("application/octet-stream");

			// Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath + "\\"
					+ CertExcelTemplate));
			// Select the first worksheet
			HSSFSheet sheet = wb.getSheet(CertFormSheetName);

			// Header
			HSSFRow row = null;
			HSSFCell cell = null;

			// Dept. name
			row = sheet.getRow(3);
			cell = row.getCell((short) 1);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
			cell.setCellValue(staff.getParty().getDescription() == null ? "" : staff.getParty()
					.getDescription());

			// User type
			cell = sheet.getRow(3).getCell((short) 3);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(staff.getType() == null ? "" : staff.getType());

			// Staff ID
			cell = sheet.getRow(4).getCell((short) 1);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(staff.getUserLoginId() == null ? "" : staff.getUserLoginId());

			// Tel
			cell = sheet.getRow(4).getCell((short) 3);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(staff.getTele_code() == null ? "" : staff.getTele_code());

			// Staff Name
			cell = sheet.getRow(5).getCell((short) 1);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(staff.getName() == null ? "" : staff.getName());

			// Email
			cell = sheet.getRow(5).getCell((short) 3);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(staff.getEmail_addr() == null ? "" : staff.getEmail_addr());

			// List
			int excelRow = CertListStartRow;
			// Style
			HSSFCellStyle textStyle = sheet.getRow(CertListStartRow).getCell((short) 0)
					.getCellStyle();

			for (int i = 0; i < certList.size(); i++) {

				SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy-MM-dd");

				SkillCert tmpValue = (SkillCert) certList.get(i);
				row = sheet.getRow(excelRow);

				cell = row.createCell((short) 0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(tmpValue.getCertDesc() == null ? "" : tmpValue.getCertDesc());
				cell.setCellStyle(textStyle);

				cell = row.createCell((short) 4);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(tmpValue.getDateGrant() == null ? "" : dateFormater
						.format(tmpValue.getDateGrant()));
				cell.setCellStyle(textStyle);

				excelRow++;
			}
			// 写入Excel工作表
			wb.write(response.getOutputStream());
			// 关闭Excel工作薄对象
			response.getOutputStream().close();
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private ActionForward exportExToExcel(ActionMapping mapping, HttpServletRequest request,
			HttpServletResponse response, UserLogin staff, List exList) {

		try {
			// Get Excel Template Path
			String TemplatePath = GetTemplateFolder();
			if (TemplatePath == null) {
				return null;
			}

			// Start to output the excel file
			response.reset();
			response.setHeader("Content-Disposition", "attachment;filename=\"" + ExSaveToFileName
					+ "\"");
			response.setContentType("application/octet-stream");

			// Use POI to read the selected Excel Spreadsheet
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(TemplatePath + "\\"
					+ ExExcelTemplate));
			// Select the first worksheet
			HSSFSheet sheet = wb.getSheet(ExFormSheetName);

			// Header
			HSSFRow row = null;
			HSSFCell cell = null;

			// Dept. name
			row = sheet.getRow(3);
			cell = row.getCell((short) 1);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);// 设置cell编码解决中文高位字节截断
			cell.setCellValue(staff.getParty().getDescription() == null ? "" : staff.getParty()
					.getDescription());

			// User type
			cell = sheet.getRow(3).getCell((short) 3);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(staff.getType() == null ? "" : staff.getType());

			// Staff ID
			cell = sheet.getRow(4).getCell((short) 1);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(staff.getUserLoginId() == null ? "" : staff.getUserLoginId());

			// Tel
			cell = sheet.getRow(4).getCell((short) 3);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(staff.getTele_code() == null ? "" : staff.getTele_code());

			// Staff Name
			cell = sheet.getRow(5).getCell((short) 1);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(staff.getName() == null ? "" : staff.getName());

			// Email
			cell = sheet.getRow(5).getCell((short) 3);
			cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			cell.setCellValue(staff.getEmail_addr() == null ? "" : staff.getEmail_addr());

			// List
			int excelRow = ExListStartRow;
			// Style
			HSSFCellStyle textStyle = sheet.getRow(ExListStartRow).getCell((short) 0)
					.getCellStyle();

			for (int i = 0; i < exList.size(); i++) {

				SkillEx tmpValue = (SkillEx) exList.get(i);
				row = sheet.getRow(excelRow);

				cell = row.createCell((short) 0);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(tmpValue.getExDesc() == null ? "" : tmpValue.getExDesc());
				cell.setCellStyle(textStyle);

				cell = row.createCell((short) 4);
				cell.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell.setCellValue(tmpValue.getExExp() == null ? "" : tmpValue.getExExp());
				cell.setCellStyle(textStyle);

				excelRow++;
			}
			// 写入Excel工作表
			wb.write(response.getOutputStream());
			// 关闭Excel工作薄对象
			response.getOutputStream().close();
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private final static String FormSheetName = "Form";

	private final static String ExcelTemplate = "SkillSetResult.xls";

	private final static String SaveToFileName = "Skill Set Report.xls";

	private final int ListStartRow = 7;

	private final static String CertFormSheetName = "Form";

	private final static String CertExcelTemplate = "SkillSetCertification.xls";

	private final static String CertSaveToFileName = "Skill Set Certification Report.xls";

	private final int CertListStartRow = 8;

	private final static String ExFormSheetName = "Form";

	private final static String ExExcelTemplate = "SkillSetExperience.xls";

	private final static String ExSaveToFileName = "Skill Set Projects Experience Report.xls";

	private final int ExListStartRow = 8;
}