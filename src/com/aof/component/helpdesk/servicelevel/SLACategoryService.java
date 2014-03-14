/*
 * Created on 2004-11-16
 *
 */
package com.aof.component.helpdesk.servicelevel;

import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;
import java.util.Locale;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import net.sf.hibernate.Hibernate;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.Transaction;

import com.aof.component.BaseServices;
import com.aof.component.domain.party.UserLogin;
import com.aof.component.helpdesk.ModifyLog;
import com.aof.webapp.action.ActionException;
import com.aof.webapp.action.ActionUtils;
import com.shcnc.utils.XmlBuilder;

/**
 * @author zhangyan
 * 
 *  
 */
public class SLACategoryService extends BaseServices {
    
	public SLACategory find(Integer id) {
		if (id == null) return null;
		try {
			getSession();
			return find(id, session);
		} catch (HibernateException e) {
			e.printStackTrace();
		} finally {
			closeSession();
		}
		return null;
	}

	public static SLACategory find(Integer id, Session sess) throws HibernateException {
		return (SLACategory) sess.get(SLACategory.class, id);
	}

	public SLACategory findFirstClass(Integer id) throws Exception {
		try {
			getSession();
			return findFirstClass(id, session);
		} catch (Exception e) {
			throw e;
		} finally {
			closeSession();
		}
	}
    
	public static SLACategory findFirstClass(Integer id, Session sess) throws Exception {
		SLACategory category = find(id, sess);
		if (category == null) throw new ActionException("helpdesk.servicelevel.category.error.notfound");
		String fullpath = category.getFullPath();
		if (fullpath == null) throw new ActionException("helpdesk.servicelevel.category.error.notfound");
		int i = fullpath.indexOf('.');
		Integer fid = ActionUtils.parseInt(i == -1 ? fullpath : fullpath.substring(0, i));
		category = find(fid, sess);
		if (category == null) throw new ActionException("helpdesk.servicelevel.category.error.notfound");
		return category;
	}

/*    
	public static SLACategory findFirstClass(Integer id, Session sess) throws Exception {
		SLACategory category = null;
		while (id != null) {
			category = find(id, sess);
			if (category == null) throw new ActionException("helpdesk.servicelevel.category.error.notfound");
			id = category.getParentId();
		}
		return category;
	}
*/
    
	public String getPathDesc(SLACategory category, Locale locale) throws Exception {
		category.setLocale(locale);
		return category.getFullDesc();
	}
    
	public SLACategory insert(SLACategory newone, UserLogin user) throws Exception {
		Transaction tx = null;

		try {
			getSession();
			tx = session.beginTransaction();
			SLAMaster master = newone.getMaster();
			if (master == null) throw new ActionException("helpdesk.servicelevel.master.error.notfound");
			master = SLAMasterService.find(master.getId(), session);
			if (master == null) throw new ActionException("helpdesk.servicelevel.master.error.notfound");
			Integer parentId = newone.getParentId();
			String fullpath = null;
			String fullchsdesc = null;
			String fullengdesc = null;
			if (parentId != null) {
				SLACategory parent = find(parentId, session);
				if (parent == null) throw new ActionException("helpdesk.servicelevel.category.error.notfound");
				fullpath = parent.getFullPath();
				fullchsdesc = parent.getFullchsDesc();
				fullengdesc = parent.getFullengDesc();
			}
			ModifyLog mlog = new ModifyLog();
			mlog.setCreateDate(new Date());
			mlog.setCreateUser(user);
			newone.setModifyLog(mlog);
			session.save(newone);
			if (fullpath == null) {
				newone.setFullPath(newone.getId().toString() + '.');
				newone.setFullchsDesc(newone.getChsDesc());
				newone.setFullengDesc(newone.getEngDesc());
			} else {
				newone.setFullPath(fullpath + newone.getId().toString() + '.');
				newone.setFullchsDesc(fullchsdesc + "\\" + newone.getChsDesc());
				newone.setFullengDesc(fullchsdesc + "\\" + newone.getEngDesc());
			}
			session.update(newone);
			tx.commit();
			return newone;
		} catch (Exception e) {
			try {
				if (tx != null) tx.rollback();
			} catch (HibernateException e1) { }
			throw e;
		} finally {
			closeSession();
		}
	}

	public SLACategory update(SLACategory newone, UserLogin user) throws Exception {
		Transaction tx = null;

		try {
			String chsDesc, engDesc;
			boolean modified = false;

			getSession();
			tx = session.beginTransaction();
			SLACategory oldone = find(newone.getId(), session);
			if (oldone == null) throw new ActionException("helpdesk.servicelevel.category.error.notfound");
			chsDesc = newone.getChsDesc();
			engDesc = newone.getEngDesc();
			modified = !isEqual(chsDesc, oldone.getChsDesc()) || !isEqual(engDesc, oldone.getEngDesc());
			if (modified) {
				oldone.setChsDesc(chsDesc);
				oldone.setEngDesc(engDesc);
				Integer parentId = oldone.getParentId();
				
				//Update full description
				if (parentId != null) {
					SLACategory parent = find(parentId, session);
					if (parent == null) throw new ActionException("helpdesk.servicelevel.category.error.notfound");
					oldone.setFullchsDesc(parent.getFullchsDesc()+ "\\" + oldone.getChsDesc());
					oldone.setFullengDesc(parent.getFullengDesc()+ "\\" + oldone.getEngDesc());
				} else {
					oldone.setFullchsDesc(oldone.getChsDesc());
					oldone.setFullengDesc(oldone.getEngDesc());
				}
				
				ModifyLog mlog = oldone.getModifyLog();
				mlog.setModifyDate(new Date());
				mlog.setModifyUser(user);
				session.update(oldone);
			}
			tx.commit();
			session.flush();
			if (modified) updateCategoryFullDesc(oldone);
			return oldone;
		} catch (HibernateException e) {
			try {
				if (tx != null) tx.rollback();
			} catch (HibernateException el) { }
			throw e;
		} finally {
			closeSession();
		}
	}

	public void delete(Integer id) throws Exception {
		Transaction tx = null;
		if (id == null) throw new ActionException("helpdesk.servicelevel.category.error.notfound");
		try {
			getSession();
			tx = session.beginTransaction();
			SLACategory category = find(id, session);
			session.delete(category);
			try {
				session.flush();
			} catch (Exception e) {
				try {
					tx.rollback();
				} catch (Exception ee) { }
				throw new ActionException("helpdesk.servicelevel.category.error.cannotdelete");
			}
			tx.commit();
		} catch (Exception e) {
			throw e;
		} finally {
			closeSession();
		}
	}

	public void updateCategoryFulPath(Integer masterid) {
		Transaction tx = null;
		try {
			getSession();
			tx = session.beginTransaction();
			List l = session.find("from SLACategory c where c.master.id = ?", masterid, Hibernate.INTEGER);
			Hashtable h = new Hashtable();
			for (int i = 0; i < l.size(); i++) {
				SLACategory c = (SLACategory)l.get(i);
				c.setFullPath(null);
				h.put(c.getId(), c);
			}
			for (int i = 0; i < l.size(); i++) {
				SLACategory c = (SLACategory)l.get(i);
				c.setFullPath(calculateFullPath(c, h));
			}
			tx.commit();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeSession();
		}
	}

	private String calculateFullPath(SLACategory c, Hashtable h) {
		if (c.getFullPath() != null) return c.getFullPath();
		Integer id = c.getId();
		Integer pid = c.getParentId();
		if (pid == null) {
			return id.toString() + '.';
		}
		SLACategory pc = (SLACategory)h.get(pid);
		if (pc == null) {
			System.err.println("Cannot find sla category with id = " + pid);
			return id.toString() + '.';
		}
		return calculateFullPath(pc, h) + id.toString() + '.';
	}
	
	public void updateCategoryFullDesc(Integer masterid) {
		Transaction tx = null;
		try {
			getSession();
			tx = session.beginTransaction();
			List l = session.find("from SLACategory c where c.master.id = ? order by c.fullPath", masterid, Hibernate.INTEGER);
			Hashtable h = new Hashtable();
			for (int i = 0; i < l.size(); i++) {
				SLACategory c = (SLACategory)l.get(i);
				c.setFullchsDesc(null);
				c.setFullengDesc(null);
				h.put(c.getId(), c);
			}
			for (int i = 0; i < l.size(); i++) {
				SLACategory c = (SLACategory)l.get(i);
				String Desc[] = calculateFullDesc(c,h);
				c.setFullchsDesc(Desc[0]);
				c.setFullengDesc(Desc[1]);
			}
			tx.commit();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeSession();
		}
	}
	
	public void updateCategoryFullDesc(SLACategory pc) {
		Transaction tx = null;
		try {
			getSession();
			tx = session.beginTransaction();
			List l = session.find("from SLACategory c where c.fullPath like '"+pc.getFullPath()+"%' order by c.fullPath");
			Hashtable h = new Hashtable();
			for (int i = 0; i < l.size(); i++) {
				SLACategory c = (SLACategory)l.get(i);
				if (!pc.getId().equals(c.getId())) {
					c.setFullchsDesc(null);
					c.setFullengDesc(null);
				}
				h.put(c.getId(), c);
			}
			
			for (int i = 0; i < l.size(); i++) {
				SLACategory c = (SLACategory)l.get(i);
				if (!pc.getId().equals(c.getId())) {
					String Desc[] = calculateFullDesc(c,h);
					c.setFullchsDesc(Desc[0]);
					c.setFullengDesc(Desc[1]);
				}
			}
			tx.commit();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeSession();
		}
	}
		
	private String[] calculateFullDesc(SLACategory c, Hashtable h){
		String Desc[] = {"",""};
		Integer id = c.getId();
		Integer pid = c.getParentId();
		if (pid == null) {
			Desc[0] = c.getChsDesc();
			Desc[1] = c.getEngDesc();
			return Desc;
		}
		SLACategory pc = (SLACategory)h.get(pid);
		if (pc == null) {
			System.err.println("Cannot find sla category with id = " + pid);
			return Desc;
		}
		Desc[0] = pc.getFullchsDesc() +"\\"+c.getChsDesc();
		Desc[1] = pc.getFullengDesc() +"\\"+c.getEngDesc();
		return Desc;
	}
	
	public String getAllForMasterAsXml(Integer masterid, Locale locale) throws Exception {
		try {
			getSession();
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document doc = builder.newDocument();

			List roots = session.find("from SLACategory c where c.parentId is null and c.master.id = ? order by c.id", masterid, Hibernate.INTEGER);
			Hashtable others = listToHashtable(session.find("from SLACategory c where not (c.parentId is null) and c.master.id = ? order by c.parentId, c.id", masterid, Hibernate.INTEGER));
			Element tree = doc.createElement("tree");
            
			buildTree(roots, others, doc, tree, locale);
			//loadLazyChildren(roots.toArray(), doc, tree, locale);
			doc.appendChild(tree);
			XmlBuilder xmlBuilder = new XmlBuilder();
			xmlBuilder.setXmlHeader("");
			return xmlBuilder.printDOMTree(doc);
		} catch (Exception e) {
			throw e;
		} finally {
			closeSession();
		}
	}

	private void buildTree(List roots, Hashtable others, Document doc, Node parent, Locale locale) {
		int len = roots.size();
		for (int i = 0; i < len; i++) {
			Element e = null;
			SLACategory p = (SLACategory)(roots.get(i));
			Integer id = p.getId();
			List children = (List)others.remove(id);
			if (children == null) {
				e = doc.createElement("leaf");
			} else {
				e = doc.createElement("branch");
				buildTree(children, others, doc, e, locale);
			}
			e.setAttribute("id", id.toString());
			p.setLocale(locale);
			e.setAttribute("desc", p.getDesc());
			parent.appendChild(e);
		}
	}
    
	private Hashtable listToHashtable(List l) {
		Hashtable result = new Hashtable();
		int len = l.size();
		Integer ppid = null;
		ArrayList cl = null;
		for (int i = 0; i < len; i++) {
			SLACategory category = (SLACategory)(l.get(i));
			Integer pid = category.getParentId();
			if (!pid.equals(ppid)) {
				if (ppid != null) result.put(ppid, cl);
				cl = new ArrayList();
				ppid = pid;
			}
			cl.add(category);
		}
		if (ppid != null) result.put(ppid, cl);
		return result;
	}
    
	public List getAll() throws Exception {
		try {
			getSession();
			return session.find("select slac from SLACategory as slac");
		} catch (Exception e) {
			throw e;
		} finally {
			closeSession();
		}

	}

}