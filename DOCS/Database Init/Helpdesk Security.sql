-------------------------------------------------------------
--ϵͳ��������
-------------------------------------------------------------
INSERT INTO Party_Type VALUES('PARTY_GROUP','PARTY');
INSERT INTO Role_Type VALUES('ORGANIZATION','COMPANY');
INSERT INTO Role_Type VALUES('ORGANIZATION_UNIT','DEPARTMENT');
INSERT INTO Role_Type VALUES('CUSTOMER','CUSTOMER');

INSERT INTO Party_Relationship_Type VALUES('CUSTOMER_REL','�ͻ���ϵ');
INSERT INTO Party_Relationship_Type VALUES('PARTNERSHIP','��������ϵ');
INSERT INTO Party_Relationship_Type VALUES('EMPLOYMENT','��Ӷ��ϵ');
INSERT INTO Party_Relationship_Type VALUES('MANAGER','�����ϵ');
INSERT INTO Party_Relationship_Type VALUES('CONTACT_REL','��ϵ��ϵ');
INSERT INTO Party_Relationship_Type VALUES('GROUP_ROLLUP','Service Line�¼�����');
INSERT INTO Party_Relationship_Type VALUES('LOCATION_ROLLUP','Regional �¼�����');

-------------------------------------------------------------
--ϵͳģ������
-------------------------------------------------------------
INSERT INTO Module VALUES('1','root','','NULL','Y',1,'', '1');
INSERT INTO Module VALUES('1.2','Admin','','NULL','Y',2,'System Administration Menu', '1');
INSERT INTO Module VALUES('1.2.2','User','','NULL','Y',2,'User Setup', '1.2');
INSERT INTO Module VALUES('1.2.2.1','User','','listUserLogin','Y',1,'User Security', '1.2.2');
INSERT INTO Module VALUES('1.2.2.3','Department','','listParty','Y',3,'Department Setup', '1.2.2');
INSERT INTO Module VALUES('1.2.3','Project Setting','','NULL','Y',2,'Project related parameter setup', '1.2');
insert into module values('1.2.3.1','Customer Industry', '', 'listIndustry', 'Y', 1, 'Customer Industry', '1.2.3');
INSERT INTO Module VALUES('1.2.3.2','Fiscal Calendar','','editFisCalendar','Y',2,'Fiscal Calendar', '1.2.3');
INSERT INTO Module VALUES('1.2.3.3','Expense Type','','listExpenseType','Y',3,'Expense Type', '1.2.3');
INSERT INTO Module VALUES('1.2.3.4','PreSale Deliverable Type','','ListDeliveryType','Y',4,Presale Deliverable Type maintenance', '1.2.3');
INSERT INTO Module VALUES('1.2.3.6','Project Event','','listCustProjectEvent','Y',5,'Project Event', '1.2.3');
INSERT INTO Module VALUES('1.2.3.7','Project Event Category','','listCustProjectType','Y',6,'Project Event Category', '1.2.3');
INSERT INTO Module VALUES('1.2.3.8','Cost Rate','','editConsultantCost','Y',8,'Consultant Cost Rate information', '1.2.3');
INSERT INTO Module VALUES('1.2.4','Working Calendar Type','','listProjCalendarType','Y',4,'Working Calendar Type definition', '1.2');
INSERT INTO Module VALUES('1.2.5','Working Calendar','','editProjCalendar','Y',5,'Working Calendar information', '1.2');
INSERT INTO Module VALUES('1.2.6','Sales Funnel Setting','','FindStepGroups','Y',6,'Sales Funnel Activities, Steps & step Groups', '1.2');
INSERT INTO Module VALUES('1.2.7','Online User Monitor','','onlineUserMonitor','Y',7,'Online User Monitor', '1.2');
INSERT INTO Module VALUES('1.2.8','PAS Permisions List','','ListSecurityPermission','Y',8,'PAS Permisions List', '1.2');
INSERT INTO Module VALUES('1.2.9','PAS Permisions Query','','FindSecurityPermission','Y',9,'PAS Permisions Query', '1.2');


-------------------------------------------------------------
--HelpDesk����Աģ������
-------------------------------------------------------------
INSERT INTO Module VALUES('2.1','Helpdesk','','NULL','Y',3,'Helpdesk�ճ�ҵ��', '1');
INSERT INTO Module VALUES('2.1.1','Call','','NULL','Y',1,'', '2.1');
INSERT INTO Module VALUES('2.1.1.1','New Call','','helpdesk.newCall','Y',1,'', '2.1.1');
INSERT INTO Module VALUES('2.1.1.2','New Change Request','','helpdesk.newCall','Y',1,'', '2.1.1');
INSERT INTO Module VALUES('2.1.1.3','New Complain','','helpdesk.newCall','Y',1,'', '2.1.1');
INSERT INTO Module VALUES('2.1.1.4','Query','','helpdesk.queryCall','Y',2,'', '2.1.1');
INSERT INTO Module VALUES('2.1.2','SLA Definition','','NULL','Y',2,'', '2.1');
INSERT INTO Module VALUES('2.1.2.1','List SLA','','helpdesk.listSLAMaster','Y',1,'', '2.1.2');
INSERT INTO Module VALUES('2.1.2.2','Create SLA','','helpdesk.newSLAMaster','Y',1,'', '2.1.2');
INSERT INTO Module VALUES('2.1.3','KB','','NULL','Y',3,'', '2.1');
INSERT INTO Module VALUES('2.1.3.1','List KB','','helpdesk.listKnowledgeBase','Y',1,'', '2.1.3');
INSERT INTO Module VALUES('2.1.3.2','Create KB','','helpdesk.newKnowledgeBase','Y',2,'', '2.1.3');
INSERT INTO Module VALUES('2.1.4','Other Data','','NULL','Y',4,'', '2.1');
INSERT INTO Module VALUES('2.1.4.1','List Configuration Type','','helpdesk.listTableType','Y',1,'', '2.1.4');
INSERT INTO Module VALUES('2.1.4.2','List Status Type','','helpdesk.listStatusType','Y',2,'', '2.1.4');
INSERT INTO Module VALUES('2.1.4.3','List Action Type','','helpdesk.listActionType','Y',3,'', '2.1.4');
INSERT INTO Module VALUES('2.1.4.4','List Party Responsibility User','','helpdesk.listPartyResponsibilityUser','Y',4,'', '2.1.4');
INSERT INTO Module VALUES('2.1.4.5','List Request Type','','helpdesk.listRequestType','Y',5,'', '2.1.4');
INSERT INTO Module VALUES('2.1.4.6','Cust. Configuration','','helpdesk.listCustomer','Y',6,'', '2.1.4');

-------------------------------------------------------------
--HelpDesk����Աģ������
-------------------------------------------------------------
INSERT INTO Module VALUES('2.2','Helpdesk','','NULL','Y',3,'Helpdesk�ճ�ҵ��', '1');
INSERT INTO Module VALUES('2.2.1','Call','','NULL','Y',1,'', '2.2');
INSERT INTO Module VALUES('2.2.1.1','New Call','','helpdesk.newCall','Y',1,'', '2.2.1');
INSERT INTO Module VALUES('2.2.1.2','New Change Request','','helpdesk.newCall','Y',1,'', '2.2.1');
INSERT INTO Module VALUES('2.2.1.3','New Complain','','helpdesk.newCall','Y',1,'', '2.2.1');
INSERT INTO Module VALUES('2.2.1.4','Query','','helpdesk.queryCall','Y',2,'', '2.2.1');
INSERT INTO Module VALUES('2.2.3','KB','','NULL','Y',3,'', '2.2');
INSERT INTO Module VALUES('2.2.3.1','List KB','','helpdesk.listKnowledgeBase','Y',1,'', '2.2.3');
INSERT INTO Module VALUES('2.2.3.2','Create KB','','helpdesk.newKnowledgeBase','Y',2,'', '2.2.3');
INSERT INTO Module VALUES('2.2.4','Other Data','','NULL','Y',4,'', '2.2');
INSERT INTO Module VALUES('2.2.4.6','Cust. Configuration','','helpdesk.listCustomer','Y',6,'', '2.2.4');


-------------------------------------------------------------
--ģ��������
-------------------------------------------------------------
INSERT INTO Module_Group VALUES('FULLADMIN_GROUP','ϵͳ����ģ��',100);
INSERT INTO Module_Group VALUES('HELPDESK_ADM_GROUP','HelpDesk����Աģ��',200);
INSERT INTO Module_Group VALUES('HELPDESK_OP_GROUP','HelpDesk����Աģ��',300);

INSERT INTO Module_Group_Associate VALUES('FULLADMIN_GROUP','1.2');
INSERT INTO Module_Group_Associate VALUES('HELPDESK_ADM_GROUP','2.1');
INSERT INTO Module_Group_Associate VALUES('HELPDESK_OP_GROUP','2.2');

-------------------------------------------------------------
--Ȩ����
-------------------------------------------------------------
INSERT INTO Security_Group VALUES('SYSTEM_MANAGE','ϵͳȨ��');
INSERT INTO Security_Group VALUES('HELPDESK_TYPE_MANAGE','HELPDESK�й�����������ά��Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_CALL_CHANGE_CLOSED','�ѹر�Call���޸�Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_CALL_MANAGE','Callά��Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_SERVICELEVEL_MANAGE','����Э��ά��Ȩ��');

-------------------------------------------------------------
--Ȩ��
-------------------------------------------------------------
---------------------------------
-- ȱʡȨ�ޣ�ÿ����½�û�������߱�)
---------------------------------
INSERT INTO Security_Permission VALUES('SYSTEM_ROLE_PAGE','ϵͳ��ɫ��ҳ�鿴Ȩ��');

---------------------------------
--ϵͳ������(ֻ��ϵͳ����Ա����ʹ���ⲿ�ֹ���)
---------------------------------
INSERT INTO Security_Permission VALUES('SECURITY_PERMISSION_CREATE','Ȩ���б���Ȩ��');
INSERT INTO Security_Permission VALUES('SECURITY_PERMISSION_VIEW','Ȩ���б�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('USER_LOGIN_CREATE','��½�û�����Ȩ��');
INSERT INTO Security_Permission VALUES('USER_LOGIN_VIEW','��½�û��鿴Ȩ��');

---------------------------------
-- HelpDeskȨ��
---------------------------------
INSERT INTO Security_Permission VALUES('HELPDESK_ACTIONTRACK_TYPE_CREATE','Call ActionTrack���ʹ���Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_ACTIONTRACK_TYPE_DELETE','Call ActionTrack����ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_ACTIONTRACK_TYPE_MODIFY','Call ActionTrack�����޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_ACTIONTRACK_TYPE_VIEW','Call ActionTrack���Ͳ鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_ATTACHMENT_CREATE','��������Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_ATTACHMENT_DELETE','����ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_ATTACHMENT_MODIFY','�����޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_ATTACHMENT_VIEW','�����鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_CREATE','Call ActionTrack����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_DELETE','Call ActionTrackɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_MODIFY','Call ActionTrack�޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_VIEW','Call ActionTrack�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_CHANGE_CLOSED','�ѹر�Call���޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_CREATE','Call����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_DELETE','Callɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_MODIFY','Call�޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_VIEW','Call�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_CREATE','Change Request ActionTrack����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_DELETE','Change Request ActionTrackɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_MODIFY','Change Request ActionTrack�޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_VIEW','Change Request ActionTrack�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_CHANGE_CLOSED','�ѹر�Change Request���޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_CREATE','Change Request����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_DELETE','Change Requestɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_MODIFY','Change Request�޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_VIEW','Change Request�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_CREATE','Complain ActionTrack����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_DELETE','Complain ActionTrackɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_MODIFY','Complain ActionTrack�޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_VIEW','Complain ActionTrack�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_CHANGE_CLOSED','�ѹر�Complain���޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_CREATE','Complain����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_DELETE','Complainɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_MODIFY','Complain�޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_VIEW','Complain�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_ROW_CREATE','�û�������Ϣ�д���Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_ROW_DELETE','�û�������Ϣ��ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_ROW_MODIFY','�û�������Ϣ���޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_ROW_VIEW','�û�������Ϣ�в鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_CREATE','�û�������Ϣ����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_DELETE','�û�������Ϣ��ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_MODIFY','�û�������Ϣ���޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_CREATE','�û�������Ϣ�����ʹ���Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_DELETE','�û�������Ϣ������ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_MODIFY','�û�������Ϣ�������޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_VIEW','�û�������Ϣ�����Ͳ鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_VIEW','�û�������Ϣ��鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_USER_LOAD','HelpDesk�пͻ��û�����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_KB_CREATE','֪ʶ�ⴴ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_KB_DELETE','֪ʶ��ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_KB_MODIFY','֪ʶ���޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_KB_VIEW','֪ʶ��鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_PARTY_RESPONSIBILITY_USER_CREATE','���Ÿ����˴���Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_PARTY_RESPONSIBILITY_USER_DELETE','���Ÿ�����ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_PARTY_RESPONSIBILITY_USER_MODIFY','���Ÿ������޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_PARTY_RESPONSIBILITY_USER_VIEW','���Ÿ����˲鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_PARTY_USER_VIEW','HelpDesk�л���/�û��鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_REQUEST_TYPE_CREATE','Call�������ʹ���Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_REQUEST_TYPE_DELETE','Call��������ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_REQUEST_TYPE_MODIFY','Call���������޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_REQUEST_TYPE_VIEW','Call�������Ͳ鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_CATEGORY_CREATE','����Э����ഴ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_CATEGORY_DELETE','����Э�����ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_CATEGORY_MODIFY','����Э������޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_CATEGORY_VIEW','����Э�����鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_MASTER_CREATE','����Э�������ݴ���Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_MASTER_DELETE','����Э��������ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_MASTER_MODIFY','����Э���������޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_MASTER_VIEW','����Э�������ݲ鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_PRIORITY_CREATE','����Э�����ȼ�����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_PRIORITY_DELETE','����Э�����ȼ�ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_PRIORITY_MODIFY','����Э�����ȼ��޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_PRIORITY_VIEW','����Э�����ȼ��鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_STATUS_TYPE_CREATE','Call״̬���ʹ���');
INSERT INTO Security_Permission VALUES('HELPDESK_STATUS_TYPE_DELETE','Call״̬����ɾ��');
INSERT INTO Security_Permission VALUES('HELPDESK_STATUS_TYPE_MODIFY','Call״̬�����޸�');
INSERT INTO Security_Permission VALUES('HELPDESK_STATUS_TYPE_VIEW','Call״̬���Ͳ鿴');


-------------------------------------------------------------
--Ȩ�����Ȩ�޶���
-------------------------------------------------------------
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'SECURITY_PERMISSION_CREATE');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'SECURITY_PERMISSION_VIEW');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'USER_LOGIN_CREATE');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'USER_LOGIN_VIEW');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'PAS_PM_REPORT_ALL');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_ACTIONTRACK_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_ACTIONTRACK_TYPE_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_ACTIONTRACK_TYPE_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_ACTIONTRACK_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_CUSTOMER_USER_LOAD');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CALL_ACTIONTRACK_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CALL_ACTIONTRACK_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CALL_ACTIONTRACK_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ACTIONTRACK_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CALL_ACTIONTRACK_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_STATUS_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_CHANGE_CLOSED', 'HELPDESK_CALL_CHANGE_CLOSED');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CALL_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CALL_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CALL_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CALL_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_SERVICELEVEL_CATEGORY_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_SERVICELEVEL_PRIORITY_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_ROW_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_PARTY_USER_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_REQUEST_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CHANGEREQUEST_ACTIONTRACK_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CHANGEREQUEST_ACTIONTRACK_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CHANGEREQUEST_ACTIONTRACK_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ACTIONTRACK_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CHANGEREQUEST_ACTIONTRACK_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_STATUS_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_CHANGE_CLOSED', 'HELPDESK_CALL_CHANGE_CLOSED');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CHANGEREQUEST_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CHANGEREQUEST_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CHANGEREQUEST_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CHANGEREQUEST_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_ROW_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_PARTY_USER_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_COMPLAIN_ACTIONTRACK_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_COMPLAIN_ACTIONTRACK_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_COMPLAIN_ACTIONTRACK_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ACTIONTRACK_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_COMPLAIN_ACTIONTRACK_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_STATUS_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_CHANGE_CLOSED', 'HELPDESK_CALL_CHANGE_CLOSED');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_COMPLAIN_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_COMPLAIN_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_COMPLAIN_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_COMPLAIN_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_ROW_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_PARTY_USER_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_ROW_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_ROW_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_ROW_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_ROW_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_KB_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_KB_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_KB_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_KB_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_KB_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_PARTY_RESPONSIBILITY_USER_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_PARTY_RESPONSIBILITY_USER_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_PARTY_RESPONSIBILITY_USER_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_PARTY_RESPONSIBILITY_USER_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_REQUEST_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_REQUEST_TYPE_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_REQUEST_TYPE_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_REQUEST_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_SERVICELEVEL_MANAGE', 'HELPDESK_PARTY_USER_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_SERVICELEVEL_MANAGE', 'HELPDESK_SERVICELEVEL_CATEGORY_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_SERVICELEVEL_MANAGE', 'HELPDESK_SERVICELEVEL_CATEGORY_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_SERVICELEVEL_MANAGE', 'HELPDESK_SERVICELEVEL_CATEGORY_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_SERVICELEVEL_MANAGE', 'HELPDESK_SERVICELEVEL_CATEGORY_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_SERVICELEVEL_MANAGE', 'HELPDESK_SERVICELEVEL_MASTER_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_SERVICELEVEL_MANAGE', 'HELPDESK_SERVICELEVEL_MASTER_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_SERVICELEVEL_MANAGE', 'HELPDESK_SERVICELEVEL_MASTER_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_SERVICELEVEL_MANAGE', 'HELPDESK_SERVICELEVEL_MASTER_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_SERVICELEVEL_MANAGE', 'HELPDESK_SERVICELEVEL_PRIORITY_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_SERVICELEVEL_MANAGE', 'HELPDESK_SERVICELEVEL_PRIORITY_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_SERVICELEVEL_MANAGE', 'HELPDESK_SERVICELEVEL_PRIORITY_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_SERVICELEVEL_MANAGE', 'HELPDESK_SERVICELEVEL_PRIORITY_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_STATUS_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_STATUS_TYPE_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_STATUS_TYPE_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_TYPE_MANAGE', 'HELPDESK_STATUS_TYPE_VIEW');

-------------------------------------------------------------
--- 		ϵͳ����Ա�˺�
-------------------------------------------------------------
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('001', 'PARTY_GROUP', 'Atos Origin China');
INSERT INTO Party_Role VALUES('001', 'ORGANIZATION_UNIT');
INSERT INTO User_Login(Role, Enable, Current_Password, Name, User_Login_Id, Party_Id) VALUES('FULLADMIN', 'Y', 'admin', 'ϵͳ����Ա', 'admin', '001');
INSERT INTO User_Login_Security_Group VALUES('admin', 'SYSTEM_MANAGE');
INSERT INTO User_Login_Module_Group VALUES('admin', 'FULLADMIN_GROUP');

-------------------------------------------------------------
--- 		Old Department List
-------------------------------------------------------------
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('AOSH', 'PARTY_GROUP', 'Atos Origin SH');
INSERT INTO Party_Role VALUES('AOSH', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('AOBJ', 'PARTY_GROUP', 'Atos Origin BJ');
INSERT INTO Party_Role VALUES('AOBJ', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('AOSHBS', 'PARTY_GROUP', 'BS SH');
INSERT INTO Party_Role VALUES('AOSHBS', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('AOSHCSIAS', 'PARTY_GROUP', 'AS SH');
INSERT INTO Party_Role VALUES('AOSHCSIAS', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('AOSHCSIQAD', 'PARTY_GROUP', 'QAD SH');
INSERT INTO Party_Role VALUES('AOSHCSIQAD', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('AOSHCSISAP', 'PARTY_GROUP', 'SAP SH');
INSERT INTO Party_Role VALUES('AOSHCSISAP', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('AOSHFA', 'PARTY_GROUP', 'F&A SH');
INSERT INTO Party_Role VALUES('AOSHFA', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('AOSHHRM', 'PARTY_GROUP', 'HRM SH');
INSERT INTO Party_Role VALUES('AOSHHRM', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('AOSHMS', 'PARTY_GROUP', 'MS SH');
INSERT INTO Party_Role VALUES('AOSHMS', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('AOSHSAM', 'PARTY_GROUP', 'S&AM SH');
INSERT INTO Party_Role VALUES('AOSHSAM', 'ORGANIZATION_UNIT');

-------------------------------------------------------------
--- 		New Department List
-------------------------------------------------------------
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('002', 'PARTY_GROUP', 'Atos Origin SH');
INSERT INTO Party_Role VALUES('002', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('003', 'PARTY_GROUP', 'Atos Origin BJ');
INSERT INTO Party_Role VALUES('003', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('004', 'PARTY_GROUP', 'BS SH');
INSERT INTO Party_Role VALUES('004', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('005', 'PARTY_GROUP', 'AS SH');
INSERT INTO Party_Role VALUES('005', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('006', 'PARTY_GROUP', 'QAD SH');
INSERT INTO Party_Role VALUES('006', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('007', 'PARTY_GROUP', 'SAP SH');
INSERT INTO Party_Role VALUES('007', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('008', 'PARTY_GROUP', 'F&A SH');
INSERT INTO Party_Role VALUES('008', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('009', 'PARTY_GROUP', 'HRM SH');
INSERT INTO Party_Role VALUES('009', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('010', 'PARTY_GROUP', 'MS SH');
INSERT INTO Party_Role VALUES('010', 'ORGANIZATION_UNIT');
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('011', 'PARTY_GROUP', 'S&AM SH');
INSERT INTO Party_Role VALUES('011', 'ORGANIZATION_UNIT');

insert into party select * from LiveDB.dbo.party where party_id = 'EAOSH'
INSERT INTO Party_Role VALUES('EAOSH', 'CUSTOMER');
--------------------------------
-- User Load
--------------------------------

insert into user_login (user_login_id, name, locale, current_password, tele_code, email_addr, role, party_id)
	select user_login_id, name, locale, current_password, tele_code, email_addr, role, '002' from devdb.dbo.user_login
	where party_id = 'AOSH'
insert into user_login (user_login_id, name, locale, current_password, tele_code, email_addr, role, party_id)
	select user_login_id, name, locale, current_password, tele_code, email_addr, role, '003' from devdb.dbo.user_login
	where party_id = 'AOBJ'
insert into user_login (user_login_id, name, locale, current_password, tele_code, email_addr, role, party_id)
	select user_login_id, name, locale, current_password, tele_code, email_addr, role, '004' from devdb.dbo.user_login
	where party_id = 'AOSHBS'
insert into user_login (user_login_id, name, locale, current_password, tele_code, email_addr, role, party_id)
	select user_login_id, name, locale, current_password, tele_code, email_addr, role, '005' from devdb.dbo.user_login
	where party_id = 'AOSHCSIAS'
insert into user_login (user_login_id, name, locale, current_password, tele_code, email_addr, role, party_id)
	select user_login_id, name, locale, current_password, tele_code, email_addr, role, '006' from devdb.dbo.user_login
	where party_id = 'AOSHCSIQAD'
insert into user_login (user_login_id, name, locale, current_password, tele_code, email_addr, role, party_id)
	select user_login_id, name, locale, current_password, tele_code, email_addr, role, '007' from devdb.dbo.user_login
	where party_id = 'AOSHCSISAP'
insert into user_login (user_login_id, name, locale, current_password, tele_code, email_addr, role, party_id)
	select user_login_id, name, locale, current_password, tele_code, email_addr, role, '008' from devdb.dbo.user_login
	where party_id = 'AOSHFA'
insert into user_login (user_login_id, name, locale, current_password, tele_code, email_addr, role, party_id)
	select user_login_id, name, locale, current_password, tele_code, email_addr, role, '009' from devdb.dbo.user_login
	where party_id = 'AOSHHRM'
insert into user_login (user_login_id, name, locale, current_password, tele_code, email_addr, role, party_id)
	select user_login_id, name, locale, current_password, tele_code, email_addr, role, '010' from devdb.dbo.user_login
	where party_id = 'AOSHMS'
insert into user_login (user_login_id, name, locale, current_password, tele_code, email_addr, role, party_id)
	select user_login_id, name, locale, current_password, tele_code, email_addr, role, '011' from devdb.dbo.user_login
	where party_id = 'AOSHSAM'

insert into User_Login_Security_Group (user_login_id, group_id) select user_login_id, group_id from livedb.dbo.User_Login_Security_Group
insert into User_Login_Module_Group (user_login_id, module_group_id) select user_login_id, module_group_id from livedb.dbo.User_Login_Module_Group

insert into ExpenseType (Exp_Code,Exp_Desc,Exp_Parent_Code,Enable,Seq) select Exp_Code,Exp_Desc,Exp_Parent_Code,Enable,Seq from devdb.dbo.ExpenseType
insert into fmonth (f_yr, f_fmseq, f_fmdesc, f_fmdate_from, f_fmdate_to,f_fmdate_freeze) select f_yr, f_fmseq, f_fmdesc, f_fmdate_from, f_fmdate_to,f_fmdate_freeze from devdb.dbo.fmonth
insert into cons_cost (userid, yr, cost) select userid, yr, cost from devdb.dbo.cons_cost

update user_login set party_id = '001' where party_id = 'AO'
update user_login set party_id = '002' where party_id = 'AOSH'
update user_login set party_id = '003' where party_id = 'AOBJ'
update user_login set party_id = '004' where party_id = 'AOSHBS'
update user_login set party_id = '005' where party_id = 'AOSHCSIAS'
update user_login set party_id = '006' where party_id = 'AOSHCSIQAD'
update user_login set party_id = '007' where party_id = 'AOSHCSISAP'
update user_login set party_id = '008' where party_id = 'AOSHFA'
update user_login set party_id = '009' where party_id = 'AOSHHRM'
update user_login set party_id = '010' where party_id = 'AOSHMS'
update user_login set party_id = '011' where party_id = 'AOSHSAM'

update Party_Responsibility_User set party_id = '001' where party_id = 'AO'
update Party_Responsibility_User set party_id = '002' where party_id = 'AOSH'
update Party_Responsibility_User set party_id = '003' where party_id = 'AOBJ'
update Party_Responsibility_User set party_id = '004' where party_id = 'AOSHBS'
update Party_Responsibility_User set party_id = '005' where party_id = 'AOSHCSIAS'
update Party_Responsibility_User set party_id = '006' where party_id = 'AOSHCSIQAD'
update Party_Responsibility_User set party_id = '007' where party_id = 'AOSHCSISAP'
update Party_Responsibility_User set party_id = '008' where party_id = 'AOSHFA'
update Party_Responsibility_User set party_id = '009' where party_id = 'AOSHHRM'
update Party_Responsibility_User set party_id = '010' where party_id = 'AOSHMS'
update Party_Responsibility_User set party_id = '011' where party_id = 'AOSHSAM'

update call_master set cm_assigned_party = '001' where cm_assigned_party = 'AO'
update call_master set cm_assigned_party = '002' where cm_assigned_party = 'AOSH'
update call_master set cm_assigned_party = '003' where cm_assigned_party = 'AOBJ'
update call_master set cm_assigned_party = '004' where cm_assigned_party = 'AOSHBS'
update call_master set cm_assigned_party = '005' where cm_assigned_party = 'AOSHCSIAS'
update call_master set cm_assigned_party = '006' where cm_assigned_party = 'AOSHCSIQAD'
update call_master set cm_assigned_party = '007' where cm_assigned_party = 'AOSHCSISAP'
update call_master set cm_assigned_party = '008' where cm_assigned_party = 'AOSHFA'
update call_master set cm_assigned_party = '009' where cm_assigned_party = 'AOSHHRM'
update call_master set cm_assigned_party = '010' where cm_assigned_party = 'AOSHMS'
update call_master set cm_assigned_party = '011' where cm_assigned_party = 'AOSHSAM'

insert into user_login (user_login_id, name, locale, current_password, tele_code, email_addr, role, party_id)
	select 'EAO'+user_login_id, name, locale, current_password, tele_code, email_addr, 'CUSTOMER', 'EAOBJ' from user_login
	where party_id = '003'

insert into custprofile (party_id, cust_industry, cust_account, ch_name)
	select party_id, 9,43, chs_name
	from party where party_id like 'C%'
