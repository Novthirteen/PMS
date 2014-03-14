//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package com.aof.webapp.action.helpdesk;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.hibernate.HibernateException;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.aof.component.helpdesk.AttachmentService;
import com.aof.component.helpdesk.DetailAttachment;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.action.ActionUtils;
import com.aof.webapp.action.BaseAction;
import com.aof.webapp.form.helpdesk.UploadForm;

//import org.apache.struts.util.RequestUtils;

/**
 * MyEclipse Struts Creation date: 11-18-2004
 * 
 * XDoclet definition:
 * 
 * @struts:action
 */
public class AttachmentAction extends com.shcnc.struts.action.BaseAction {

	// --------------------------------------------------------- Instance
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
		else if (action.equals(VIEW)) {
			return download(mapping, form, request, response);
		}
		else if (action.equals(LIST)) {
			return list(mapping, form, request, response);
		}
		else if (action.equals(DELETE)) {
			return delete(mapping, form, request, response);
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
		final String groupId = (request.getParameter(GROUP_ID));
		if (groupId == null) {
			throw new ActionException("helpdesk.attachment.error.not.enough.parameters");
		}
		if (groupId.trim().length() != 32) {
			throw new ActionException("helpdesk.attachment.error.attach.groupid");
		}
		request.getSession().setAttribute("upload_groupid",groupId.trim());
		UploadForm uploadForm = (UploadForm) this.getForm("/helpdesk.insertAttachment",
				request);
		uploadForm.setGroupID(groupId);
		return mapping.findForward("jsp");
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return @throws
	 *         HibernateException
	 */
	private ActionForward delete(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws HibernateException {
		final Integer id = ActionUtils.parseInt(request.getParameter("id"));
		if (id == null) {
			throw new RuntimeException("helpdesk.attachment.error.para");
		}
		final String groupId = (request.getParameter("groupid"));
		if (groupId.trim().length() != 32) {
			throw new RuntimeException("helpdesk.attachment.error.attach.groupid");
		}
		AttachmentService service = new AttachmentService();
		service.delete(id);
		ActionForward retVal = new ActionForward("/helpdesk.listAttachment.do?groupid="
				+ groupId);
		retVal.setRedirect(true);
		return retVal;
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return @throws
	 *         HibernateException
	 */
	private ActionForward list(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws HibernateException {
		final String groupId = (request.getParameter("groupid"));
		if (groupId.trim().length() != 32) {
			throw new RuntimeException("helpdesk.attachment.error.attach.groupid");
		}
		AttachmentService service = new AttachmentService();
		List attachList = service.list(groupId);
		request.setAttribute("attachList", attachList);
		final String listPage = request.getParameter("listPage");
		if (listPage != null) {
			return new ActionForward(listPage);
		}

		return mapping.findForward("defaultListPage");
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return @throws
	 *         HibernateException
	 */
	private static final String SUBJECT = "attachment.title";

	private ActionForward download(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException, HibernateException, IllegalAccessException,
			InvocationTargetException {
		final Integer id = ActionUtils.parseInt(request.getParameter("id"));
		if (id == null) {
			throw new ActionException("helpdesk.attachment.error.para");
		}
		AttachmentService service = new AttachmentService();
		DetailAttachment detail = service.getDetail(id);
		if (detail == null) {
			throw new ActionException(ActionUtils.ERROR_NOT_FOUND, SUBJECT);
		}
		download(detail, request, response);
		return null;
	}

	private final static String DEFAULT_MIME_TYPE = "application/octet-stream";

	/**
	 * @param detail
	 * @param response
	 * @throws IOException
	 */
	private void download(DetailAttachment detail, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.reset();
		response.setHeader("Server", "yech@cst");

		//���߿ͻ�������ϵ��������߳���������
		//��Ӧ�ĸ�ʽ��:
		//Accept-Ranges: bytes
		response.setHeader("Accept-Ranges", "bytes");

		int startPos = 0;
		final int length = detail.getSize().intValue();

		//����ǵ�һ����,��û�жϵ�����,״̬��Ĭ�ϵ� 200,������ʽ����
		//��Ӧ�ĸ�ʽ��:
		//HTTP/1.1 200 OK
		if (request.getHeader("Range") != null) //�ͻ�����������ص��ļ���Ŀ�ʼ�ֽ�
		{
			//����������ļ��ķ�Χ������ȫ��,��ͻ�������֧�ֲ���ʼ�ļ�������
			//Ҫ����״̬
			//��Ӧ�ĸ�ʽ��:
			//HTTP/1.1 206 Partial Content
			response
					.setStatus(javax.servlet.http.HttpServletResponse.SC_PARTIAL_CONTENT);//206
			//�������еõ���ʼ���ֽ�
			//����ĸ�ʽ��:
			//Range: bytes=[�ļ���Ŀ�ʼ�ֽ�]-
			startPos = Integer.parseInt(request.getHeader("Range").replaceAll(
					"bytes=", "").replaceAll("-", ""));
		}

		//���ص��ļ�(���)����
		//��Ӧ�ĸ�ʽ��:
		//Content-Length: [�ļ����ܴ�С] - [�ͻ�����������ص��ļ���Ŀ�ʼ�ֽ�]
		response.setHeader("Content-Length", new Long(length - startPos)
				.toString());
		if (startPos != 0) {
			//���Ǵ��ʼ����,
			//��Ӧ�ĸ�ʽ��:
			//Content-Range: bytes [�ļ���Ŀ�ʼ�ֽ�]-[�ļ����ܴ�С - 1]/[�ļ����ܴ�С]
			response.setHeader("Content-Range", "bytes " + startPos + "-"
					+ (length - 1) + "/" + length);
		}

		//ʹ�ͻ���ֱ������
		//��Ӧ�ĸ�ʽ��:
		//Content-Type: application/octet-stream
		response.setContentType(detail.getMime());

		if (detail.getMime().equals(DEFAULT_MIME_TYPE)) {
			//Ϊ�ͻ�������ָ��Ĭ�ϵ������ļ�����
			//��Ӧ�ĸ�ʽ��:
			//Content-Disposition: attachment;filename="[�ļ���]"
			//response.setHeader("Content-Disposition",
			// "attachment;filename=\"" + s.substring(s.lastIndexOf("\\") + 1) +
			// "\"");
			response.setHeader("Content-Disposition", "attachment;filename=\""
					+ detail.getName() + "\"");
		}

		//output file
		response.getOutputStream().write(detail.getContent(), startPos,
				length - startPos);

		//flush
		//response.flushBuffer();
		response.setStatus( HttpServletResponse.SC_OK );
        response.flushBuffer();
	}

	/**
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 */
	private final static String GROUP_ID = "groupid";

	private ActionForward upload(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws FileNotFoundException, IOException, HibernateException {
			
		try {
			final UploadForm uploadForm = (UploadForm) form;
			if (uploadForm.getFile() == null) {
				this.postGlobalError("helpdesk.attachment.error.upload.exceed.maxsize", request);
				UploadForm newForm = (UploadForm) this.getForm("/helpdesk.insertAttachment",
						request);
				final String groupID=(String) request.getSession().getAttribute("upload_groupid");
				newForm.setGroupID(groupID);
				return mapping.getInputForward();
			}
			AttachmentService service = new AttachmentService();
			final String fileName = uploadForm.getFile().getFileName();
			if (fileName.trim().length() == 0) {
				this.postGlobalError("helpdesk.attachment.error.upload.no.file", request);
				return mapping.getInputForward();
			}
			byte[] content = uploadForm.getFile().getFileData();
			if (content.length == 0) {
				this.postGlobalError("helpdesk.attachment.error.upload.size.zero", request);
				return mapping.getInputForward();
			}
			DetailAttachment attach = new DetailAttachment();
			attach.setContent(content);
			attach.setCreateDate(new Date());
			attach.setTitle(uploadForm.getTitle());
			attach.setCreateUser(ActionUtils.getCurrentUser(request));
			attach.setMime(this.getMime(uploadForm.getFile().getFileName()));
			attach.setName(uploadForm.getFile().getFileName());
			attach.setSize(new Integer(uploadForm.getFile().getFileSize()));
			attach.setGroupid(uploadForm.getGroupID());
			boolean success = service.insert(attach);
			this.postGlobalMessage("helpdesk.attachment.upload.success",uploadForm.getFile().getFileName(),
						request);
			return mapping.getInputForward();
		} catch (Throwable e) {
			e.printStackTrace();
			this.postGlobalError("helpdesk.attachment.error.upload.failed", request);
			return mapping.getInputForward();
		}

	}

	private String getMime(String file) {
		String retVal = DEFAULT_MIME_TYPE;
		file = file.toLowerCase();
		if (file.endsWith(".txt")) {
			return "text/plain";
		}
		if (file.endsWith(".htm") || file.endsWith(".html")) {
			return "text/html";
		}
		if (file.endsWith(".jpg") || file.endsWith(".jpeg")) {
			return "image/jpeg";
		}
		if (file.endsWith(".gif")) {
			return "image/gif";
		}
		return retVal;
	}
}

