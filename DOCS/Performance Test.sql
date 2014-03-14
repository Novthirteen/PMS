declare @weekno int
declare @RecId int
set @weekno = 1
while (@weekno <=200)
begin
	insert into proj_ts_mstr (tsm_userlogin, ts_status,ts_period,ts_updatedate,ts_totalhours)
		select tsm_userlogin, ts_status,convert(varchar(10),DATEADD(day, 7*@weekno, cast(ts_period as datetime)),120) ,ts_updatedate,ts_totalhours from proj_ts_mstr where tsm_id = 11
	SELECT @RecId = @@IDENTITY
	insert into proj_ts_det (tsm_id, ts_proj_id, ts_projevent, ts_servicetype, ts_hrs_user, ts_user_rate, ts_hrs_confirm, ts_status, ts_confirm, ts_cafstatus_user, ts_cafstatus_confirm, ts_date)
		select @RecId, ts_proj_id, ts_projevent, ts_servicetype, ts_hrs_user, ts_user_rate, ts_hrs_confirm, ts_status, ts_confirm, ts_cafstatus_user, ts_cafstatus_confirm, DATEADD(day,7, ts_date) from proj_ts_det where tsm_id = 11
	set @weekno = @weekno +1
end

DECLARE tnames_cursor CURSOR
FOR
   select user_login_id from user_login where user_login_id like 'cn%'
OPEN tnames_cursor
declare @userId varchar(50)
declare @weekno int
declare @RecId int
FETCH NEXT FROM tnames_cursor INTO @userId
WHILE (@@FETCH_STATUS <> -1)
begin
	IF (@@FETCH_STATUS <> -2)
	begin
		set @weekno = 1
		while (@weekno <=200)
		begin
			insert into proj_ts_mstr (tsm_userlogin, ts_status,ts_period,ts_updatedate,ts_totalhours)
				select @userId, ts_status,convert(varchar(10),DATEADD(day, 7*@weekno, cast(ts_period as datetime)),120) ,ts_updatedate,ts_totalhours from proj_ts_mstr where tsm_id = 11
			SELECT @RecId = @@IDENTITY
			insert into proj_ts_det (tsm_id, ts_proj_id, ts_projevent, ts_servicetype, ts_hrs_user, ts_user_rate, ts_hrs_confirm, ts_status, ts_confirm, ts_cafstatus_user, ts_cafstatus_confirm, ts_date)
				select @RecId, ts_proj_id, ts_projevent, ts_servicetype, ts_hrs_user, ts_user_rate, ts_hrs_confirm, ts_status, ts_confirm, ts_cafstatus_user, ts_cafstatus_confirm, DATEADD(day,7, ts_date) from proj_ts_det where tsm_id = 11
			set @weekno = @weekno +1
		end
	end
	FETCH NEXT FROM tnames_cursor INTO @userId
end


-- Expense data
declare @RecId int
declare @seqno int
set @seqno = 2
while (@seqno <=10)
begin
	insert into proj_exp_mstr (em_proj_id, em_userlogin, em_status, em_exp_date, em_entry_date, em_verify_date, em_approval_date, em_receipt_date, em_claimtype, em_code)
		select em_proj_id, em_userlogin, em_status, em_exp_date, em_entry_date, em_verify_date, em_approval_date, em_receipt_date, em_claimtype, 'E05'+right('000000'+CAST(@seqno AS VARCHAR(10)),6) from proj_exp_mstr where em_id =10
	SELECT @RecId = @@IDENTITY
	insert into proj_exp_amt (em_id, exp_id, ea_amt_user, ea_amt_confirm, ea_amt_paid)
		select @RecId, exp_id, ea_amt_user, ea_amt_confirm, ea_amt_paid from proj_exp_amt where em_id =10
	insert into proj_exp_det (em_id, exp_id, ed_amt_user, ed_date)
		select @RecId, exp_id, ed_amt_user, ed_date from proj_exp_det where em_id =10
	set @seqno = @seqno +1
end



c:
cd C:\AOApp\src\com\aof\webapp
native2ascii -encoding GBK chinese.txt ApplicationResources_zh.properties
