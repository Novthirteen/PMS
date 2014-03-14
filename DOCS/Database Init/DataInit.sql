-------------------------------------------------------------
--					ϵͳ��������
-------------------------------------------------------------
INSERT INTO Party_Type VALUES('PARTY_GROUP','��֯����');
INSERT INTO Role_Type VALUES('ORGANIZATION','�ܹ�˾');
INSERT INTO Role_Type VALUES('ORGANIZATION_UNIT','���Ż���');
INSERT INTO Role_Type VALUES('CUSTOMER','�ͻ�');

INSERT INTO Party_Relationship_Type VALUES('CUSTOMER_REL','�ͻ���ϵ');
INSERT INTO Party_Relationship_Type VALUES('PARTNERSHIP','��������ϵ');
INSERT INTO Party_Relationship_Type VALUES('EMPLOYMENT','��Ӷ��ϵ');
INSERT INTO Party_Relationship_Type VALUES('MANAGER','�����ϵ');
INSERT INTO Party_Relationship_Type VALUES('CONTACT_REL','��ϵ��ϵ');
INSERT INTO Party_Relationship_Type VALUES('GROUP_ROLLUP','�¼�����');

-------------------------------------------------------------
--					ϵͳģ������
-------------------------------------------------------------
INSERT INTO Module VALUES('1',				'root',						'',	'NULL',							'Y',	1,	'', '1');
INSERT INTO Module VALUES('1.2',	'Admin',					'',	'NULL',							'Y',	2,	'ϵͳ����-һ���˵�', '1');
INSERT INTO Module VALUES('1.2.2',	'User',						'',	'NULL',							'Y',	2,	'', '1.2');
INSERT INTO Module VALUES('1.2.2.1','List User',				'',	'listUserLogin',				'Y',	1,	'', '1.2.2');
INSERT INTO Module VALUES('1.2.2.2','Create User',				'',	'editUserLogin',				'Y',	2,	'', '1.2.2');
INSERT INTO Module VALUES('1.2.2.3','List Party',				'',	'listParty',					'Y',	3,	'', '1.2.2');
INSERT INTO Module VALUES('1.2.2.4','Create Party',				'',	'editParty',					'Y',	4,	'', '1.2.2');
INSERT INTO Module VALUES('1.2.3',	'Customer',					'',	'NULL',							'Y',	2,	'', '1.2');
INSERT INTO Module VALUES('1.2.3.1','List Customer User',		'',	'listCustUserLogin',			'Y',	1,	'', '1.2.3');
INSERT INTO Module VALUES('1.2.3.2','Create Customer User',		'',	'editCustUserLogin',			'Y',	2,	'', '1.2.3');
INSERT INTO Module VALUES('1.2.3.3','List Customer',			'',	'listCustParty',				'Y',	3,	'', '1.2.3');
INSERT INTO Module VALUES('1.2.3.4','Create Customer',			'',	'editCustParty',				'Y',	4,	'', '1.2.3');
INSERT INTO Module VALUES('1.2.4',	'Project',					'',	'NULL',							'Y',	3,	'', '1.2');
INSERT INTO Module VALUES('1.2.4.1','Project',					'',	'listCustProject',				'Y',	1,	'', '1.2.4');
INSERT INTO Module VALUES('1.2.4.2','Event',					'',	'listCustProjectEvent',			'Y',	2,	'', '1.2.4');
INSERT INTO Module VALUES('1.2.4.3','Event Type',				'',	'listCustProjectEventType',		'Y',	3,	'', '1.2.4');
INSERT INTO Module VALUES('1.2.4.4','Expense Type',				'',	'listExpenseType',				'Y',	4,	'', '1.2.4');
INSERT INTO Module VALUES('1.2.4.5','Currency',					'',	'listCurrency',					'Y',	5,	'', '1.2.4');
INSERT INTO Module VALUES('1.2.5',	'Parameter',				'',	'NULL',							'Y',	4,	'', '1.2');
INSERT INTO Module VALUES('1.2.5.1','Parameter',				'',	'listSysParameter',				'Y',	1,	'', '1.2.5');
INSERT INTO Module VALUES('1.2.5.2','Create Parameter',			'',	'editSysParameter',				'Y',	2,	'', '1.2.5');

-------------------------------------------------------------
--					HelpDeskģ������
-------------------------------------------------------------
INSERT INTO Module VALUES('2.1',	'Helpdesk',							'',	'NULL',									'Y',	3,	'Helpdesk�ճ�ҵ��', '1');
INSERT INTO Module VALUES('2.1.1',	'Call',								'',	'NULL',									'Y',	1,	'', '2.1');
INSERT INTO Module VALUES('2.1.1.1','New Call',							'',	'helpdesk.newCall',						'Y',	1,	'', '2.1.1');
INSERT INTO Module VALUES('2.1.1.2','New Change Request',				'',	'helpdesk.newCall',						'Y',	1,	'', '2.1.1');
INSERT INTO Module VALUES('2.1.1.3','New Complain',						'',	'helpdesk.newCall',						'Y',	1,	'', '2.1.1');
INSERT INTO Module VALUES('2.1.1.4','Query',							'',	'helpdesk.queryCall',					'Y',	2,	'', '2.1.1');
INSERT INTO Module VALUES('2.1.2',	'SLA Definition',					'',	'NULL',									'Y',	2,	'', '2.1');
INSERT INTO Module VALUES('2.1.2.1','List SLA',							'',	'helpdesk.listSLAMaster',				'Y',	1,	'', '2.1.2');
INSERT INTO Module VALUES('2.1.2.2','Create SLA',						'',	'helpdesk.newSLAMaster',				'Y',	1,	'', '2.1.2');
INSERT INTO Module VALUES('2.1.3',	'KB',								'',	'NULL',									'Y',	3,	'', '2.1');
INSERT INTO Module VALUES('2.1.3.1','List KB',							'',	'helpdesk.listKnowledgeBase',			'Y',	1,	'', '2.1.3');
INSERT INTO Module VALUES('2.1.3.2','Create KB',						'',	'helpdesk.newKnowledgeBase',			'Y',	2,	'', '2.1.3');
INSERT INTO Module VALUES('2.1.4',	'Other Data',						'',	'NULL',									'Y',	4,	'', '2.1');
INSERT INTO Module VALUES('2.1.4.1','List Configuration Type',			'',	'helpdesk.listTableType',				'Y',	1,	'', '2.1.4');
INSERT INTO Module VALUES('2.1.4.2','List Status Type',					'',	'helpdesk.listStatusType',				'Y',	2,	'', '2.1.4');
INSERT INTO Module VALUES('2.1.4.3','List Action Type',					'',	'helpdesk.listActionType',				'Y',	3,	'', '2.1.4');
INSERT INTO Module VALUES('2.1.4.4','List Party Responsibility User',	'',	'helpdesk.listPartyResponsibilityUser',	'Y',	4,	'', '2.1.4');
INSERT INTO Module VALUES('2.1.4.5','List Request Type',				'',	'helpdesk.listRequestType',				'Y',	5,	'', '2.1.4');
INSERT INTO Module VALUES('2.1.4.6','List Customer',					'',	'helpdesk.listCustomer',				'Y',	6,	'', '2.1.4');

INSERT INTO Module_Group VALUES('FULLADMIN_GROUP',	'ϵͳ����ģ��',		100);
INSERT INTO Module_Group VALUES('HELPDESK_OP_GROUP','HELPDESK ����ģ��',	200);

INSERT INTO Module_Group_Associate VALUES('FULLADMIN_GROUP',	'1.2');
INSERT INTO Module_Group_Associate VALUES('HELPDESK_OP_GROUP',	'2.1');

-------------------------------------------------------------
--		Ȩ����
-------------------------------------------------------------
INSERT INTO Security_Group VALUES('SYSTEM_MANAGE',								'ϵͳȨ��');
INSERT INTO Security_Group VALUES('HELPDESK_ACTIONTRACK_TYPE_MANAGE',			'ActionTrack����ά��Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_CALL_ACTIONTRACK_MANAGE',			'Call ActionTrackά��Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_CALL_CHANGE_CLOSED',				'�ѹر�Call���޸�Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_CALL_MANAGE',						'Callά��Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_MANAGE',	'Change Request ActionTrackά��Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_CHANGEREQUEST_CHANGE_CLOSED',		'�ѹر�Change Request���޸�Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_CHANGEREQUEST_MANAGE',				'Change Requestά��Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_MANAGE',		'Complain ActionTrackά��Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_COMPLAIN_CHANGE_CLOSED',			'�ѹر�Complain���޸�Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_COMPLAIN_MANAGE',					'Complainά��Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_MANAGE',		'�ͻ�������Ϣ��ά��Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_MANAGE',	'�ͻ�������Ϣ������ά��Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_KB_MANAGE',							'֪ʶ��ά��Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_KB_USE',							'֪ʶ��ʹ��Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_PARTY_RESPONSIBILITY_USER_MANAGE',	'���Ÿ�����ά��Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_REQUEST_TYPE_MANAGE',				'Call��������ά��Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_SERVICELEVEL_MANAGE',				'����Э��ά��Ȩ��');
INSERT INTO Security_Group VALUES('HELPDESK_STATUS_TYPE_MANAGE',				'Call״̬����ά��Ȩ��');

-------------------------------------------------------------
--		Ȩ��
-------------------------------------------------------------
---------------------------------
-- ȱʡȨ�ޣ�ÿ����½�û�������߱�)
---------------------------------
INSERT INTO Security_Permission VALUES('SYSTEM_ROLE_PAGE',	'ϵͳ��ɫ��ҳ�鿴Ȩ��');

---------------------------------
--ϵͳ������(ֻ��ϵͳ����Ա����ʹ���ⲿ�ֹ���)
---------------------------------
INSERT INTO Security_Permission VALUES('SECURITY_PERMISSION_CREATE',	'Ȩ���б���Ȩ��');
INSERT INTO Security_Permission VALUES('SECURITY_PERMISSION_VIEW',		'Ȩ���б�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('USER_LOGIN_CREATE',				'��½�û�����Ȩ��');
INSERT INTO Security_Permission VALUES('USER_LOGIN_VIEW',				'��½�û��鿴Ȩ��');

---------------------------------
-- HelpDeskȨ��
---------------------------------
INSERT INTO Security_Permission VALUES('HELPDESK_ACTIONTRACK_TYPE_CREATE',					'Call ActionTrack���ʹ���Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_ACTIONTRACK_TYPE_DELETE',					'Call ActionTrack����ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_ACTIONTRACK_TYPE_MODIFY',					'Call ActionTrack�����޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_ACTIONTRACK_TYPE_VIEW',					'Call ActionTrack���Ͳ鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_ATTACHMENT_CREATE',						'��������Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_ATTACHMENT_DELETE',						'����ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_ATTACHMENT_MODIFY',						'�����޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_ATTACHMENT_VIEW',							'�����鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_CREATE',					'Call ActionTrack����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_DELETE',					'Call ActionTrackɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_MODIFY',					'Call ActionTrack�޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_VIEW',					'Call ActionTrack�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_CHANGE_CLOSED',						'�ѹر�Call���޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_CREATE',								'Call����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_DELETE',								'Callɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_MODIFY',								'Call�޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CALL_VIEW',								'Call�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_CREATE',			'Change Request ActionTrack����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_DELETE',			'Change Request ActionTrackɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_MODIFY',			'Change Request ActionTrack�޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_VIEW',			'Change Request ActionTrack�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_CHANGE_CLOSED',				'�ѹر�Change Request���޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_CREATE',						'Change Request����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_DELETE',						'Change Requestɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_MODIFY',						'Change Request�޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CHANGEREQUEST_VIEW',						'Change Request�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_CREATE',				'Complain ActionTrack����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_DELETE',				'Complain ActionTrackɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_MODIFY',				'Complain ActionTrack�޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_VIEW',				'Complain ActionTrack�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_CHANGE_CLOSED',					'�ѹر�Complain���޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_CREATE',							'Complain����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_DELETE',							'Complainɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_MODIFY',							'Complain�޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_COMPLAIN_VIEW',							'Complain�鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_ROW_CREATE',				'�û�������Ϣ�д���Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_ROW_DELETE',				'�û�������Ϣ��ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_ROW_MODIFY',				'�û�������Ϣ���޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_ROW_VIEW',					'�û�������Ϣ�в鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_CREATE',				'�û�������Ϣ����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_DELETE',				'�û�������Ϣ��ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_MODIFY',				'�û�������Ϣ���޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_CREATE',		'�û�������Ϣ�����ʹ���Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_DELETE',		'�û�������Ϣ������ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_MODIFY',		'�û�������Ϣ�������޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_VIEW',			'�û�������Ϣ�����Ͳ鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_VIEW',				'�û�������Ϣ��鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_KB_CREATE',								'֪ʶ�ⴴ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_KB_DELETE',								'֪ʶ��ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_KB_MODIFY',								'֪ʶ���޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_KB_VIEW',									'֪ʶ��鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_PARTY_RESPONSIBILITY_USER_CREATE',			'���Ÿ����˴���Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_PARTY_RESPONSIBILITY_USER_DELETE',			'���Ÿ�����ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_PARTY_RESPONSIBILITY_USER_MODIFY',			'���Ÿ������޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_PARTY_RESPONSIBILITY_USER_VIEW',			'���Ÿ����˲鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_PARTY_USER_VIEW',							'HelpDesk�л���/�û��鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_REQUEST_TYPE_CREATE',						'Call�������ʹ���Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_REQUEST_TYPE_DELETE',						'Call��������ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_REQUEST_TYPE_MODIFY',						'Call���������޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_REQUEST_TYPE_VIEW',						'Call�������Ͳ鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_CATEGORY_CREATE',				'����Э����ഴ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_CATEGORY_DELETE',				'����Э�����ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_CATEGORY_MODIFY',				'����Э������޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_CATEGORY_VIEW',				'����Э�����鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_MASTER_CREATE',				'����Э�������ݴ���Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_MASTER_DELETE',				'����Э��������ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_MASTER_MODIFY',				'����Э���������޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_MASTER_VIEW',					'����Э�������ݲ鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_PRIORITY_CREATE',				'����Э�����ȼ�����Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_PRIORITY_DELETE',				'����Э�����ȼ�ɾ��Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_PRIORITY_MODIFY',				'����Э�����ȼ��޸�Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_SERVICELEVEL_PRIORITY_VIEW',				'����Э�����ȼ��鿴Ȩ��');
INSERT INTO Security_Permission VALUES('HELPDESK_STATUS_TYPE_CREATE',						'Call״̬���ʹ���');
INSERT INTO Security_Permission VALUES('HELPDESK_STATUS_TYPE_DELETE',						'Call״̬����ɾ��');
INSERT INTO Security_Permission VALUES('HELPDESK_STATUS_TYPE_MODIFY',						'Call״̬�����޸�');
INSERT INTO Security_Permission VALUES('HELPDESK_STATUS_TYPE_VIEW',							'Call״̬���Ͳ鿴');


-------------------------------------------------------------
--		Ȩ�����Ȩ�޶���
-------------------------------------------------------------
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'SECURITY_PERMISSION_CREATE');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'SECURITY_PERMISSION_VIEW');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'USER_LOGIN_CREATE');
INSERT INTO Security_Group_Permission VALUES('SYSTEM_MANAGE', 'USER_LOGIN_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_ACTIONTRACK_TYPE_MANAGE', 'HELPDESK_ACTIONTRACK_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_ACTIONTRACK_TYPE_MANAGE', 'HELPDESK_ACTIONTRACK_TYPE_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_ACTIONTRACK_TYPE_MANAGE', 'HELPDESK_ACTIONTRACK_TYPE_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_ACTIONTRACK_TYPE_MANAGE', 'HELPDESK_ACTIONTRACK_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_MANAGE', 'HELPDESK_ATTACHMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_MANAGE', 'HELPDESK_ATTACHMENT_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_MANAGE', 'HELPDESK_ATTACHMENT_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_MANAGE', 'HELPDESK_ATTACHMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_MANAGE', 'HELPDESK_CALL_ACTIONTRACK_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_MANAGE', 'HELPDESK_CALL_ACTIONTRACK_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_MANAGE', 'HELPDESK_CALL_ACTIONTRACK_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_MANAGE', 'HELPDESK_ACTIONTRACK_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_MANAGE', 'HELPDESK_CALL_ACTIONTRACK_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_ACTIONTRACK_MANAGE', 'HELPDESK_STATUS_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_CHANGE_CLOSED', 'HELPDESK_CALL_CHANGE_CLOSED');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_ATTACHMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CALL_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CALL_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CALL_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CALL_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_ROW_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_PARTY_USER_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CALL_MANAGE', 'HELPDESK_REQUEST_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_MANAGE', 'HELPDESK_ATTACHMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_MANAGE', 'HELPDESK_ATTACHMENT_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_MANAGE', 'HELPDESK_ATTACHMENT_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_MANAGE', 'HELPDESK_ATTACHMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_MANAGE', 'HELPDESK_CHANGEREQUEST_ACTIONTRACK_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_MANAGE', 'HELPDESK_CHANGEREQUEST_ACTIONTRACK_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_MANAGE', 'HELPDESK_CHANGEREQUEST_ACTIONTRACK_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_MANAGE', 'HELPDESK_ACTIONTRACK_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_MANAGE', 'HELPDESK_CHANGEREQUEST_ACTIONTRACK_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_ACTIONTRACK_MANAGE', 'HELPDESK_STATUS_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_CHANGE_CLOSED', 'HELPDESK_CHANGEREQUEST_CHANGE_CLOSED');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_MANAGE', 'HELPDESK_ATTACHMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_MANAGE', 'HELPDESK_ATTACHMENT_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_MANAGE', 'HELPDESK_ATTACHMENT_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_MANAGE', 'HELPDESK_ATTACHMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_MANAGE', 'HELPDESK_CHANGEREQUEST_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_MANAGE', 'HELPDESK_CHANGEREQUEST_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_MANAGE', 'HELPDESK_CHANGEREQUEST_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_MANAGE', 'HELPDESK_CHANGEREQUEST_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_ROW_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CHANGEREQUEST_MANAGE', 'HELPDESK_PARTY_USER_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_MANAGE', 'HELPDESK_ATTACHMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_MANAGE', 'HELPDESK_ATTACHMENT_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_MANAGE', 'HELPDESK_ATTACHMENT_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_MANAGE', 'HELPDESK_ATTACHMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_MANAGE', 'HELPDESK_COMPLAIN_ACTIONTRACK_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_MANAGE', 'HELPDESK_COMPLAIN_ACTIONTRACK_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_MANAGE', 'HELPDESK_COMPLAIN_ACTIONTRACK_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_MANAGE', 'HELPDESK_ACTIONTRACK_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_MANAGE', 'HELPDESK_COMPLAIN_ACTIONTRACK_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_ACTIONTRACK_MANAGE', 'HELPDESK_STATUS_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_CHANGE_CLOSED', 'HELPDESK_COMPLAIN_CHANGE_CLOSED');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_MANAGE', 'HELPDESK_ATTACHMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_MANAGE', 'HELPDESK_ATTACHMENT_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_MANAGE', 'HELPDESK_ATTACHMENT_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_MANAGE', 'HELPDESK_ATTACHMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_MANAGE', 'HELPDESK_COMPLAIN_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_MANAGE', 'HELPDESK_COMPLAIN_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_MANAGE', 'HELPDESK_COMPLAIN_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_MANAGE', 'HELPDESK_COMPLAIN_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_ROW_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_COMPLAIN_MANAGE', 'HELPDESK_PARTY_USER_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_ROW_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_ROW_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_ROW_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_ROW_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_MANAGE', 'HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_KB_MANAGE', 'HELPDESK_ATTACHMENT_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_KB_MANAGE', 'HELPDESK_ATTACHMENT_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_KB_MANAGE', 'HELPDESK_ATTACHMENT_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_KB_MANAGE', 'HELPDESK_ATTACHMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_KB_MANAGE', 'HELPDESK_KB_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_KB_MANAGE', 'HELPDESK_KB_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_KB_MANAGE', 'HELPDESK_KB_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_KB_MANAGE', 'HELPDESK_KB_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_KB_USE', 'HELPDESK_ATTACHMENT_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_KB_USE', 'HELPDESK_KB_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_PARTY_RESPONSIBILITY_USER_MANAGE', 'HELPDESK_PARTY_RESPONSIBILITY_USER_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_PARTY_RESPONSIBILITY_USER_MANAGE', 'HELPDESK_PARTY_RESPONSIBILITY_USER_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_PARTY_RESPONSIBILITY_USER_MANAGE', 'HELPDESK_PARTY_RESPONSIBILITY_USER_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_PARTY_RESPONSIBILITY_USER_MANAGE', 'HELPDESK_PARTY_RESPONSIBILITY_USER_VIEW');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_REQUEST_TYPE_MANAGE', 'HELPDESK_REQUEST_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_REQUEST_TYPE_MANAGE', 'HELPDESK_REQUEST_TYPE_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_REQUEST_TYPE_MANAGE', 'HELPDESK_REQUEST_TYPE_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_REQUEST_TYPE_MANAGE', 'HELPDESK_REQUEST_TYPE_VIEW');
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
INSERT INTO Security_Group_Permission VALUES('HELPDESK_STATUS_TYPE_MANAGE', 'HELPDESK_STATUS_TYPE_CREATE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_STATUS_TYPE_MANAGE', 'HELPDESK_STATUS_TYPE_DELETE');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_STATUS_TYPE_MANAGE', 'HELPDESK_STATUS_TYPE_MODIFY');
INSERT INTO Security_Group_Permission VALUES('HELPDESK_STATUS_TYPE_MANAGE', 'HELPDESK_STATUS_TYPE_VIEW');

-------------------------------------------------------------
--- 		Call Type
-------------------------------------------------------------
INSERT INTO Call_Type VALUES('A', 'Call', 'Call');
INSERT INTO Call_Type VALUES('B', 'Change Request', 'ChangeRequest');
INSERT INTO Call_Type VALUES('C', 'Complain', 'Complain');

-------------------------------------------------------------
--- Party Responsibility Type
-------------------------------------------------------------
INSERT INTO Party_Responsibility_Type VALUES('A', 'Default Party Notify Person');
INSERT INTO Party_Responsibility_Type VALUES('B', 'Call Warning Notify Person');

-------------------------------------------------------------
--- 		ϵͳ����Ա�˺�
-------------------------------------------------------------
INSERT INTO Party(Party_Id, Party_Type_Id, Description) VALUES('AO', 'PARTY_GROUP', 'ԴѶ��Ϣ�������޹�˾');
INSERT INTO Party_Role VALUES('AO', 'ORGANIZATION_UNIT');
INSERT INTO User_Login(Role, Enable, Current_Password, Name, User_Login_Id, Party_Id) VALUES('FULLADMIN', 'Y', 'admin', 'ϵͳ����Ա', 'admin', 'AO');
INSERT INTO User_Login_Security_Group VALUES('admin', 'SYSTEM_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_CALL_ACTIONTRACK_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_ACTIONTRACK_TYPE_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_CALL_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_CALL_CHANGE_CLOSED');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_STATUS_TYPE_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_CHANGEREQUEST_ACTIONTRACK_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_CHANGEREQUEST_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_CHANGEREQUEST_CHANGE_CLOSED');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_COMPLAIN_ACTIONTRACK_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_COMPLAIN_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_COMPLAIN_CHANGE_CLOSED');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_CUSTOMER_CONFIG_TABLE_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_CUSTOMER_CONFIG_TABLE_TYPE_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_KB_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_PARTY_RESPONSIBILITY_USER_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_REQUEST_TYPE_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('admin', 'HELPDESK_SERVICELEVEL_MANAGE');
INSERT INTO User_Login_Module_Group VALUES('admin', 'FULLADMIN_GROUP');
INSERT INTO User_Login_Module_Group VALUES('admin', 'HELPDESK_OP_GROUP');

-- Helpdesk����ʦ
INSERT INTO User_Login(Role, Enable, Current_Password, Name, User_Login_Id, Party_Id) VALUES('INTERNALUSER', 'Y', 'helpdesk', 'Helpdesk �����û�', 'helpdesk', 'AO');
INSERT INTO User_Login_Security_Group VALUES('helpdesk', 'HELPDESK_CALL_ACTIONTRACK_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('helpdesk', 'HELPDESK_CALL_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('helpdesk', 'HELPDESK_CHANGEREQUEST_ACTIONTRACK_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('helpdesk', 'HELPDESK_CHANGEREQUEST_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('helpdesk', 'HELPDESK_COMPLAIN_ACTIONTRACK_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('helpdesk', 'HELPDESK_COMPLAIN_MANAGE');
INSERT INTO User_Login_Security_Group VALUES('helpdesk', 'HELPDESK_KB_USE');
INSERT INTO User_Login_Module_Group VALUES('helpdesk', 'HELPDESK_OP_GROUP');

-- TimeSheet Permission
INSERT INTO Module VALUES('2.2','PRM','','NULL','Y',10,'Project �ճ�ҵ��','1');
INSERT INTO Module VALUES('2.2.1','TimeSheet','','NULL','Y',1,'','2.2');
INSERT INTO Module VALUES('2.2.1.1','TimeSheet','','editTimeSheet','Y',1,'','2.2.1');

INSERT INTO Module_Group VALUES('PRM_OP_GROUP','PRM ����ģ��',200);
INSERT INTO Module_Group_Associate VALUES('PRM_OP_GROUP','2.2');

-------
DELETE FROM User_Login_Module_Group

DELETE FROM Module_Group_Associate
DELETE FROM Module_Group
DELETE FROM Module

DELETE FROM User_Login_Security_Group

DELETE FROM Security_Group_Permission
DELETE FROM Security_Group
DELETE FROM Security_Permission

DELETE FROM KB

DELETE FROM CM_Status_History
DELETE FROM CM_Action_History
DELETE FROM Action_Type
DELETE FROM CM_History
DELETE FROM Call_Master

DELETE FROM Request_Type
DELETE FROM Status_Type
DELETE FROM Call_Type

DELETE FROM CustConfigItem
DELETE FROM CustConfigRow
DELETE FROM CustConfigTable
DELETE FROM CustConfigColumn
DELETE FROM CustConfigTableType

DELETE FROM SLA_Priority
DELETE FROM SLA_Category
DELETE FROM SLA_MSTR

DELETE FROM Attachment

DELETE Proj_Ts_Det
DELETE Proj_MSTR

DELETE FROM User_Login

DELETE FROM Party_Relationship
DELETE FROM Party_Role
DELETE FROM Party_Relationship_Type
DELETE FROM Role_Type
DELETE FROM Party
DELETE FROM Party_Type
