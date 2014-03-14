if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_Action_History_ACTION_TYPE]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Action_History] DROP CONSTRAINT FK_CM_Action_History_ACTION_TYPE
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_Call_Type]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_Call_Type
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Request_Type_Call_Type]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Request_Type] DROP CONSTRAINT FK_Request_Type_Call_Type
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Status_Type_Call_Type]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Status_Type] DROP CONSTRAINT FK_Status_Type_Call_Type
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_custConfigColumn_CustConfigTableType]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[custConfigColumn] DROP CONSTRAINT FK_custConfigColumn_CustConfigTableType
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_custConfigTable_CustConfigTableType1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[custConfigTable] DROP CONSTRAINT FK_custConfigTable_CustConfigTableType1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK87DE9A6CF721B6BD]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[MODULE] DROP CONSTRAINT FK87DE9A6CF721B6BD
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK98E6854B4995ABCE]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[MODULE_GROUP_ASSOCIATE] DROP CONSTRAINT FK98E6854B4995ABCE
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK98E6854B1246F6E]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[MODULE_GROUP_ASSOCIATE] DROP CONSTRAINT FK98E6854B1246F6E
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKC614CF61246F6E]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[USER_LOGIN_MODULE_GROUP] DROP CONSTRAINT FKC614CF61246F6E
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK28ADD7115BC03139]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PARTY_RELATIONSHIP] DROP CONSTRAINT FK28ADD7115BC03139
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK48622C666B487C7]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PARTY] DROP CONSTRAINT FK48622C666B487C7
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Party_Responsibility_User_Party_Responsibility_Type]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Party_Responsibility_User] DROP CONSTRAINT FK_Party_Responsibility_User_Party_Responsibility_Type
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Proj_TS_Det_ProjEvent]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_TS_Det] DROP CONSTRAINT FK_Proj_TS_Det_ProjEvent
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProjEvent_ProjEventType_ProjEvent]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProjEvent_ProjEventType] DROP CONSTRAINT FK_ProjEvent_ProjEventType_ProjEvent
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProjEvent_ProjEventType_ProjEventType]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProjEvent_ProjEventType] DROP CONSTRAINT FK_ProjEvent_ProjEventType_ProjEventType
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK28ADD71179A88F07]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PARTY_RELATIONSHIP] DROP CONSTRAINT FK28ADD71179A88F07
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK28ADD711C06D3856]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PARTY_RELATIONSHIP] DROP CONSTRAINT FK28ADD711C06D3856
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK3B3FDA4F6A3C2D77]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PARTY_ROLE] DROP CONSTRAINT FK3B3FDA4F6A3C2D77
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK98650ACE4CD4DEFB]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SECURITY_GROUP_PERMISSION] DROP CONSTRAINT FK98650ACE4CD4DEFB
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKCDAF484A4CD4DEFB]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[USER_LOGIN_SECURITY_GROUP] DROP CONSTRAINT FKCDAF484A4CD4DEFB
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK98650ACE6466358B]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SECURITY_GROUP_PERMISSION] DROP CONSTRAINT FK98650ACE6466358B
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_Contact]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_Contact
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_USER_LOGIN]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_USER_LOGIN
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_USER_LOGIN1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_USER_LOGIN1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_User1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_User1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_User2]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_User2
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_Action_History_USER_LOGIN]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Action_History] DROP CONSTRAINT FK_CM_Action_History_USER_LOGIN
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_Action_History_USER_LOGIN1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Action_History] DROP CONSTRAINT FK_CM_Action_History_USER_LOGIN1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_Action_History_USER_LOGIN2]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Action_History] DROP CONSTRAINT FK_CM_Action_History_USER_LOGIN2
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_History_USER_LOGIN]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FK_CM_History_USER_LOGIN
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_History_USER_LOGIN1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FK_CM_History_USER_LOGIN1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_History_USER_LOGIN2]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FK_CM_History_USER_LOGIN2
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_History_USER_LOGIN3]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FK_CM_History_USER_LOGIN3
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_Status_History_User]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Status_History] DROP CONSTRAINT FK_CM_Status_History_User
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_Status_History_User1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Status_History] DROP CONSTRAINT FK_CM_Status_History_User1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Party_Responsibility_User_USER_LOGIN]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Party_Responsibility_User] DROP CONSTRAINT FK_Party_Responsibility_User_USER_LOGIN
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Proj_Mstr_USER_LOGIN]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Mstr] DROP CONSTRAINT FK_Proj_Mstr_USER_LOGIN
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Proj_TS_Det_USER_LOGIN]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_TS_Det] DROP CONSTRAINT FK_Proj_TS_Det_USER_LOGIN
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_Category_CUser]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Category] DROP CONSTRAINT FK_SLA_Category_CUser
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_Category_MUser]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Category] DROP CONSTRAINT FK_SLA_Category_MUser
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_MSTR_CUser]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_MSTR] DROP CONSTRAINT FK_SLA_MSTR_CUser
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_MSTR_MUser]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_MSTR] DROP CONSTRAINT FK_SLA_MSTR_MUser
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_Priority_CUser]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Priority] DROP CONSTRAINT FK_SLA_Priority_CUser
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_Priority_MUser]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Priority] DROP CONSTRAINT FK_SLA_Priority_MUser
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKC614CF6BDE0A7C5]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[USER_LOGIN_MODULE_GROUP] DROP CONSTRAINT FKC614CF6BDE0A7C5
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKCDAF484ABDE0A7C5]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[USER_LOGIN_SECURITY_GROUP] DROP CONSTRAINT FKCDAF484ABDE0A7C5
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_Company
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_PARTY]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_PARTY
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_History_PARTY]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FK_CM_History_PARTY
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_History_PARTY1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FK_CM_History_PARTY1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_custConfigTable_PARTY]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[custConfigTable] DROP CONSTRAINT FK_custConfigTable_PARTY
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_KB_PARTY]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[KB] DROP CONSTRAINT FK_KB_PARTY
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_KB_PARTY1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[KB] DROP CONSTRAINT FK_KB_PARTY1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK28ADD7112CD7E6A6]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PARTY_RELATIONSHIP] DROP CONSTRAINT FK28ADD7112CD7E6A6
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK28ADD7117620E957]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PARTY_RELATIONSHIP] DROP CONSTRAINT FK28ADD7117620E957
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Party_Responsibility_User_PARTY]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Party_Responsibility_User] DROP CONSTRAINT FK_Party_Responsibility_User_PARTY
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK3B3FDA4F758A0D34]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PARTY_ROLE] DROP CONSTRAINT FK3B3FDA4F758A0D34
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Proj_Mstr_PARTY]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Mstr] DROP CONSTRAINT FK_Proj_Mstr_PARTY
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Proj_Mstr_PARTY1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Mstr] DROP CONSTRAINT FK_Proj_Mstr_PARTY1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_MSTR_Party]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_MSTR] DROP CONSTRAINT FK_SLA_MSTR_Party
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_Request_Type]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_Request_Type
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_custConfigItem_custConfigColumn]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[custConfigItem] DROP CONSTRAINT FK_custConfigItem_custConfigColumn
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Proj_TS_Det_Proj_Mstr]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_TS_Det] DROP CONSTRAINT FK_Proj_TS_Det_Proj_Mstr
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_Category_SLA_MSTR]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Category] DROP CONSTRAINT FK_SLA_Category_SLA_MSTR
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_custConfigRow_custConfigTable]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[custConfigRow] DROP CONSTRAINT FK_custConfigRow_custConfigTable
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_SLA_Category]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_SLA_Category
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_History_SLA_Category]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FK_CM_History_SLA_Category
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_History_SLA_Category1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FK_CM_History_SLA_Category1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_KB_SLA_Category]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[KB] DROP CONSTRAINT FK_KB_SLA_Category
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_Category_SLA_Category]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Category] DROP CONSTRAINT FK_SLA_Category_SLA_Category
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_Priority_SLA_Category]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Priority] DROP CONSTRAINT FK_SLA_Priority_SLA_Category
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_custConfigItem_custConfigRow]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[custConfigItem] DROP CONSTRAINT FK_custConfigItem_custConfigRow
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_SLA_Priority]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_SLA_Priority
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_History_SLA_Priority]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FK_CM_History_SLA_Priority
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_History_SLA_Priority1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FK_CM_History_SLA_Priority1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_Action_History_Call_Master]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Action_History] DROP CONSTRAINT FK_CM_Action_History_Call_Master
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_History_Call_Master]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FK_CM_History_Call_Master
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CM_Status_History_CM_Action_History]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Status_History] DROP CONSTRAINT FK_CM_Status_History_CM_Action_History
GO

/****** Object:  Trigger dbo.tI_CallType    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tI_CallType]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tI_CallType]
GO

/****** Object:  Stored Procedure dbo.sp_dailyemail    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dailyemail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dailyemail]
GO

/****** Object:  Stored Procedure dbo.sp_getWarningNotifyEmail    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_getWarningNotifyEmail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_getWarningNotifyEmail]
GO

/****** Object:  Stored Procedure dbo.fn_addblank    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fn_addblank]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[fn_addblank]
GO

/****** Object:  Stored Procedure dbo.fn_getstrlen    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fn_getstrlen]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[fn_getstrlen]
GO

/****** Object:  Stored Procedure dbo.sp_insertrecord    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_insertrecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_insertrecord]
GO

/****** Object:  Table [dbo].[CM_Status_History]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CM_Status_History]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CM_Status_History]
GO

/****** Object:  Table [dbo].[CM_Action_History]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CM_Action_History]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CM_Action_History]
GO

/****** Object:  Table [dbo].[CM_History]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CM_History]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CM_History]
GO

/****** Object:  Table [dbo].[Call_Master]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Call_Master]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Call_Master]
GO

/****** Object:  Table [dbo].[KB]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[KB]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[KB]
GO

/****** Object:  Table [dbo].[SLA_Priority]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SLA_Priority]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SLA_Priority]
GO

/****** Object:  Table [dbo].[custConfigItem]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[custConfigItem]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[custConfigItem]
GO

/****** Object:  Table [dbo].[Proj_TS_Det]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_TS_Det]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_TS_Det]
GO

/****** Object:  Table [dbo].[SLA_Category]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SLA_Category]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SLA_Category]
GO

/****** Object:  Table [dbo].[custConfigRow]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[custConfigRow]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[custConfigRow]
GO

/****** Object:  Table [dbo].[PARTY_RELATIONSHIP]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PARTY_RELATIONSHIP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PARTY_RELATIONSHIP]
GO

/****** Object:  Table [dbo].[PARTY_ROLE]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PARTY_ROLE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PARTY_ROLE]
GO

/****** Object:  Table [dbo].[Party_Responsibility_User]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Party_Responsibility_User]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Party_Responsibility_User]
GO

/****** Object:  Table [dbo].[Proj_Mstr]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_Mstr]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_Mstr]
GO

/****** Object:  Table [dbo].[SLA_MSTR]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SLA_MSTR]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SLA_MSTR]
GO

/****** Object:  Table [dbo].[custConfigTable]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[custConfigTable]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[custConfigTable]
GO

/****** Object:  Table [dbo].[MODULE_GROUP_ASSOCIATE]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MODULE_GROUP_ASSOCIATE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MODULE_GROUP_ASSOCIATE]
GO

/****** Object:  Table [dbo].[PARTY]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PARTY]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PARTY]
GO

/****** Object:  Table [dbo].[ProjEvent_ProjEventType]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjEvent_ProjEventType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ProjEvent_ProjEventType]
GO

/****** Object:  Table [dbo].[Request_Type]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Request_Type]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Request_Type]
GO

/****** Object:  Table [dbo].[SECURITY_GROUP_PERMISSION]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SECURITY_GROUP_PERMISSION]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SECURITY_GROUP_PERMISSION]
GO

/****** Object:  Table [dbo].[Status_Type]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Status_Type]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Status_Type]
GO

/****** Object:  Table [dbo].[USER_LOGIN_MODULE_GROUP]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USER_LOGIN_MODULE_GROUP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[USER_LOGIN_MODULE_GROUP]
GO

/****** Object:  Table [dbo].[USER_LOGIN_SECURITY_GROUP]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USER_LOGIN_SECURITY_GROUP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[USER_LOGIN_SECURITY_GROUP]
GO

/****** Object:  Table [dbo].[custConfigColumn]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[custConfigColumn]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[custConfigColumn]
GO

/****** Object:  Table [dbo].[ACTION_TYPE]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACTION_TYPE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACTION_TYPE]
GO

/****** Object:  Table [dbo].[Attachment]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Attachment]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Attachment]
GO

/****** Object:  Table [dbo].[Call_Type]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Call_Type]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Call_Type]
GO

/****** Object:  Table [dbo].[Currency]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Currency]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Currency]
GO

/****** Object:  Table [dbo].[CustConfigTableType]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CustConfigTableType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CustConfigTableType]
GO

/****** Object:  Table [dbo].[ExpenseType]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ExpenseType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ExpenseType]
GO

/****** Object:  Table [dbo].[MODULE]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MODULE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MODULE]
GO

/****** Object:  Table [dbo].[MODULE_GROUP]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MODULE_GROUP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MODULE_GROUP]
GO

/****** Object:  Table [dbo].[PARTY_RELATIONSHIP_TYPE]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PARTY_RELATIONSHIP_TYPE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PARTY_RELATIONSHIP_TYPE]
GO

/****** Object:  Table [dbo].[PARTY_TYPE]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PARTY_TYPE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PARTY_TYPE]
GO

/****** Object:  Table [dbo].[Party_Responsibility_Type]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Party_Responsibility_Type]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Party_Responsibility_Type]
GO

/****** Object:  Table [dbo].[ProjEvent]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjEvent]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ProjEvent]
GO

/****** Object:  Table [dbo].[ProjEventType]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjEventType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ProjEventType]
GO

/****** Object:  Table [dbo].[ROLE_TYPE]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ROLE_TYPE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ROLE_TYPE]
GO

/****** Object:  Table [dbo].[SECURITY_GROUP]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SECURITY_GROUP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SECURITY_GROUP]
GO

/****** Object:  Table [dbo].[SECURITY_PERMISSION]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SECURITY_PERMISSION]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SECURITY_PERMISSION]
GO

/****** Object:  Table [dbo].[USER_LOGIN]    Script Date: 2004-12-23 22:14:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USER_LOGIN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[USER_LOGIN]
GO

/****** Object:  Table [dbo].[ACTION_TYPE]    Script Date: 2004-12-23 22:14:11 ******/
CREATE TABLE [dbo].[ACTION_TYPE] (
	[ActionId] [int] IDENTITY (1, 1) NOT NULL ,
	[ActionDesc] [varchar] (255) NOT NULL ,
	[ActionDisabled] [bit] NOT NULL ,
	[CallType] [varchar] (20) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Attachment]    Script Date: 2004-12-23 22:14:11 ******/
CREATE TABLE [dbo].[Attachment] (
	[Attach_GroupID] [char] (32) NOT NULL ,
	[Attach_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[Attach_Name] [varchar] (50) NOT NULL ,
	[Attach_MIME] [varchar] (255) NOT NULL ,
	[Attach_Size] [int] NOT NULL ,
	[Attach_Content] [image] NOT NULL ,
	[Attach_CUser] [varchar] (255) NOT NULL ,
	[Attach_CDate] [datetime] NOT NULL ,
	[deleted] [bit] NOT NULL ,
	[title] [varchar] (800) NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Call_Type]    Script Date: 2004-12-23 22:14:12 ******/
CREATE TABLE [dbo].[Call_Type] (
	[type] [varchar] (20) NOT NULL ,
	[typedesc] [varchar] (255) NOT NULL ,
	[name] [varchar] (50) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Currency]    Script Date: 2004-12-23 22:14:12 ******/
CREATE TABLE [dbo].[Currency] (
	[Curr_Id] [varchar] (255) NOT NULL ,
	[Curr_Name] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[CustConfigTableType]    Script Date: 2004-12-23 22:14:12 ******/
CREATE TABLE [dbo].[CustConfigTableType] (
	[type_id] [int] IDENTITY (1, 1) NOT NULL ,
	[type_name] [varchar] (255) NOT NULL ,
	[disabled] [bit] NOT NULL ,
	[type_cuser] [char] (255) NULL ,
	[type_muser] [char] (255) NULL ,
	[type_cdate] [datetime] NULL ,
	[type_mdate] [datetime] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ExpenseType]    Script Date: 2004-12-23 22:14:12 ******/
CREATE TABLE [dbo].[ExpenseType] (
	[EType_Id] [int] IDENTITY (1, 1) NOT NULL ,
	[EType_EDesc] [varchar] (255) NULL ,
	[EType_CDesc] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[MODULE]    Script Date: 2004-12-23 22:14:12 ******/
CREATE TABLE [dbo].[MODULE] (
	[MODULE_ID] [varchar] (255) NOT NULL ,
	[MODULE_NAME] [varchar] (255) NULL ,
	[MODULE_IMAGE] [varchar] (255) NULL ,
	[REQUEST_PATH] [varchar] (255) NULL ,
	[VISBALE] [varchar] (255) NULL ,
	[PRIORITY] [int] NULL ,
	[DESCRIPTION] [varchar] (255) NULL ,
	[MODULE_PARENT_ID] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[MODULE_GROUP]    Script Date: 2004-12-23 22:14:12 ******/
CREATE TABLE [dbo].[MODULE_GROUP] (
	[MODULE_GROUP_ID] [varchar] (255) NOT NULL ,
	[DESCRIPTION] [varchar] (255) NULL ,
	[PRIORITY] [int] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PARTY_RELATIONSHIP_TYPE]    Script Date: 2004-12-23 22:14:12 ******/
CREATE TABLE [dbo].[PARTY_RELATIONSHIP_TYPE] (
	[RELATIONSHIP_TYPE_ID] [varchar] (255) NOT NULL ,
	[DESCRIPTION] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PARTY_TYPE]    Script Date: 2004-12-23 22:14:13 ******/
CREATE TABLE [dbo].[PARTY_TYPE] (
	[PARTY_TYPE_ID] [varchar] (255) NOT NULL ,
	[DESCRIPTION] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Party_Responsibility_Type]    Script Date: 2004-12-23 22:14:13 ******/
CREATE TABLE [dbo].[Party_Responsibility_Type] (
	[TypeId] [char] (1) NOT NULL ,
	[Description] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ProjEvent]    Script Date: 2004-12-23 22:14:13 ******/
CREATE TABLE [dbo].[ProjEvent] (
	[PEvent_Id] [int] IDENTITY (1, 1) NOT NULL ,
	[PEvent_Name] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ProjEventType]    Script Date: 2004-12-23 22:14:13 ******/
CREATE TABLE [dbo].[ProjEventType] (
	[PET_Id] [int] IDENTITY (1, 1) NOT NULL ,
	[PET_Name] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ROLE_TYPE]    Script Date: 2004-12-23 22:14:13 ******/
CREATE TABLE [dbo].[ROLE_TYPE] (
	[ROLE_TYPE_ID] [varchar] (255) NOT NULL ,
	[DESCRIPTION] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[SECURITY_GROUP]    Script Date: 2004-12-23 22:14:13 ******/
CREATE TABLE [dbo].[SECURITY_GROUP] (
	[GROUP_ID] [varchar] (255) NOT NULL ,
	[DESCRIPTION] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[SECURITY_PERMISSION]    Script Date: 2004-12-23 22:14:13 ******/
CREATE TABLE [dbo].[SECURITY_PERMISSION] (
	[PERMISSION_ID] [varchar] (255) NOT NULL ,
	[DESCRIPTION] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[USER_LOGIN]    Script Date: 2004-12-23 22:14:13 ******/
CREATE TABLE [dbo].[USER_LOGIN] (
	[USER_LOGIN_ID] [varchar] (255) NOT NULL ,
	[NAME] [varchar] (255) NULL ,
	[CURRENT_PASSWORD] [varchar] (255) NULL ,
	[ENABLE] [varchar] (255) NULL ,
	[TELE_CODE] [varchar] (255) NULL ,
	[MOBILE_CODE] [varchar] (255) NULL ,
	[TITLE] [varchar] (255) NULL ,
	[EMAIL_ADDR] [varchar] (255) NULL ,
	[NOTE] [varchar] (255) NULL ,
	[ROLE] [varchar] (255) NULL ,
	[PARTY_ID] [varchar] (50) NULL ,
	[locale] [varchar] (50) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[MODULE_GROUP_ASSOCIATE]    Script Date: 2004-12-23 22:14:14 ******/
CREATE TABLE [dbo].[MODULE_GROUP_ASSOCIATE] (
	[MODULE_GROUP_ID] [varchar] (255) NOT NULL ,
	[MODULE_ID] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PARTY]    Script Date: 2004-12-23 22:14:14 ******/
CREATE TABLE [dbo].[PARTY] (
	[PARTY_ID] [varchar] (50) NOT NULL ,
	[PARTY_TYPE_ID] [varchar] (255) NULL ,
	[DESCRIPTION] [varchar] (255) NULL ,
	[ADDRESS] [varchar] (255) NULL ,
	[TELE_CODE] [varchar] (255) NULL ,
	[FAX_CODE] [varchar] (255) NULL ,
	[POST_CODE] [varchar] (255) NULL ,
	[CITY] [varchar] (255) NULL ,
	[PROVINCE] [varchar] (255) NULL ,
	[LINK_MAN] [varchar] (255) NULL ,
	[NOTE] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ProjEvent_ProjEventType]    Script Date: 2004-12-23 22:14:14 ******/
CREATE TABLE [dbo].[ProjEvent_ProjEventType] (
	[PEvent_Id] [int] NOT NULL ,
	[PET_Id] [int] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Request_Type]    Script Date: 2004-12-23 22:14:14 ******/
CREATE TABLE [dbo].[Request_Type] (
	[Id] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (255) NOT NULL ,
	[Disabled] [bit] NOT NULL ,
	[CallType] [varchar] (20) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[SECURITY_GROUP_PERMISSION]    Script Date: 2004-12-23 22:14:14 ******/
CREATE TABLE [dbo].[SECURITY_GROUP_PERMISSION] (
	[GROUP_ID] [varchar] (255) NOT NULL ,
	[PERMISSION_ID] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Status_Type]    Script Date: 2004-12-23 22:14:14 ******/
CREATE TABLE [dbo].[Status_Type] (
	[status_id] [int] IDENTITY (0, 1) NOT NULL ,
	[status_type] [varchar] (20) NOT NULL ,
	[status_level] [int] NOT NULL ,
	[status_disabled] [bit] NOT NULL ,
	[status_desc] [varchar] (255) NOT NULL ,
	[status_flag] [int] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[USER_LOGIN_MODULE_GROUP]    Script Date: 2004-12-23 22:14:15 ******/
CREATE TABLE [dbo].[USER_LOGIN_MODULE_GROUP] (
	[USER_LOGIN_ID] [varchar] (255) NOT NULL ,
	[MODULE_GROUP_ID] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[USER_LOGIN_SECURITY_GROUP]    Script Date: 2004-12-23 22:14:15 ******/
CREATE TABLE [dbo].[USER_LOGIN_SECURITY_GROUP] (
	[USER_LOGIN_ID] [varchar] (255) NOT NULL ,
	[GROUP_ID] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[custConfigColumn]    Script Date: 2004-12-23 22:14:15 ******/
CREATE TABLE [dbo].[custConfigColumn] (
	[column_id] [int] IDENTITY (1, 1) NOT NULL ,
	[column_name] [varchar] (255) NOT NULL ,
	[column_type] [int] NOT NULL ,
	[table_type] [int] NOT NULL ,
	[column_index] [int] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PARTY_RELATIONSHIP]    Script Date: 2004-12-23 22:14:15 ******/
CREATE TABLE [dbo].[PARTY_RELATIONSHIP] (
	[PARTY_FROM_ID] [varchar] (50) NOT NULL ,
	[PARTY_TO_ID] [varchar] (50) NOT NULL ,
	[ROLE_FROM_ID] [varchar] (255) NOT NULL ,
	[ROLE_TO_ID] [varchar] (255) NOT NULL ,
	[RELATIONSHIP_TYPE_ID] [varchar] (255) NOT NULL ,
	[NOTE] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PARTY_ROLE]    Script Date: 2004-12-23 22:14:15 ******/
CREATE TABLE [dbo].[PARTY_ROLE] (
	[PARTY_ID] [varchar] (50) NOT NULL ,
	[ROLE_TYPE_ID] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Party_Responsibility_User]    Script Date: 2004-12-23 22:14:15 ******/
CREATE TABLE [dbo].[Party_Responsibility_User] (
	[Id] [int] IDENTITY (1, 1) NOT NULL ,
	[Party_Id] [varchar] (50) NOT NULL ,
	[User_Login_Id] [varchar] (255) NOT NULL ,
	[TypeId] [char] (1) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_Mstr]    Script Date: 2004-12-23 22:14:16 ******/
CREATE TABLE [dbo].[Proj_Mstr] (
	[Proj_Id] [varchar] (255) NOT NULL ,
	[Proj_Name] [varchar] (255) NULL ,
	[Cust_Id] [varchar] (50) NULL ,
	[Dep_Id] [varchar] (50) NULL ,
	[Proj_Status] [varchar] (255) NULL ,
	[Proj_PM_User] [varchar] (255) NULL ,
	[Proj_Type] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[SLA_MSTR]    Script Date: 2004-12-23 22:14:16 ******/
CREATE TABLE [dbo].[SLA_MSTR] (
	[SLA_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[SLA_Desc] [varchar] (255) NULL ,
	[SLA_Type] [char] (1) NULL ,
	[SLA_Party] [varchar] (50) NULL ,
	[SLA_Active] [char] (1) NOT NULL ,
	[SLA_CDate] [datetime] NULL ,
	[SLA_CUser] [varchar] (255) NULL ,
	[SLA_MDate] [datetime] NULL ,
	[SLA_MUser] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[custConfigTable]    Script Date: 2004-12-23 22:14:16 ******/
CREATE TABLE [dbo].[custConfigTable] (
	[table_id] [int] IDENTITY (1, 1) NOT NULL ,
	[cust_id] [varchar] (50) NOT NULL ,
	[table_type] [int] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_TS_Det]    Script Date: 2004-12-23 22:14:16 ******/
CREATE TABLE [dbo].[Proj_TS_Det] (
	[Ts_Id] [int] IDENTITY (1, 1) NOT NULL ,
	[Ts_Proj_Id] [varchar] (255) NULL ,
	[Ts_ProjEvent] [int] NULL ,
	[Ts_UserLogin] [varchar] (255) NULL ,
	[Ts_Hrs] [int] NULL ,
	[Ts_Status] [varchar] (255) NULL ,
	[Ts_CAFStatus_User] [varchar] (255) NULL ,
	[Ts_CAFStatus_Confirm] [varchar] (255) NULL ,
	[Ts_Date] [datetime] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[SLA_Category]    Script Date: 2004-12-23 22:14:16 ******/
CREATE TABLE [dbo].[SLA_Category] (
	[SLC_ID] [int] IDENTITY (0, 1) NOT NULL ,
	[SLA_ID] [int] NOT NULL ,
	[SLC_CDesc] [varchar] (255) NULL ,
	[SLC_EDesc] [varchar] (255) NULL ,
	[SLC_CDate] [datetime] NULL ,
	[SLC_CUser] [varchar] (255) NULL ,
	[SLC_MDate] [datetime] NULL ,
	[SLC_MUser] [varchar] (255) NULL ,
	[SLC_Parent] [int] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[custConfigRow]    Script Date: 2004-12-23 22:14:16 ******/
CREATE TABLE [dbo].[custConfigRow] (
	[table_id] [int] NOT NULL ,
	[row_id] [int] IDENTITY (1, 1) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[KB]    Script Date: 2004-12-23 22:14:17 ******/
CREATE TABLE [dbo].[KB] (
	[Id] [int] IDENTITY (1, 1) NOT NULL ,
	[SLC_ID] [int] NOT NULL ,
	[CustomerId] [varchar] (50) NULL ,
	[OriginalCustomerId] [varchar] (50) NULL ,
	[CM_ID] [int] NULL ,
	[Subject] [varchar] (255) NOT NULL ,
	[ProblemDesc] [varchar] (800) NULL ,
	[Solution] [text] NOT NULL ,
	[Keyword] [varchar] (255) NULL ,
	[ProblemAttachGroupId] [char] (32) NOT NULL ,
	[SolutionAttachGroupId] [char] (32) NOT NULL ,
	[Published] [bit] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[SLA_Priority]    Script Date: 2004-12-23 22:14:17 ******/
CREATE TABLE [dbo].[SLA_Priority] (
	[SLP_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[SLC_ID] [int] NOT NULL ,
	[SLP_CDesc] [varchar] (255) NULL ,
	[SLP_EDesc] [varchar] (255) NULL ,
	[SLP_ResTime] [int] NULL ,
	[SLP_SolTime] [int] NULL ,
	[SLP_ClsTime] [int] NULL ,
	[SLP_CDate] [datetime] NULL ,
	[SLP_CUser] [varchar] (255) NULL ,
	[SLP_MDate] [datetime] NULL ,
	[SLP_MUser] [varchar] (255) NULL ,
	[SLP_WResTime] [int] NULL ,
	[SLP_WSolTime] [int] NULL ,
	[SLP_WClsTime] [int] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[custConfigItem]    Script Date: 2004-12-23 22:14:17 ******/
CREATE TABLE [dbo].[custConfigItem] (
	[row_id] [int] NOT NULL ,
	[column_id] [int] NOT NULL ,
	[content] [varchar] (800) NOT NULL ,
	[item_id] [int] IDENTITY (1, 1) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Call_Master]    Script Date: 2004-12-23 22:14:17 ******/
CREATE TABLE [dbo].[Call_Master] (
	[CM_ID] [int] IDENTITY (0, 1) NOT NULL ,
	[CM_Company_ID] [varchar] (50) NULL ,
	[CM_Contact_ID] [varchar] (255) NULL ,
	[CM_Type] [varchar] (20) NULL ,
	[CM_Type2] [varchar] (20) NULL ,
	[SLC_ID] [int] NULL ,
	[SLP_ID] [int] NULL ,
	[CM_Subject] [varchar] (255) NULL ,
	[CM_Desc] [varchar] (800) NULL ,
	[CM_Status] [int] NULL ,
	[CM_Assigned_Party] [varchar] (50) NULL ,
	[CM_Assigned_User] [varchar] (255) NULL ,
	[CM_Accepted_Date] [datetime] NULL ,
	[CM_Target_Date] [datetime] NULL ,
	[CM_Solved_Date] [datetime] NULL ,
	[CM_Closed_Date] [datetime] NULL ,
	[AttachmentID] [char] (32) NULL ,
	[CM_Customer] [varchar] (255) NULL ,
	[CM_Contact] [varchar] (255) NULL ,
	[CM_Tele_Code] [varchar] (255) NULL ,
	[CM_Email] [varchar] (255) NULL ,
	[CM_Fax] [varchar] (255) NULL ,
	[CM_Mobile_Code] [varchar] (255) NULL ,
	[CM_Province] [varchar] (255) NULL ,
	[CM_CDate] [datetime] NULL ,
	[CM_CUser] [varchar] (255) NULL ,
	[CM_MDate] [datetime] NULL ,
	[CM_MUser] [varchar] (255) NULL ,
	[Response_date] [datetime] NULL ,
	[solved_date] [datetime] NULL ,
	[closed_date] [datetime] NULL ,
	[solved_user] [varchar] (255) NULL ,
	[sum_cost] [float] NOT NULL ,
	[ticket_number] [char] (9) NOT NULL ,
	[request_type] [int] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[CM_Action_History]    Script Date: 2004-12-23 22:14:18 ******/
CREATE TABLE [dbo].[CM_Action_History] (
	[CMAH_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[CM_ID] [int] NOT NULL ,
	[CMAH_Type] [int] NULL ,
	[CMAH_Subject] [varchar] (255) NULL ,
	[CMAH_Desc] [varchar] (800) NULL ,
	[CMAH_Attachment_ID] [char] (32) NULL ,
	[CMAH_Cost] [float] NULL ,
	[CMAH_Operator] [varchar] (255) NULL ,
	[CMAH_Date] [datetime] NULL ,
	[CMAH_CDate] [datetime] NULL ,
	[CMAH_CUser] [varchar] (255) NULL ,
	[CMAH_MDate] [datetime] NULL ,
	[CMAH_MUser] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[CM_History]    Script Date: 2004-12-23 22:14:18 ******/
CREATE TABLE [dbo].[CM_History] (
	[CMAH_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[CM_ID] [int] NULL ,
	[new_Party_ID] [varchar] (50) NULL ,
	[new_User_Login_ID] [varchar] (255) NULL ,
	[CMAH_Desc] [varchar] (255) NULL ,
	[CMAH_CDate] [datetime] NULL ,
	[CMAH_CUser] [varchar] (255) NULL ,
	[old_party_id] [varchar] (50) NULL ,
	[old_user_login_id] [varchar] (255) NULL ,
	[old_request_type] [int] NULL ,
	[new_reqeust_type] [int] NULL ,
	[old_priority] [int] NULL ,
	[new_priority] [int] NULL ,
	[CMAH_MDate] [datetime] NULL ,
	[CMAH_MUser] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[CM_Status_History]    Script Date: 2004-12-23 22:14:18 ******/
CREATE TABLE [dbo].[CM_Status_History] (
	[CMSH_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[CMAH_ID] [int] NOT NULL ,
	[CMSH_Status_Old] [int] NULL ,
	[CMSH_Status_New] [int] NULL ,
	[CMSH_Desc] [varchar] (255) NULL ,
	[CMSH_CDate] [datetime] NULL ,
	[CMSH_CUser] [varchar] (255) NULL ,
	[CMSH_MDate] [datetime] NULL ,
	[CMSH_MUser] [varchar] (255) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ACTION_TYPE] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACTION_TYPE] PRIMARY KEY  CLUSTERED 
	(
		[ActionId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Attachment] WITH NOCHECK ADD 
	CONSTRAINT [PK_Attachment] PRIMARY KEY  CLUSTERED 
	(
		[Attach_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Call_Type] WITH NOCHECK ADD 
	CONSTRAINT [PK_Call_Type] PRIMARY KEY  CLUSTERED 
	(
		[type]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Currency] WITH NOCHECK ADD 
	CONSTRAINT [PK_Currency] PRIMARY KEY  CLUSTERED 
	(
		[Curr_Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CustConfigTableType] WITH NOCHECK ADD 
	CONSTRAINT [PK_tableType] PRIMARY KEY  CLUSTERED 
	(
		[type_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ExpenseType] WITH NOCHECK ADD 
	CONSTRAINT [PK_ExpenseType] PRIMARY KEY  CLUSTERED 
	(
		[EType_Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[MODULE] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[MODULE_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[MODULE_GROUP] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[MODULE_GROUP_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PARTY_RELATIONSHIP_TYPE] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[RELATIONSHIP_TYPE_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PARTY_TYPE] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[PARTY_TYPE_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Party_Responsibility_Type] WITH NOCHECK ADD 
	CONSTRAINT [PK_Party_Responsibility_Type] PRIMARY KEY  CLUSTERED 
	(
		[TypeId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ProjEvent] WITH NOCHECK ADD 
	CONSTRAINT [PK_ProjEvent] PRIMARY KEY  CLUSTERED 
	(
		[PEvent_Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ProjEventType] WITH NOCHECK ADD 
	CONSTRAINT [PK_ProjEventType] PRIMARY KEY  CLUSTERED 
	(
		[PET_Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ROLE_TYPE] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[ROLE_TYPE_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[SECURITY_GROUP] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[GROUP_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[SECURITY_PERMISSION] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[PERMISSION_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[USER_LOGIN] WITH NOCHECK ADD 
	CONSTRAINT [PK__USER_LOGIN__0A9D95DB] PRIMARY KEY  CLUSTERED 
	(
		[USER_LOGIN_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[MODULE_GROUP_ASSOCIATE] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[MODULE_GROUP_ID],
		[MODULE_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PARTY] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[PARTY_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Request_Type] WITH NOCHECK ADD 
	CONSTRAINT [PK_Request_Type] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[SECURITY_GROUP_PERMISSION] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[GROUP_ID],
		[PERMISSION_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Status_Type] WITH NOCHECK ADD 
	CONSTRAINT [PK_Status_Type] PRIMARY KEY  CLUSTERED 
	(
		[status_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[USER_LOGIN_MODULE_GROUP] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[USER_LOGIN_ID],
		[MODULE_GROUP_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[USER_LOGIN_SECURITY_GROUP] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[USER_LOGIN_ID],
		[GROUP_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[custConfigColumn] WITH NOCHECK ADD 
	CONSTRAINT [PK_custColumn] PRIMARY KEY  CLUSTERED 
	(
		[column_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PARTY_RELATIONSHIP] WITH NOCHECK ADD 
	CONSTRAINT [PK_PARTY_RELATIONSHIP] PRIMARY KEY  CLUSTERED 
	(
		[PARTY_FROM_ID],
		[PARTY_TO_ID],
		[ROLE_FROM_ID],
		[ROLE_TO_ID],
		[RELATIONSHIP_TYPE_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PARTY_ROLE] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[PARTY_ID],
		[ROLE_TYPE_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Party_Responsibility_User] WITH NOCHECK ADD 
	CONSTRAINT [PK_Party_Notify_User] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_Mstr] WITH NOCHECK ADD 
	CONSTRAINT [PK_Proj_Mstr] PRIMARY KEY  CLUSTERED 
	(
		[Proj_Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[SLA_MSTR] WITH NOCHECK ADD 
	CONSTRAINT [PK_SLA_MSTR] PRIMARY KEY  CLUSTERED 
	(
		[SLA_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[custConfigTable] WITH NOCHECK ADD 
	CONSTRAINT [PK_custConfigTable] PRIMARY KEY  CLUSTERED 
	(
		[table_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_TS_Det] WITH NOCHECK ADD 
	CONSTRAINT [PK_Proj_TS_Det] PRIMARY KEY  CLUSTERED 
	(
		[Ts_Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[SLA_Category] WITH NOCHECK ADD 
	CONSTRAINT [PK_SLA_Category] PRIMARY KEY  CLUSTERED 
	(
		[SLC_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[custConfigRow] WITH NOCHECK ADD 
	CONSTRAINT [PK_custConfigRow] PRIMARY KEY  CLUSTERED 
	(
		[row_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[KB] WITH NOCHECK ADD 
	CONSTRAINT [PK_KB] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[SLA_Priority] WITH NOCHECK ADD 
	CONSTRAINT [PK_SLA_Priority] PRIMARY KEY  CLUSTERED 
	(
		[SLP_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[custConfigItem] WITH NOCHECK ADD 
	CONSTRAINT [PK_custConfigItem] PRIMARY KEY  CLUSTERED 
	(
		[item_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Call_Master] WITH NOCHECK ADD 
	CONSTRAINT [PK_Call_Master] PRIMARY KEY  CLUSTERED 
	(
		[CM_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CM_Action_History] WITH NOCHECK ADD 
	CONSTRAINT [PK_CM_Comm_History] PRIMARY KEY  CLUSTERED 
	(
		[CMAH_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CM_History] WITH NOCHECK ADD 
	CONSTRAINT [PK_CM_Assign_History] PRIMARY KEY  CLUSTERED 
	(
		[CMAH_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CM_Status_History] WITH NOCHECK ADD 
	CONSTRAINT [PK_CM_Status_History] PRIMARY KEY  CLUSTERED 
	(
		[CMSH_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACTION_TYPE] ADD 
	CONSTRAINT [DF_ACTION_TYPE_ActionDisabled] DEFAULT (0) FOR [ActionDisabled]
GO

ALTER TABLE [dbo].[Attachment] ADD 
	CONSTRAINT [DF_Attachment_deleted] DEFAULT (0) FOR [deleted],
	CONSTRAINT [DF_Attachment_title] DEFAULT ('') FOR [title]
GO

ALTER TABLE [dbo].[CustConfigTableType] ADD 
	CONSTRAINT [DF_tableType_disabled] DEFAULT (0) FOR [disabled],
	CONSTRAINT [IX_CustConfigTableType] UNIQUE  NONCLUSTERED 
	(
		[type_name]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[USER_LOGIN] ADD 
	CONSTRAINT [DF_USER_LOGIN_locale] DEFAULT ('en') FOR [locale]
GO

ALTER TABLE [dbo].[Status_Type] ADD 
	CONSTRAINT [DF_Status_Type_status_disabled] DEFAULT (0) FOR [status_disabled],
	CONSTRAINT [DF_Status_Type_status_flag] DEFAULT (0) FOR [status_flag]
GO

ALTER TABLE [dbo].[custConfigColumn] ADD 
	CONSTRAINT [DF_custConfigColumn_column_type] DEFAULT (0) FOR [column_type]
GO

ALTER TABLE [dbo].[SLA_MSTR] ADD 
	CONSTRAINT [DF_SLA_MSTR_SLA_Active] DEFAULT ('N') FOR [SLA_Active]
GO

ALTER TABLE [dbo].[KB] ADD 
	CONSTRAINT [DF_KB_Published] DEFAULT (0) FOR [Published]
GO

ALTER TABLE [dbo].[custConfigItem] ADD 
	CONSTRAINT [IX_custConfigItem] UNIQUE  NONCLUSTERED 
	(
		[row_id],
		[column_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Call_Master] ADD 
	CONSTRAINT [DF_Call_Master_CM_Type] DEFAULT (1) FOR [CM_Type],
	CONSTRAINT [DF_Call_Master_SLC_id] DEFAULT (1) FOR [SLC_ID],
	CONSTRAINT [DF_Call_Master_sum_hour] DEFAULT (0) FOR [sum_cost],
	CONSTRAINT [DF_Call_Master_ticket_number] DEFAULT ('') FOR [ticket_number],
	CONSTRAINT [IX_Call_Master] UNIQUE  NONCLUSTERED 
	(
		[ticket_number]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[MODULE] ADD 
	CONSTRAINT [FK87DE9A6CF721B6BD] FOREIGN KEY 
	(
		[MODULE_PARENT_ID]
	) REFERENCES [dbo].[MODULE] (
		[MODULE_ID]
	)
GO

ALTER TABLE [dbo].[MODULE_GROUP_ASSOCIATE] ADD 
	CONSTRAINT [FK98E6854B1246F6E] FOREIGN KEY 
	(
		[MODULE_GROUP_ID]
	) REFERENCES [dbo].[MODULE_GROUP] (
		[MODULE_GROUP_ID]
	),
	CONSTRAINT [FK98E6854B4995ABCE] FOREIGN KEY 
	(
		[MODULE_ID]
	) REFERENCES [dbo].[MODULE] (
		[MODULE_ID]
	)
GO

ALTER TABLE [dbo].[PARTY] ADD 
	CONSTRAINT [FK48622C666B487C7] FOREIGN KEY 
	(
		[PARTY_TYPE_ID]
	) REFERENCES [dbo].[PARTY_TYPE] (
		[PARTY_TYPE_ID]
	)
GO

ALTER TABLE [dbo].[ProjEvent_ProjEventType] ADD 
	CONSTRAINT [FK_ProjEvent_ProjEventType_ProjEvent] FOREIGN KEY 
	(
		[PEvent_Id]
	) REFERENCES [dbo].[ProjEvent] (
		[PEvent_Id]
	),
	CONSTRAINT [FK_ProjEvent_ProjEventType_ProjEventType] FOREIGN KEY 
	(
		[PET_Id]
	) REFERENCES [dbo].[ProjEventType] (
		[PET_Id]
	)
GO

ALTER TABLE [dbo].[Request_Type] ADD 
	CONSTRAINT [FK_Request_Type_Call_Type] FOREIGN KEY 
	(
		[CallType]
	) REFERENCES [dbo].[Call_Type] (
		[type]
	)
GO

ALTER TABLE [dbo].[SECURITY_GROUP_PERMISSION] ADD 
	CONSTRAINT [FK98650ACE4CD4DEFB] FOREIGN KEY 
	(
		[GROUP_ID]
	) REFERENCES [dbo].[SECURITY_GROUP] (
		[GROUP_ID]
	),
	CONSTRAINT [FK98650ACE6466358B] FOREIGN KEY 
	(
		[PERMISSION_ID]
	) REFERENCES [dbo].[SECURITY_PERMISSION] (
		[PERMISSION_ID]
	)
GO

ALTER TABLE [dbo].[Status_Type] ADD 
	CONSTRAINT [FK_Status_Type_Call_Type] FOREIGN KEY 
	(
		[status_type]
	) REFERENCES [dbo].[Call_Type] (
		[type]
	)
GO

ALTER TABLE [dbo].[USER_LOGIN_MODULE_GROUP] ADD 
	CONSTRAINT [FKC614CF61246F6E] FOREIGN KEY 
	(
		[MODULE_GROUP_ID]
	) REFERENCES [dbo].[MODULE_GROUP] (
		[MODULE_GROUP_ID]
	),
	CONSTRAINT [FKC614CF6BDE0A7C5] FOREIGN KEY 
	(
		[USER_LOGIN_ID]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

ALTER TABLE [dbo].[USER_LOGIN_SECURITY_GROUP] ADD 
	CONSTRAINT [FKCDAF484A4CD4DEFB] FOREIGN KEY 
	(
		[GROUP_ID]
	) REFERENCES [dbo].[SECURITY_GROUP] (
		[GROUP_ID]
	),
	CONSTRAINT [FKCDAF484ABDE0A7C5] FOREIGN KEY 
	(
		[USER_LOGIN_ID]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

ALTER TABLE [dbo].[custConfigColumn] ADD 
	CONSTRAINT [FK_custConfigColumn_CustConfigTableType] FOREIGN KEY 
	(
		[table_type]
	) REFERENCES [dbo].[CustConfigTableType] (
		[type_id]
	)
GO

ALTER TABLE [dbo].[PARTY_RELATIONSHIP] ADD 
	CONSTRAINT [FK28ADD7112CD7E6A6] FOREIGN KEY 
	(
		[PARTY_TO_ID]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK28ADD7115BC03139] FOREIGN KEY 
	(
		[RELATIONSHIP_TYPE_ID]
	) REFERENCES [dbo].[PARTY_RELATIONSHIP_TYPE] (
		[RELATIONSHIP_TYPE_ID]
	),
	CONSTRAINT [FK28ADD7117620E957] FOREIGN KEY 
	(
		[PARTY_FROM_ID]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK28ADD71179A88F07] FOREIGN KEY 
	(
		[ROLE_FROM_ID]
	) REFERENCES [dbo].[ROLE_TYPE] (
		[ROLE_TYPE_ID]
	),
	CONSTRAINT [FK28ADD711C06D3856] FOREIGN KEY 
	(
		[ROLE_TO_ID]
	) REFERENCES [dbo].[ROLE_TYPE] (
		[ROLE_TYPE_ID]
	)
GO

ALTER TABLE [dbo].[PARTY_ROLE] ADD 
	CONSTRAINT [FK3B3FDA4F6A3C2D77] FOREIGN KEY 
	(
		[ROLE_TYPE_ID]
	) REFERENCES [dbo].[ROLE_TYPE] (
		[ROLE_TYPE_ID]
	),
	CONSTRAINT [FK3B3FDA4F758A0D34] FOREIGN KEY 
	(
		[PARTY_ID]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	)
GO

ALTER TABLE [dbo].[Party_Responsibility_User] ADD 
	CONSTRAINT [FK_Party_Responsibility_User_PARTY] FOREIGN KEY 
	(
		[Party_Id]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK_Party_Responsibility_User_Party_Responsibility_Type] FOREIGN KEY 
	(
		[TypeId]
	) REFERENCES [dbo].[Party_Responsibility_Type] (
		[TypeId]
	),
	CONSTRAINT [FK_Party_Responsibility_User_USER_LOGIN] FOREIGN KEY 
	(
		[User_Login_Id]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

ALTER TABLE [dbo].[Proj_Mstr] ADD 
	CONSTRAINT [FK_Proj_Mstr_PARTY] FOREIGN KEY 
	(
		[Cust_Id]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK_Proj_Mstr_PARTY1] FOREIGN KEY 
	(
		[Dep_Id]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK_Proj_Mstr_USER_LOGIN] FOREIGN KEY 
	(
		[Proj_PM_User]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

ALTER TABLE [dbo].[SLA_MSTR] ADD 
	CONSTRAINT [FK_SLA_MSTR_CUser] FOREIGN KEY 
	(
		[SLA_CUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK_SLA_MSTR_MUser] FOREIGN KEY 
	(
		[SLA_MUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK_SLA_MSTR_Party] FOREIGN KEY 
	(
		[SLA_Party]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	)
GO

ALTER TABLE [dbo].[custConfigTable] ADD 
	CONSTRAINT [FK_custConfigTable_CustConfigTableType1] FOREIGN KEY 
	(
		[table_type]
	) REFERENCES [dbo].[CustConfigTableType] (
		[type_id]
	),
	CONSTRAINT [FK_custConfigTable_PARTY] FOREIGN KEY 
	(
		[cust_id]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	)
GO

ALTER TABLE [dbo].[Proj_TS_Det] ADD 
	CONSTRAINT [FK_Proj_TS_Det_Proj_Mstr] FOREIGN KEY 
	(
		[Ts_Proj_Id]
	) REFERENCES [dbo].[Proj_Mstr] (
		[Proj_Id]
	),
	CONSTRAINT [FK_Proj_TS_Det_ProjEvent] FOREIGN KEY 
	(
		[Ts_ProjEvent]
	) REFERENCES [dbo].[ProjEvent] (
		[PEvent_Id]
	),
	CONSTRAINT [FK_Proj_TS_Det_USER_LOGIN] FOREIGN KEY 
	(
		[Ts_UserLogin]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

ALTER TABLE [dbo].[SLA_Category] ADD 
	CONSTRAINT [FK_SLA_Category_CUser] FOREIGN KEY 
	(
		[SLC_CUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK_SLA_Category_MUser] FOREIGN KEY 
	(
		[SLC_MUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK_SLA_Category_SLA_Category] FOREIGN KEY 
	(
		[SLC_Parent]
	) REFERENCES [dbo].[SLA_Category] (
		[SLC_ID]
	),
	CONSTRAINT [FK_SLA_Category_SLA_MSTR] FOREIGN KEY 
	(
		[SLA_ID]
	) REFERENCES [dbo].[SLA_MSTR] (
		[SLA_ID]
	)
GO

ALTER TABLE [dbo].[custConfigRow] ADD 
	CONSTRAINT [FK_custConfigRow_custConfigTable] FOREIGN KEY 
	(
		[table_id]
	) REFERENCES [dbo].[custConfigTable] (
		[table_id]
	)
GO

ALTER TABLE [dbo].[KB] ADD 
	CONSTRAINT [FK_KB_PARTY] FOREIGN KEY 
	(
		[CustomerId]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK_KB_PARTY1] FOREIGN KEY 
	(
		[OriginalCustomerId]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK_KB_SLA_Category] FOREIGN KEY 
	(
		[SLC_ID]
	) REFERENCES [dbo].[SLA_Category] (
		[SLC_ID]
	)
GO

ALTER TABLE [dbo].[SLA_Priority] ADD 
	CONSTRAINT [FK_SLA_Priority_CUser] FOREIGN KEY 
	(
		[SLP_CUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK_SLA_Priority_MUser] FOREIGN KEY 
	(
		[SLP_MUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK_SLA_Priority_SLA_Category] FOREIGN KEY 
	(
		[SLC_ID]
	) REFERENCES [dbo].[SLA_Category] (
		[SLC_ID]
	)
GO

ALTER TABLE [dbo].[custConfigItem] ADD 
	CONSTRAINT [FK_custConfigItem_custConfigColumn] FOREIGN KEY 
	(
		[column_id]
	) REFERENCES [dbo].[custConfigColumn] (
		[column_id]
	),
	CONSTRAINT [FK_custConfigItem_custConfigRow] FOREIGN KEY 
	(
		[row_id]
	) REFERENCES [dbo].[custConfigRow] (
		[row_id]
	)
GO

ALTER TABLE [dbo].[Call_Master] ADD 
	CONSTRAINT [FK_Call_Master_Call_Type] FOREIGN KEY 
	(
		[CM_Type]
	) REFERENCES [dbo].[Call_Type] (
		[type]
	) ON UPDATE CASCADE ,
	CONSTRAINT [FK_Call_Master_Company] FOREIGN KEY 
	(
		[CM_Company_ID]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK_Call_Master_Contact] FOREIGN KEY 
	(
		[CM_Contact_ID]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK_Call_Master_PARTY] FOREIGN KEY 
	(
		[CM_Assigned_Party]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK_Call_Master_Request_Type] FOREIGN KEY 
	(
		[request_type]
	) REFERENCES [dbo].[Request_Type] (
		[Id]
	),
	CONSTRAINT [FK_Call_Master_SLA_Category] FOREIGN KEY 
	(
		[SLC_ID]
	) REFERENCES [dbo].[SLA_Category] (
		[SLC_ID]
	),
	CONSTRAINT [FK_Call_Master_SLA_Priority] FOREIGN KEY 
	(
		[SLP_ID]
	) REFERENCES [dbo].[SLA_Priority] (
		[SLP_ID]
	),
	CONSTRAINT [FK_Call_Master_USER_LOGIN] FOREIGN KEY 
	(
		[CM_Assigned_User]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK_Call_Master_USER_LOGIN1] FOREIGN KEY 
	(
		[solved_user]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK_Call_Master_User1] FOREIGN KEY 
	(
		[CM_CUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK_Call_Master_User2] FOREIGN KEY 
	(
		[CM_MUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

ALTER TABLE [dbo].[CM_Action_History] ADD 
	CONSTRAINT [FK_CM_Action_History_ACTION_TYPE] FOREIGN KEY 
	(
		[CMAH_Type]
	) REFERENCES [dbo].[ACTION_TYPE] (
		[ActionId]
	),
	CONSTRAINT [FK_CM_Action_History_Call_Master] FOREIGN KEY 
	(
		[CM_ID]
	) REFERENCES [dbo].[Call_Master] (
		[CM_ID]
	),
	CONSTRAINT [FK_CM_Action_History_USER_LOGIN] FOREIGN KEY 
	(
		[CMAH_Operator]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK_CM_Action_History_USER_LOGIN1] FOREIGN KEY 
	(
		[CMAH_CUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK_CM_Action_History_USER_LOGIN2] FOREIGN KEY 
	(
		[CMAH_MUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

ALTER TABLE [dbo].[CM_History] ADD 
	CONSTRAINT [FK_CM_History_Call_Master] FOREIGN KEY 
	(
		[CM_ID]
	) REFERENCES [dbo].[Call_Master] (
		[CM_ID]
	),
	CONSTRAINT [FK_CM_History_PARTY] FOREIGN KEY 
	(
		[old_party_id]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK_CM_History_PARTY1] FOREIGN KEY 
	(
		[new_Party_ID]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK_CM_History_SLA_Category] FOREIGN KEY 
	(
		[old_request_type]
	) REFERENCES [dbo].[SLA_Category] (
		[SLC_ID]
	),
	CONSTRAINT [FK_CM_History_SLA_Category1] FOREIGN KEY 
	(
		[new_reqeust_type]
	) REFERENCES [dbo].[SLA_Category] (
		[SLC_ID]
	),
	CONSTRAINT [FK_CM_History_SLA_Priority] FOREIGN KEY 
	(
		[old_priority]
	) REFERENCES [dbo].[SLA_Priority] (
		[SLP_ID]
	),
	CONSTRAINT [FK_CM_History_SLA_Priority1] FOREIGN KEY 
	(
		[new_priority]
	) REFERENCES [dbo].[SLA_Priority] (
		[SLP_ID]
	),
	CONSTRAINT [FK_CM_History_USER_LOGIN] FOREIGN KEY 
	(
		[new_User_Login_ID]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK_CM_History_USER_LOGIN1] FOREIGN KEY 
	(
		[old_user_login_id]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK_CM_History_USER_LOGIN2] FOREIGN KEY 
	(
		[CMAH_CUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK_CM_History_USER_LOGIN3] FOREIGN KEY 
	(
		[CMAH_MUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

ALTER TABLE [dbo].[CM_Status_History] ADD 
	CONSTRAINT [FK_CM_Status_History_CM_Action_History] FOREIGN KEY 
	(
		[CMAH_ID]
	) REFERENCES [dbo].[CM_Action_History] (
		[CMAH_ID]
	),
	CONSTRAINT [FK_CM_Status_History_User] FOREIGN KEY 
	(
		[CMSH_CUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK_CM_Status_History_User1] FOREIGN KEY 
	(
		[CMSH_MUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.fn_addblank    Script Date: 2004-12-23 22:14:18 ******/

CREATE PROCEDURE fn_addblank 
	@schk varchar(255),@nreturn int=161
AS
declare @stmp varchar(255),@nlen int,@i int
exec @nlen=fn_getstrlen @schk
if @nlen>@nreturn
	select @stmp=substring(@schk,1,@nreturn)
else
begin
	select @stmp=@stmp+space(@nreturn-@nlen)
end
select @stmp
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.fn_getstrlen    Script Date: 2004-12-23 22:14:18 ******/

CREATE PROCEDURE fn_getstrlen 
	@schk varchar(255)
AS
declare @ntmp int,@nlen int,@i int
select @nlen=len(@schk),@i=1,@ntmp=0
while @i<=@nlen
begin
	if convert(int,substring(convert(varbinary,substring(@schk ,@i,1)),1,1))>127 
		select @ntmp=@ntmp+2
	else
		select @ntmp=@ntmp+1
	select @i=@i+1
end
--select @ntmp
return @ntmp
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.sp_insertrecord    Script Date: 2004-12-23 22:14:18 ******/

CREATE PROCEDURE sp_insertrecord	--插入警报记录
	 @subject varchar(255),@asparty varchar(50),@asuser varchar(255),@cmid int,@restime datetime,@soltime datetime,@clstime datetime,
	@name varchar(255),@status int,@statustype varchar(20),@ticket char(9),@accepttime datetime,@slpdesc varchar(255),@reparty varchar(50),@reuser varchar(255),
	@seq int output,@curtype int
AS
DECLARE @L1 int,@L2 int,@L3 int,@L4 int,@L5 int,@L6 int,@L7 int,@L8 int
DECLARE @C1 char(13),@C2 char(12),@C3 char(40),@C4 char(20),@C5 char(20),@C6 char(10),@C7 char(20),@C8 char(12)
SELECT @L1=13,@L2=12,@L3=40,@L4=20,@L5=20,@L6=10,@L7=20,@L8=12

if @seq=0  /*当前party该类型第一条告警信息,初始化表头记录*/
begin
	insert into ##mailsend values(@curtype,1,' ')
	insert into ##mailsend values(@curtype,2,'Out off Warning '+case when @curtype=1 then 'Response' when @curtype=2 then 'Solved' else 'Closed' end+' time:')
	insert into ##mailsend values(@curtype,3,' ')
	insert into ##mailsend values(@curtype,4,CONVERT(CHAR(13),'Ticket Number')+'  '+
						CONVERT(CHAR(12),'Request Date')+'  '+
						CONVERT(CHAR(40),'Description')+'  '+
						CONVERT(CHAR(20),'Assignee')+'  '+
						CONVERT(CHAR(20),'Requestor')+'  '+
						CONVERT(CHAR(10),'Due Date')+'  '+
						CONVERT(CHAR(20),'Priority')+'  '+
						CONVERT(CHAR(12),'out-off days'))	
	insert into ##mailsend values(@curtype,5,replace(space(@L1),' ','-')+'  '+
						replace(space(@L2),' ','-')+'  '+
						replace(space(@L3),' ','-')+'  '+
						replace(space(@L4),' ','-')+'  '+
						replace(space(@L5),' ','-')+'  '+
						replace(space(@L6),' ','-')+'  '+
						replace(space(@L7),' ','-')+'  '+
						replace(space(@L8),' ','-'))
	select @seq=6
end
/*正式插入警报记录*/
select @C1=@ticket,@C2=CONVERT(CHAR(10),@accepttime,120),@C3=@subject,@C4=@asparty+'-'+@asuser,@C5=@reparty+'-'+@reuser,@C7=@slpdesc
select @C6=convert(char(10),case when @curtype=1 then @restime when @curtype=2 then @soltime else @clstime end,120)
select @C8=str(case when @curtype=1 then DATEDIFF(day,@restime, getdate()) when @curtype=2 then  DATEDIFF(day,@soltime,getdate()) else  DATEDIFF(day,@clstime,getdate()) end)
insert into ##mailsend values(@curtype,@seq,@C1+'  '+@C2+'  '+@C3+'  '+@C4+'  '+@C5+'  '+@C6+'  '+@C7+'  '+@C8)
select @seq=@seq+1
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.sp_getWarningNotifyEmail    Script Date: 2004-12-23 22:14:18 ******/

CREATE PROCEDURE sp_getWarningNotifyEmail  --获得当前party的联系人mail地址
	@partyid varchar(50), @allemail varchar(5000) OUTPUT
AS
declare @email varchar(255),@ncount int
select @ncount=0,@allemail=''
declare #linkman cursor for 
select email_addr from user_login,party_responsibility_user u where u.party_id=@partyid AND u.typeId='B' AND u.user_login_id=user_login.user_login_id AND NOT(email_addr IS NULL)
open #linkman
fetch #linkman into  @email
while @@fetch_status=0
begin	
	if @ncount>0  select @allemail=@allemail+";" 
	select @allemail=@allemail+rtrim(@email)
	select @ncount=@ncount+1
	
	fetch #linkman into @email
end
close #linkman
deallocate #linkman
if (@ncount=0) select @allemail = null
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.sp_dailyemail    Script Date: 2004-12-23 22:14:18 ******/


CREATE  PROCEDURE sp_dailyemail AS
DECLARE @partyid varchar(50),@email varchar(5000)
DECLARE @subject varchar(255),@asparty varchar(50),@asuser varchar(255),@cmid int,@restime datetime,@soltime datetime,@clstime datetime,
	@name varchar(255),@status int,@statustype varchar(20),@ticket char(9),@accepttime datetime,@slpdesc varchar(255),@reparty varchar(50),@reuser varchar(255)
DECLARE @stitle varchar(100),@sfrom varchar(50)
DECLARE @tablename varchar(50),@tableresult varchar(50)
DECLARE @resstatus int,@solstatus int,@clostatus int    /*状态的标准level*/
DECLARE @resseq int,@solseq int,@closeq int               /*当前party的3种状态的seq*/
DECLARE @curtype int  					/*当前处理的call需要警报的类型*/

DECLARE @sformat varchar(200)
DECLARE @cursit int,@ncurlen  int
DECLARE @ptrval binary(16)
DECLARE @stmp CHAR(161)

/*建立临时table*/
select @tablename='##mailsend'
Select @tableresult=name from sysobjects where name =@tablename
if @tableresult<>null drop table ##mailsend
CREATE TABLE ##mailsend (type int,seqno int,detail text)
CREATE TABLE ##formatmail(detail text)
INSERT INTO ##formatmail values('')

/*根据部门发信*/
declare #party cursor for
	SELECT party.party_id from party
open #party
fetch #party into  @partyid
while @@fetch_status=0
begin
	/*初始化*/
	insert into ##mailsend values (0,1,'Dear All,')
	insert into ##mailsend values (0,2,'    The following calls will be out of expected warning period range.')
	select @stitle='Help Desk Warning which are out off targeted warning period'
	select @sfrom='Helpdesk System'

	SET NOCOUNT ON
	exec sp_getWarningNotifyEmail @partyid, @email OUTPUT /*获得所有联系人的email*/
	if NOT @email is null begin
		select @resseq=0,@solseq=0,@closeq=0
		declare #call cursor for
		select CM_SUBJECT,isnull(CM_Assigned_Party,party_id) as CM_Assigned_Party ,isnull(CM_Assigned_user,cm_cuser) as CM_Assigned_user,cm_id
			,CM_Target_Date as resttime ,CM_Solved_Date as soltime,CM_Closed_Date as clstime,name,status_level,cm_type,ticket_number
			,cm_accepted_date,slp_edesc,isnull(CM_customer,cm_company_id) as CM_customer ,isnull(CM_contact,cm_contact_id) as CM_contact
			from call_master left join sla_priority on (call_master.slp_id=sla_priority.slp_id),user_login,status_type where user_login_id=cm_cuser and
			(CM_Assigned_Party=@partyid or (ISNULL(CM_Assigned_Party,party_id)=@partyid) ) and Status_id=cm_status order by cm_id
		open #call
		fetch #call into  @subject,@asparty,@asuser,@cmid,@restime,@soltime,@clstime,@name,@status,@statustype,@ticket,@accepttime,@slpdesc,@reparty,@reuser
		while @@fetch_status=0
		begin
			/*获得当前call的标准三个状态的level*/
			select @resstatus=status_level from status_type where status_type=@statustype and status_flag=1
			select @solstatus=status_level from status_type where status_type=@statustype and status_flag=2
			select @clostatus=status_level from status_type where status_type=@statustype and status_flag=3
			select @curtype=0
			
			if @status<@resstatus and @restime<>null  and @restime<getdate()   
			begin
				select @curtype=1 --尚未响应
				exec sp_insertrecord  @subject,@asparty,@asuser,@cmid,@restime,@soltime,@clstime,@name,@status,@statustype,@ticket,
					@accepttime,@slpdesc,@reparty,@reuser,@resseq output,@curtype	
			end
			if @status<@solstatus and @soltime<>null  and @soltime<getdate()    --select @curtype=2 --尚未解决
			begin
				select @curtype=2 --尚未解决
				exec sp_insertrecord  @subject,@asparty,@asuser,@cmid,@restime,@soltime,@clstime,@name,@status,@statustype,@ticket,
					@accepttime,@slpdesc,@reparty,@reuser,@solseq output,@curtype	
			end
			if @status<@clostatus and @clstime<>null  and @clstime<getdate()    --select @curtype=3 --尚未关闭
			begin
				select @curtype=3 --尚未关闭
				exec sp_insertrecord  @subject,@asparty,@asuser,@cmid,@restime,@soltime,@clstime,@name,@status,@statustype,@ticket,
					@accepttime,@slpdesc,@reparty,@reuser,@closeq output,@curtype	
			end
			
			fetch #call into  @subject,@asparty,@asuser,@cmid,@restime,@soltime,@clstime,@name,@status,@statustype,@ticket,@accepttime,@slpdesc,@reparty,@reuser
		end
		close #call
		deallocate #call
	
		SET NOCOUNT Off
		if @resseq>0 or @solseq>0 or @closeq>0
		begin
			insert into ##mailsend values (4,1,' ')
			insert into ##mailsend values (4,2,'Please check it!')
	--		select detail from ##mailsend order by type,seqno
			
			delete from ##formatmail
			INSERT INTO ##formatmail values('')
			select @cursit=0
			declare #format cursor for
				SELECT detail from ##mailsend order by type,seqno
			open #format
			fetch #format into  @sformat
			while @@fetch_status=0
			begin
				select @sformat=@sformat+char(13)
				select @ncurlen=len(@sformat)
				
				SELECT @ptrval = TEXTPTR(detail) FROM ##formatmail 
				UPDATETEXT ##formatmail.detail @ptrval @cursit 0 @sformat
				--select @sformat
				--select @ncurlen
				--select * from ##formatmail
				select @cursit=@cursit+@ncurlen
				--update ##formatmail set detail=detail+rtrim(@sformat)
				fetch #format into @sformat
			end
			close #format
			deallocate #format
			--select * from ##formatmail
			--exec master.dbo.xp_sendmail @recipients =@email, @subject = @stitle, @query='select detail from ##mailsend order by type,seqno', @no_header= 'TRUE'
			exec master.dbo.xp_sendmail @recipients =@email, @subject = @stitle, @query='select detail from ##formatmail', @no_header= 'TRUE',@width =500000
	
		end
	end
	delete from ##mailsend
	fetch #party into  @partyid
end
close #party
deallocate #party
drop table ##mailsend
drop table ##formatmail
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Trigger dbo.tI_CallType    Script Date: 2004-12-23 22:14:18 ******/
/****** Object:  Trigger dbo.tI_STOK    Script Date: 2001/3/6 PM 04:41:49 ******/
CREATE  trigger tI_CallType on dbo.Call_Type for INSERT as
declare @i_type varchar(20)
declare #1 cursor for select type from inserted
open #1
fetch #1 into @i_type
while @@fetch_status=0
begin
    insert into Status_Type(status_type,status_level,status_disabled,status_desc,status_flag)
	values(@i_type,1,0,'RESPONSE',1)
    insert into Status_Type(status_type,status_level,status_disabled,status_desc,status_flag)
	values(@i_type,2,0,'SOLVED',2)
    insert into Status_Type(status_type,status_level,status_disabled,status_desc,status_flag)
	values(@i_type,3,0,'CLOSED',3)
   /* INSERT stokWORK(s_pos,s_code) VALUES(@s_pos, @s_code)*/
    fetch #1 into @i_type
end
close #1
deallocate #1

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

