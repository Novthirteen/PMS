--seperate allowance
--project '6739C.01'
insert into proj_bill (bill_code, bill_type, bill_proj_id, bill_addr, bill_createdate, bill_createuser, bill_status)
select bill_code + 'A', bill_type, bill_proj_id, bill_addr, bill_createdate, bill_createuser, bill_status
from proj_bill where bill_code = 'ISOVER20041102';

update proj_tr_det set tr_mstr_id = pb1.bill_id 
from proj_bill as pb1 inner join proj_bill as pb2 on pb1.bill_code = pb2.bill_code + 'A'
inner join proj_tr_det as ptd on ptd.tr_mstr_id = pb2.bill_id
where pb2.bill_code = 'ISOVER20041102' and ptd.tr_category = 'Allowance';

update proj_bill set bill_calamount = amount
from proj_bill as pb inner join 
(select sum(ptd.tr_amount) as amount,tr_mstr_id from proj_tr_det as ptd inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where ptd.tr_category = 'Allowance' and pb.bill_code = 'ISOVER20041102A'
group by tr_mstr_id) as a on pb.bill_id = a.tr_mstr_id;

update proj_bill set bill_calamount = amount
from proj_bill as pb inner join 
(select sum(ptd.tr_amount) as amount,tr_mstr_id from proj_tr_det as ptd inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where pb.bill_code = 'ISOVER20041102'
group by tr_mstr_id) as a on pb.bill_id = a.tr_mstr_id;

--project '6739C.01'
insert into proj_bill (bill_code, bill_type, bill_proj_id, bill_addr, bill_createdate, bill_createuser, bill_status)
select bill_code + 'A', bill_type, bill_proj_id, bill_addr, bill_createdate, bill_createuser, bill_status
from proj_bill where bill_code = 'ISOVER20041125';

update proj_tr_det set tr_mstr_id = pb1.bill_id 
from proj_bill as pb1 inner join proj_bill as pb2 on pb1.bill_code = pb2.bill_code + 'A'
inner join proj_tr_det as ptd on ptd.tr_mstr_id = pb2.bill_id
where pb2.bill_code = 'ISOVER20041125' and ptd.tr_category = 'Allowance';

update proj_bill set bill_calamount = amount
from proj_bill as pb inner join 
(select sum(ptd.tr_amount) as amount,tr_mstr_id from proj_tr_det as ptd inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where ptd.tr_category = 'Allowance' and pb.bill_code = 'ISOVER20041125A'
group by tr_mstr_id) as a on pb.bill_id = a.tr_mstr_id;

update proj_bill set bill_calamount = amount
from proj_bill as pb inner join 
(select sum(ptd.tr_amount) as amount,tr_mstr_id from proj_tr_det as ptd inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where pb.bill_code = 'ISOVER20041125'
group by tr_mstr_id) as a on pb.bill_id = a.tr_mstr_id;

--project '6739C.01'
insert into proj_bill (bill_code, bill_type, bill_proj_id, bill_addr, bill_createdate, bill_createuser, bill_status)
select bill_code + 'A', bill_type, bill_proj_id, bill_addr, bill_createdate, bill_createuser, bill_status
from proj_bill where bill_code = 'ISOVER20041222';

update proj_tr_det set tr_mstr_id = pb1.bill_id 
from proj_bill as pb1 inner join proj_bill as pb2 on pb1.bill_code = pb2.bill_code + 'A'
inner join proj_tr_det as ptd on ptd.tr_mstr_id = pb2.bill_id
where pb2.bill_code = 'ISOVER20041222' and ptd.tr_category = 'Allowance';

update proj_bill set bill_calamount = amount
from proj_bill as pb inner join 
(select sum(ptd.tr_amount) as amount,tr_mstr_id from proj_tr_det as ptd inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where ptd.tr_category = 'Allowance' and pb.bill_code = 'ISOVER20041222A'
group by tr_mstr_id) as a on pb.bill_id = a.tr_mstr_id;

update proj_bill set bill_calamount = amount
from proj_bill as pb inner join 
(select sum(ptd.tr_amount) as amount,tr_mstr_id from proj_tr_det as ptd inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where pb.bill_code = 'ISOVER20041222'
group by tr_mstr_id) as a on pb.bill_id = a.tr_mstr_id;

--project '6739C.01'
insert into proj_bill (bill_code, bill_type, bill_proj_id, bill_addr, bill_createdate, bill_createuser, bill_status)
select bill_code + 'A', bill_type, bill_proj_id, bill_addr, bill_createdate, bill_createuser, bill_status
from proj_bill where bill_code = 'ISOVER20050201';

update proj_tr_det set tr_mstr_id = pb1.bill_id 
from proj_bill as pb1 inner join proj_bill as pb2 on pb1.bill_code = pb2.bill_code + 'A'
inner join proj_tr_det as ptd on ptd.tr_mstr_id = pb2.bill_id
where pb2.bill_code = 'ISOVER20050201' and ptd.tr_category = 'Allowance';

update proj_bill set bill_calamount = amount
from proj_bill as pb inner join 
(select sum(ptd.tr_amount) as amount,tr_mstr_id from proj_tr_det as ptd inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where ptd.tr_category = 'Allowance' and pb.bill_code = 'ISOVER20050201A'
group by tr_mstr_id) as a on pb.bill_id = a.tr_mstr_id;

update proj_bill set bill_calamount = amount
from proj_bill as pb inner join 
(select sum(ptd.tr_amount) as amount,tr_mstr_id from proj_tr_det as ptd inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where pb.bill_code = 'ISOVER20050201'
group by tr_mstr_id) as a on pb.bill_id = a.tr_mstr_id;

--project '6739C.01'
insert into proj_bill (bill_code, bill_type, bill_proj_id, bill_addr, bill_createdate, bill_createuser, bill_status)
select bill_code + 'A', bill_type, bill_proj_id, bill_addr, bill_createdate, bill_createuser, bill_status
from proj_bill where bill_code = 'ISOVER20050307';

update proj_tr_det set tr_mstr_id = pb1.bill_id 
from proj_bill as pb1 inner join proj_bill as pb2 on pb1.bill_code = pb2.bill_code + 'A'
inner join proj_tr_det as ptd on ptd.tr_mstr_id = pb2.bill_id
where pb2.bill_code = 'ISOVER20050307' and ptd.tr_category = 'Allowance';

update proj_bill set bill_calamount = amount
from proj_bill as pb inner join 
(select sum(ptd.tr_amount) as amount,tr_mstr_id from proj_tr_det as ptd inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where ptd.tr_category = 'Allowance' and pb.bill_code = 'ISOVER20050307A'
group by tr_mstr_id) as a on pb.bill_id = a.tr_mstr_id;

update proj_bill set bill_calamount = amount
from proj_bill as pb inner join 
(select sum(ptd.tr_amount) as amount,tr_mstr_id from proj_tr_det as ptd inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where pb.bill_code = 'ISOVER20050307'
group by tr_mstr_id) as a on pb.bill_id = a.tr_mstr_id;

--project '05000033'
insert into proj_bill (bill_code, bill_type, bill_proj_id, bill_addr, bill_createdate, bill_createuser, bill_status)
select bill_code + 'A', bill_type, bill_proj_id, bill_addr, bill_createdate, bill_createuser, bill_status
from proj_bill where bill_code = 'PSS20050310';

update proj_tr_det set tr_mstr_id = pb1.bill_id 
from proj_bill as pb1 inner join proj_bill as pb2 on pb1.bill_code = pb2.bill_code + 'A'
inner join proj_tr_det as ptd on ptd.tr_mstr_id = pb2.bill_id
where pb2.bill_code = 'PSS20050310' and ptd.tr_category = 'Allowance';

update proj_bill set bill_calamount = amount
from proj_bill as pb inner join 
(select sum(ptd.tr_amount) as amount,tr_mstr_id from proj_tr_det as ptd inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where ptd.tr_category = 'Allowance' and pb.bill_code = 'PSS20050310A'
group by tr_mstr_id) as a on pb.bill_id = a.tr_mstr_id;

update proj_bill set bill_calamount = amount
from proj_bill as pb inner join 
(select sum(ptd.tr_amount) as amount,tr_mstr_id from proj_tr_det as ptd inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where pb.bill_code = 'PSS20050310'
group by tr_mstr_id) as a on pb.bill_id = a.tr_mstr_id;