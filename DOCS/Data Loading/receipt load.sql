update template_receipt set projectname = rtrim(projectname);
update template_receipt set invoicename = rtrim(invoicename);

update template_receipt set projectId = pm.proj_id from template_receipt as tr inner join proj_mstr as pm on pm.proj_id like '%' + tr.projectName;  

update template_receipt set invoiceid = pi.inv_id from template_receipt as tr inner join proj_invoice as pi on pi.inv_code = tr.invoicename;

insert into proj_receipt 
(receipt_no, invoice_id, receive_amount, currency, receive_date, note, create_user, create_date)
select receiptno, invoiceid, amount, 'RMB', receiptdate, '', 'admin', getDate()
from template_receipt 
where projectid is not null 
  and invoiceid is not null
