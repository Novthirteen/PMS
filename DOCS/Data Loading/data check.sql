-- missing project
select projectName, sum(workinghours), servicetypename from template_caf where projectId is null
group by projectName, servicetypename
order by projectName, servicetypename;

-- Service type not in current project
select projectid, sum(workinghours), servicetypename, rate 
from template_caf 
where servicetypeid is null and staffid is not null and rate <> 0
group by projectid, servicetypename,rate

-- Rate Check with PAS Project data
select distinct tc.projectid, p.proj_name, tc.servicetypename, tc.rate * tc.workinghours, pst.st_rate
from template_caf as tc inner join proj_servicetype as pst on pst.st_proj_id = tc.projectid and pst.st_desc = tc.servicetypename
                        inner join proj_mstr as p on p.proj_id = tc.projectid
where pst.st_rate <> tc.rate
	and p.contracttype = 'TM'
	and tc.staffname <> 'downpay';

-- Zero Rate
select distinct projectid, sum(workinghours), servicetypename, rate from template_caf where rate is null or rate = 0
group by projectid, servicetypename, rate;

-- TS Gap
select tc.projectid, p.proj_name, tc.staffid, ul.[name], tc.servicetypename, tc.workinghours, ptd.ts_hrs_user, ptd.ts_date
from template_caf as tc inner join proj_mstr as p on tc.projectid = p.proj_id
			inner join proj_ts_det as ptd on (ptd.ts_proj_id = tc.projectid and ptd.ts_date = tc.cafdate)
			inner join user_login as ul on tc.staffid = ul.user_login_id
			inner join proj_ts_mstr as ptm on (ptm.tsm_userlogin = ul.user_login_id and ptd.tsm_id = ptm.tsm_id)
where tc.workinghours <> ptd.ts_hrs_user

-- milestone not in current project
select projectid, sum(workinghours), staffname, rate from template_caf where staffid is null and staffname is not null and staffname <> 'downpay'
group by projectid, staffname, rate

--duplicate projectevent check with proj_ts_det
select tsd.ts_id, tsd.ts_proj_id, tsd.ts_servicetype, tsd.ts_projevent,tc.projecteventid, tsd.ts_date, tsm.tsm_userlogin
from proj_ts_mstr as tsm inner join proj_ts_det as tsd on tsm.tsm_id = tsd.tsm_id
                                  inner join template_caf as tc on (tc.projectid = tsd.ts_proj_id 
                                                                and tc.servicetypeid = tsd.ts_servicetype 
                                                                and tc.cafdate = tsd.ts_date
                                                                and tc.staffid = tsm.tsm_userlogin)
inner join 
(select tsd.ts_proj_id, tsd.ts_servicetype, tsd.ts_date, tsm.tsm_userlogin
 from proj_ts_mstr as tsm inner join proj_ts_det as tsd on tsm.tsm_id = tsd.tsm_id
                                  inner join template_caf as tc on (tc.projectid = tsd.ts_proj_id 
                                                                and tc.servicetypeid = tsd.ts_servicetype 
                                                                and tc.cafdate = tsd.ts_date
                                                                and tc.staffid = tsm.tsm_userlogin)
where tc.projecteventid <> tsd.ts_projevent
group by tsd.ts_proj_id, tsd.ts_servicetype, tsd.ts_date, tsm.tsm_userlogin
having count(*) <> 1) as a on (a.ts_proj_id = tsd.ts_proj_id and a.ts_servicetype = tsd.ts_servicetype and a.ts_date = tsd.ts_date and a.tsm_userlogin = tsm.tsm_userlogin)

-- check ts in pas but not in prm
select tsd.ts_proj_id, tsm.tsm_userlogin, tsd.ts_date, tsd.ts_servicetype, tsd.ts_projevent, tsd.ts_hrs_user, tsd.ts_hrs_confirm
 from proj_ts_mstr as tsm inner join proj_ts_det as tsd on tsm.tsm_id = tsd.tsm_id
			  inner join proj_mstr as pm on pm.proj_id = tsd.ts_proj_id
                                  left join template_caf as tc on (tc.projectid = tsd.ts_proj_id 
                                                                and tc.servicetypeid = tsd.ts_servicetype 
                                                                and tc.cafdate = tsd.ts_date
                                                                and tc.staffid = tsm.tsm_userlogin
								and tc.projecteventid = tsd.ts_projevent)
			
where tc.selfid is null 
and pm.contracttype = 'TM'
and (tsd.ts_hrs_user <> 0 or tsd.ts_hrs_confirm <> 0)
and tsd.ts_proj_id in (select distinct projectid from template_caf);

--check total bill amount (without allowance)
select p.description, pm.proj_id, pm.proj_name, pb.bill_code, pb.bill_calamount
from proj_bill as pb inner join proj_mstr as pm on pb.bill_proj_id = pm.proj_id
                     inner join party as p on pb.bill_addr = p.party_id
where pb.bill_code not like '%A'
order by pb.bill_code

--check total bill amount (only allowance)
select p.description, pm.proj_id, pm.proj_name, pb.bill_code, pb.bill_calamount
from proj_bill as pb inner join proj_mstr as pm on pb.bill_proj_id = pm.proj_id
                     inner join party as p on pb.bill_addr = p.party_id
where pb.bill_code like '%A'
order by pb.bill_code

--invoice check
select pb.bill_proj_id, pb.bill_code, pb.bill_calamount, tb.amount, tb.invoicecode, tb.invoiceamount from proj_bill as pb left join template_billing as tb on pb.bill_id = tb.billid
order by pb.bill_proj_id