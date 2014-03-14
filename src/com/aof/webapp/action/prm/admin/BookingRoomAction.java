package com.aof.webapp.action.prm.admin;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Query;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;

import com.aof.component.domain.party.UserLogin;
import com.aof.component.prm.admin.BookingRoomVO;
import com.aof.core.persistence.hibernate.Hibernate2Session;
import com.aof.util.UtilDateTime;

public class BookingRoomAction extends DispatchAction {

	public ActionForward preview(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		return mapping.findForward("preview-success");
	}

	public ActionForward list4Add(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

	//	Logger log = Logger.getLogger(EditPreSaleProjectAction.class.getName());
		String action = request.getParameter("formAction");
	//	log.info("action=" + action);

		String strDate = request.getParameter("date");
		Date date = UtilDateTime.toDate2(strDate + " 00:00:00.000");
		String room = request.getParameter("room");

		if (action == null) {
			action = "view";
		}

		try {
			Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;

			if (action.equals("create")) {

				String personId = request.getParameter("iPerson");
				String startTime = request.getParameter("iStartTime");
				String endTime = request.getParameter("iEndTime");

				BookingRoomVO tmpValue = new BookingRoomVO();
				UserLogin person = new UserLogin();

				tmpValue.setBookingDate(date);
				tmpValue.setRoom(room);
				tmpValue.setStartTime(startTime);
				tmpValue.setEndTime(endTime);

				tx = hs.beginTransaction();

				person = (UserLogin) hs.load(person.getClass(), personId);
				tmpValue.setPerson(person);
				hs.save(tmpValue);

				hs.flush();
				tx.commit();
			}

			if (action.equals("remove")) {

				Long id = Long.valueOf(request.getParameter("bookingId"));

				tx = hs.beginTransaction();

				BookingRoomVO tmpValue = (BookingRoomVO) hs.load(
						BookingRoomVO.class, id);
				hs.delete(tmpValue);

				hs.flush();
				tx.commit();
			}

			if (action.equals("update")) {

				String bookingId[] = request.getParameterValues("bookingId");
				String startTime[] = request.getParameterValues("startTime");
				String endTime[] = request.getParameterValues("endTime");

				BookingRoomVO tmpValue = new BookingRoomVO();

				tx = hs.beginTransaction();

				int rowSize = java.lang.reflect.Array.getLength(bookingId);
				for (int i = 0; i < rowSize; i++) {
					Long id = null;
					if (bookingId[i] != null && bookingId[i].length() > 0) {
						id = Long.valueOf(bookingId[i]);
						tmpValue = (BookingRoomVO) hs.load(BookingRoomVO.class,
								id);
						tmpValue.setStartTime(startTime[i]);
						tmpValue.setEndTime(endTime[i]);
						hs.update(tmpValue);
					}
				}
				tx.commit();
				hs.flush();
			}

			if (action.equals("view") || action.equals("create")
					|| action.equals("remove") || action.equals("update")) {

				request.setAttribute("dateAdd", strDate);
				request.setAttribute("roomAdd", room);

				tx = hs.beginTransaction();
				List valueList = null;

				Query query = hs
						.createQuery("from BookingRoomVO as br where br.room=? and br.bookingDate=? order by br.startTime");
				query.setString(0, room);
				query.setDate(1, date);
				valueList = query.list();

				request.setAttribute("valueList", valueList);
				hs.flush();
				tx.commit();
			}
		} catch (Exception e) {
			e.printStackTrace();
		//	log.error(e.getMessage());
			return (mapping.findForward("view"));
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
		return mapping.findForward("list4Add-success");
	}

	public ActionForward query(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		String room = request.getParameter("room");
		String strDate = request.getParameter("date");
		Date startDay = UtilDateTime.getThisWeekDay(strDate, 1);
		Date endDay = UtilDateTime.getDiffDay(startDay, 6);

		try {
			Session hs = Hibernate2Session.currentSession();
			Transaction tx = null;
			tx = hs.beginTransaction();
			List valueList = null;

			if (room == null || room.trim().equals("")) {
				Query query = hs
						.createQuery("from BookingRoomVO as br where br.bookingDate>=? and br.bookingDate<=? order by br.bookingDate,br.room,br.startTime");
				query.setDate(0, startDay);
				query.setDate(1, endDay);
				valueList = query.list();
			} else {
				Query query = hs
						.createQuery("from BookingRoomVO as br where br.room=? and br.bookingDate>=? and br.bookingDate<=? order by br.bookingDate,br.room,br.startTime");
				query.setString(0, room);
				query.setDate(1, startDay);
				query.setDate(2, endDay);
				valueList = query.list();
			}
			request.setAttribute("valueList", valueList);
			request.setAttribute("startDay", startDay);
			hs.flush();
			tx.commit();

		} catch (Exception e) {
			e.printStackTrace();
		//	log.error(e.getMessage());
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
		return mapping.findForward("query-success");
	}
}
