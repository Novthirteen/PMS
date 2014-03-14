/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.domain.module;

import java.util.*;

import net.sf.hibernate.Session;

import com.aof.component.BaseServices;
import com.aof.component.domain.party.UserLogin;
import com.aof.core.persistence.hibernate.Hibernate2Session;

/**
 * @author xxp 
 * @version 2003-6-24
 *
 */
public class ModuleWorker {
	public List getUserLoginModule(UserLogin ul) throws Exception{
		List result = new ArrayList();

		Session session = Hibernate2Session.currentSession();
		ModuleServices ms = new ModuleServices();
		ms.setSession(session);
		
		Set set = ul.getModuleGroups();
		Iterator it = set.iterator();

		while(it.hasNext()){
			Map map = new HashMap();
			Module m = (Module)it.next();
			map.put(m,ms.getChildModules(m.getModuleId()));
			result.add(map);
		}
		
		return result;
	}
}