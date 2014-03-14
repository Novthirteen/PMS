-- TimeSheet Permission
insert into module values ('3.1','Data Entry','','NULL','Y',10,'Data entry for Time Sheet, Project Expense','1');
insert into module values ('3.1.1','Time Sheet','','NULL','Y',1,'Time Sheet Records Maintenance','3.1');
insert into module values ('3.1.1.1','Time Sheet Entry','','findPRMPage.do?SecId=1','Y',1,'Actual Time Sheet data entry','3.1.1');
insert into module values ('3.1.1.2','Time Sheet Forecast','','findPRMPage.do?SecId=2','Y',2,'Time Sheet Forecast data entry','3.1.1');
insert into module values ('3.1.1.3','Time Sheet Approval','','findPRMPage.do?SecId=3','Y',3,'This is used by project manager to approve his projects related Time sheet data','3.1.1');
insert into module values ('3.1.1.4','TimeSheet CAF Update','','findPRMPage.do?SecId=4','Y',4,'This is used by PMA to update CAF data', '3.1.1');
insert into module values ('3.1.2','Project Management','','NULL','Y',2,'Project Management Operation','3.1');
insert into module values ('3.1.2.1','Forecast To Complete','','findPrjFCPage.do?SecId=1','Y',1,'Monthly Update your project cost forecast to complete','3.1.2');
insert into module values ('3.1.2.2','Project Member Assignment','','assignProject','Y',2,'Assign prject members in your project','3.1.2');
insert into module values ('3.1.2.3','Acceptance Status Update','','findProjAccpPage','Y',3,'update the acceptance status for customer and company','3.1.2');
insert into module values ('3.1.3','Project Expense','','NULL','Y',3,'Project Expense Claims Processes','3.1');
insert into module values ('3.1.3.1','Expense Entry','','findExpSelfPage.do','Y',1,'Expense data entry','3.1.3');
insert into module values ('3.1.3.2','Expense Verify','','findExpToVerifyPage.do','Y',2,'This is used by PMA to verify the expense amount','3.1.3');
insert into module values ('3.1.3.3','Expense Approval','','findExpToApprovalPage.do','Y',3,'This is used by PM to approve the expense forms','3.1.3');
insert into module values ('3.1.3.4','Expense Pay-Out','','findExpToClaimPage.do','Y',4,'This is used by F&A to pay-out expenses','3.1.3');
insert into module values ('3.1.3.5','Other Cost Entry','','findCostSelfPage.do?Type=Expense','Y',5,'This is used by PMA to entry other cost data','3.1.3');
insert into module values ('3.1.4','Procurement/SubContract','','findCostSelfPage.do?Type=ExtCost','Y',4,'This is used by PMA to entry procu/sub cost data','3.1');


insert into module_group values('PRM_OP_GROUP','PRM ����ģ��',300);
insert into module_group_associate values ('PRM_OP_GROUP','3.1');

-- TimeSheet Permission
insert into module values ('3.2','Master Data','','NULL','Y',11,'Project Master Data Administration','1');
INSERT INTO Module VALUES('3.2.1','Project','','NULL','Y',1,'Project information administration', '3.2');
INSERT INTO Module VALUES('3.2.1.2','External Project','','listContractProject','Y',2,'External Project information administration', '3.2.1');
INSERT INTO Module VALUES('3.2.1.3','Internal Project','','listInternalProject','Y',3,'Internal Project information administration', '3.2.1');
INSERT INTO Module VALUES('3.2.2','F&A','','NULL','Y',2,'Finance & Accounting Operations', '3.2');
INSERT INTO Module VALUES('3.2.2.1','Exchange Rate','','listCurrencyType','Y',1,'Currency and Exchange Rate information', '3.2.2');
INSERT INTO Module VALUES('3.2.2.4','Cost Rate','','editConsultantCost','Y',4,'Consultant Cost Rate information', '3.2.2');
INSERT INTO Module VALUES('3.2.3','Customer','','NULL','Y',3,'Customer information administration', '3.2');
INSERT INTO Module VALUES('3.2.3.3','Customer','','listCustParty','Y',2,'Customer information', '3.2.3');
INSERT INTO Module VALUES('3.2.3.6','Customer Group','','listCustomerAccount','Y',4,'Customer Group information', '3.2.3');

insert into module_group values('PRM_ADM_GROUP','PRM ����ģ��',310);
insert into module_group_associate values ('PRM_ADM_GROUP','3.2');

insert into module values ('3.3','Report','','NULL','Y',11,'Project related report','1');
INSERT INTO Module VALUES('3.3.1','F&A Report','','NULL','Y',1,'F&A related Report', '3.3');
insert into module values ('3.3.1.1','Cost By Project','','pas.report.CostByPMRpt.do','Y',1,'Cost by project manager Report','3.3.1');
insert into module values ('3.3.1.2','Project Cost vs Budget','','pas.report.ProjectOverBudgetRpt.do','Y',2,'Project Cost vs Budget Report','3.3.1');
insert into module values ('3.3.1.3','Revenue Calculation','','pas.report.ForecastVarianceRpt.do','Y',3,'Revenue Calculation Report','3.3.1');
insert into module values ('3.3.1.4','Project Status','','pas.report.ProjectStatusRpt.do','Y',4,'Project Status Report','3.3.1');
insert into module values ('3.3.1.5','Utilization Report','','pas.report.TSStatusSummaryRpt.do','Y',5,'Utilization Report', '3.3.1');
insert into module values ('3.3.1.6','Project Cost Query', '', 'pas.report.ProjectCostRpt.do', 'Y', 6, 'Project Cost Query report', '3.3.1');
insert into module values ('3.3.1.7','Expense Analysis','','pas.report.ExpenseAnalysisRpt.do','Y',7,'Expense Analysis Report','3.3.1');
insert into module values ('3.3.1.8','Outstanding CAF Status Report','','pas.report.CAFStatusRpt.do','Y',8,'Outstanding CAF Report','3.3.1');
insert into module values ('3.3.1.9','Detailed Time Sheet Query','','pas.report.TSDetailRpt.do','Y',9,'Time Sheet Details Report','3.3.1');
insert into module values ('3.3.1.10','Resource Forecast Report','','pas.report.ResourceForecastRpt.do','Y',10,'Resource Forecast Report','3.3.1');
insert into module values ('3.3.1.11','Resource Actual vs Forecast Report','','pas.report.ActualVSForecastRpt.do','Y',11,'Resource Actual vs Forecast Report','3.3.1');
insert into module values ('3.3.1.12','Man-Day Actual vs Budget Report','','pas.report.ActualVSBudgetMDRpt.do','Y',12,'Man-Day Actual vs Budget Report','3.3.1');
insert into module values ('3.3.2','Fiscal Calendar','','listFisCalendar','Y',2,'View Fiscal Calendar','3.3');
insert into module_group values('PRM_RPT_GROUP','PRM ����ģ��',320);
insert into module_group_associate values ('PRM_RPT_GROUP','3.3');

insert into module values ('4.1','Contact','','NULL','Y',12,'CRM����ҵ��','1');
INSERT INTO Module VALUES('4.1.1','Customer','','NULL','Y',1,'', '4.1');
INSERT INTO Module VALUES('4.1.1.1','Customer Contact','','listCustUserLogin','Y',1,'Customer Contact information administration', '4.1.1');

insert into module_group values('CRM_ADM_GROUP','CRM ����ģ��',320);
insert into module_group_associate values ('CRM_ADM_GROUP','4.1');

insert into module values ('5.1','AR/AP','','NULL','Y',13,'Ӧ��Ӧ������ҵ��','1');
INSERT INTO Module VALUES('5.1.1','Billing','','NULL','Y',1,'billing operations', '5.1');
INSERT INTO Module VALUES('5.1.1.1','Billing Pending List','','findBillPendingList','Y',2,'billing pending list operations', '5.1.1');
INSERT INTO Module VALUES('5.1.1.2','Billing Instructions','','FindBillingInstruction','Y',3,'billing instruction operations', '5.1.1');
INSERT INTO Module VALUES('5.1.2','Payment','','NULL','Y',2,'payment operations', '5.1');
INSERT INTO Module VALUES('5.1.2.1','Payment Pending List','','NULL','Y',4,'payment pending list operations', '5.1.2');
INSERT INTO Module VALUES('5.1.2.2','Payment Instructions','','NULL','Y',5,'payment instruction operations', '5.1.2');
INSERT INTO Module VALUES('5.1.3','Invoice','','NULL','Y',3,'Invoice operations', '5.1');
INSERT INTO Module VALUES('5.1.3.1','Invoice maintenance','','findInvoice','Y',6,'Invoice information maintenance', '5.1.3');
INSERT INTO Module VALUES('5.1.3.2','EMS maintenance','','findEMS','Y',7,'EMS information operations', '5.1.3');
insert into module_group values('FO_ADM_GROUP','FO ����ģ��',330);
insert into module_group_associate values ('FO_ADM_GROUP','5.1');

-------------------------------------------------------------
--Ȩ����
-------------------------------------------------------------
INSERT INTO Security_Group VALUES('PRM_TYPE_MANAGE','PAS�й�����������ά��Ȩ��');
INSERT INTO Security_Group VALUES('PRM_DATA_MANAGE','PASά��Ȩ��');
INSERT INTO Security_Group VALUES('PRM_PA_MANAGE','PAS PAά��Ȩ��');
INSERT INTO Security_Group VALUES('PRM_DEP_MANAGE','PAS��������Ȩ��');
INSERT INTO Security_Group VALUES('PRM_FA_MANAGE','PAS F&AȨ��');
-------------------------------------------------------------
--Ȩ��
-------------------------------------------------------------

---------------------------------
--ϵͳ������(ֻ��ϵͳ����Ա����ʹ���ⲿ�ֹ���)
---------------------------------
INSERT INTO Security_Permission VALUES('INTERNAL_DEPARMENT_CREATE','�û����Ŵ���Ȩ��');
INSERT INTO Security_Permission VALUES('INTERNAL_DEPARMENT_VIEW','�û����Ų鿴Ȩ��');

---------------------------------
-- Staff Ȩ��
---------------------------------
INSERT INTO Security_Permission VALUES('EXPENSE_SELF_VIEW','���˷��ò鿴Ȩ��');
INSERT INTO Security_Permission VALUES('EXPENSE_APPROVAL_VIEW','�������ò鿴Ȩ��');
INSERT INTO Security_Permission VALUES('EXPENSE_CREATE','���ô���Ȩ��');
INSERT INTO Security_Permission VALUES('EXPENSE_APPROVAL','��������Ȩ��');
INSERT INTO Security_Permission VALUES('TIME_SHEET_CREATE','��ĿTime Sheet����Ȩ��');
INSERT INTO Security_Permission VALUES('TIME_SHEET_VIEW','��ĿTime Sheet�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('TIME_SHEET_APPROVAL','��ĿTime Sheet����Ȩ��');
INSERT INTO Security_Permission VALUES('TIME_SHEET_FORECAST_CREATE','��ĿTime Sheet forecast ����Ȩ��');
INSERT INTO Security_Permission VALUES('TIME_SHEET_FORECAST_VIEW','��ĿTime Sheet forecast �鿴Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_PROJECT_SELECT','��Ŀѡ��Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_PROJECT_CTC_CREATE','��ĿCTC����Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_PROJECT_CTC_VIEW','��ĿCTC�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_PROJECT_PTC_CREATE','��ĿPTC����Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_PROJECT_MEMBER_CREATE','��Ŀ��Ա����Ȩ��');

---------------------------------
-- project administration Ȩ��
---------------------------------
INSERT INTO Security_Permission VALUES('PROJECT_TYPE_CREATE','��Ŀ����ͷ��ഴ��Ȩ��');
INSERT INTO Security_Permission VALUES('PROJECT_TYPE_VIEW','��Ŀ����ͷ���鿴Ȩ��');
INSERT INTO Security_Permission VALUES('INDUSTRY_CREATE','�ͻ���ҵ����Ȩ��');
INSERT INTO Security_Permission VALUES('INDUSTRY_VIEW','�ͻ���ҵ�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_ACCOUNT_CREATE','�ͻ�����Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_ACCOUNT_VIEW','�ͻ��鿴Ȩ��');

INSERT INTO Security_Permission VALUES('COST_CENTER_CREATE','�ɱ����Ĵ���Ȩ��');
INSERT INTO Security_Permission VALUES('COST_CENTER_VIEW','�ɱ����Ĳ鿴Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_PROJECT_CREATE','��Ŀ����Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_PROJECT_VIEW','��Ŀ�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_BID_PROJECT_CREATE','BID��Ŀ����Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_BID_PROJECT_VIEW','BID_��Ŀ�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_SUPP_PROJECT_CREATE','Support��Ŀ����Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_SUPP_PROJECT_VIEW','Support��Ŀ�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_INT_PROJECT_CREATE','Internal��Ŀ����Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_INT_PROJECT_VIEW','Internal��Ŀ�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_CONT_PROJECT_CREATE','Contract��Ŀ����Ȩ��');
INSERT INTO Security_Permission VALUES('CUST_CONT_PROJECT_VIEW','Contract��Ŀ�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('COST_RATE_CREATE','Ա����λʱ��ɱ�����Ȩ��');
INSERT INTO Security_Permission VALUES('FISCAL_CALENDAR_CREATE','���������������Ȩ��');
INSERT INTO Security_Permission VALUES('PROJECT_EVENT_CREATE','��Ŀ����ʹ���Ȩ��');
INSERT INTO Security_Permission VALUES('PROJECT_EVENT_VIEW','��Ŀ����Ͳ鿴Ȩ��');
INSERT INTO Security_Permission VALUES('ADMIN_CURRENCY_CREATE','���ִ���Ȩ��');
INSERT INTO Security_Permission VALUES('ADMIN_CURRENCY_VIEW','���ֲ鿴Ȩ��');
INSERT INTO Security_Permission VALUES('EXPENSE_TYPE_CREATE','�������ʹ���Ȩ��');
INSERT INTO Security_Permission VALUES('EXPENSE_TYPE_VIEW','�������Ͳ鿴Ȩ��');
INSERT INTO Security_Permission VALUES('PROJECT_TYPE_CREATE','��Ŀ����ͷ��ഴ��Ȩ��');
INSERT INTO Security_Permission VALUES('PROJECT_TYPE_VIEW','��Ŀ����ͷ���鿴Ȩ��');
INSERT INTO Security_Permission VALUES('PROJECT_EVENT_TYPE_CREATE','��ĿEVENT TYPE����Ȩ��');
INSERT INTO Security_Permission VALUES('PROJECT_EVENT_TYPE_VIEW','��ĿEVENT TYPE�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('PROJECT_CALENDAR_CREATE','������������Ȩ��');
INSERT INTO Security_Permission VALUES('PROJECT_CALENDAR_VIEW','���������鿴Ȩ��');

---------------------------------
-- PA Ȩ��
---------------------------------
INSERT INTO Security_Permission VALUES('OTHER_COST_VIEW','�������ò鿴Ȩ��');
INSERT INTO Security_Permission VALUES('OTHER_COST_ALL','�����������ò鿴Ȩ��');
INSERT INTO Security_Permission VALUES('OTHER_COST_CREATE','�������ô���Ȩ��');
INSERT INTO Security_Permission VALUES('TIME_SHEET_CAF','��ĿTime Sheet CAF���ݸ���Ȩ��');
INSERT INTO Security_Permission VALUES('TIME_SHEET_ALL','��ĿTime Sheet�������ݸ���Ȩ��');
INSERT INTO Security_Permission VALUES('PAS_PM_REPORT_ALL','������Ŀ����鿴Ȩ��');
INSERT INTO Security_Permission VALUES('EXPENSE_CLAIM','���ñ���Ȩ��');
INSERT INTO Security_Permission VALUES('EXPENSE_VERIFY','�������Ȩ��');
INSERT INTO Security_Permission VALUES('PAS_UTL_REPORT_VIEW','Utilization����鿴Ȩ��');
INSERT INTO Security_Permission VALUES('PAS_CAF_REPORT_VIEW','CAF Status����鿴Ȩ��');
INSERT INTO Security_Permission VALUES('PAS_TS_DETAIL_VIEW','TS Detail����鿴Ȩ��');
INSERT INTO Security_Permission VALUES('PAS_RESOURCE_FORECAST_VIEW','Resource Forecast ����鿴Ȩ��');
INSERT INTO Security_Permission VALUES('PAS_ACTUAL_FORECAST_VIEW','Resource Actual vs Forecast ����鿴Ȩ��');
INSERT INTO Security_Permission VALUES('PAS_COST_VS_BUDGET_REPORT_VIEW','COST VS BUDGET ����鿴Ȩ��');
INSERT INTO Security_Permission VALUES('PAS_REVENUE_REPORT_VIEW','REVENUE����鿴Ȩ��');
INSERT INTO Security_Permission VALUES('PAS_PROJ_STATUS_REPORT_VIEW','PROJECT STATUS����鿴Ȩ��');
INSERT INTO Security_Permission VALUES('PAS_COST_QUERY_REPORT_VIEW','PROJECT COST QUERY����鿴Ȩ��');
INSERT INTO Security_Permission VALUES('PAS_EXP_ANALYSIS_REPORT_VIEW','EXPENSE ANALYSIS����鿴Ȩ��');
INSERT INTO Security_Permission VALUES('MANDAY_ACTUAL_VS_BUDGET_REPORT_VIEW','MAN-DAY ACTUAL VS BUDGET����鿴Ȩ��');

INSERT INTO Security_Permission VALUES('PROJECT_ACCP_CREATE','��ĿAcceptance����Ȩ��');
INSERT INTO Security_Permission VALUES('PROJECT_ACCP_VIEW','��ĿAcceptance�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('PROJECT_ACCP_ALL','������ĿAcceptance�鿴Ȩ��');

INSERT INTO Security_Permission VALUES('PROJECT_BILLING_CREATE','��ĿӦ�մ���Ȩ��');
INSERT INTO Security_Permission VALUES('PROJECT_BILLING_VIEW','��ĿӦ�ղ鿴Ȩ��');
INSERT INTO Security_Permission VALUES('PROJECT_BILLING_ALL','������ĿӦ�ղ鿴Ȩ��');

INSERT INTO Security_Permission VALUES('PROJECT_PAYMENT_CREATE','��ĿӦ������Ȩ��');
INSERT INTO Security_Permission VALUES('PROJECT_PAYMENT_VIEW','��ĿӦ���鿴Ȩ��');
INSERT INTO Security_Permission VALUES('PROJECT_PAYMENT_ALL','������ĿӦ���鿴Ȩ��');

INSERT INTO Security_Permission VALUES('PROJ_INVOICE_CREATE','��ĿӦ�շ�Ʊ����Ȩ��');
INSERT INTO Security_Permission VALUES('PROJ_INVOICE_VIEW','��ĿӦ�շ�Ʊ�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('PROJ_INVOICE_ALL','������ĿӦ�շ�Ʊ�鿴Ȩ��');

INSERT INTO Security_Permission VALUES('PROJ_EMS_CREATE','��ĿӦ��EMS����Ȩ��');
INSERT INTO Security_Permission VALUES('PROJ_EMS_VIEW','��ĿӦ��EMS�鿴Ȩ��');
---------------------------------
-- Manager Ȩ��
---------------------------------
INSERT INTO Security_Permission VALUES('CUST_PROJECT_MEMBER_ALL','��������Ŀ��Ա����Ȩ��');
INSERT INTO Security_Permission VALUES('PAS_PM_REPORT_VIEW','��Ŀ����鿴Ȩ��');
-------------------------------------------------------------
--Ȩ�����Ȩ�޶���
-------------------------------------------------------------
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'INTERNAL_DEPARMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'INTERNAL_DEPARMENT_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'EXPENSE_APPROVAL');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'EXPENSE_SELF_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'EXPENSE_APPROVAL_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'EXPENSE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'TIME_SHEET_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'TIME_SHEET_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'TIME_SHEET_APPROVAL');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'TIME_SHEET_FORECAST_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'TIME_SHEET_FORECAST_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'CUST_PROJECT_SELECT');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'CUST_PROJECT_CTC_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'CUST_PROJECT_CTC_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'CUST_PROJECT_PTC_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'CUST_PROJECT_MEMBER_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'PROJECT_ACCP_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'PROJECT_ACCP_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'PROJECT_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'PROJECT_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'INDUSTRY_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'INDUSTRY_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'CUST_ACCOUNT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'CUST_ACCOUNT_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'COST_CENTER_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'COST_CENTER_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'CUST_PROJECT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'CUST_PROJECT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'CUST_BID_PROJECT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'CUST_BID_PROJECT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'CUST_SUPP_PROJECT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'CUST_SUPP_PROJECT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'CUST_INT_PROJECT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'CUST_INT_PROJECT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'CUST_CONT_PROJECT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'CUST_CONT_PROJECT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'COST_RATE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'FISCAL_CALENDAR_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'PROJECT_EVENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'PROJECT_EVENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'ADMIN_CURRENCY_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'ADMIN_CURRENCY_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'EXPENSE_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'EXPENSE_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'PROJECT_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'PROJECT_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'PROJECT_EVENT_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'PROJECT_EVENT_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'PROJECT_CALENDAR_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TYPE_MANAGE', 'PROJECT_CALENDAR_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','OTHER_COST_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','OTHER_COST_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','TIME_SHEET_CAF');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','TIME_SHEET_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','PAS_UTL_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','EXPENSE_VERIFY');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','PAS_PM_REPORT_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','PROJECT_ACCP_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','PROJECT_ACCP_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE', 'PROJECT_ACCP_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','PROJECT_BILLING_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','PROJECT_BILLING_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE', 'PROJECT_BILLING_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','PROJECT_PAYMENT_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','PROJECT_PAYMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE', 'PROJECT_PAYMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','PAS_CAF_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','PAS_TS_DETAIL_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','PAS_RESOURCE_FORECAST_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','PAS_ACTUAL_FORECAST_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','PROJ_INVOICE_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE', 'PROJ_INVOICE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE','PROJ_EMS_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE', 'PROJ_EMS_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE', 'PROJ_INVOICE_ALL');

INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE', 'PAS_COST_VS_BUDGET_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE', 'PAS_REVENUE_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE', 'PAS_PROJ_STATUS_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE', 'PAS_COST_QUERY_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE', 'PAS_EXP_ANALYSIS_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_MANAGE', 'MANDAY_ACTUAL_VS_BUDGET_REPORT_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_FA_MANAGE', 'EXPENSE_CLAIM');
INSERT INTO Security_Group_Permission VALUES('PRM_FA_MANAGE', 'PAS_PM_REPORT_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_FA_MANAGE', 'PROJECT_ACCP_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_FA_MANAGE','PROJECT_PAYMENT_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_FA_MANAGE','PROJECT_PAYMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_FA_MANAGE', 'PROJECT_PAYMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_FA_MANAGE','PROJECT_BILLING_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_FA_MANAGE','PROJECT_BILLING_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_FA_MANAGE', 'PROJECT_BILLING_CREATE');

INSERT INTO Security_Group_Permission VALUES('PRM_FA_MANAGE','PROJ_INVOICE_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_FA_MANAGE', 'PROJ_INVOICE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_FA_MANAGE','PROJ_EMS_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_FA_MANAGE', 'PROJ_EMS_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_FA_MANAGE', 'PROJ_INVOICE_ALL');

INSERT INTO Security_Group_Permission VALUES('PRM_DEP_MANAGE', 'PAS_PM_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_DEP_MANAGE', 'CUST_PROJECT_MEMBER_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_DEP_MANAGE', 'PAS_PM_REPORT_ALL');