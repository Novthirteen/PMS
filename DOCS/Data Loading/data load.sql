--delete project '2005000002'
delete from proj_servicetype where st_proj_id = '2005000002';
delete from proj_ctc where ctc_proj_id = '2005000002';
delete from proj_mstr where proj_id = '2005000002';

--delete workinghours is null or zero
delete from template_caf where workinghours is null or workinghours = 0;

--delete allowance
delete from template_caf where rate = 200;

--delete project '4149C.01';
delete from template_caf where projectname = '4149C.01';

--adjust project '6742C.02'
delete from template_caf where projectname = '6742C.02';
insert into template_caf (staffname, projectname, workinghours, billcode, rate, status)
	values ('Milestone 0', '6742C.02', 28, 'EASTMAN20040101', 37248.20, '01/01/2004');
insert into template_caf (staffname, projectname, workinghours, billcode, rate, status)
	values ('Milestone 1', '6742C.02', 50, 'EASTMAN20040827', 37248.20, '08/27/2004');
insert into template_caf (staffname, projectname, workinghours, billcode, rate, status)
	values ('Milestone 2', '6742C.02', 126, 'eastman20041027', 74496.42, '10/27/2004');
	
--insert acceptance
insert into template_caf (staffname, projectname, workinghours, servicetypename, billcode, rate, status)
	values ('TRAINING', '6735C.01', 20, 'TC', 'HAWK20040101', 83000, '01/01/2004');
insert into template_caf (staffname, projectname, workinghours, billcode, rate, status)
	values ('TC', '05000080', 7, 'BROSE20050427', 27888, '04/27/2005');
insert into template_caf (staffname, projectname, workinghours, billcode, rate, status)
	values ('Survey and Training', '6601C.10', 19, 'AVERY20041115', 82983.4, '11/15/2004');
insert into template_caf (staffname, projectname, workinghours, billcode, rate, status)
	values ('BMS', '6601C.10', 17, 'AVERY20041115', 82983.4, '11/15/2004');
insert into template_caf (staffname, projectname, workinghours, billcode, rate, status)
	values ('Implemenatation', '6601C.10', 3, 'AVERY20041115', 82983.4, '11/15/2004');
insert into template_caf (staffname, projectname, workinghours, billcode, rate, status)
	values ('SUPPORT', '05000033', 22, 'PSS20050310', 129480, '03/10/2005');
insert into template_caf (staffname, projectname, workinghours, servicetypename, billcode, rate, status)
	values ('YONG SIK', '6737C.02', 1, 'TC', 'TOWER20041108', 29050, '07/01/2004');
update template_caf set staffname = 'QAD MFG/PRO' where projectname = '05000078';
insert into template_caf (staffname, projectname, workinghours, servicetypename, billcode, rate, status)
	values ('PROGRESS', '2005000078', 0, 'TC', 'BROSE20050425', 14202.11, '04/25/2005');
update template_caf set billcode = 'TOWER20041227' where projectname = '6737C.02' and status = '10/08/04';
update template_caf set rate = 525000 where projectname = '6757C.01';

--find project id due to the projectName
update template_caf set projectId = pm.proj_id from template_caf as tc inner join proj_mstr as pm on pm.proj_id like '%' + tc.projectName;

--remove project which do not in pas system
delete from template_caf where projectId is null;
update template_caf set projectName = null;

--format caf date to same format
update template_caf set status = '20' + substring(status, 7,2) + '-' + substring(status, 1,2) + '-' + substring(status, 4,2) where datalength(status) = 8;

--remove blank of the these fields
update template_caf set staffname = rtrim(staffname);
update template_caf set serviceTypeName = rtrim(serviceTypeName);
update template_caf set billcode = rtrim(billcode);
update template_caf set status = rtrim(status);

--set to 'admin' as default value, which staffname is empty
update template_caf set staffname='admin' where staffname is null or staffname = '';

--set to '2004-01-01' as defaulst value, which caf date is not correct
update template_caf set status = '2004-01-01' where len(status) <> 10 or status is null;

--transfer caf date and empty the status
update template_caf set CAFDate = convert(datetime, status);
update template_caf set status = null;

--update workinghours from days to hours
update template_caf set workinghours = workinghours * 8;

--update rate from days to hours
--update template_caf set rate = round(rate, 4);
--update template_caf set rate = rate / 8;

--set ProjectEvent to 'Other Billable'
update template_caf set ProjectEventId = 15, ProjectEventName = 'Other Billable';

--set CreateUser to 'admin'
update template_caf set CreateUser = 'admin';

--adjust project '6703C.26'
update template_caf set staffName = 'admin' where projectid = '6703C.26' and staffname = 'DOWNPAY';

--insert billing 
insert into proj_bill (
bill_code,bill_type,bill_proj_id,bill_addr, bill_status )
select distinct  tc.billcode, 'Normal', pm.proj_id, pm.proj_billaddr_id, 'Draft'
from template_caf as tc inner join proj_mstr as pm on tc.projectid = pm.proj_id
where (tc.billcode is not null and tc.billcode <> '' and (staffname <> 'downpay' or workinghours * rate < 0));

insert into proj_bill (
bill_code,bill_type,bill_proj_id,bill_addr, bill_status )
select distinct  tc.billcode, 'Down Payment', pm.proj_id, pm.proj_billaddr_id, 'Draft'
from template_caf as tc inner join proj_mstr as pm on tc.projectid = pm.proj_id
where (tc.billcode is not null and tc.billcode <> '' and staffname = 'downpay' and workinghours * rate > 0);

update proj_bill set bill_createdate = convert(datetime, substring(bill_code, len(bill_code) - 7,4 ) 
     + '-' 
     + substring(bill_code, len(bill_code) - 3,2 ) 
     + '-' 
     + substring(bill_code, len(bill_code) - 1,2 ) ),
	bill_createuser = 'admin';
	
--update bill id due to the bill code
update template_caf set billId = pb.bill_id from template_caf as tc inner join proj_bill as pb on tc.billcode = pb.bill_code and tc.projectid = pb.bill_proj_id;

--adjust servicetype rate
update proj_servicetype set st_rate = 4272.3825 where st_proj_id = '04000367' and st_desc = 'TC';
update proj_servicetype set st_rate = 5810 where st_proj_id = '05000024' and st_desc = 'AC';
update proj_servicetype set st_rate = 5810 where st_proj_id = '05000024' and st_desc = 'TC';
update proj_servicetype set st_rate = 4359.58 where st_proj_id = '05000077' and st_desc = 'TC';
update proj_servicetype set st_rate = 4581.6 where st_proj_id = '6265C.07' and st_desc = 'BC';
update proj_servicetype set st_rate = 4359.575 where st_proj_id = '6552C18A' and st_desc = 'BC';
update proj_servicetype set st_rate = 4359.575 where st_proj_id = '6552C18A' and st_desc = 'TC';
update proj_servicetype set st_rate = 4795.5325 where st_proj_id = '6715C.04' and st_desc = 'BC';
update proj_servicetype set st_rate = 4359.575 where st_proj_id = '6715C.04' and st_desc = 'TC';
update proj_servicetype set st_rate = 3662.043 where st_proj_id = '6739C.01' and st_desc = 'BC';
update proj_servicetype set st_rate = 6975.32 where st_proj_id = '6739C.01' and st_desc = 'PM';
update proj_servicetype set st_rate = 3487.66 where st_proj_id = '6739C.01' and st_desc = 'TC';
update proj_servicetype set st_rate = 3735 where st_proj_id = '6746C.02' and st_desc = 'BC';
update proj_servicetype set st_rate = 3394.8 where st_proj_id = '6748C.03' and st_desc = 'BC';
update proj_servicetype set st_rate = 3394.8 where st_proj_id = '6748C.03' and st_desc = 'PM';
update proj_servicetype set st_rate = 3394.8 where st_proj_id = '6748C.03' and st_desc = 'TC';
update proj_servicetype set st_rate = 3486 where st_proj_id = '6751C.01' and st_desc = 'BC';
update proj_servicetype set st_desc = 'June', st_estimatedate = '2004-07-01 00:00:00.000' where st_proj_id = '6737C.02A' and st_desc = 'July';
update proj_servicetype set st_desc = 'July', st_estimatedate = '2004-08-01 00:00:00.000' where st_proj_id = '6737C.02A' and st_desc = 'August';
update proj_servicetype set st_desc = 'August', st_estimatedate = '2004-09-01 00:00:00.000' where st_proj_id = '6737C.02A' and st_desc = 'September';
update proj_servicetype set st_desc = 'September', st_estimatedate = '2004-10-01 00:00:00.000' where st_proj_id = '6737C.02A' and st_desc = 'Octomber';
update proj_servicetype set st_desc = 'Octomber', st_estimatedate = '2004-11-01 00:00:00.000' where st_proj_id = '6737C.02A' and st_desc = 'November';
update proj_servicetype set st_desc = 'November', st_estimatedate = '2004-12-01 00:00:00.000' where st_proj_id = '6737C.02A' and st_desc = 'December';
insert proj_servicetype (st_proj_id, st_desc, st_rate, st_scrate, st_estdays, st_estimatedate) values ('6737C.02A', 'December', 29050, 0, 22, '2005-01-01 00:00:00.000');

--set project '05000033' to TM
--update proj_mstr set contracttype = 'TM' where proj_id = '05000033';
--update proj_servicetype set st_desc = 'TC', st_rate = 4980 where st_proj_id = '05000033';

--insert into proj_servicetype (st_proj_id, st_desc, st_rate, st_scrate, st_estdays)
--values ('05000033', 'TC FOC', 0, 0, 4);

--set project '05000093' to TM
update proj_mstr set contracttype = 'TM' where proj_id = '05000093';
update proj_servicetype set st_desc = 'TC', st_rate = 5810 where st_proj_id = '05000093';

--set project '6703C.26' to TM
update proj_mstr set contracttype = 'TM' where proj_id = '6703C.26';
update proj_servicetype set st_desc = 'TC', st_rate = 2905 where st_proj_id = '6703C.26';

--set project '6735C.01' to TM
--update proj_mstr set contracttype = 'TM' where proj_id = '6735C.01';
--update proj_servicetype set st_desc = 'TC', st_rate = 4150 where st_proj_id = '6735C.01' and st_desc = 'TRAINING';
--insert into proj_servicetype (st_proj_id, st_desc, st_rate, st_scrate, st_estdays) values ('6735C.01', 'TC FOC', 0, 0, 4);

--set project '05000037' to TM
update proj_mstr set contracttype = 'TM' where proj_id = '05000037';
update proj_servicetype set st_desc = 'TC', st_rate = 30000 where st_proj_id = '05000037';

--set project '05000062' to TM
update proj_mstr set contracttype = 'TM' where proj_id = '05000062';
update proj_servicetype set st_desc = 'TC', st_rate = 4150 where st_proj_id = '05000062';

--set project '05000091' to TM
update proj_mstr set contracttype = 'TM' where proj_id = '05000091';
update proj_servicetype set st_desc = 'TC', st_rate = 3662.0425 where st_proj_id = '05000091';

--set project '04000426' to TM
update proj_mstr set contracttype = 'TM' where proj_id = '04000426';
update proj_servicetype set st_desc = 'TC', st_rate = 5810 where st_proj_id = '04000426';

--set project '05000080' to TM
--update proj_mstr set contracttype = 'TM' where proj_id = '05000080';
--update proj_servicetype set st_desc = 'TC', st_rate = 3984 where st_proj_id = '05000080';

--set project '05000002' to FP
update proj_mstr set contracttype = 'FP' where proj_id = '05000002';

--set project '6742C.02' to FP
update proj_mstr set contracttype = 'FP' where proj_id = '6742C.02';

--adjust servic type of '8019C.40'
update proj_servicetype set st_desc = 'TC', st_rate = '158808.71' where st_proj_id = '8019C.40';

--adjust service type of '6747C.01'
insert into proj_servicetype (st_proj_id, st_desc, st_rate,st_estdays,st_estimatedate)
values ('6747C.01', 'Nov', 10576.28, 1, '2005-05-08 00:00:00.000');

insert into proj_servicetype (st_proj_id, st_desc, st_rate,st_estdays,st_estimatedate)
values ('6747C.01', 'Dec', 10576.28, 1, '2005-05-08 00:00:00.000');

update proj_servicetype set st_rate = 10576.28 where st_proj_id = '6747C.01';

--adjust service type of '6703C.26'
insert into proj_servicetype (st_proj_id, st_desc, st_rate, st_scrate, st_estdays,st_estimatedate)
values ('6703C.26', 'PM', 52290, 0, 2, '2004-09-14 00:00:00.000');

--update service type id
update template_caf set servicetypename = 'TRAINING' where projectid = '6735C.01';
update template_caf set servicetypename = 'SUPPORT' where projectid = '05000033';
update template_caf set servicetypename = 'Survey and Training' where projectid = '6601C.10' and rate = 4367.54736;
update template_caf set servicetypename = 'Implemenatation' where projectid = '6601C.10' and staffname = 'ALAN';
update template_caf set servicetypename = 'Implemenatation' where projectid = '6601C.10' and staffname = 'YURONG' and cafdate = '2004-09-16 00:00:00.000';
update template_caf set servicetypename = 'BMS' where projectid = '6601C.10' and servicetypename = 'TC';
--update template_caf set projectid = '6601C.10A' where projectid = '6601C.10';
--update template_caf set servicetypename = 'TC FOC' where projectid = '6601C.10A' and servicetypename='TC' and rate = 0;
update template_caf set servicetypename = 'TC FOC' where projectid = '6570C.01' and servicetypename='TC' and rate = 0;
--update template_caf set servicetypename = 'TC FOC' where projectid = '6735C.01' and servicetypename='TC' and rate = 0;
--update template_caf set servicetypename = 'TC FOC' where projectid = '05000033' and servicetypename='TC' and rate = 0;
update template_caf set servicetypename = 'PM FOC' where projectid = '6739C.01' and servicetypename='PM' and rate = 0;
update template_caf set servicetypename = 'expense' where projectid = '6715C.03' and rate = '14000';
update template_caf set servicetypename = 'SUPPORT' where projectid = '05000011' and servicetypename = 'TC';
update template_caf set servicetypename = 'BC' where projectid = '05000061' and servicetypename = 'TC';
update template_caf set servicetypename = 'BC' where projectid = '6737C.02' and servicetypename = 'AC';
update template_caf set servicetypename = 'BC' where projectid = '6748C.03' and servicetypename = 'AC';
update template_caf set servicetypeName = 'TC' where (servicetypename is null or servicetypename = '') and projectid = '6205C.03';
update template_caf set servicetypeid = pst.st_id from template_caf as tc inner join proj_servicetype as pst on pst.st_proj_id = tc.projectid and pst.st_desc = tc.servicetypename;

--update staff id
update template_caf set staffName = 'total' where projectid = '6581C.30';
update template_caf set staffName = 'Total', rate = 231387.40 where projectid = '6598C.03';
update template_caf set staffName = 'total', rate = 91403.64 where projectid = '8023C.18';
update template_caf set staffName = 'June', projectid = '6737C.02A' where projectid = '6737C.02' and servicetypename = 'TC' and CAFDate = '2004-07-01 00:00:00.000';
update template_caf set staffName = 'July', projectid = '6737C.02A' where projectid = '6737C.02' and servicetypename = 'TC' and CAFDate = '2004-08-02 00:00:00.000';
update template_caf set staffName = 'August', projectid = '6737C.02A' where projectid = '6737C.02' and servicetypename = 'TC' and CAFDate = '2004-09-01 00:00:00.000';
update template_caf set staffName = 'September', projectid = '6737C.02A' where projectid = '6737C.02' and servicetypename = 'TC' and CAFDate = '2004-10-08 00:00:00.000';
update template_caf set staffName = 'Octomber', projectid = '6737C.02A' where projectid = '6737C.02' and servicetypename = 'TC' and CAFDate = '2004-10-31 00:00:00.000';
update template_caf set staffName = 'November', projectid = '6737C.02A' where projectid = '6737C.02' and servicetypename = 'TC' and CAFDate = '2004-11-30 00:00:00.000';
update template_caf set staffName = 'December', projectid = '6737C.02A' where projectid = '6737C.02' and servicetypename = 'TC' and CAFDate = '2004-12-31 00:00:00.000';
update template_caf set staffName = 'admin' where projectid = '6715C.03' and rate = '14000';
update template_caf set staffName = 'casen', projecteventid = 1, projecteventname = 'Business/Technical Consulting' where projectid = '8019C.40' and staffName = 'qad';
update template_caf set staffname = 'REMAIN' where projectid = '6806C.06' and rate = '4600.5714';
update template_caf set staffname = 'GO LIVE' where projectid = '6806C.06' and rate = '4293.8666';
update template_caf set staffname = 'ANALYSIS' where projectid = '6806C.06' and rate = '3715.846';
update template_caf set staffname = 'customization' where staffname = 'CASEN' and projectid = '05000111' and servicetypename = 'TC';
--update template_caf set staffname = 'DOWNPAY' where staffname = 'JOEY' and projectid = '6742C.02' and workinghours = -8 and servicetypename = 'TC';
update template_caf set staffname = 'Athlon' where staffname = 'Althlon'
update template_caf set staffid = ts.staffid from template_caf as tc inner join template_staff as ts on tc.staffname = ts.staffnameinprm;
update template_caf set staffid = null where staffid = 'OTHERS';
update template_caf set staffid = 'EXT00017' where staffName = 'sub' and staffid is null;
update template_caf set staffid = 'INT00001' where staffName = 'correct' and staffid is null;

--update milestone
update template_caf set staffname = 'DELIVERY' where projectid = '6573C.09' and staffname = 'REMAIN' and rate = 118800;
update template_caf set staffname = 'MAINTENANCE' where projectid = '05000063' and staffname = 'MAINT';
update template_caf set staffname = 'CUSTOMIZATION' where projectid = '05000081' and staffname = 'SERVICE';
update template_caf set staffname = 'TASK COMPLETED' where projectid = '05000092' and staffname = 'service';
update template_caf set staffname = 'TC' where projectid = '05000095' and staffname = 'service';
update template_caf set staffname = 'Lisence', projectid = '6570C.01A' where projectid = '6570C.01' and staffname = 'LICENSE';
update template_caf set staffname = 'Mar' where projectid = '6747C.01' and staffname = 'march';
update template_caf set staffname = 'Apr' where projectid = '6747C.01' and staffname = 'april';
update template_caf set staffname = '1ST LINE SUPPORT' where projectid = '6807C.19' and staffname = 'maint';
update template_caf set staffname = '1ST LINE SUPPORT' where projectid = '6807C.20' and staffname = 'maint';
update template_caf set staffname = '第一阶段项目准备完后5天内' where projectid = '6816C.01' and staffname = 'phase 1';
update template_caf set staffname = '第一阶段业务蓝图设计批准后5天内' where projectid = '6816C.01' and staffname = 'phase 2';
update template_caf set servicetypename = staffname, staffname = null, servicetypeid = pst.st_id from template_caf as tc inner join proj_servicetype as pst on (tc.projectid = pst.st_proj_id and tc.staffname = pst.st_desc) where tc.staffid is null;

--update down payment
update template_caf set servicetypeid = null, servicetypename = null where staffname = 'downpay';

--update projectevent due to staffid, cafdate, projectid, servicetype
--if there is duplicate projectevent, we dont update here
update template_caf set projecteventid = tsd.ts_projevent, projecteventname = pe.PEvent_Name
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
having count(*) = 1) as a on (a.ts_proj_id = tsd.ts_proj_id and a.ts_servicetype = tsd.ts_servicetype and a.ts_date = tsd.ts_date and a.tsm_userlogin = tsm.tsm_userlogin)
inner join projevent as pe on tsd.ts_projevent = pe.PEvent_Id;

--adjust projectevent
update template_caf set projecteventid = pe.pevent_id, projecteventname = pe.PEvent_Name
from template_caf as tc, projevent as pe
where tc.projectid = '6740C.03' 
and tc.staffid = 'CN01219' 
and tc.cafdate = '2005-04-11 00:00:00.000' 
and tc.servicetypeid = 7
and pe.pevent_id = 8;

update template_caf set projecteventid = pe.pevent_id, projecteventname = pe.PEvent_Name
from template_caf as tc, projevent as pe
where tc.projectid = '6740C.03' 
and tc.staffid = 'CN01219' 
and tc.cafdate = '2005-04-14 00:00:00.000' 
and tc.servicetypeid = 7
and pe.pevent_id = 8;

--adjust minus workinghours to positive 
update template_caf set workinghours = -workinghours where projectid = '6521C.22' and workinghours < 0;

update template_caf set status = 'draft';