update template_caf set projectId = pm.proj_id from template_caf as tc inner join proj_mstr as pm on pm.proj_id like '%' + tc.projectName 
where selfid > 5129;

update template_caf set projectName = null
where selfid > 5129;

update template_caf set workinghours = workinghours * 8
where selfid > 5129;

update template_caf set ProjectEventId = 15, ProjectEventName = 'Other Billable'
where selfid > 5129;

update template_caf set CreateUser = 'admin'
where selfid > 5129;

update template_caf set staffid = ts.staffid from template_caf as tc inner join template_staff as ts on tc.staffname = ts.staffnameinprm
where tc.selfid > 5129;

update template_caf set servicetypeid = pst.st_id from template_caf as tc inner join proj_servicetype as pst on pst.st_proj_id = tc.projectid and pst.st_desc = tc.servicetypename
where tc.selfid > 5129;

update template_caf set status = 'draft' 
where selfid > 5129;