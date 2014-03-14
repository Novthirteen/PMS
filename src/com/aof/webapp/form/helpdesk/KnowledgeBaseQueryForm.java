/*
 * Created on 2004-12-2
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form.helpdesk;
import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import com.shcnc.struts.form.BaseQueryForm;
/**
 * @author zhangyan
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class KnowledgeBaseQueryForm extends BaseQueryForm{
	private String searchword="";
	private String select="";
	private String categoryid="";
	private String categorydesc="";
	
	public void reset() {
	    searchword="";
	    select="";
	    categoryid="";
	}
	
	public String getSearchword() {
		return searchword;
	}
	public void setSearchword(String searchword) {
		this.searchword = searchword;
	}
	public String getSelect() {
		return select;
	}
	public void setSelect(String select) {
		this.select = select;
	}
	public String getCategoryid(){
		return categoryid;
	}
	public void setCategoryid(String categoryid){
		this.categoryid = categoryid;
	}
	public String getCategorydesc(){
		return categorydesc;
	}
	public void setCategorydesc(String categorydesc){
		this.categorydesc = categorydesc;
	}
}
