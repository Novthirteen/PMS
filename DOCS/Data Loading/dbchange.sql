insert into proj_tr_det(tr_type, tr_category, tr_rec_id, tr_amount, tr_currency, tr_ex_rate, tr_mstr_id, tr_desc1, tr_desc2, tr_proj_id, tr_party_id, tr_date, tr_createdate, tr_date1, tr_num1, tr_num2, tr_staff, tr_createuser)
select ptd.tr_type, 'Allowance', ptd.tr_rec_id,  (ptd.tr_num1 / 8 * 200), ptd.tr_currency, ptd.tr_ex_rate, ptd.tr_mstr_id, ptd.tr_desc1, ptd.tr_desc2, ptd.tr_proj_id, ptd.tr_party_id, ptd.tr_date, ptd.tr_createdate, ptd.tr_date1, (ptd.tr_num1 / 8), 200, ptd.tr_staff, ptd.tr_createuser from proj_tr_det as ptd 
inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where pb.bill_code = 'FAU WX20041102';

update proj_bill set bill_calamount = '59946.39' where bill_code = 'FAU WX20040827';

insert into proj_tr_det(tr_type, tr_category, tr_rec_id, tr_amount, tr_currency, tr_ex_rate, tr_mstr_id, tr_desc1, tr_desc2, tr_proj_id, tr_party_id, tr_date, tr_createdate, tr_date1, tr_num1, tr_num2, tr_staff, tr_createuser)
select ptd.tr_type, 'Allowance', ptd.tr_rec_id,  (ptd.tr_num1 / 8 * 200), ptd.tr_currency, ptd.tr_ex_rate, ptd.tr_mstr_id, ptd.tr_desc1, ptd.tr_desc2, ptd.tr_proj_id, ptd.tr_party_id, ptd.tr_date, ptd.tr_createdate, ptd.tr_date1, (ptd.tr_num1 / 8), 200, ptd.tr_staff, ptd.tr_createuser from proj_tr_det as ptd 
inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where pb.bill_code = 'FAU WX20040827';

update proj_bill set bill_calamount = '79928.52' where bill_code = 'FAU WX20041102';

insert into proj_tr_det(tr_type, tr_category, tr_rec_id, tr_amount, tr_currency, tr_ex_rate, tr_mstr_id, tr_desc1, tr_desc2, tr_proj_id, tr_party_id, tr_date, tr_createdate, tr_date1, tr_num1, tr_num2, tr_staff, tr_createuser)
select ptd.tr_type, 'Allowance', ptd.tr_rec_id,  (ptd.tr_num1 / 8 * 200), ptd.tr_currency, ptd.tr_ex_rate, ptd.tr_mstr_id, ptd.tr_desc1, ptd.tr_desc2, ptd.tr_proj_id, ptd.tr_party_id, ptd.tr_date, ptd.tr_createdate, ptd.tr_date1, (ptd.tr_num1 / 8), 200, ptd.tr_staff, ptd.tr_createuser from proj_tr_det as ptd 
inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where pb.bill_code = 'FAU WX20041125';

update proj_bill set bill_calamount = '52453.09' where bill_code = 'FAU WX20041125';

insert into proj_tr_det(tr_type, tr_category, tr_rec_id, tr_amount, tr_currency, tr_ex_rate, tr_mstr_id, tr_desc1, tr_desc2, tr_proj_id, tr_party_id, tr_date, tr_createdate, tr_date1, tr_num1, tr_num2, tr_staff, tr_createuser)
select ptd.tr_type, 'Allowance', ptd.tr_rec_id,  (ptd.tr_num1 / 8 * 200), ptd.tr_currency, ptd.tr_ex_rate, ptd.tr_mstr_id, ptd.tr_desc1, ptd.tr_desc2, ptd.tr_proj_id, ptd.tr_party_id, ptd.tr_date, ptd.tr_createdate, ptd.tr_date1, (ptd.tr_num1 / 8), 200, ptd.tr_staff, ptd.tr_createuser from proj_tr_det as ptd 
inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where pb.bill_code = 'FAU WX20041223';

update proj_bill set bill_calamount = '57448.62' where bill_code = 'FAU WX20041223';

insert into proj_tr_det(tr_type, tr_category, tr_rec_id, tr_amount, tr_currency, tr_ex_rate, tr_mstr_id, tr_desc1, tr_desc2, tr_proj_id, tr_party_id, tr_date, tr_createdate, tr_date1, tr_num1, tr_num2, tr_staff, tr_createuser)
select ptd.tr_type, 'Allowance', ptd.tr_rec_id,  (ptd.tr_num1 / 8 * 200), ptd.tr_currency, ptd.tr_ex_rate, ptd.tr_mstr_id, ptd.tr_desc1, ptd.tr_desc2, ptd.tr_proj_id, ptd.tr_party_id, ptd.tr_date, ptd.tr_createdate, ptd.tr_date1, (ptd.tr_num1 / 8), 200, ptd.tr_staff, ptd.tr_createuser from proj_tr_det as ptd 
inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where pb.bill_code = 'FAU WX20050111';

update proj_bill set bill_calamount = '27475.43' where bill_code = 'FAU WX20050111';

insert into proj_tr_det(tr_type, tr_category, tr_rec_id, tr_amount, tr_currency, tr_ex_rate,tr_desc1, tr_desc2, tr_proj_id, tr_party_id, tr_date, tr_createdate, tr_date1, tr_num1, tr_num2, tr_staff, tr_createuser)
select ptd.tr_type, 'Allowance', ptd.tr_rec_id,  (ptd.tr_num1 / 8 * 200), ptd.tr_currency, ptd.tr_ex_rate, ptd.tr_desc1, ptd.tr_desc2, ptd.tr_proj_id, ptd.tr_party_id, ptd.tr_date, ptd.tr_createdate, ptd.tr_date1, (ptd.tr_num1 / 8), 200, ptd.tr_staff, ptd.tr_createuser from proj_tr_det as ptd 
inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where pb.bill_code = 'poly sz20050307';

insert into proj_tr_det(tr_type, tr_category, tr_rec_id, tr_amount, tr_currency, tr_ex_rate,tr_desc1, tr_desc2, tr_proj_id, tr_party_id, tr_date, tr_createdate, tr_date1, tr_num1, tr_num2, tr_staff, tr_createuser)
select ptd.tr_type, 'Allowance', ptd.tr_rec_id,  (ptd.tr_num1 / 8 * 200), ptd.tr_currency, ptd.tr_ex_rate, ptd.tr_desc1, ptd.tr_desc2, ptd.tr_proj_id, ptd.tr_party_id, ptd.tr_date, ptd.tr_createdate, ptd.tr_date1, (ptd.tr_num1 / 8), 200, ptd.tr_staff, ptd.tr_createuser from proj_tr_det as ptd 
inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where pb.bill_code = 'poly sz20050201';

-----------------------------2005/05/24------------------------------
insert into proj_tr_det(tr_type, tr_category, tr_rec_id, tr_amount, tr_currency, tr_ex_rate,  tr_desc1, tr_desc2, tr_proj_id, tr_party_id, tr_date, tr_createdate, tr_date1, tr_num1, tr_num2, tr_staff, tr_createuser)
select ptd.tr_type, 'Allowance', ptd.tr_rec_id,  (ptd.tr_num1 / 8 * 100), ptd.tr_currency, ptd.tr_ex_rate, ptd.tr_desc1, ptd.tr_desc2, ptd.tr_proj_id, ptd.tr_party_id, ptd.tr_date, ptd.tr_createdate, ptd.tr_date1, (ptd.tr_num1 / 8), 100, ptd.tr_staff, ptd.tr_createuser from proj_tr_det as ptd 
inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where pb.bill_proj_id = '04000425';

insert into proj_tr_det(tr_type, tr_category, tr_rec_id, tr_amount, tr_currency, tr_ex_rate,  tr_desc1, tr_desc2, tr_proj_id, tr_party_id, tr_date, tr_createdate, tr_date1, tr_num1, tr_num2, tr_staff, tr_createuser)
select ptd.tr_type, 
'Allowance', 
ptd.tr_rec_id,  
(ptd.tr_num1 / 8 * 100), 
ptd.tr_currency, 
ptd.tr_ex_rate, 
ptd.tr_desc1, 
ptd.tr_desc2, 
ptd.tr_proj_id, 
ptd.tr_party_id, 
ptd.tr_date, 
ptd.tr_createdate, 
ptd.tr_date1, 
(ptd.tr_num1 / 8), 
100, 
ptd.tr_staff, 
ptd.tr_createuser 
from proj_tr_det as ptd 
inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where pb.bill_proj_id = '05000011';

insert into proj_ts_mstr (tsm_userlogin, ts_status, ts_period, ts_updateDate, ts_totalhours) 
values ('CN01275', 'draft', '2004-11-01', getdate(), 56);
insert into proj_ts_mstr (tsm_userlogin, ts_status, ts_period, ts_updateDate, ts_totalhours) 
values ('CN01275', 'draft', '2005-01-03', getdate(), 208);
insert into proj_ts_mstr (tsm_userlogin, ts_status, ts_period, ts_updateDate, ts_totalhours) 
values ('CN01275', 'draft', '2005-03-14', getdate(), 240);

insert into proj_ts_det (tsm_id, ts_proj_id, ts_projevent, ts_servicetype, ts_hrs_user, ts_user_rate, ts_hrs_confirm, ts_status, ts_cafstatus_user, ts_cafstatus_confirm, ts_date, ts_confirm, ts_confirmDate)
select ptm.tsm_id, '6806C.06', 1, st_id,208, 0, 208, 'Approved', 'N', 'Y', '2005-01-04', 'Confirmed', '2005-01-04' 
from proj_ts_mstr as ptm,
proj_servicetype as pst
where tsm_userlogin = 'CN01275'
and ts_period = '2005-01-03'
and pst.st_proj_id = '6806C.06'
and pst.st_desc = 'ANALYSIS'

insert into proj_ts_det (tsm_id, ts_proj_id, ts_projevent, ts_servicetype, ts_hrs_user, ts_user_rate, ts_hrs_confirm, ts_status, ts_cafstatus_user, ts_cafstatus_confirm, ts_date, ts_confirm, ts_confirmDate)
select ptm.tsm_id, '6806C.06', 1, st_id,56, 0, 56, 'Approved', 'N', 'Y', '2004-11-02', 'Confirmed', '2004-11-02' 
from proj_ts_mstr as ptm,
proj_servicetype as pst
where tsm_userlogin = 'CN01275'
and ts_period = '2004-11-01'
and pst.st_proj_id = '6806C.06'
and pst.st_desc = 'REMAIN'

insert into proj_ts_det (tsm_id, ts_proj_id, ts_projevent, ts_servicetype, ts_hrs_user, ts_user_rate, ts_hrs_confirm, ts_status, ts_cafstatus_user, ts_cafstatus_confirm, ts_date, ts_confirm, ts_confirmDate)
select ptm.tsm_id, '6806C.06', 1, st_id,240, 0, 240, 'Approved', 'N', 'Y', '2005-03-15', 'Confirmed', '2005-03-15' 
from proj_ts_mstr as ptm,
proj_servicetype as pst
where tsm_userlogin = 'CN01275'
and ts_period = '2005-03-14'
and pst.st_proj_id = '6806C.06'
and pst.st_desc = 'GO LIVE'

insert into proj_tr_det(tr_type, tr_category, tr_rec_id, tr_amount, tr_currency, tr_ex_rate,  tr_desc1, tr_desc2, tr_proj_id, tr_party_id, tr_date, tr_createdate, tr_date1, tr_num1, tr_num2, tr_staff, tr_createuser)
select 'bill', 'Allowance', tsd.ts_id, (ts_hrs_confirm / 8 * 100), 'RMB', 1, 'Other Billable', pst.st_desc, pm.proj_id, pm.cust_id, tsd.ts_date, getdate(), tsd.ts_date, (ts_hrs_confirm / 8), 100, tsm.tsm_userlogin, 'admin'
from proj_ts_det as tsd
inner join proj_servicetype as pst on tsd.ts_servicetype = pst.st_id
inner join proj_mstr as pm on tsd.ts_proj_id = pm.proj_id
inner join proj_ts_mstr as tsm on tsd.tsm_id = tsm.tsm_id
where ts_hrs_confirm <> 0 and tsd.ts_proj_id = '6806C.06'

-----------------------------2005/05/25------------------------------
update proj_bill set bill_proj_id  = '6715C.07/H' where bill_proj_id = '6715C07H'
update proj_invoice set inv_proj_id = '6715C.07/H' where inv_proj_id = '6715C07H'
update proj_tr_det set tr_proj_id = '6715C.07/H' where tr_proj_id = '6715C07H'
delete from proj_servicetype where st_proj_id = '6715C07H';
delete from proj_mstr where proj_id = '6715C07H';

update proj_bill set bill_proj_id  = '6715C.07/S' where bill_proj_id = '6715C07S'
update proj_invoice set inv_proj_id = '6715C.07/S' where inv_proj_id = '6715C07S'
update proj_tr_det set tr_proj_id = '6715C.07/S' where tr_proj_id = '6715C07S'
update proj_assign set proj_id = '6715C.07/S' where proj_id = '6715C07S';
delete from proj_servicetype where st_proj_id = '6715C07S';
delete from proj_mstr where proj_id = '6715C07S';

-----------------------------2005/05/26------------------------------
delete from proj_tr_det where tr_mstr_id = (select bill_id from proj_bill where bill_code = 'HYUNDAI20040101');
delete from proj_bill where bill_code = 'HYUNDAI20040101';

delete from proj_tr_det where tr_mstr_id = (select bill_id from proj_bill where bill_code = 'HYUNDAI20041102');
delete from proj_bill where bill_code = 'HYUNDAI20041102';

delete from proj_tr_det where tr_mstr_id = (select bill_id from proj_bill where bill_code = 'TOWER20040101');
delete from proj_bill where bill_code = 'TOWER20040101';

------------------------------2005/05/27-----------------------------
update proj_mstr set contracttype = 'FP' where proj_id = '2004000428';

update proj_servicetype set st_rate = 68475 where st_proj_id = '2004000428';

delete from proj_tr_det where tr_proj_id = '2004000428'

delete from proj_tr_det where tr_mstr_id is null and tr_proj_id = '6521c.22'

------------------------------2005/05/30-----------------------------
insert into proj_tr_det(tr_type, tr_category, tr_rec_id, tr_amount, tr_currency, tr_ex_rate,  tr_desc1, tr_desc2, tr_proj_id, tr_party_id, tr_date, tr_createdate, tr_date1, tr_num1, tr_num2, tr_staff, tr_createuser)
select 'bill', 'Allowance', tsd.ts_id, (ts_hrs_confirm / 8 * 290), 'RMB', 1, 'Other Billable', pst.st_desc, pm.proj_id, pm.cust_id, tsd.ts_date, getdate(), tsd.ts_date, (ts_hrs_confirm / 8), 290, tsm.tsm_userlogin, 'admin'
from proj_ts_det as tsd
inner join proj_servicetype as pst on tsd.ts_servicetype = pst.st_id
inner join proj_mstr as pm on tsd.ts_proj_id = pm.proj_id
inner join proj_ts_mstr as tsm on tsd.tsm_id = tsm.tsm_id
where ts_hrs_confirm <> 0 and tsd.ts_proj_id = '6205C.03'

insert into proj_tr_det(tr_type, tr_category, tr_rec_id, tr_amount, tr_currency, tr_ex_rate,  tr_desc1, tr_desc2, tr_proj_id, tr_party_id, tr_date, tr_createdate, tr_date1, tr_num1, tr_num2, tr_staff, tr_createuser)
select ptd.tr_type, 'Allowance', ptd.tr_rec_id,  1000, ptd.tr_currency, ptd.tr_ex_rate, ptd.tr_desc1, ptd.tr_desc2, ptd.tr_proj_id, ptd.tr_party_id, ptd.tr_date, ptd.tr_createdate, ptd.tr_date1, 5, 200, ptd.tr_staff, ptd.tr_createuser 
from proj_tr_det as ptd 
inner join proj_bill as pb on ptd.tr_mstr_id = pb.bill_id
where pb.bill_proj_id = '05000061';

------------------------------2005/06/10-----------------------------
insert into proj_tr_det
(tr_type,
tr_category,
tr_rec_id,
tr_amount,
tr_currency,
tr_ex_rate,
tr_desc1,
tr_desc2,
tr_proj_id,
tr_party_id,
tr_date,
tr_createdate,
tr_staff,
tr_createuser)
select tr_type, 
'Credit-Down-Payment', 
tr_rec_id, 
-1 * tr_amount, 
tr_currency, 
tr_ex_rate,
tr_desc1,
tr_desc2,
tr_proj_id,
tr_party_id,
tr_date,
tr_createdate,
tr_staff,
tr_createuser
from proj_tr_det
where tr_proj_id = '6552c18a'
and tr_category = 'Down-Payment';

update proj_ts_det set ts_servicetype = 254
from proj_ts_det as ptd
inner join proj_ts_mstr as ptm on ptd.tsm_id = ptm.tsm_id
where ptd.ts_proj_id = '8433c.01'
and ptm.tsm_userlogin = 'CN01184'
and ptd.ts_servicetype = 253;

update proj_tr_det 
set tr_amount = 4795.5325,
tr_num2 = 4795.5325,
tr_desc2 = 'BC'
from proj_tr_det
where tr_proj_id = '8433c.01'
and tr_staff = 'CN01184'
and tr_amount = 5231.49;

update proj_ts_det set ts_servicetype = 253
from proj_ts_det as ptd
inner join proj_ts_mstr as ptm on ptd.tsm_id = ptm.tsm_id
where ptd.ts_proj_id = '8433c.01'
and ptm.tsm_userlogin = 'CN01427'
and ts_servicetype = 254;

update proj_tr_det 
set tr_amount = 5231.49,
tr_num2 = 5231.49,
tr_desc2 = 'Senior BC'
from proj_tr_det
where tr_proj_id = '8433c.01'
and tr_staff = 'CN01427'
and tr_amount = 4795.5325;

update proj_tr_det 
set tr_amount = 2615.745,
tr_num2 = 2615.745,
tr_desc2 = 'Senior BC'
from proj_tr_det
where tr_proj_id = '8433c.01'
and tr_staff = 'CN01427'
and tr_amount = 2397.76625;

------------------------------2005/06/15-----------------------------
delete from proj_receipt where invoice_id = 159

delete from proj_invoice where inv_proj_id = '6570C.01A'

update proj_servicetype set st_billid = null where st_proj_id = '6570C.01A'

delete from proj_bill where bill_proj_id = '6570C.01A'

delete from proj_tr_det where tr_proj_id = '6570C.01A'