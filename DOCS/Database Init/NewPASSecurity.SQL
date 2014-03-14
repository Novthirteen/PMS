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
insert into module values ('3.1.3.6','Airfare Cost Entry','','findCostSelfPage.do?Type=Expense&CostType=EAF','Y',6,'This is used by PMA to entry airfare cost data','3.1.3');
insert into module values ('3.1.4','Procurement/SubContract','','findCostSelfPage.do?Type=ExtCost','Y',4,'This is used by PMA to entry procu/sub cost data','3.1');
insert into module values ('3.1.5','Pre-Sale Activity','','ListPreSaleProject','Y',5,'ListPreSaleProject','3.1');
insert into module values ('3.1.6','Sales Bid Tracking','','ListSalesBid','Y',6,'Sales Bid Tracking','3.1');



insert into module_group values('PRM_OP_GROUP','PRM 操作模块',300);
insert into module_group_associate values ('PRM_OP_GROUP','3.1');

-- TimeSheet Permission
insert into module values ('3.2','Master Data','','NULL','Y',11,'Project Master Data Administration','1');
INSERT INTO Module VALUES('3.2.1','Contract Profile','','NULL','Y',1,'Contract Profile administration', '3.2');
INSERT INTO Module VALUES('3.2.1.1','Contract','','findContractProfile','Y',1,'Contract Profile Maintenance', '3.2.1');
INSERT INTO Module VALUES('3.2.1.2','Purchase Order','','findPurchaseOrder','Y',2,'Purchase Order Maintenance', '3.2.1');
INSERT INTO Module VALUES('3.2.2','Project Profile','','NULL','Y',2,'Project Profile administration', '3.2');
INSERT INTO Module VALUES('3.2.2.1','Contract Project','','listContractProject','Y',1,'contract Project information administration', '3.2.2');
INSERT INTO Module VALUES('3.2.2.2','Purchase Order Project','','listPOProject','Y',2,'PO Project information administration', '3.2.2');
INSERT INTO Module VALUES('3.2.2.3','Internal Project','','listInternalProject','Y',3,'Internal Project information administration', '3.2.2');
INSERT INTO Module VALUES('3.2.3','F&A','','NULL','Y',3,'Finance & Accounting Operations', '3.2');
INSERT INTO Module VALUES('3.2.3.1','Exchange Rate','','listCurrencyType','Y',1,'Currency and Exchange Rate information', '3.2.3');

INSERT INTO Module VALUES('3.2.4','Customer','','NULL','Y',4,'Customer information administration', '3.2');
INSERT INTO Module VALUES('3.2.4.3','Customer','','listCustParty','Y',2,'Customer information', '3.2.4');
INSERT INTO Module VALUES('3.2.4.6','Customer Group','','listCustomerAccount','Y',4,'Customer Group information', '3.2.4');
INSERT INTO Module VALUES('3.2.5','Supplier','','NULL','Y',5,'Supplier information administration', '3.2');
INSERT INTO Module VALUES('3.2.5.1','Supplier','','listVendorParty','Y',2,'vendor information', '3.2.5');



insert into module_group values('PRM_ADM_GROUP','PRM 管理模块',310);
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
INSERT INTO Module VALUES('3.3.2','Other Report','','NULL','Y',2,'other Report', '3.3');
insert into module values ('3.3.2.1','Outstanding CAF Status Report','','pas.report.CAFStatusRpt.do','Y',8,'Outstanding CAF Report','3.3.2');
insert into module values ('3.3.2.2','Detailed Time Sheet Query','','pas.report.TSDetailRpt.do','Y',9,'Time Sheet Details Report','3.3.2');
insert into module values ('3.3.2.3','Resource Forecast Report','','pas.report.ResourceForecastRpt.do','Y',10,'Resource Forecast Report','3.3.2');
insert into module values ('3.3.2.4','Resource Actual vs Forecast Report','','pas.report.ActualVSForecastRpt.do','Y',11,'Resource Actual vs Forecast Report','3.3.2');
insert into module values ('3.3.2.5','Man-Day Actual vs Budget Report','','pas.report.ActualVSBudgetMDRpt.do','Y',12,'Man-Day Actual vs Budget Report','3.3.2');
insert into module values ('3.3.2.6','Sales Performance Report','','pas.report.SalesPerformanceRpt.do','Y',13,'Sales Performance Report','3.3.2');
insert into module values ('3.3.2.7','CAF Overall Summary Report','','pas.report.CAFSummaryRpt.do','Y',14,'CAF Overall Summary Report','3.3.2');
insert into module values ('3.3.2.8','Presale Update Report','','pas.report.PresaleUpdateRpt.do','Y',15,'Presale update Report','3.3.2');
insert into module values ('3.3.2.9','Expense Summary Report','','pas.report.ExpenseSummaryRpt.do','Y',16,'Expense Summary Report','3.3.2');
insert into module values ('3.3.2.10','Outstanding Acceptance Report','','pas.report.OutstandingAcceptanceRpt.do','Y',17,'Outstanding Acceptance Report','3.3.2');
insert into module values ('3.3.2.11','Outstanding TS Approval Report','','pas.report.OutstandingTSRpt.do','Y',18,'Outstanding Time Sheet Approval Report','3.3.2');
insert into module values ('3.3.2.12','Sales Pipeline Report','','pas.report.PipelineCurrentRpt.do','Y',19,'Sales Pipeline Report','3.3.2');
INSERT INTO Module VALUES('3.3.3','AR/AP Report','','NULL','Y',3,'AR/AP Report', '3.3');
insert into module values ('3.3.3.1','AR Agent Report','','pas.report.ARAgentRpt.do','Y',13,'AR Agent Report','3.3.3');
insert into module values ('3.3.3.2','Customer Statement','','pas.report.ARCustStatementRpt','Y',14,'Customer statement','3.3.3');
insert into module values ('3.3.4','Fiscal Calendar','','listFisCalendar','Y',4,'View Fiscal Calendar','3.3');
insert into module_group values('PRM_RPT_GROUP','PRM 报表模块',320);
insert into module_group_associate values ('PRM_RPT_GROUP','3.3');

----new menu for reports
insert into module values ('3.3','Report','','NULL','Y',11,'Project related report','1');

INSERT INTO Module VALUES('3.3.1','PA Related Reports ','','NULL','Y',1,'Project Performance Report By PA', '3.3');
insert into module values ('3.3.1.1','Outstanding CAF Status Report','','pas.report.CAFStatusRpt.do','Y',1,'Outstanding CAF Report','3.3.1');
insert into module values ('3.3.1.2','Outstanding Acceptance Report','','pas.report.OutstandingAcceptanceRpt.do','Y',2,'Outstanding Acceptance Report','3.3.1');
insert into module values ('3.3.1.3','Man-Day Actual vs Budget Report','','pas.report.ActualVSBudgetMDRpt.do','Y',3,'Man-Day Actual vs Budget Report','3.3.1');
insert into module values ('3.3.1.4','AR Aging Report','','pas.report.ARAgingRpt.do','Y',4,'AR Agent Report','3.3.1');
insert into module values ('3.3.1.5','Invoice Tracking Report','','pas.report.InvoiceTrackingRpt.do','Y',5,'Invoice Tracking Report','3.3.1');
insert into module values ('3.3.1.6','CAF Checking Report','','pas.report.CAFSummaryRpt.do','Y',6,'CAF Checking Report','3.3.1');
insert into module values ('3.3.1.7','Customer Statement','','pas.report.ARCustStatementRpt','Y',7,'Customer statement','3.3.1');

INSERT INTO Module VALUES('3.3.2','PM Related Reports','','NULL','Y',2,'Project Performance Report By PM', '3.3');
insert into module values ('3.3.2.1','Outstanding TS Approval Report','','pas.report.OutstandingTSRpt.do','Y',8,'Outstanding Time Sheet Approval Report','3.3.2');
insert into module values ('3.3.2.2','Man-Day Actual vs Budget Report','','pas.report.ActualVSBudgetMDRpt.do','Y',9,'Man-Day Actual vs Budget Report','3.3.2');
insert into module values ('3.3.2.3','Detailed Time Sheet Query','','pas.report.TSDetailRpt.do','Y',10,'Time Sheet Details Report','3.3.2');
insert into module values ('3.3.2.4','CAF Checking Report','','pas.report.CAFSummaryRpt.do','Y',11,'CAF Checking Report','3.3.2');
insert into module values ('3.3.2.5','Expense Summary Report','','pas.report.ExpenseSummaryRpt.do','Y',12,'Expense Summary Report','3.3.2');
insert into module values ('3.3.2.6','AR Aging Report','','pas.report.ARAgingRpt.do','Y',13,'AR Agent Report','3.3.2');
insert into module values ('3.3.2.7','Project Cost vs Budget Report','','pas.report.ProjectOverBudgetRpt.do','Y',14,'Project Cost vs Budget Report','3.3.2');
insert into module values ('3.3.2.8','Project Status Report','','pas.report.ProjectStatusRpt.do','Y',15,'Project Status Report','3.3.2');

INSERT INTO Module VALUES('3.3.3','SL Manager Related Reports','','NULL','Y',3,'Project Performance Report By SL Manager', '3.3');
insert into module values ('3.3.3.1','Utilization Report','','pas.report.TSStatusSummaryRpt.do','Y',16,'Utilization Report', '3.3.3');
insert into module values ('3.3.3.2','Cost By Project Report','','pas.report.CostByPMRpt.do','Y',17,'Cost by project manager Report','3.3.3');
insert into module values ('3.3.3.3','Project Cost vs Budget Report','','pas.report.ProjectOverBudgetRpt.do','Y',18,'Project Cost vs Budget Report','3.3.3');
insert into module values ('3.3.3.4','Revenue Calculation Report','','pas.report.ForecastVarianceRpt.do','Y',19,'Revenue Calculation Report','3.3.3');
insert into module values ('3.3.3.5','Project Status Report','','pas.report.ProjectStatusRpt.do','Y',20,'Project Status Report','3.3.3');
insert into module values ('3.3.3.6','Resource Forecast Report','','pas.report.ResourceForecastRpt.do','Y',21,'Resource Forecast Report','3.3.3');
insert into module values ('3.3.3.7','Resource Actual vs Forecast Report','','pas.report.ActualVSForecastRpt.do','Y',22,'Resource Actual vs Forecast Report','3.3.3');
insert into module values ('3.3.3.8','Resource Overtime Tracking Report','','pas.report.ResourceOTTrackingRpt.do','Y',23,'','3.3.3');
insert into module values ('3.3.3.9','AR Aging Report','','pas.report.ARAgingRpt.do','Y',24,'AR Agent Report','3.3.3');
insert into module values ('3.3.3.10','Customer Statement','','pas.report.ARCustStatementRpt','Y',25,'Customer statement','3.3.3');

INSERT INTO Module VALUES('3.3.4','Sales Related Reports','','NULL','Y',25,'Sales Related Reports', '3.3');
insert into module values ('3.3.4.1','Sales Performance Report','','pas.report.SalesPerformanceRpt.do','Y',25,'Sales Performance Report','3.3.4');
insert into module values ('3.3.4.2','Presale Update Report','','pas.report.PresaleUpdateRpt.do','Y',26,'Presale update Report','3.3.4');
insert into module values ('3.3.4.3','Sales Pipeline Report','','pas.report.PipelineCurrentRpt.do','Y',27,'Sales Pipeline Report','3.3.4');
-----------------------------------


insert into module values ('4.1','Contact','','NULL','Y',12,'CRM管理业务','1');
INSERT INTO Module VALUES('4.1.1','Customer','','NULL','Y',1,'', '4.1');
INSERT INTO Module VALUES('4.1.1.1','Customer Contact','','listCustUserLogin','Y',1,'Customer Contact information administration', '4.1.1');

insert into module_group values('CRM_ADM_GROUP','CRM 管理模块',320);
insert into module_group_associate values ('CRM_ADM_GROUP','4.1');

insert into module values ('5.1','AR/AP','','NULL','Y',13,'应收应付管理业务','1');
INSERT INTO Module VALUES('5.1.1','Billing','','NULL','Y',1,'billing operations', '5.1');
INSERT INTO Module VALUES('5.1.1.1','Billing Pending List','','findBillPendingList','Y',2,'billing pending list operations', '5.1.1');
INSERT INTO Module VALUES('5.1.1.2','Billing Instructions','','FindBillingInstruction','Y',3,'billing instruction operations', '5.1.1');
INSERT INTO Module VALUES('5.1.1.3','Downpayment Instructions','','FindDownpaymentInstruction','Y',10,'downpayment instruction operations', '5.1.1');
INSERT INTO Module VALUES('5.1.2','Payment','','NULL','Y',2,'payment operations', '5.1');
INSERT INTO Module VALUES('5.1.2.1','Payment Pending List','','findPaymentPendingList','Y',4,'payment pending list operations', '5.1.2');
INSERT INTO Module VALUES('5.1.2.2','Payment Instructions','','NULL','Y',5,'payment instruction operations', '5.1.2');
INSERT INTO Module VALUES('5.1.2.3','Payment Downpayment Instructions','','FindPaymentDownpaymentInstruction','Y',6,'payment downpaymentinstruction operations', '5.1.2');
INSERT INTO Module VALUES('5.1.2.4','Payment','','findPaymentInvoice','Y',7,'payment cost', '5.1.2');
INSERT INTO Module VALUES('5.1.2.5','Supplier Invoice','','listSupplierInvoice','Y',8,'Supplier Invoice', '5.1.2');
INSERT INTO Module VALUES('5.1.3','Invoice','','NULL','Y',3,'Invoice operations', '5.1');
INSERT INTO Module VALUES('5.1.3.1','Invoice Maintenance','','findInvoice','Y',6,'Invoice information maintenance', '5.1.3');
INSERT INTO Module VALUES('5.1.3.2','EMS Maintenance','','findEMS','Y',7,'EMS information operations', '5.1.3');
INSERT INTO Module VALUES('5.1.3.3','Invoice Confirmation','','findInvoiceConfirm','Y',8,'Invoice Confirmation operations', '5.1.3');

INSERT INTO Module VALUES('5.1.3.5','Lost Records Maintenance','','findLost','Y',10,'Find Lost Records operations', '5.1.3');
INSERT INTO Module VALUES('5.1.4','Receipt','','NULL','Y',4,'Receipt operations', '5.1');
INSERT INTO Module VALUES('5.1.4.1','Receipt','','findReceiptMstr','Y',11,'Receipt master operations', '5.1.4');
INSERT INTO Module VALUES('5.1.4.2','Receipt Settlement','','findReceipt','Y',12,'Receipt settlement operations', '5.1.4');
insert into module_group values('FO_ADM_GROUP','FO 管理模块',330);
insert into module_group_associate values ('FO_ADM_GROUP','5.1');

insert into module values ('6.1','Pre-Sale','','NULL','Y',14,'Pre-sale管理业务','1');
INSERT INTO Module VALUES('6.1.1','Pro-Sale Project','','ListPreSaleProject','Y',1,'Pro-Sale Project Maintenance', '6.1');
INSERT INTO Module VALUES('6.1.2','Deliverable Type','','ListDeliveryType','Y',2,'Deliverable Type maintenance', '6.1');

insert into module_group values('PRE_SALE_GROUP','PRESALE 管理模块',340);
insert into module_group_associate values ('PRE_SALE_GROUP','6.1');

insert into module values ('7.1','Sales Maintenance','','NULL','Y',15,'Sales Funnel管理业务','1');
INSERT INTO Module VALUES('7.1.1','Sales Funnel','','null','Y',1,'Sales Funnel Maintenance', '7.1')
insert into module values ('7.1.2','Pre-Sale Activity','','ListPreSaleProject','Y',2,'ListPreSaleProject','7.1');

insert into module_group values('SALE_FUNNEL_GROUP','SALES FUNNEL 管理模块',350);
insert into module_group_associate values ('SALE_FUNNEL_GROUP','7.1');
-------------------------------------------------------------
--权限组
-------------------------------------------------------------

INSERT INTO Security_Group VALUES('PRM_DATA_MANAGE','PAS员工有关类型主数据维护权限');
INSERT INTO Security_Group VALUES('PRM_PM_MANAGE','PAS_PM维护权限');
INSERT INTO Security_Group VALUES('PRM_TS_PA_MANAGE','PAS_TS_PA维护权限');
INSERT INTO Security_Group VALUES('PRM_TS_APPROVE_MANAGE','PAS_TS_APPROVE维护权限');
INSERT INTO Security_Group VALUES('PRM_RESOURCE_ASSIGN_MANAGE','PAS资源分配权限');
INSERT INTO Security_Group VALUES('PRM_ACCEPTANCE_MANAGE','PAS_ACCEPTANCE维护权限');
INSERT INTO Security_Group VALUES('PRM_EXP_PA_MANAGE','PAS_EXPENSE_PA维护权限');
INSERT INTO Security_Group VALUES('PRM_EXP_FA_MANAGE','PAS_EXPENSE_FA维护权限');
INSERT INTO Security_Group VALUES('PRM_OC_PA_MANAGE','PAS OTHER_COST_PA维护权限');
INSERT INTO Security_Group VALUES('PRM_PS_PA_MANAGE','PAS_PROCU_SUB_PA维护权限');
INSERT INTO Security_Group VALUES('PRM_PROJ_FA_MANAGE','PAS PROJECT_F&A维护权限');
INSERT INTO Security_Group VALUES('PRM_MSTR_FA_MANAGE','PAS_MASTER_FA维护权限');
INSERT INTO Security_Group VALUES('PRM_PM_RPT1_MANAGE','PAS_PM一般报表维护权限');
INSERT INTO Security_Group VALUES('PRM_PM_RPT2_MANAGE','PAS PM特指报表维护权限');
INSERT INTO Security_Group VALUES('PRM_MGE_RPT_MANAGE','PAS全部报表维护权限');
INSERT INTO Security_Group VALUES('PRM_PA_RPT_MANAGE','PAS_PA报表维护权限');
INSERT INTO Security_Group VALUES('PRM_BILLING_MANAGE','PROJECT BILLING维护权限');
INSERT INTO Security_Group VALUES('PRM_PAYMENT_MANAGE','PROJECT PAYMENT维护权限');
INSERT INTO Security_Group VALUES('PRM_INVOICE_MANAGE','PROJECT INVOICE维护权限');
INSERT INTO Security_Group VALUES('PRM_EMS_MANAGE','PROJECT EMS维护权限');
INSERT INTO Security_Group VALUES('PRM_RECEIPT_MANAGE','PROJECT RECEIPT维护权限');
INSERT INTO Security_Group VALUES('PRM_PRESALE_MANAGE','PROJECT PRESALE维护权限');
INSERT INTO Security_Group VALUES('PRM_VENDOR_MANAGE','PROJECT VENDOR维护权限');
INSERT INTO Security_Group VALUES('PRM_SALES_FUNNEL_MANAGE','SALES FUNNEL维护权限');
INSERT INTO Security_Group VALUES('AR_AGENT_MANAGE','AR AGENT维护权限');
INSERT INTO Security_Group VALUES('AR_CS_MANAGE','AR CUSTOMER STATEMENT维护权限');
INSERT INTO Security_Group VALUES('SALES_PERFORMANCE_RPT_VIEW_MANAGE','SALES_PERFORMANCE 报表查看权限');
INSERT INTO Security_Group VALUES('SALES_PERFORMANCE_RPT_ALL_MANAGE','SALES_PERFORMANCE 报表全部查看权限');

INSERT INTO Security_Group VALUES('PAYMENT_INVOICE_MANAGE','PAYMENT INVOICE维护权限');
INSERT INTO Security_Group VALUES('SALES_STEPS_MANAGE','SALES STEPS维护权限');

INSERT INTO Security_Group VALUES('PRM_CUSTOMER_MANAGE','PROJECT CUSTOMER维护权限');
INSERT INTO Security_Group VALUES('CUSTOMER_CONTACT_MANAGE','CUSTOMER CONTACT维护权限');

INSERT INTO Security_Group VALUES('CAF_SUMMARY_MANAGE','CAF SUMMARY维护权限');

INSERT INTO Security_Group VALUES('RECEIPT_MSTR_MANAGE','RECEIPT MASTER 维护权限');

INSERT INTO Security_Group VALUES('PRESALE_UPDATE_RPT_VIEW_MANAGE','PRESALE UPDATE 报表查看权限');
INSERT INTO Security_Group VALUES('PRESALE_UPDATE_RPT_ALL_MANAGE','PRESALE UPDATE 报表全部查看权限');

INSERT INTO Security_Group VALUES('EXPENSE_SUMMARY_RPT_VIEW_MANAGE','EXPENSE SUMMARY 报表查看权限');
INSERT INTO Security_Group VALUES('EXPENSE_SUMMARY_RPT_ALL_MANAGE','EXPENSE SUMMARY 报表全部查看权限');
-------------------------------------------------------------

--权限
-------------------------------------------------------------

---------------------------------
--系统管理功能(只有系统管理员可以使用这部分功能)
---------------------------------
INSERT INTO Security_Permission VALUES('INTERNAL_DEPARMENT_CREATE','用户部门创建权限');
INSERT INTO Security_Permission VALUES('INTERNAL_DEPARMENT_VIEW','用户部门查看权限');

---------------------------------
-- Staff 权限
---------------------------------
INSERT INTO Security_Permission VALUES('TIME_SHEET_CREATE','项目Time Sheet创建权限');
INSERT INTO Security_Permission VALUES('TIME_SHEET_VIEW','项目Time Sheet查看权限');
INSERT INTO Security_Permission VALUES('TIME_SHEET_FORECAST_CREATE','项目Time Sheet forecast 创建权限');
INSERT INTO Security_Permission VALUES('TIME_SHEET_FORECAST_VIEW','项目Time Sheet forecast 查看权限');
INSERT INTO Security_Permission VALUES('EXPENSE_SELF_VIEW','本人费用查看权限');
INSERT INTO Security_Permission VALUES('EXPENSE_CREATE','费用创建权限');
INSERT INTO Security_Permission VALUES('CUST_PROJECT_SELECT','项目选择权限');

---------------------------------
-- PM 权限
---------------------------------
INSERT INTO Security_Permission VALUES('TIME_SHEET_APPROVAL','项目Time Sheet审批权限');
INSERT INTO Security_Permission VALUES('CUST_PROJECT_CTC_CREATE','项目CTC创建权限');
INSERT INTO Security_Permission VALUES('CUST_PROJECT_CTC_VIEW','项目CTC查看权限');
INSERT INTO Security_Permission VALUES('EXPENSE_APPROVAL','费用审批权限');
INSERT INTO Security_Permission VALUES('EXPENSE_APPROVAL_VIEW','审批费用查看权限');


---------------------------------
-- TS PA 权限
---------------------------------
INSERT INTO Security_Permission VALUES('TIME_SHEET_ALL','项目Time Sheet所有数据更新权限');
INSERT INTO Security_Permission VALUES('TIME_SHEET_CAF','项目Time Sheet CAF数据更新权限');

---------------------------------
-- RESOURCE ASSIGN 权限
---------------------------------
INSERT INTO Security_Permission VALUES('CUST_PROJECT_MEMBER_CREATE','项目成员创建权限');
INSERT INTO Security_Permission VALUES('CUST_PROJECT_MEMBER_ALL','本部门项目成员管理权限');

---------------------------------
-- ACCEPTANCE 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PROJECT_ACCP_CREATE','项目Acceptance创建权限');
INSERT INTO Security_Permission VALUES('PROJECT_ACCP_VIEW','项目Acceptance查看权限');
INSERT INTO Security_Permission VALUES('PROJECT_ACCP_ALL','部门项目Acceptance查看权限');

---------------------------------
-- EXPENSE PA 权限
---------------------------------
INSERT INTO Security_Permission VALUES('EXPENSE_VERIFY','费用审核权限');


---------------------------------
-- EXPENSE CLAIM FA 权限
---------------------------------
INSERT INTO Security_Permission VALUES('EXPENSE_CLAIM','费用报销权限');
INSERT INTO Security_Permission VALUES('EXPENSE_TYPE_CREATE','费用类型创建权限');
INSERT INTO Security_Permission VALUES('EXPENSE_TYPE_VIEW','费用类型查看权限');

---------------------------------
-- OTHER COST PA 权限
---------------------------------
INSERT INTO Security_Permission VALUES('OTHER_COST_VIEW','其他费用查看权限');
INSERT INTO Security_Permission VALUES('OTHER_COST_ALL','部门其他费用查看权限');
INSERT INTO Security_Permission VALUES('OTHER_COST_CREATE','其他费用创建权限');

---------------------------------
-- PROCUMENT/SUBCONTRACT PA 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PROCU_SUB_VIEW','其他采购费用查看权限');
INSERT INTO Security_Permission VALUES('PROCU_SUB_ALL','部门其他采购费用查看权限');
INSERT INTO Security_Permission VALUES('PROCU_SUB_CREATE','其他采购费用创建权限');

---------------------------------
-- PROJECT FA 权限
---------------------------------
INSERT INTO Security_Permission VALUES('CUST_INT_PROJECT_CREATE','Internal项目创建权限');
INSERT INTO Security_Permission VALUES('CUST_INT_PROJECT_VIEW','Internal项目查看权限');
INSERT INTO Security_Permission VALUES('CUST_CONT_PROJECT_CREATE','Contract项目创建权限');
INSERT INTO Security_Permission VALUES('CUST_CONT_PROJECT_VIEW','Contract项目查看权限');

INSERT INTO Security_Permission VALUES('PROJECT_EVENT_CREATE','项目活动类型创建权限');
INSERT INTO Security_Permission VALUES('PROJECT_EVENT_VIEW','项目活动类型查看权限');
INSERT INTO Security_Permission VALUES('PROJECT_EVENT_TYPE_CREATE','项目EVENT TYPE创建权限');
INSERT INTO Security_Permission VALUES('PROJECT_EVENT_TYPE_VIEW','项目EVENT TYPE查看权限');

INSERT INTO Security_Permission VALUES('FISCAL_CALENDAR_CREATE','财务年度日历创建权限');
INSERT INTO Security_Permission VALUES('FISCAL_CALENDAR_VIEW','财务年度日历查看权限');

INSERT INTO Security_Permission VALUES('PROJECT_TYPE_CREATE','项目活动类型分类创建权限');
INSERT INTO Security_Permission VALUES('PROJECT_TYPE_VIEW','项目活动类型分类查看权限');

---------------------------------
-- MASTER FA 权限
---------------------------------
INSERT INTO Security_Permission VALUES('ADMIN_CURRENCY_CREATE','币种创建权限');
INSERT INTO Security_Permission VALUES('ADMIN_CURRENCY_VIEW','币种查看权限');
INSERT INTO Security_Permission VALUES('COST_RATE_CREATE','员工单位时间成本创建权限');
INSERT INTO Security_Permission VALUES('INDUSTRY_CREATE','客户行业创建权限');
INSERT INTO Security_Permission VALUES('INDUSTRY_VIEW','客户行业查看权限');

INSERT INTO Security_Permission VALUES('PROJECT_CALENDAR_CREATE','工作日历创建权限');
INSERT INTO Security_Permission VALUES('PROJECT_CALENDAR_VIEW','工作日历查看权限');

---------------------------------
-- MANAGER REPORT 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PAS_PM_REPORT_ALL','部门项目报告查看权限');
INSERT INTO Security_Permission VALUES('PROJ_COST_REPORT_VIEW','COST BY PROJECT RPT 查看权限');
INSERT INTO Security_Permission VALUES('PROJ_COST_REPORT_ALL','COST BY PROJECT RPT 全部查看权限');
INSERT INTO Security_Permission VALUES('PAS_UTL_REPORT_VIEW','Utilization报告查看权限');
INSERT INTO Security_Permission VALUES('PAS_TS_DETAIL_VIEW','TS Detail报告查看权限');
INSERT INTO Security_Permission VALUES('PAS_CAF_REPORT_VIEW','OUTSTANDING CAF Status报告查看权限');
INSERT INTO Security_Permission VALUES('PAS_RESOURCE_FORECAST_VIEW','Resource Forecast 报告查看权限');
INSERT INTO Security_Permission VALUES('PAS_ACTUAL_FORECAST_VIEW','Resource Actual vs Forecast 报告查看权限');

INSERT INTO Security_Permission VALUES('PAS_COST_VS_BUDGET_REPORT_VIEW','COST VS BUDGET 报告查看权限');
INSERT INTO Security_Permission VALUES('PAS_REVENUE_REPORT_VIEW','REVENUE报告查看权限');
INSERT INTO Security_Permission VALUES('PAS_PROJ_STATUS_REPORT_VIEW','PROJECT STATUS报告查看权限');
INSERT INTO Security_Permission VALUES('PAS_COST_QUERY_REPORT_VIEW','PROJECT COST QUERY报告查看权限');
INSERT INTO Security_Permission VALUES('PAS_EXP_ANALYSIS_REPORT_VIEW','EXPENSE ANALYSIS报告查看权限');
INSERT INTO Security_Permission VALUES('MANDAY_ACTUAL_VS_BUDGET_REPORT_VIEW','MAN-DAY ACTUAL VS BUDGET报告查看权限');

---------------------------------
--BILLING 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PROJECT_BILLING_CREATE','项目应收创建权限');
INSERT INTO Security_Permission VALUES('PROJECT_BILLING_VIEW','项目应收查看权限');
INSERT INTO Security_Permission VALUES('PROJECT_BILLING_ALL','部门项目应收查看权限');
--DOWNPAYMENT
---------------------------------
INSERT INTO Security_Permission VALUES('PROJECT_DOWNPAYMENT_CREATE','项目DOWNPAYMENT创建权限');
INSERT INTO Security_Permission VALUES('PROJECT_DOWNPAYMENT_VIEW','项目DOWNPAYMENT查看权限');
INSERT INTO Security_Permission VALUES('PROJECT_DOWNPAYMENT_ALL','部门项目DOWNPAYMENT查看权限');
---------------------------------
--PAYMENT 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PROJECT_PAYMENT_CREATE','项目应付创建权限');
INSERT INTO Security_Permission VALUES('PROJECT_PAYMENT_VIEW','项目应付查看权限');
INSERT INTO Security_Permission VALUES('PROJECT_PAYMENT_ALL','部门项目应付查看权限');


---------------------------------
--INVOICE 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PROJ_INVOICE_CREATE','项目应收发票创建权限');
INSERT INTO Security_Permission VALUES('PROJ_INVOICE_VIEW','项目应收发票查看权限');
INSERT INTO Security_Permission VALUES('PROJ_INVOICE_ALL','部门项目应收发票查看权限');

---------------------------------
--EMS 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PROJ_EMS_CREATE','项目应收EMS创建权限');
INSERT INTO Security_Permission VALUES('PROJ_EMS_VIEW','项目应收EMS查看权限');
INSERT INTO Security_Permission VALUES('PROJ_EMS_ALL','部门项目应收EMS查看权限');

---------------------------------
--RECEIPT 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PROJ_RECEIPT_CREATE','项目应收收据创建权限');
INSERT INTO Security_Permission VALUES('PROJ_RECEIPT_VIEW','项目应收收据查看权限');
INSERT INTO Security_Permission VALUES('PROJ_RECEIPT_ALL','部门项目应收收据查看权限');

---------------------------------
--RECEIPT MASTER 权限
---------------------------------
INSERT INTO Security_Permission VALUES('RECEIPT_MSTR_CREATE','收据主信息创建权限');
INSERT INTO Security_Permission VALUES('RECEIPT_MSTR_VIEW','收据主信息查看权限');
---------------------------------
--LOST RECORDS 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PROJ_LOST_CREATE','项目LOST应收收据创建权限');
INSERT INTO Security_Permission VALUES('PROJ_LOST_VIEW','项目LOST应收收据查看权限');
INSERT INTO Security_Permission VALUES('PROJ_LOST_ALL','部门LOST项目应收收据查看权限');

---------------------------------
--online user monitor 权限
---------------------------------
INSERT INTO Security_Permission VALUES('ONLINE_USER_VIEW','在线用户查看权限');

---------------------------------
--Presale Maintenance 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PROJ_PRESALE_VIEW','PRESALE 项目查看权限');
INSERT INTO Security_Permission VALUES('PROJ_PRESALE_CREATE','PRESALE 项目创建权限');
INSERT INTO Security_Permission VALUES('PROJ_PRESALE_ALL','PRESALE 项目部门查看权限');

INSERT INTO Security_Permission VALUES('DELIV_TYPE_CREATE','PRESALE DELIVERABLE TYPE 创建权限');
INSERT INTO Security_Permission VALUES('DELIV_TYPE_VIEW','PRESALE DELIVERABLE TYPE 查看权限');

---------------------------------
--Vendor Maintenance 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PROJ_VENDOR_VIEW','VENDOR查看权限');
INSERT INTO Security_Permission VALUES('PROJ_VENDOR_CREATE','VENDOR创建权限');
INSERT INTO Security_Permission VALUES('PROJ_VENDOR_ALL','VENDOR全部查看权限');

---------------------------------
--Sales Funnel 权限
---------------------------------
INSERT INTO Security_Permission VALUES('SALES_FUNNEL_VIEW','SALES FUNNEL查看权限');
INSERT INTO Security_Permission VALUES('SALES_FUNNEL_CREATE','SALES FUNNEL创建权限');
INSERT INTO Security_Permission VALUES('SALES_FUNNEL_ALL','SALES FUNNEL全部查看权限');

---------------------------------
--AR Report 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PAS_AR_AGENT_VIEW','AR AGENT RPT 查看权限');
INSERT INTO Security_Permission VALUES('PAS_AR_AGENT_ALL','AR AGENT RPT 全部查看权限');

INSERT INTO Security_Permission VALUES('PAS_AR_CS_VIEW','AR CUSTOMER STATEMENT RPT 查看权限');
INSERT INTO Security_Permission VALUES('PAS_AR_CS_ALL','AR CUSTOMER STATEMENT RPT 全部查看权限');

---------------------------------
--Sales Performance Report 权限
---------------------------------
INSERT INTO Security_Permission VALUES('SALES_PERFORMANCE_VIEW','SALES PERFORMANCE RPT 查看权限');
INSERT INTO Security_Permission VALUES('SALES_PERFORMANCE_ALL','SALES PERFORMANCE RPT 全部查看权限');

---------------------------------
--INVOICE 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PAYMENT_INVOICE_CREATE','项目应付发票创建权限');
INSERT INTO Security_Permission VALUES('PAYMENT_INVOICE_VIEW','项目应付发票查看权限');
INSERT INTO Security_Permission VALUES('PAYMENT_INVOICE_ALL','部门项目应付发票查看权限');
-------------------------------------------------------------

---------------------------------
--CONTRACT PROFILE 权限
---------------------------------
INSERT INTO Security_Permission VALUES('CONTRACT_PROFILE_CREATE','合同项目档案创建权限');
INSERT INTO Security_Permission VALUES('CONTRACT_PROFILE_VIEW','合同项目档案查看权限');
INSERT INTO Security_Permission VALUES('CONTRACT_PROFILE_ALL','部门合同项目档案查看权限');
-------------------------------------------------------------

---------------------------------
--PO PROFILE 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PO_PROFILE_CREATE','PO项目档案创建权限');
INSERT INTO Security_Permission VALUES('PO_PROFILE_VIEW','PO项目档案查看权限');
INSERT INTO Security_Permission VALUES('PO_PROFILE_ALL','部门PO项目档案查看权限');
-------------------------------------------------------------

---------------------------------
--PO Project 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PO_PROJECT_CREATE','项目应付发票创建权限');
INSERT INTO Security_Permission VALUES('PO_PROJECT_VIEW','项目应付发票查看权限');
INSERT INTO Security_Permission VALUES('PO_PROJECT_ALL','部门项目应付发票查看权限');

---------------------------------
--STEPS * ACTIVITIES 权限
---------------------------------
INSERT INTO Security_Permission VALUES('SALES_STEPS_CREATE','SALES STEPS创建权限');
INSERT INTO Security_Permission VALUES('SALES_STEPS_VIEW','SALES STEPS查看权限');
INSERT INTO Security_Permission VALUES('SALES_STEPS_ALL','部门SALES STEPS查看权限');

---------------------------------
--CUSTOMER & CUSTOMER ACCOUNT 权限
---------------------------------
INSERT INTO Security_Permission VALUES('CUST_PARTY_CREATE','CUST PARTY创建权限');
INSERT INTO Security_Permission VALUES('CUST_PARTY_VIEW','CUST PARTY查看权限');


INSERT INTO Security_Permission VALUES('CUST_ACCOUNT_CREATE','客户创建权限');
INSERT INTO Security_Permission VALUES('CUST_ACCOUNT_VIEW','客户查看权限');


	-- CUSTOMER GROUP 权限
---------------------------------
INSERT INTO Security_Group VALUES('CUST_GROUP_CREATE','CUST GROUP 创建权限');
INSERT INTO Security_Group VALUES('CUST_GROUP_VIEW','CUST GROUP 查看权限');
INSERT INTO Security_Group_Permission VALUES('CUST_GROUP_CREATE', 'CUST_ACCOUNT_CREATE');
INSERT INTO Security_Group_Permission VALUES('CUST_GROUP_VIEW', 'CUST_ACCOUNT_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_CUSTOMER_MANAGE', 'CUST_PARTY_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_CUSTOMER_MANAGE', 'CUST_PARTY_VIEW');


	-- CUSTOMER CONTACT 权限
---------------------------------
INSERT INTO Security_Permission VALUES('CUST_CONTACT_CREATE','CUST CONTACT 创建权限');
INSERT INTO Security_Permission VALUES('CUST_CONTACT_VIEW','CUST CONTACT 查看权限');
-------------------------------------------------------------

	-- CAF Summary 权限
---------------------------------
INSERT INTO Security_Permission VALUES('CAF_SUMMARY_ALL',' CAF SUMMARY 部门查看权限');
INSERT INTO Security_Permission VALUES('CAF_SUMMARY_VIEW','CAF SUMMARY 查看权限');

	-- PRESALE UPDATE RPT 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PRESALE_UPDATE_RPT_ALL',' PRESALE UPDATE RPT 部门查看权限');
INSERT INTO Security_Permission VALUES('PRESALE_UPDATE_RPT_VIEW','PRESALE UPDATE RPT 查看权限');
-------------------------------------------------------------

	-- EXPENSE SUMMARY RPT 权限
---------------------------------
INSERT INTO Security_Permission VALUES('PAS_EXPSUMMARY_REPORT_ALL','  EXPENSE SUMMARY RPT 部门查看权限');
INSERT INTO Security_Permission VALUES('PAS_EXPSUMMARY_REPORT_VIEW','  EXPENSE SUMMARY RPT 查看权限');
-------------------------------------------------------------
-------------------------------------------------------------

	--权限组的权限定义
-------------------------------------------------------------
-------------------------------------------------------------

	--系统权限
----------------------
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'INTERNAL_DEPARMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'INTERNAL_DEPARMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'SECURITY_PERMISSION_CREATE');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'SECURITY_PERMISSION_VIEW');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'USER_LOGIN_CREATE');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'USER_LOGIN_VIEW');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'ONLINE_USER_VIEW');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'COST_RATE_CREATE');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'FISCAL_CALENDAR_CREATE');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'FISCAL_CALENDAR_VIEW');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'PROJECT_CALENDAR_CREATE');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'PROJECT_CALENDAR_VIEW');
----------------------

	--STAFF 权限
----------------------
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'TIME_SHEET_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'TIME_SHEET_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'TIME_SHEET_FORECAST_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'TIME_SHEET_FORECAST_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'EXPENSE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'EXPENSE_SELF_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_DATA_MANAGE', 'CUST_PROJECT_SELECT');


 
	--PM 权限
----------------------
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'TIME_SHEET_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'TIME_SHEET_APPROVAL');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'CUST_PROJECT_CTC_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'CUST_PROJECT_CTC_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'CUST_PROJECT_MEMBER_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'PROJECT_ACCP_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'PROJECT_ACCP_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'EXPENSE_APPROVAL');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_MANAGE', 'EXPENSE_APPROVAL_VIEW');



	--TS PA 权限
----------------------
INSERT INTO Security_Group_Permission VALUES('PRM_TS_PA_MANAGE', 'TIME_SHEET_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TS_PA_MANAGE', 'TIME_SHEET_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_TS_PA_MANAGE', 'TIME_SHEET_ALL');

INSERT INTO Security_Group_Permission VALUES('PRM_TS_PA_MANAGE', 'TIME_SHEET_FORECAST_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TS_PA_MANAGE', 'TIME_SHEET_FORECAST_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_TS_PA_MANAGE', 'EXPENSE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_TS_PA_MANAGE', 'EXPENSE_SELF_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_TS_PA_MANAGE', 'TIME_SHEET_CAF');
--TS APPROVE 权限
----------------------

INSERT INTO Security_Group_Permission VALUES('PRM_TS_APPROVE_MANAGE', 'TIME_SHEET_APPROVAL');

	--RESOURCE ASSIGN 权限
----------------------
INSERT INTO Security_Group_Permission VALUES('PRM_RESOURCE_ASSIGN_MANAGE', 'CUST_PROJECT_MEMBER_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_RESOURCE_ASSIGN_MANAGE', 'CUST_PROJECT_MEMBER_CREATE');

	--ACCEPTANCE 权限
----------------------
INSERT INTO Security_Group_Permission VALUES('PRM_ACCEPTANCE_MANAGE', 'PROJECT_ACCP_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_ACCEPTANCE_MANAGE', 'PROJECT_ACCP_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_ACCEPTANCE_MANAGE', 'PROJECT_ACCP_ALL');

	--EXPENSE VERIFY PA 权限
----------------------
INSERT INTO Security_Group_Permission VALUES('PRM_EXP_PA_MANAGE', 'EXPENSE_VERIFY');

	-- EXPENSE CLAIM FA 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_EXP_FA_MANAGE', 'EXPENSE_CLAIM');
INSERT INTO Security_Group_Permission VALUES('PRM_EXP_FA_MANAGE', 'EXPENSE_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_EXP_FA_MANAGE', 'EXPENSE_TYPE_VIEW');



	-- OTHER COST PA 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_OC_PA_MANAGE', 'OTHER_COST_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_OC_PA_MANAGE', 'OTHER_COST_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_OC_PA_MANAGE', 'OTHER_COST_ALL');

	-- PROCUMENT/SUBCONTRACT PA 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_PS_PA_MANAGE', 'PROCU_SUB_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PS_PA_MANAGE', 'PROCU_SUB_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PS_PA_MANAGE', 'PROCU_SUB_ALL');
	
	-- PROJECT FA 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'CUST_INT_PROJECT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'CUST_INT_PROJECT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'CUST_CONT_PROJECT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'CUST_CONT_PROJECT_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'PROJECT_EVENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'PROJECT_EVENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'PROJECT_EVENT_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'PROJECT_EVENT_TYPE_VIEW');



INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'PROJECT_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'PROJECT_TYPE_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'PAS_PM_REPORT_ALL');

INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'PO_PROJECT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'PO_PROJECT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PROJ_FA_MANAGE', 'PO_PROJECT_ALL');


	-- MASTER FA 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'ADMIN_CURRENCY_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'ADMIN_CURRENCY_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'INDUSTRY_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'INDUSTRY_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'CUST_ACCOUNT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'CUST_ACCOUNT_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'PROJECT_CALENDAR_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'PROJECT_CALENDAR_VIEW');

INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'CONTRACT_PROFILE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'CONTRACT_PROFILE_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'CONTRACT_PROFILE_ALL');

INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'PO_PROFILE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'PO_PROFILE_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MSTR_FA_MANAGE', 'PO_PROFILE_ALL');


-------------------------------------------------------------

	-- MANAGER REPORT 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'PAS_PM_REPORT_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'FISCAL_CALENDAR_VIEW');
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
	-- 一般报表权限
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
	-- 特指报表权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT2_MANAGE', 'PAS_PM_REPORT_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT2_MANAGE', 'FISCAL_CALENDAR_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PM_RPT2_MANAGE', 'PAS_REVENUE_REPORT_VIEW');



---------------------------------
	-- PA报表权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_PA_RPT_MANAGE', 'PAS_PM_REPORT_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_RPT_MANAGE', 'FISCAL_CALENDAR_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_RPT_MANAGE', 'PAS_UTL_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_RPT_MANAGE', 'PAS_TS_DETAIL_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_RPT_MANAGE', 'PAS_CAF_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_RPT_MANAGE', 'PAS_EXP_ANALYSIS_REPORT_VIEW');

---------------------------------
	-- BILLING 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_BILLING_MANAGE', 'PROJECT_BILLING_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_BILLING_MANAGE', 'PROJECT_BILLING_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_BILLING_MANAGE', 'PROJECT_BILLING_ALL');

INSERT INTO Security_Group_Permission VALUES('PRM_BILLING_MANAGE', 'PROJECT_DOWNPAYMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_BILLING_MANAGE', 'PROJECT_DOWNPAYMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_BILLING_MANAGE', 'PROJECT_DOWNPAYMENT_ALL');


---------------------------------
	-- PAYMENT 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_PAYMENT_MANAGE', 'PROJECT_PAYMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PAYMENT_MANAGE', 'PROJECT_PAYMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PAYMENT_MANAGE', 'PROJECT_PAYMENT_ALL');
---------------------------------
	-- INVOICE 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_INVOICE_MANAGE', 'PROJ_INVOICE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_INVOICE_MANAGE', 'PROJ_INVOICE_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_INVOICE_MANAGE', 'PROJ_INVOICE_ALL');

INSERT INTO Security_Group_Permission VALUES('PRM_INVOICE_MANAGE', 'PROJ_LOST_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_INVOICE_MANAGE', 'PROJ_LOST_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_INVOICE_MANAGE', 'PROJ_LOST_ALL');




---------------------------------
	-- EMS 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_EMS_MANAGE', 'PROJ_EMS_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_EMS_MANAGE', 'PROJ_EMS_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_EMS_MANAGE', 'PROJ_EMS_ALL');

	-- EMS 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_RECEIPT_MANAGE', 'PROJ_RECEIPT_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_RECEIPT_MANAGE', 'PROJ_RECEIPT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_RECEIPT_MANAGE', 'PROJ_RECEIPT_ALL');

INSERT INTO Security_Group_Permission VALUES('PRM_RECEIPT_MANAGE', 'RECEIPT_MSTR_VIEW');

INSERT INTO Security_Group_Permission VALUES('RECEIPT_MSTR_MANAGE', 'RECEIPT_MSTR_VIEW');
INSERT INTO Security_Group_Permission VALUES('RECEIPT_MSTR_MANAGE', 'RECEIPT_MSTR_CREATE');

	-- PRESALE 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_PRESALE_MANAGE', 'PROJ_PRESALE_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PRESALE_MANAGE', 'PROJ_PRESALE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PRESALE_MANAGE', 'PROJ_PRESALE_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_PRESALE_MANAGE', 'DELIV_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_PRESALE_MANAGE', 'DELIV_TYPE_VIEW');

	-- VENDOR 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_VENDOR_MANAGE', 'PROJ_VENDOR_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_VENDOR_MANAGE', 'PROJ_VENDOR_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_VENDOR_MANAGE', 'PROJ_VENDOR_ALL');

	-- COST BY PROJECT RPT 权限
----------------------------------
INSERT INTO Security_Group VALUES('PROJ_COST_REPORT_VIEW','COST BY PROJECT RPT 查看权限');
INSERT INTO Security_Group VALUES('PROJ_COST_REPORT_ALL','COST BY PROJECT RPT 全部查看权限');
INSERT INTO Security_Group_Permission VALUES('PROJ_COST_REPORT_VIEW', 'PROJ_COST_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PROJ_COST_REPORT_ALL', 'PROJ_COST_REPORT_ALL');

	-- SALES FUNNEL 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRM_SALES_FUNNEL_MANAGE', 'SALES_FUNNEL_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_SALES_FUNNEL_MANAGE', 'SALES_FUNNEL_CREATE');
INSERT INTO Security_Group_Permission VALUES('PRM_SALES_FUNNEL_MANAGE', 'SALES_FUNNEL_ALL');



-- AR AGENT 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('AR_AGENT_MANAGE', 'PAS_AR_AGENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('AR_AGENT_MANAGE', 'PAS_AR_AGENT_ALL');

INSERT INTO Security_Group_Permission VALUES('AR_CS_MANAGE', 'PAS_AR_CS_VIEW');
INSERT INTO Security_Group_Permission VALUES('AR_CS_MANAGE', 'PAS_AR_CS_ALL');



INSERT INTO Security_Group_Permission VALUES('SALES_PERFORMANCE_RPT_VIEW_MANAGE', 'SALES_PERFORMANCE_VIEW');
INSERT INTO Security_Group_Permission VALUES('SALES_PERFORMANCE_RPT_ALL_MANAGE', 'SALES_PERFORMANCE_ALL');

---------------------------------
	-- PAYMENT INVOICE 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PAYMENT_INVOICE_MANAGE', 'PAYMENT_INVOICE_CREATE');
INSERT INTO Security_Group_Permission VALUES('PAYMENT_INVOICE_MANAGE', 'PAYMENT_INVOICE_VIEW');
INSERT INTO Security_Group_Permission VALUES('PAYMENT_INVOICE_MANAGE', 'PAYMENT_INVOICE_ALL');

---------------------------------
	-- SALES STEPS 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('SALES_STEPS_MANAGE', 'SALES_STEPS_CREATE');
INSERT INTO Security_Group_Permission VALUES('SALES_STEPS_MANAGE', 'SALES_STEPS_VIEW');
INSERT INTO Security_Group_Permission VALUES('SALES_STEPS_MANAGE', 'SALES_STEPS_ALL');

---------------------------------
	-- CUSTOMER CONTACT 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('CUSTOMER_CONTACT_MANAGE', 'CUST_CONTACT_CREATE');
INSERT INTO Security_Group_Permission VALUES('CUSTOMER_CONTACT_MANAGE', 'CUST_CONTACT_VIEW');

---------------------------------
	-- CAF SUMMARY RPT 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('CAF_SUMMARY_MANAGE', 'CAF_SUMMARY_ALL');
INSERT INTO Security_Group_Permission VALUES('CAF_SUMMARY_MANAGE', 'CAF_SUMMARY_VIEW');

---------------------------------
	-- PAS PERMISSION LIST
---------------------------------
INSERT INTO Security_Group VALUES('PAS_PERMISSION_MANAGE','PAS PERMISSION 查看权限');
INSERT INTO Security_Permission VALUES('PAS_PERMISSION_VIEW','PAS PERMISSION 查看权限');
INSERT INTO Security_Permission VALUES('PERMISSION_QUERY_VIEW','PERMISSION QUERY查看权限');
INSERT INTO Security_Permission VALUES('PERMISSION_QUERY_ALL','PERMISSION ALL查看权限');
INSERT INTO Security_Group_Permission VALUES('PAS_PERMISSION_MANAGE', 'PAS_PERMISSION_VIEW');
INSERT INTO Security_Group_Permission VALUES('PAS_PERMISSION_MANAGE', 'PERMISSION_QUERY_VIEW');
INSERT INTO Security_Group_Permission VALUES('PAS_PERMISSION_MANAGE', 'PERMISSION_QUERY_ALL');


---------------------------------
	-- PRESALE UPDATE RPT 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('PRESALE_UPDATE_RPT_VIEW_MANAGE', 'PRESALE_UPDATE_RPT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRESALE_UPDATE_RPT_ALL_MANAGE', 'PRESALE_UPDATE_RPT_ALL');

---------------------------------
	-- PRESALE UPDATE RPT 权限
---------------------------------
INSERT INTO Security_Group_Permission VALUES('EXPENSE_SUMMARY_RPT_VIEW_MANAGE', 'PAS_EXPSUMMARY_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('EXPENSE_SUMMARY_RPT_ALL_MANAGE', 'PAS_EXPSUMMARY_REPORT_ALL');


---------------------------------
--SUPPLIER INVOICE MASTER 权限
---------------------------------
INSERT INTO Security_Permission VALUES('SUPPLIER_INVOICE_MSTR_CREATE','供应商发票主信息创建权限');
INSERT INTO Security_Permission VALUES('SUPPLIER_INVOICE_MSTR_VIEW','供应商发票主信息查看权限');
INSERT INTO Security_Group VALUES('SUPPLIER_INVOICE_MSTR_MANAGE','SUPPLIER INVOICE MASTER 维护权限');
INSERT INTO Security_Group_Permission VALUES('PAYMENT_INVOICE_MANAGE', 'SUPPLIER_INVOICE_MSTR_VIEW');
INSERT INTO Security_Group_Permission VALUES('SUPPLIER_INVOICE_MSTR_MANAGE', 'SUPPLIER_INVOICE_MSTR_VIEW');
INSERT INTO Security_Group_Permission VALUES('SUPPLIER_INVOICE_MSTR_MANAGE', 'SUPPLIER_INVOICE_MSTR_CREATE');


-- outstanding acceptance 
------------------------------
INSERT INTO Security_Group VALUES('OUTSTANDING_ACCEPTANCE_RPT_VIEW_MANAGE','OUTSTANDING ACCEPTANCE 报表查看权限');
INSERT INTO Security_Group VALUES('OUTSTANDING_ACCEPTANCE_RPT_ALL_MANAGE','OUTSTANDING ACCEPTANCE 报表全部查看权限');

INSERT INTO Security_Permission VALUES('OUTSTANDING_ACCEPTANCE_RPT_ALL','  OUTSTANDING ACCEPTANCE RPT 部门查看权限');
INSERT INTO Security_Permission VALUES('OUTSTANDING_ACCEPTANCE_RPT_VIEW','  OUTSTANDING ACCEPTANCE RPT 查看权限');

INSERT INTO Security_Group_Permission VALUES('OUTSTANDING_ACCEPTANCE_RPT_VIEW_MANAGE', 'OUTSTANDING_ACCEPTANCE_RPT_VIEW');
INSERT INTO Security_Group_Permission VALUES('OUTSTANDING_ACCEPTANCE_RPT_ALL_MANAGE', 'OUTSTANDING_ACCEPTANCE_RPT_ALL');

-- outstanding TS report
-----------------------------
INSERT INTO Security_Permission VALUES('OUTSTANDING_TS_RPT_ALL','  OUTSTANDING TS RPT 部门查看权限');
INSERT INTO Security_Permission VALUES('OUTSTANDING_TS_RPT_VIEW','  OUTSTANDING TS RPT 查看权限');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'OUTSTANDING_TS_RPT_VIEW');
INSERT INTO Security_Group VALUES('OUTSTANDING_TS_RPT_ALL_MANAGE','OUTSTANDING TS 报表全部查看权限');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'OUTSTANDING_TS_RPT_ALL');

-- invoice tracking report
-----------------------------
INSERT INTO Security_Permission VALUES('INVOICE_TRACKING_RPT_ALL','  INVOICE TRACKING RPT 部门查看权限');
INSERT INTO Security_Permission VALUES('INVOICE_TRACKING_RPT_VIEW','  INVOICE TRACKING RPT 查看权限');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'INVOICE_TRACKING_RPT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'INVOICE_TRACKING_RPT_ALL');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_RPT_MANAGE', 'INVOICE_TRACKING_RPT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_RPT_MANAGE', 'INVOICE_TRACKING_RPT_ALL');


--weekly report for PA ( project  by pm report)

INSERT INTO Security_Permission VALUES('PM_PROJECT_REPORT_VIEW','PROJECT BY PM RPT 查看权限');
INSERT INTO Security_Group_Permission VALUES('PRM_PA_RPT_MANAGE', 'PM_PROJECT_REPORT_VIEW');
INSERT INTO Security_Group_Permission VALUES('PRM_MGE_RPT_MANAGE', 'PM_PROJECT_REPORT_VIEW');

