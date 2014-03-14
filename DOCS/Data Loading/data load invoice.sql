--trim
update template_billing set billcode = rtrim(billcode);      
update template_billing set projectname = rtrim(projectname);
update template_billing set billaddress = rtrim(billaddress);
update template_billing set invoicecode = rtrim(invoicecode);

--update projectid due to projectname
update template_billing set projectid = pm.proj_id from proj_mstr as pm inner join template_billing as tb on pm.proj_id like '%'+tb.projectname;

--delete invoice if projiectid is null
delete from template_billing where projectid is null;
update template_billing set projectname = null;

--update billid due to billname and projectid
update template_billing set billid = pb.bill_id from template_billing as tb inner join proj_bill as pb on (tb.billcode = pb.bill_code and tb.projectid = pb.bill_proj_id);

--delete invoice if billid is null
delete from template_billing where billid is null;

--insert EMS
insert into proj_EMS (ems_type, ems_no, ems_date, ems_note, ems_create_date, ems_create_user, ems_department)
values ('Other Deliver', 'admin', '2004-01-01', 'For all import invoice', '2004-01-01', 'admin', '014');

--insert invoice