/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.domain.module;

import java.util.*;

import com.aof.component.BaseServices;

import net.sf.hibernate.HibernateException;


/**
 * @author xxp 
 * @version 2003-6-23
 *
 */

public class ModuleServices extends BaseServices {

	public ModuleServices(){
		super();
	}
	
	public Set getChildModules(Module m) throws HibernateException{
		this.createSession();
		
		Set result = null;
		Module currentModule = (Module)session.load(Module.class,m.getModuleId());
		result = currentModule.getModules();
		
		Iterator it = result.iterator();
		while(it.hasNext()){
			Module cm = (Module)it.next();
		}
		
		this.closeSession();
		return result;
		
	}

	public List getChildModules(String moduleId) {
		Set result = null;
		List list = null;
		try{
			Module currentModule = (Module)session.load(Module.class,moduleId);
			list = new ArrayList();
			
			if( currentModule !=null && currentModule.getVisbale().equals("Y") ) {
				result = currentModule.getModules();
	

				if(result != null){
					Iterator it = session.filter(result,"order by priority").iterator();
					while(it.hasNext()){
						Map map = new HashMap();
						Module cm = (Module)it.next();
						if(cm.getVisbale().equals("Y")){  
							map.put(cm, getChildModules(cm.getModuleId()) );
			
							list.add(map);		
							//log.info(cm.getModuleId()+"<->"+cm.getModuleName()+"<->"+cm.getRequestPath()+"<->"+cm.getPriority());
						}
					}
				}
	
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			return list;
		}

	}		
	
	public List getChildModules(String moduleId,net.sf.hibernate.Session session) {

		Set result = null;
		List list = null;
		try{
			Module currentModule = (Module)session.load(Module.class,moduleId);
			list = new ArrayList();
			if( currentModule !=null && currentModule.getVisbale().equals("Y") ) {
				result = currentModule.getModules();
				if(result != null){
					Iterator it = session.filter(result,"order by priority").iterator();
					while(it.hasNext()){
						Map map = new HashMap();
						Module cm = (Module)it.next();
						if(cm.getVisbale().equals("Y")){  
							map.put(cm, getChildModules(cm.getModuleId(),session) );
							list.add(map);		
							//log.info(cm.getModuleId()+"<->"+cm.getModuleName()+"<->"+cm.getRequestPath()+"<->"+cm.getPriority());
						}
					}
				}
	
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			return list;
		}
	}	
	public List getAllModuleGroups() throws HibernateException{
		this.createSession();
		
		List result = null;
		session.find("from ModuleGroup mg");
		
		this.closeSession();
		
		return result;
	}
 	
 	public Module getModuleByModuleId(String moduleId) {
		Module module = null;
		try{
 			this.createSession();
 			module = (Module)session.load(Module.class,moduleId);
 		}catch(Exception e){
 			
 		}finally{
			this.closeSession();
			return module;
 		}
 		
 	}
}
