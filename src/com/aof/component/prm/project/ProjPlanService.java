package com.aof.component.prm.project;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.aof.webapp.action.prm.projectmanager.ProjectBOMBean;
import com.shcnc.utils.XmlBuilder;

public class ProjPlanService {
	private List list;

	private List stdList;

	private List rootList;

	private HashMap actMap;

	private List stdrootList;

	private List bomrootList;

	public ProjPlanService(List result, HashMap map, List list, int flag) {
		this.rootList = new ArrayList();
		this.stdrootList = new ArrayList();
		this.bomrootList = new ArrayList();

		if (result == null)
			this.list = new ArrayList();
		else {
			this.list = result;
			if (flag == 1)
				buildSeperateTree(1);
		}
		if (map == null)
			this.actMap = new HashMap();
		else
			this.actMap = map;
		if (list == null)
			this.stdList = new ArrayList();
		else {
			this.stdList = list;
			if (flag == 1)
				buildSeperateTree(0);
		}
	}

	public String BuildXMLTree(int flag) {
		if (flag == 0) // for new bom
		{
			Iterator itor = list.iterator();
			HashMap bomItems = new HashMap();
			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			DocumentBuilder builder;
			try {
				builder = factory.newDocumentBuilder();
			} catch (ParserConfigurationException e) {
				throw new RuntimeException(e);
			}
			Document doc = builder.newDocument();

			while (itor.hasNext()) {
				StandardBOM d = (StandardBOM) itor.next();
				bomItems.put(new Long(d.getId()), d);
			}
			itor = list.iterator();
			while (itor.hasNext()) {
				StandardBOM d = (StandardBOM) itor.next();
				d = (StandardBOM) bomItems.get(new Long(d.getId()));
				StandardBOM pd = d.getParent();
				if (pd.getId() == d.getId()) {
					rootList.add(d);
				} else {
					pd = (StandardBOM) bomItems.get(new Long(pd.getId()));
					pd.addChild(d);
				}
			}
			Element tree = doc.createElement("tree");

			buildTree(rootList, doc, tree, flag);
			doc.appendChild(tree);
			XmlBuilder xmlBuilder = new XmlBuilder();
			xmlBuilder.setXmlHeader("");
			return xmlBuilder.printDOMTree(doc);
		}
		if (flag == 1) // for update bom
		{
			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			DocumentBuilder builder;
			try {
				builder = factory.newDocumentBuilder();
			} catch (ParserConfigurationException e) {
				throw new RuntimeException(e);
			}
			Document doc = builder.newDocument();

			ChildrenCombine(null, this.stdrootList, this.bomrootList);

			Element tree = doc.createElement("tree");

			buildTree(rootList, doc, tree, flag);
			doc.appendChild(tree);
			XmlBuilder xmlBuilder = new XmlBuilder();
			xmlBuilder.setXmlHeader("");
			return xmlBuilder.printDOMTree(doc);
		} else
			return null;

	}

	private void buildTree(List roots, Document doc, Node parent, int flag) {
		if (flag == 0) // new bom
		{
			int len = roots.size();
			for (int i = 0; i < len; i++) {
				Element e = null;
				StandardBOM d = (StandardBOM) (roots.get(i));
				ProjPlanBom temp = (ProjPlanBom) this.actMap
						.get(d.getRanking());
				long id = d.getId();
				List children = d.getChildren();
				if (children == null || children.isEmpty()) {
					e = doc.createElement("leaf");
				} else {
					e = doc.createElement("branch");
					buildTree(children, doc, e, flag);
				}
				e.setAttribute("id", new Long(id).toString());
				if (temp == null)
					e.setAttribute("_id", id + "-");// store the id
				else
					e.setAttribute("_id", id + "-" + temp.getId());
				e.setAttribute("desc", d.getStepdesc());// store
				e.setAttribute("descid", "desc" + d.getId());
				e.setAttribute("parentid", "parent" + d.getId());
				if (d.getParent() != null)
					e.setAttribute("parent", d.getParent().getId() + "-"
							+ d.getRanking());
				else
					e.setAttribute("parent", "-" + d.getRanking());
				e.setAttribute("check", "chk");
				e.setAttribute("branchroot", "branchroot");
				e.setAttribute("onclick", "Tick('" + id + "')");
				if (temp != null)
					e.setAttribute("status", "1");
				else
					e.setAttribute("status", "0");
				parent.appendChild(e);
			}
		}
		if (flag == 1) // update bom
		{
			int len = roots.size();
			for (int i = 0; i < len; i++) {
				Element e = null;

				ProjectBOMBean d = (ProjectBOMBean) (roots.get(i));

				long id = d.getStd_id(); // this is for std id
				List children = d.getChild();
				if (children == null || children.isEmpty()) {
					e = doc.createElement("leaf");
				} else {
					e = doc.createElement("branch");
					buildTree(children, doc, e, flag);
				}

				if (d.getBom_desc() == null) {
					e.setAttribute("id", d.getStd_rank());
					e.setAttribute("_id", d.getStd_rank());
					e.setAttribute("desc", d.getStd_desc());// store
					e.setAttribute("descid", "desc" + d.getStd_rank());
					e.setAttribute("status", "0");

				} else {
					e.setAttribute("id", d.getBom_rank());
					e.setAttribute("_id", d.getBom_rank());
					e.setAttribute("desc", d.getBom_desc());// store
					e.setAttribute("descid", "desc" + d.getBom_rank());
					e.setAttribute("status", "1");
				}
				e.setAttribute("check", "chk");
				e.setAttribute("branchroot", "branchroot");
				e.setAttribute("onclick", "Tick()");

				parent.appendChild(e);
			}
		}

	}

	public void ChildrenCombine(ProjectBOMBean pBean, List std, List bom) {

		if ((std != null) || (bom != null)) {
			ProjectBOMBean stdbean = null;
			ProjectBOMBean bombean = null;
			Iterator it = null;
			Iterator itor = null;
			if (std != null) {
				it = std.iterator();
				if (it.hasNext())
					stdbean = (ProjectBOMBean) it.next();
			}
			if (bom != null) {
				itor = bom.iterator();
				if (itor.hasNext())
					bombean = (ProjectBOMBean) itor.next();
			}

			while ((stdbean != null) || (bombean != null)) {
				if ((stdbean != null) && (bombean != null)) {
					if (stdbean.getStd_rank().equalsIgnoreCase(
							bombean.getBom_rank())) {
						ProjectBOMBean tempBean = new ProjectBOMBean();
						tempBean.setBom_desc(bombean.getBom_desc());
						tempBean.setBom_id(bombean.getBom_id());
						tempBean.setBom_rank(bombean.getBom_rank());

						tempBean.setStd_desc(stdbean.getStd_desc());
						tempBean.setStd_id(stdbean.getStd_id());
						tempBean.setStd_rank(stdbean.getStd_rank());

						if (pBean == null)
							this.rootList.add(tempBean);
						else
							pBean.addChild(tempBean);

						if ((stdbean.getChild() != null)
								|| (bombean.getChild() != null)) {
							ChildrenCombine(tempBean, stdbean.getChild(),
									bombean.getChild()); // inner cycle
						}

						if (it.hasNext())
							stdbean = (ProjectBOMBean) it.next();
						else
							stdbean = null;
						if (itor.hasNext())
							bombean = (ProjectBOMBean) itor.next();
						else
							bombean = null;
					} else {
						ProjectBOMBean tempBean = new ProjectBOMBean();
						tempBean.setStd_desc(stdbean.getStd_desc());
						tempBean.setStd_id(stdbean.getStd_id());
						tempBean.setStd_rank(stdbean.getStd_rank());
						if (pBean == null)
							this.rootList.add(tempBean);
						else
							pBean.addChild(tempBean);
						ChildrenCombine(tempBean, stdbean.getChild(), null);

						if (it.hasNext())
							stdbean = (ProjectBOMBean) it.next();
						else
							stdbean = null;
					}
				} else if (stdbean != null) {
					ProjectBOMBean tempBean = new ProjectBOMBean();
					tempBean.setStd_desc(stdbean.getStd_desc());
					tempBean.setStd_id(stdbean.getStd_id());
					tempBean.setStd_rank(stdbean.getStd_rank());
					if (pBean == null)
						this.rootList.add(tempBean);
					else
						pBean.addChild(tempBean);

					ChildrenCombine(tempBean, stdbean.getChild(), null);
					if (it.hasNext())
						stdbean = (ProjectBOMBean) it.next();
					else
						stdbean = null;
				} else if (bombean != null) {
					ProjectBOMBean tempBean = new ProjectBOMBean();
					tempBean.setBom_desc(bombean.getBom_desc());
					tempBean.setBom_id(bombean.getBom_id());
					tempBean.setBom_rank(bombean.getBom_rank());

					if (pBean == null)
						this.rootList.add(tempBean);
					else
						pBean.addChild(tempBean);

					ChildrenCombine(tempBean, null, bombean.getChild()); // inner
					// cycle
					if (itor.hasNext())
						bombean = (ProjectBOMBean) itor.next();
					else
						bombean = null;
				}
			}
		}
	}

	public void buildSeperateTree(int flag) {
		if (flag == 0) // std bom list
		{
			HashMap map = new HashMap();
			Iterator it = this.stdList.iterator();
			while (it.hasNext()) {
				StandardBOM bom = (StandardBOM) it.next();
				StandardBOM pbom = bom.getParent();
				ProjectBOMBean pbean = null;
				if (pbom != null)
					pbean = (ProjectBOMBean) map.get(pbom.getRanking());

				ProjectBOMBean bean = new ProjectBOMBean();
				bean.setStd_desc(bom.getStepdesc());
				bean.setStd_id(bom.getId());
				bean.setStd_rank(bom.getRanking());

				if (pbom.getId() == bom.getId()) {
					this.stdrootList.add(bean);
				} else {
					if (pbean != null)
						pbean.addChild(bean);
				}
				map.put(bom.getRanking(), bean);

			}
		} else if (flag == 1) {
			HashMap map = new HashMap();
			Iterator it = this.list.iterator();
			while (it.hasNext()) {
				ProjPlanBom bom = (ProjPlanBom) it.next();
				ProjPlanBom pbom = bom.getParent();
				ProjectBOMBean pbean = null;
				if (pbom != null)
					pbean = (ProjectBOMBean) map.get(pbom.getRanking());

				ProjectBOMBean bean = new ProjectBOMBean();
				bean.setBom_desc(bom.getStepdesc());
				bean.setBom_id(bom.getId());
				bean.setBom_rank(bom.getRanking());

				if (pbom == null) {
					this.bomrootList.add(bean);
				} else {
					if (pbean != null) {
						pbean.addChild(bean);
					}
				}
				map.put(bom.getRanking(), bean);

			}

		}

	}
}
