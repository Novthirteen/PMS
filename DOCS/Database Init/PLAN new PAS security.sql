--1.
delete from user_login_security_group
where group_id = 'PRM_TYPE_MANAGE'
delete from user_login_security_group
where group_id = 'PRM_PA_MANAGE'
delete from user_login_security_group
where group_id = 'PRM_DEP_MANAGE'
delete from user_login_security_group
where group_id = 'PRM_FA_MANAGE'


--2.
DELETE FROM SECURITY_GROUP_PERMISSION 
WHERE GROUP_ID = 'PRM_TYPE_MANAGE'
DELETE FROM SECURITY_GROUP_PERMISSION 
WHERE GROUP_ID = 'PRM_PA_MANAGE'
DELETE FROM SECURITY_GROUP_PERMISSION 
WHERE GROUP_ID = 'PRM_DEP_MANAGE'
DELETE FROM SECURITY_GROUP_PERMISSION 
WHERE GROUP_ID = 'PRM_FA_MANAGE'
DELETE FROM SECURITY_GROUP_PERMISSION 
WHERE GROUP_ID = 'PRM_DATA_MANAGE'


--3.
DELETE FROM SECURITY_GROUP 
WHERE GROUP_ID = 'PRM_TYPE_MANAGE'
DELETE FROM SECURITY_GROUP 
WHERE GROUP_ID = 'PRM_PA_MANAGE'
DELETE FROM SECURITY_GROUP 
WHERE GROUP_ID = 'PRM_DEP_MANAGE'
DELETE FROM SECURITY_GROUP 
WHERE GROUP_ID = 'PRM_FA_MANAGE'


--4.
-------------------------------------------------------------
--???

INSERT INTO Security_Group VALUES('PRM_PM_MANAGE','PAS_PM????');
INSERT INTO Security_Group VALUES('PRM_TS_PA_MANAGE','PAS_TS_PA????');
INSERT INTO Security_Group VALUES('PRM_RESOURCE_ASSIGN_MANAGE','PAS??????');
INSERT INTO Security_Group VALUES('PRM_ACCEPTANCE_MANAGE','PAS_ACCEPTANCE????');
INSERT INTO Security_Group VALUES('PRM_EXP_PA_MANAGE','PAS_EXPENSE_PA????');
INSERT INTO Security_Group VALUES('PRM_EXP_FA_MANAGE','PAS_EXPENSE_FA????');
INSERT INTO Security_Group VALUES('PRM_OC_PA_MANAGE','PAS OTHER_COST_PA????');
INSERT INTO Security_Group VALUES('PRM_PS_PA_MANAGE','PAS_PROCU_SUB_PA????');
INSERT INTO Security_Group VALUES('PRM_PROJ_FA_MANAGE','PAS PROJECT_F&A????');
INSERT INTO Security_Group VALUES('PRM_MSTR_FA_MANAGE','PAS_MASTER_FA????');
INSERT INTO Security_Group VALUES('PRM_PM_RPT1_MANAGE','PAS_PM????????');
INSERT INTO Security_Group VALUES('PRM_PM_RPT2_MANAGE','PAS PM????????');
INSERT INTO Security_Group VALUES('PRM_MGE_RPT_MANAGE','PAS????????');
INSERT INTO Security_Group VALUES('PRM_PA_RPT_MANAGE','PAS_PA??????');
INSERT INTO Security_Group VALUES('PRM_BILLING_MANAGE','PROJECT BILLING????');
INSERT INTO Security_Group VALUES('PRM_PAYMENT_MANAGE','PROJECT PAYMENT????');
INSERT INTO Security_Group VALUES('PRM_INVOICE_MANAGE','PROJECT INVOICE????');
INSERT INTO Security_Group VALUES('PRM_EMS_MANAGE','PROJECT EMS????');

--5
--??
-------------------------------------------------------------

INSERT INTO Security_Permission VALUES('FISCAL_CALENDAR_VIEW','??????????');
INSERT INTO Security_Permission VALUES('PAS_COST_VS_BUDGET_REPORT_VIEW','COST VS BUDGET ??????');
INSERT INTO Security_Permission VALUES('PAS_REVENUE_REPORT_VIEW','REVENUE??????');
INSERT INTO Security_Permission VALUES('PAS_PROJ_STATUS_REPORT_VIEW','PROJECT STATUS??????');
INSERT INTO Security_Permission VALUES('PAS_COST_QUERY_REPORT_VIEW','PROJECT COST QUERY??????');
INSERT INTO Security_Permission VALUES('PAS_EXP_ANALYSIS_REPORT_VIEW','EXPENSE ANALYSIS??????');
INSERT INTO Security_Permission VALUES('MANDAY_ACTUAL_VS_BUDGET_REPORT_VIEW','MAN-DAY ACTUAL VS BUDGET??????');

INSERT INTO Security_Permission VALUES('PAS_TS_DETAIL_VIEW','TS Detail??????');
INSERT INTO Security_Permission VALUES('PAS_CAF_REPORT_VIEW','OUTSTANDING CAF Status??????');
INSERT INTO Security_Permission VALUES('PAS_RESOURCE_FORECAST_VIEW','Resource Forecast ??????');
INSERT INTO Security_Permission VALUES('PAS_ACTUAL_FORECAST_VIEW','Resource Actual vs Forecast ??????');
INSERT INTO Security_Permission VALUES('PROCU_SUB_VIEW','其他采购费用查看权限');
INSERT INTO Security_Permission VALUES('PROCU_SUB_ALL','部门其他采购费用查看权限');
INSERT INTO Security_Permission VALUES('PROCU_SUB_CREATE','其他采购费用创建权限');


INSERT INTO Security_Group_Permission VALUES('PRM_PS_PA_MANAGE', 'PROCU_SUB_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PS_PA_MANAGE', 'PROCU_SUB_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PS_PA_MANAGE', 'PROCU_SUB_ALL');
---------------------------------
-- ACCEPTANCE ??
---------------------------------
INSERT INTO Security_Permission VALUES('PROJECT_ACCP_CREATE','??Acceptance????');
INSERT INTO Security_Permission VALUES('PROJECT_ACCP_VIEW','??Acceptance????');
INSERT INTO Security_Permission VALUES('PROJECT_ACCP_ALL','????Acceptance????');

---------------------------------
--BILLING ??
---------------------------------
INSERT INTO Security_Permission VALUES('PROJECT_BILLING_CREATE','????????');
INSERT INTO Security_Permission VALUES('PROJECT_BILLING_VIEW','????????');
INSERT INTO Security_Permission VALUES('PROJECT_BILLING_ALL','??????????');

---------------------------------
--PAYMENT ??
---------------------------------
INSERT INTO Security_Permission VALUES('PROJECT_PAYMENT_CREATE','????????');
INSERT INTO Security_Permission VALUES('PROJECT_PAYMENT_VIEW','????????');
INSERT INTO Security_Permission VALUES('PROJECT_PAYMENT_ALL','??????????');


---------------------------------
--INVOICE ??
---------------------------------
INSERT INTO Security_Permission VALUES('PROJ_INVOICE_CREATE','??????????');
INSERT INTO Security_Permission VALUES('PROJ_INVOICE_VIEW','??????????');
INSERT INTO Security_Permission VALUES('PROJ_INVOICE_ALL','????????????');

---------------------------------
--EMS ??
---------------------------------
INSERT INTO Security_Permission VALUES('PROJ_EMS_CREATE','????EMS????');
INSERT INTO Security_Permission VALUES('PROJ_EMS_VIEW','????EMS????');
INSERT INTO Security_Permission VALUES('PROJ_EMS_ALL','部门项目应收EMS查看权限');



--6
-------------------------------------------------------------
	--????????
-------------------------------------------------------------
-------------------------------------------------------------



	--STAFF ??
----------------------
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'TIME_SHEET_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'TIME_SHEET_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'TIME_SHEET_FORECAST_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'TIME_SHEET_FORECAST_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'EXPENSE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'EXPENSE_SELF_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'CUST_PROJECT_SELECT');


 
	--PM ??
----------------------
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'TIME_SHEET_APPROVAL');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'CUST_PROJECT_CTC_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'CUST_PROJECT_CTC_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'CUST_PROJECT_MEMBER_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'PROJECT_ACCP_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'PROJECT_ACCP_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'EXPENSE_APPROVAL');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'EXPENSE_APPROVAL_VIEW');



	--TS PA ??
----------------------
INSERT INTO Security_Group_Permission VALUES('PRM_TS_PA_MANAGE', 'TIME_SHEET_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TS_PA_MANAGE', 'TIME_SHEET_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_TS_PA_MANAGE', 'TIME_SHEET_ALL');

INSERT INTO Security_Group_Permission VALUES('PRM_TS_PA_MANAGE', 'TIME_SHEET_FORECAST_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TS_PA_MANAGE', 'TIME_SHEET_FORECAST_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_TS_PA_MANAGE', 'EXPENSE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TS_PA_MANAGE', 'EXPENSE_SELF_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_TS_PA_MANAGE', 'TIME_SHEET_CAF');


	--RESOURCE ASSIGN ??
----------------------
INSERT INTO Security_Group_Permission VALUES('PRM_RESOURCE_ASSIGN_MANAGE', 'CUST_PROJECT_MEMBER_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_RESOURCE_ASSIGN_MANAGE', 'CUST_PROJECT_MEMBER_CREATE');

	--ACCEPTANCE ??
----------------------
INSERT INTO Security_Group_Permission VALUES('PRM_ACCEPTANCE_MANAGE', 'PROJECT_ACCP_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_ACCEPTANCE_MANAGE', 'PROJECT_ACCP_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_ACCEPTANCE_MANAGE', 'PROJECT_ACCP_ALL');

	--EXPENSE VERIFY PA ??
----------------------
INSERT INTO Security_Group_Permission VALUES('PRM_EXP_PA_MANAGE', 'EXPENSE_VERIFY');

	-- EXPENSE CLAIM FA ??
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_EXP_FA_MANAGE', 'EXPENSE_CLAIM');
INSERT INTO Security_Group_Permission VALUES('PRM_EXP_FA_MANAGE', 'EXPENSE_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_EXP_FA_MANAGE', 'EXPENSE_TYPE_VIEW');



	-- OTHER COST PA ??
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_OC_PA_MANAGE', 'OTHER_COST_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_OC_PA_MANAGE', 'OTHER_COST_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_OC_PA_MANAGE', 'OTHER_COST_ALL');

	-- PROCUMENT/SUBCONTRACT PA ??
---------------------------------
	--???????????????
	-- PROJECT FA ??
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'CUST_INT_PROJECT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'CUST_INT_PROJECT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'CUST_CONT_PROJECT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'CUST_CONT_PROJECT_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'PROJECT_EVENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'PROJECT_EVENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'PROJECT_EVENT_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'PROJECT_EVENT_TYPE_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'FISCAL_CALENDAR_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'FISCAL_CALENDAR_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'PROJECT_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'PROJECT_TYPE_VIEW');


	-- MASTER FA ??
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'ADMIN_CURRENCY_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'ADMIN_CURRENCY_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'COST_RATE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'INDUSTRY_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'INDUSTRY_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'CUST_ACCOUNT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'CUST_ACCOUNT_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'PROJECT_CALENDAR_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'PROJECT_CALENDAR_VIEW');


	-- MANAGER REPORT ??
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'PAS_PM_REPORT_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'FISCAL_CALENDAR_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'PAS_PM_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'PAS_UTL_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'PAS_TS_DETAIL_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'PAS_CAF_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'PAS_RESOURCE_FORECAST_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'PAS_ACTUAL_FORECAST_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'PAS_COST_VS_BUDGET_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'PAS_REVENUE_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'PAS_PROJ_STATUS_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'PAS_COST_QUERY_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'PAS_EXP_ANALYSIS_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'MANDAY_ACTUAL_VS_BUDGET_REPORT_VIEW');

---------------------------------
	-- ??????
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT1_MANAGE', 'PAS_PM_REPORT_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT1_MANAGE', 'FISCAL_CALENDAR_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT1_MANAGE', 'PAS_UTL_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT1_MANAGE', 'PAS_TS_DETAIL_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT1_MANAGE', 'PAS_RESOURCE_FORECAST_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT1_MANAGE', 'PAS_ACTUAL_FORECAST_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT1_MANAGE', 'PAS_CAF_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT1_MANAGE', 'PAS_COST_VS_BUDGET_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT1_MANAGE', 'PAS_PROJ_STATUS_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT1_MANAGE', 'PAS_COST_QUERY_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT1_MANAGE', 'PAS_EXP_ANALYSIS_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT1_MANAGE', 'MANDAY_ACTUAL_VS_BUDGET_REPORT_VIEW');


---------------------------------
	-- ??????
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT2_MANAGE', 'PAS_PM_REPORT_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT2_MANAGE', 'FISCAL_CALENDAR_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT2_MANAGE', 'PAS_PM_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT2_MANAGE', 'PAS_REVENUE_REPORT_VIEW');


---------------------------------
	-- PA????
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_PA_RPT_MANAGE', 'PAS_PM_REPORT_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_RPT_MANAGE', 'FISCAL_CALENDAR_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_RPT_MANAGE', 'PAS_UTL_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_RPT_MANAGE', 'PAS_TS_DETAIL_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_RPT_MANAGE', 'PAS_CAF_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_RPT_MANAGE', 'PAS_EXP_ANALYSIS_REPORT_VIEW');

---------------------------------
	-- BILLING ??
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_BILLING_MANAGE', 'PROJECT_BILLING_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_BILLING_MANAGE', 'PROJECT_BILLING_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_BILLING_MANAGE', 'PROJECT_BILLING_ALL');

---------------------------------
	-- PAYMENT ??
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_PAYMENT_MANAGE', 'PROJECT_PAYMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PAYMENT_MANAGE', 'PROJECT_PAYMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PAYMENT_MANAGE', 'PROJECT_PAYMENT_ALL');
---------------------------------
	-- INVOICE ??
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_INVOICE_MANAGE', 'PROJ_INVOICE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_INVOICE_MANAGE', 'PROJ_INVOICE_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_INVOICE_MANAGE', 'PROJ_INVOICE_ALL');
---------------------------------
	-- EMS ??
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_EMS_MANAGE', 'PROJ_EMS_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_EMS_MANAGE', 'PROJ_EMS_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_EMS_MANAGE', 'PROJ_EMS_ALL');

--7
-------------------------
insert into module values ('3.1.2.3','Acceptance Status Update','','findProjAccpPage','Y',3,'update the acceptance status for customer and company','3.1.2');
insert into module values ('3.3.1.8','Outstanding CAF Status Report','','pas.report.CAFStatusRpt.do','Y',8,'Outstanding CAF Report','3.3.1');
insert into module values ('3.3.1.9','Detailed Time Sheet Query','','pas.report.TSDetailRpt.do','Y',9,'Time Sheet Details Report','3.3.1');
insert into module values ('3.3.1.10','Resource Forecast Report','','pas.report.ResourceForecastRpt.do','Y',10,'Resource Forecast Report','3.3.1');
insert into module values ('3.3.1.11','Resource Actual vs Forecast Report','','pas.report.ActualVSForecastRpt.do','Y',11,'Resource Actual vs Forecast Report','3.3.1');
insert into module values ('3.3.1.12','Man-Day Actual vs Budget Report','','pas.report.ActualVSBudgetMDRpt.do','Y',12,'Man-Day Actual vs Budget Report','3.3.1');


insert into module values ('5.1','AR/AP','','NULL','Y',13,'????????','1');
INSERT INTO Module VALUES('5.1.1','Billing','','NULL','Y',1,'billing operations', '5.1');
INSERT INTO Module VALUES('5.1.1.1','Billing Pending List','','findBillPendingList','Y',2,'billing pending list operations', '5.1.1');
INSERT INTO Module VALUES('5.1.1.2','Billing Instructions','','FindBillingInstruction','Y',3,'billing instruction operations', '5.1.1');
INSERT INTO Module VALUES('5.1.2','Payment','','NULL','Y',2,'payment operations', '5.1');
INSERT INTO Module VALUES('5.1.2.1','Payment Pending List','','NULL','Y',4,'payment pending list operations', '5.1.2');
INSERT INTO Module VALUES('5.1.2.2','Payment Instructions','','NULL','Y',5,'payment instruction operations', '5.1.2');
INSERT INTO Module VALUES('5.1.3','Invoice','','NULL','Y',3,'Invoice operations', '5.1');
INSERT INTO Module VALUES('5.1.3.1','Invoice maintenance','','findInvoice','Y',6,'Invoice information maintenance', '5.1.3');
INSERT INTO Module VALUES('5.1.3.2','EMS maintenance','','findEMS','Y',7,'EMS information operations', '5.1.3');
insert into module_group values('FO_ADM_GROUP','FO ????',330);
insert into module_group_associate values ('FO_ADM_GROUP','5.1');

