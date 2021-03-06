if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKE07CBFA3F99082D8]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ACTION_TYPE] DROP CONSTRAINT FKE07CBFA3F99082D8
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_Call_Type]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_Call_Type
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK11EE7B636109660F]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK11EE7B636109660F
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Request_Type_Call_Type]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Request_Type] DROP CONSTRAINT FK_Request_Type_Call_Type
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK576B5F2AF99082D8]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Request_Type] DROP CONSTRAINT FK576B5F2AF99082D8
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKD6EB5994224BF011]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Cost_Mstr] DROP CONSTRAINT FKD6EB5994224BF011
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKD0CC7F2BA6543D0B]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[custConfigColumn] DROP CONSTRAINT FKD0CC7F2BA6543D0B
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_custConfigTable_CustConfigTableType1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[custConfigTable] DROP CONSTRAINT FK_custConfigTable_CustConfigTableType1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKFF634159A6543D0B]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[custConfigTable] DROP CONSTRAINT FKFF634159A6543D0B
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKA742F7EFB328D67D]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Exp_Det] DROP CONSTRAINT FKA742F7EFB328D67D
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKC8504630BBA859C0]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_CTC] DROP CONSTRAINT FKC8504630BBA859C0
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKC85076FDBBA859C0]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_PTC] DROP CONSTRAINT FKC85076FDBBA859C0
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

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_Company]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_Company
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_PARTY]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_PARTY
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK11EE7B6341E32732]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK11EE7B6341E32732
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK11EE7B639DF399AA]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK11EE7B639DF399AA
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKAED6219FDF7B242C]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FKAED6219FDF7B242C
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKAED6219FEAD660F3]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FKAED6219FEAD660F3
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_custConfigTable_PARTY]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[custConfigTable] DROP CONSTRAINT FK_custConfigTable_PARTY
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKFF634159433AA687]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[custConfigTable] DROP CONSTRAINT FKFF634159433AA687
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK9571892E5B9]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[KB] DROP CONSTRAINT FK9571892E5B9
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK9573467DA6A]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[KB] DROP CONSTRAINT FK9573467DA6A
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK28ADD7112CD7E6A6]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PARTY_RELATIONSHIP] DROP CONSTRAINT FK28ADD7112CD7E6A6
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK28ADD7117620E957]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PARTY_RELATIONSHIP] DROP CONSTRAINT FK28ADD7117620E957
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK8438C4634ABE0554]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Party_Responsibility_User] DROP CONSTRAINT FK8438C4634ABE0554
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK3B3FDA4F758A0D34]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PARTY_ROLE] DROP CONSTRAINT FK3B3FDA4F758A0D34
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK41BD8646433AA687]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Mstr] DROP CONSTRAINT FK41BD8646433AA687
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK41BD8646B0683F4B]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Mstr] DROP CONSTRAINT FK41BD8646B0683F4B
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_MSTR_Party]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_MSTR] DROP CONSTRAINT FK_SLA_MSTR_Party
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKD6A51F7B216DBD0F]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_MSTR] DROP CONSTRAINT FKD6A51F7B216DBD0F
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKC672F9D5758A0D34]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[USER_LOGIN] DROP CONSTRAINT FKC672F9D5758A0D34
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK28ADD7115BC03139]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[PARTY_RELATIONSHIP] DROP CONSTRAINT FK28ADD7115BC03139
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProjEvent_ProjEventType_ProjEventType]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProjEvent_ProjEventType] DROP CONSTRAINT FK_ProjEvent_ProjEventType_ProjEventType
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKD6EB5994368F3A]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Cost_Mstr] DROP CONSTRAINT FKD6EB5994368F3A
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK41BD8646CA5D36DC]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Mstr] DROP CONSTRAINT FK41BD8646CA5D36DC
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK4061911DA04]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProjEvent] DROP CONSTRAINT FK4061911DA04
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

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK11EE7B6342464587]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK11EE7B6342464587
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK654FF1BCB9112BD3]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Status_History] DROP CONSTRAINT FK654FF1BCB9112BD3
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK654FF1BCB911305A]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Status_History] DROP CONSTRAINT FK654FF1BCB911305A
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK3A511C00FB5840C8]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Action_History] DROP CONSTRAINT FK3A511C00FB5840C8
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKD299DD35D12E979D]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_TS_Det] DROP CONSTRAINT FKD299DD35D12E979D
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK7C3F5CCDD12E979D]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_TS_Forecast_Det] DROP CONSTRAINT FK7C3F5CCDD12E979D
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ProjEvent_ProjEventType_ProjEvent]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ProjEvent_ProjEventType] DROP CONSTRAINT FK_ProjEvent_ProjEventType_ProjEvent
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK9B93D723E6A8235A]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Cost_Det] DROP CONSTRAINT FK9B93D723E6A8235A
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_Request_Type]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_Request_Type
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK11EE7B634DAE96EA]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK11EE7B634DAE96EA
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK1C935439A82A454]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Attachment] DROP CONSTRAINT FK1C935439A82A454
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

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK11EE7B637CBFF8AF]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK11EE7B637CBFF8AF
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK11EE7B63BF237A99]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK11EE7B63BF237A99
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK11EE7B63BFB065A3]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK11EE7B63BFB065A3
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK11EE7B63CC297FC5]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK11EE7B63CC297FC5
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK11EE7B63D38E8487]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK11EE7B63D38E8487
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK3A511C006EAFF700]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Action_History] DROP CONSTRAINT FK3A511C006EAFF700
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK3A511C006F3CE20A]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Action_History] DROP CONSTRAINT FK3A511C006F3CE20A
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKAED6219F6EAFF700]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FKAED6219F6EAFF700
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKAED6219F6F3CE20A]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FKAED6219F6F3CE20A
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKAED6219F89C8678D]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FKAED6219F89C8678D
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKAED6219FECE3EB46]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FKAED6219FECE3EB46
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK654FF1BCBC851EAE]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Status_History] DROP CONSTRAINT FK654FF1BCBC851EAE
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK654FF1BCBD1209B8]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Status_History] DROP CONSTRAINT FK654FF1BCBD1209B8
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK5D11241BCE2B2E46]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Cons_Cost] DROP CONSTRAINT FK5D11241BCE2B2E46
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK8438C463AF0DC7C5]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Party_Responsibility_User] DROP CONSTRAINT FK8438C463AF0DC7C5
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKB3FA5C11F73AEA2F]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Assign] DROP CONSTRAINT FKB3FA5C11F73AEA2F
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK9B93D7237B9437A5]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Cost_Det] DROP CONSTRAINT FK9B93D7237B9437A5
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK412052482AA8FFA7]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Exp_Mstr] DROP CONSTRAINT FK412052482AA8FFA7
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKAB5A921CAF0DC7C5]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Member_Group] DROP CONSTRAINT FKAB5A921CAF0DC7C5
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK41BD86466C7969EB]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Mstr] DROP CONSTRAINT FK41BD86466C7969EB
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKBB0892AA9BEFD4D]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_TS_Forecast_Mstr] DROP CONSTRAINT FKBB0892AA9BEFD4D
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK80A615C2A9BEFD4D]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_TS_Mstr] DROP CONSTRAINT FK80A615C2A9BEFD4D
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_Category_CUser]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Category] DROP CONSTRAINT FK_SLA_Category_CUser
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_Category_MUser]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Category] DROP CONSTRAINT FK_SLA_Category_MUser
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKC565BA758A8C1B59]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Category] DROP CONSTRAINT FKC565BA758A8C1B59
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKC565BA758B190663]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Category] DROP CONSTRAINT FKC565BA758B190663
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_MSTR_CUser]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_MSTR] DROP CONSTRAINT FK_SLA_MSTR_CUser
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_MSTR_MUser]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_MSTR] DROP CONSTRAINT FK_SLA_MSTR_MUser
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKD6A51F7B20BFA4D7]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_MSTR] DROP CONSTRAINT FKD6A51F7B20BFA4D7
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKD6A51F7B214C8FE1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_MSTR] DROP CONSTRAINT FKD6A51F7B214C8FE1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_Priority_CUser]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Priority] DROP CONSTRAINT FK_SLA_Priority_CUser
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_Priority_MUser]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Priority] DROP CONSTRAINT FK_SLA_Priority_MUser
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK7CEB771B3A3D1DA6]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Priority] DROP CONSTRAINT FK7CEB771B3A3D1DA6
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK7CEB771B3ACA08B0]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Priority] DROP CONSTRAINT FK7CEB771B3ACA08B0
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKC614CF6BDE0A7C5]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[USER_LOGIN_MODULE_GROUP] DROP CONSTRAINT FKC614CF6BDE0A7C5
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKCDAF484ABDE0A7C5]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[USER_LOGIN_SECURITY_GROUP] DROP CONSTRAINT FKCDAF484ABDE0A7C5
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKEF7218288014D6A4]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[custConfigItem] DROP CONSTRAINT FKEF7218288014D6A4
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_custConfigRow_custConfigTable]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[custConfigRow] DROP CONSTRAINT FK_custConfigRow_custConfigTable
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK9C5EA625CAA0FB2C]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[custConfigRow] DROP CONSTRAINT FK9C5EA625CAA0FB2C
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKB3FA5C11ED90353D]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Assign] DROP CONSTRAINT FKB3FA5C11ED90353D
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK9B93D723ED90353D]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Cost_Det] DROP CONSTRAINT FK9B93D723ED90353D
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKC8504630164F2C10]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_CTC] DROP CONSTRAINT FKC8504630164F2C10
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK41205248FC3CC0A6]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Exp_Mstr] DROP CONSTRAINT FK41205248FC3CC0A6
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKAB5A921C50C8C93D]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Member_Group] DROP CONSTRAINT FKAB5A921C50C8C93D
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKC85076FDA5EC3FDD]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_PTC] DROP CONSTRAINT FKC85076FDA5EC3FDD
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKD299DD35C624FB7D]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_TS_Det] DROP CONSTRAINT FKD299DD35C624FB7D
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK7C3F5CCDC624FB7D]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_TS_Forecast_Det] DROP CONSTRAINT FK7C3F5CCDC624FB7D
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK7C3F5CCDCC79B52C]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_TS_Forecast_Det] DROP CONSTRAINT FK7C3F5CCDCC79B52C
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKD299DD35CC79B52C]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_TS_Det] DROP CONSTRAINT FKD299DD35CC79B52C
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_Category_SLA_MSTR]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Category] DROP CONSTRAINT FK_SLA_Category_SLA_MSTR
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKC565BA75CA5CC392]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Category] DROP CONSTRAINT FKC565BA75CA5CC392
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKEF721828C8DC31A0]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[custConfigItem] DROP CONSTRAINT FKEF721828C8DC31A0
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKA742F7EF5C24412]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proj_Exp_Det] DROP CONSTRAINT FKA742F7EF5C24412
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_SLA_Category]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_SLA_Category
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK11EE7B6391F11870]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK11EE7B6391F11870
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKAED6219F6870D909]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FKAED6219F6870D909
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKAED6219FC1C0CA02]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FKAED6219FC1C0CA02
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK95791F11890]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[KB] DROP CONSTRAINT FK95791F11890
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_Category_SLA_Category]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Category] DROP CONSTRAINT FK_SLA_Category_SLA_Category
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SLA_Priority_SLA_Category]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Priority] DROP CONSTRAINT FK_SLA_Priority_SLA_Category
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK7CEB771BCA5DAC50]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[SLA_Priority] DROP CONSTRAINT FK7CEB771BCA5DAC50
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Call_Master_SLA_Priority]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK_Call_Master_SLA_Priority
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK11EE7B6391F70143]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Call_Master] DROP CONSTRAINT FK11EE7B6391F70143
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKAED6219F531FF8BC]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FKAED6219F531FF8BC
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKAED6219F5AA0D563]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FKAED6219F5AA0D563
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK3A511C003D49510]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Action_History] DROP CONSTRAINT FK3A511C003D49510
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FKAED6219F3D49510]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_History] DROP CONSTRAINT FKAED6219F3D49510
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK654FF1BC5F5CCA09]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CM_Status_History] DROP CONSTRAINT FK654FF1BC5F5CCA09
GO

/****** Object:  Trigger dbo.tI_CallType    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tI_CallType]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tI_CallType]
GO

/****** Object:  Stored Procedure dbo.sp_cleanUnusedAttachment    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_cleanUnusedAttachment]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_cleanUnusedAttachment]
GO

/****** Object:  Stored Procedure dbo.sp_dailyemail    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_dailyemail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_dailyemail]
GO

/****** Object:  Stored Procedure dbo.sp_getWarningNotifyEmail    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_getWarningNotifyEmail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_getWarningNotifyEmail]
GO

/****** Object:  Stored Procedure dbo.sp_insertrecord    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_insertrecord]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_insertrecord]
GO

/****** Object:  Stored Procedure dbo.fn_addblank    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fn_addblank]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[fn_addblank]
GO

/****** Object:  Stored Procedure dbo.fn_addtab    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fn_addtab]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[fn_addtab]
GO

/****** Object:  Stored Procedure dbo.fn_getstrlen    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fn_getstrlen]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[fn_getstrlen]
GO

/****** Object:  Table [dbo].[CM_Status_History]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CM_Status_History]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CM_Status_History]
GO

/****** Object:  Table [dbo].[CM_Action_History]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CM_Action_History]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CM_Action_History]
GO

/****** Object:  Table [dbo].[CM_History]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CM_History]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CM_History]
GO

/****** Object:  Table [dbo].[Call_Master]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Call_Master]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Call_Master]
GO

/****** Object:  Table [dbo].[KB]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[KB]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[KB]
GO

/****** Object:  Table [dbo].[Proj_Exp_Det]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_Exp_Det]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_Exp_Det]
GO

/****** Object:  Table [dbo].[SLA_Priority]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SLA_Priority]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SLA_Priority]
GO

/****** Object:  Table [dbo].[Proj_Assign]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_Assign]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_Assign]
GO

/****** Object:  Table [dbo].[Proj_CTC]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_CTC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_CTC]
GO

/****** Object:  Table [dbo].[Proj_Cost_Det]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_Cost_Det]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_Cost_Det]
GO

/****** Object:  Table [dbo].[Proj_Exp_Mstr]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_Exp_Mstr]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_Exp_Mstr]
GO

/****** Object:  Table [dbo].[Proj_Member_Group]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_Member_Group]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_Member_Group]
GO

/****** Object:  Table [dbo].[Proj_PTC]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_PTC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_PTC]
GO

/****** Object:  Table [dbo].[Proj_TS_Det]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_TS_Det]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_TS_Det]
GO

/****** Object:  Table [dbo].[Proj_TS_Forecast_Det]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_TS_Forecast_Det]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_TS_Forecast_Det]
GO

/****** Object:  Table [dbo].[SLA_Category]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SLA_Category]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SLA_Category]
GO

/****** Object:  Table [dbo].[custConfigItem]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[custConfigItem]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[custConfigItem]
GO

/****** Object:  Table [dbo].[Attachment]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Attachment]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Attachment]
GO

/****** Object:  Table [dbo].[Cons_Cost]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Cons_Cost]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Cons_Cost]
GO

/****** Object:  Table [dbo].[Party_Responsibility_User]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Party_Responsibility_User]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Party_Responsibility_User]
GO

/****** Object:  Table [dbo].[ProjEvent_ProjEventType]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjEvent_ProjEventType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ProjEvent_ProjEventType]
GO

/****** Object:  Table [dbo].[Proj_Mstr]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_Mstr]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_Mstr]
GO

/****** Object:  Table [dbo].[Proj_TS_Forecast_Mstr]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_TS_Forecast_Mstr]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_TS_Forecast_Mstr]
GO

/****** Object:  Table [dbo].[Proj_TS_Mstr]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_TS_Mstr]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_TS_Mstr]
GO

/****** Object:  Table [dbo].[SLA_MSTR]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SLA_MSTR]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SLA_MSTR]
GO

/****** Object:  Table [dbo].[USER_LOGIN_MODULE_GROUP]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USER_LOGIN_MODULE_GROUP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[USER_LOGIN_MODULE_GROUP]
GO

/****** Object:  Table [dbo].[USER_LOGIN_SECURITY_GROUP]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USER_LOGIN_SECURITY_GROUP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[USER_LOGIN_SECURITY_GROUP]
GO

/****** Object:  Table [dbo].[custConfigRow]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[custConfigRow]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[custConfigRow]
GO

/****** Object:  Table [dbo].[ACTION_TYPE]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ACTION_TYPE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ACTION_TYPE]
GO

/****** Object:  Table [dbo].[MODULE_GROUP_ASSOCIATE]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MODULE_GROUP_ASSOCIATE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MODULE_GROUP_ASSOCIATE]
GO

/****** Object:  Table [dbo].[PARTY_RELATIONSHIP]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PARTY_RELATIONSHIP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PARTY_RELATIONSHIP]
GO

/****** Object:  Table [dbo].[PARTY_ROLE]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PARTY_ROLE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PARTY_ROLE]
GO

/****** Object:  Table [dbo].[ProjEvent]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjEvent]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ProjEvent]
GO

/****** Object:  Table [dbo].[Proj_Cost_Mstr]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_Cost_Mstr]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_Cost_Mstr]
GO

/****** Object:  Table [dbo].[Request_Type]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Request_Type]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Request_Type]
GO

/****** Object:  Table [dbo].[SECURITY_GROUP_PERMISSION]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SECURITY_GROUP_PERMISSION]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SECURITY_GROUP_PERMISSION]
GO

/****** Object:  Table [dbo].[USER_LOGIN]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USER_LOGIN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[USER_LOGIN]
GO

/****** Object:  Table [dbo].[custConfigColumn]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[custConfigColumn]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[custConfigColumn]
GO

/****** Object:  Table [dbo].[custConfigTable]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[custConfigTable]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[custConfigTable]
GO

/****** Object:  Table [dbo].[Call_Type]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Call_Type]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Call_Type]
GO

/****** Object:  Table [dbo].[Currency]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Currency]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Currency]
GO

/****** Object:  Table [dbo].[CustConfigTableType]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CustConfigTableType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CustConfigTableType]
GO

/****** Object:  Table [dbo].[ExpenseType]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ExpenseType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ExpenseType]
GO

/****** Object:  Table [dbo].[FMonth]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FMonth]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[FMonth]
GO

/****** Object:  Table [dbo].[MODULE]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MODULE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MODULE]
GO

/****** Object:  Table [dbo].[MODULE_GROUP]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MODULE_GROUP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MODULE_GROUP]
GO

/****** Object:  Table [dbo].[PARTY]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PARTY]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PARTY]
GO

/****** Object:  Table [dbo].[PARTY_RELATIONSHIP_TYPE]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PARTY_RELATIONSHIP_TYPE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PARTY_RELATIONSHIP_TYPE]
GO

/****** Object:  Table [dbo].[PARTY_TYPE]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PARTY_TYPE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PARTY_TYPE]
GO

/****** Object:  Table [dbo].[Party_Responsibility_Type]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Party_Responsibility_Type]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Party_Responsibility_Type]
GO

/****** Object:  Table [dbo].[ProjEventType]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjEventType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ProjEventType]
GO

/****** Object:  Table [dbo].[Proj_Cost_Type]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_Cost_Type]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_Cost_Type]
GO

/****** Object:  Table [dbo].[Proj_Type]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proj_Type]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proj_Type]
GO

/****** Object:  Table [dbo].[ROLE_TYPE]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ROLE_TYPE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ROLE_TYPE]
GO

/****** Object:  Table [dbo].[SECURITY_GROUP]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SECURITY_GROUP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SECURITY_GROUP]
GO

/****** Object:  Table [dbo].[SECURITY_PERMISSION]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SECURITY_PERMISSION]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SECURITY_PERMISSION]
GO

/****** Object:  Table [dbo].[Status_Type]    Script Date: 2005-1-7 9:39:37 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Status_Type]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Status_Type]
GO

/****** Object:  Table [dbo].[Call_Type]    Script Date: 2005-1-7 9:39:40 ******/
CREATE TABLE [dbo].[Call_Type] (
	[type] [varchar] (20) NOT NULL ,
	[typedesc] [varchar] (255) NOT NULL ,
	[name] [varchar] (50) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Currency]    Script Date: 2005-1-7 9:39:41 ******/
CREATE TABLE [dbo].[Currency] (
	[Curr_Id] [varchar] (255) NOT NULL ,
	[Curr_Name] [varchar] (255) NULL ,
	[Curr_Rate] [float] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[CustConfigTableType]    Script Date: 2005-1-7 9:39:41 ******/
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

/****** Object:  Table [dbo].[ExpenseType]    Script Date: 2005-1-7 9:39:41 ******/
CREATE TABLE [dbo].[ExpenseType] (
	[Exp_Id] [int] IDENTITY (1, 1) NOT NULL ,
	[Exp_Code] [varchar] (255) NOT NULL ,
	[Exp_Desc] [varchar] (255) NULL ,
	[Exp_Parent_Code] [int] NOT NULL ,
	[Enable] [varchar] (255) NULL ,
	[Seq] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[FMonth]    Script Date: 2005-1-7 9:39:41 ******/
CREATE TABLE [dbo].[FMonth] (
	[f_fm_cd] [numeric](19, 0) IDENTITY (1, 1) NOT NULL ,
	[f_yr] [int] NOT NULL ,
	[f_fmseq] [smallint] NOT NULL ,
	[f_fmdesc] [varchar] (255) NULL ,
	[f_fmdate_from] [datetime] NOT NULL ,
	[f_fmdate_to] [datetime] NOT NULL ,
	[f_fmdate_freeze] [datetime] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[MODULE]    Script Date: 2005-1-7 9:39:41 ******/
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

/****** Object:  Table [dbo].[MODULE_GROUP]    Script Date: 2005-1-7 9:39:41 ******/
CREATE TABLE [dbo].[MODULE_GROUP] (
	[MODULE_GROUP_ID] [varchar] (255) NOT NULL ,
	[DESCRIPTION] [varchar] (255) NULL ,
	[PRIORITY] [int] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PARTY]    Script Date: 2005-1-7 9:39:42 ******/
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

/****** Object:  Table [dbo].[PARTY_RELATIONSHIP_TYPE]    Script Date: 2005-1-7 9:39:42 ******/
CREATE TABLE [dbo].[PARTY_RELATIONSHIP_TYPE] (
	[RELATIONSHIP_TYPE_ID] [varchar] (255) NOT NULL ,
	[DESCRIPTION] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PARTY_TYPE]    Script Date: 2005-1-7 9:39:42 ******/
CREATE TABLE [dbo].[PARTY_TYPE] (
	[PARTY_TYPE_ID] [varchar] (255) NOT NULL ,
	[DESCRIPTION] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Party_Responsibility_Type]    Script Date: 2005-1-7 9:39:42 ******/
CREATE TABLE [dbo].[Party_Responsibility_Type] (
	[TypeId] [char] (1) NOT NULL ,
	[Description] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ProjEventType]    Script Date: 2005-1-7 9:39:42 ******/
CREATE TABLE [dbo].[ProjEventType] (
	[PET_Id] [int] IDENTITY (1, 1) NOT NULL ,
	[PET_Name] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_Cost_Type]    Script Date: 2005-1-7 9:39:42 ******/
CREATE TABLE [dbo].[Proj_Cost_Type] (
	[typeid] [varchar] (255) NOT NULL ,
	[typename] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_Type]    Script Date: 2005-1-7 9:39:42 ******/
CREATE TABLE [dbo].[Proj_Type] (
	[PT_Id] [varchar] (255) NOT NULL ,
	[PT_Desc] [varchar] (255) NULL ,
	[Open_Project] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ROLE_TYPE]    Script Date: 2005-1-7 9:39:42 ******/
CREATE TABLE [dbo].[ROLE_TYPE] (
	[ROLE_TYPE_ID] [varchar] (255) NOT NULL ,
	[DESCRIPTION] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[SECURITY_GROUP]    Script Date: 2005-1-7 9:39:42 ******/
CREATE TABLE [dbo].[SECURITY_GROUP] (
	[GROUP_ID] [varchar] (255) NOT NULL ,
	[DESCRIPTION] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[SECURITY_PERMISSION]    Script Date: 2005-1-7 9:39:42 ******/
CREATE TABLE [dbo].[SECURITY_PERMISSION] (
	[PERMISSION_ID] [varchar] (255) NOT NULL ,
	[DESCRIPTION] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Status_Type]    Script Date: 2005-1-7 9:39:42 ******/
CREATE TABLE [dbo].[Status_Type] (
	[status_id] [int] IDENTITY (1, 1) NOT NULL ,
	[status_level] [int] NOT NULL ,
	[status_disabled] [tinyint] NOT NULL ,
	[status_desc] [varchar] (255) NOT NULL ,
	[status_flag] [int] NOT NULL ,
	[status_type] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ACTION_TYPE]    Script Date: 2005-1-7 9:39:43 ******/
CREATE TABLE [dbo].[ACTION_TYPE] (
	[ActionId] [int] IDENTITY (1, 1) NOT NULL ,
	[ActionDesc] [varchar] (255) NOT NULL ,
	[ActionDisabled] [bit] NOT NULL ,
	[CallType] [varchar] (20) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[MODULE_GROUP_ASSOCIATE]    Script Date: 2005-1-7 9:39:43 ******/
CREATE TABLE [dbo].[MODULE_GROUP_ASSOCIATE] (
	[MODULE_GROUP_ID] [varchar] (255) NOT NULL ,
	[MODULE_ID] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PARTY_RELATIONSHIP]    Script Date: 2005-1-7 9:39:43 ******/
CREATE TABLE [dbo].[PARTY_RELATIONSHIP] (
	[PARTY_FROM_ID] [varchar] (50) NOT NULL ,
	[PARTY_TO_ID] [varchar] (50) NULL ,
	[ROLE_FROM_ID] [varchar] (255) NULL ,
	[ROLE_TO_ID] [varchar] (255) NULL ,
	[RELATIONSHIP_TYPE_ID] [varchar] (255) NULL ,
	[NOTE] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[PARTY_ROLE]    Script Date: 2005-1-7 9:39:43 ******/
CREATE TABLE [dbo].[PARTY_ROLE] (
	[PARTY_ID] [varchar] (50) NOT NULL ,
	[ROLE_TYPE_ID] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ProjEvent]    Script Date: 2005-1-7 9:39:43 ******/
CREATE TABLE [dbo].[ProjEvent] (
	[PEvent_Id] [int] IDENTITY (1, 1) NOT NULL ,
	[PEvent_Code] [varchar] (255) NULL ,
	[PEvent_Name] [varchar] (255) NULL ,
	[PT] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_Cost_Mstr]    Script Date: 2005-1-7 9:39:43 ******/
CREATE TABLE [dbo].[Proj_Cost_Mstr] (
	[costcode] [int] IDENTITY (1, 1) NOT NULL ,
	[currency] [varchar] (255) NULL ,
	[type] [varchar] (255) NULL ,
	[refno] [varchar] (255) NULL ,
	[costdescription] [varchar] (255) NULL ,
	[totalvalue] [float] NULL ,
	[exchangerate] [float] NULL ,
	[costdate] [datetime] NULL ,
	[createuser] [varchar] (255) NULL ,
	[createdate] [datetime] NULL ,
	[modifyuser] [varchar] (255) NULL ,
	[modifydate] [datetime] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Request_Type]    Script Date: 2005-1-7 9:39:43 ******/
CREATE TABLE [dbo].[Request_Type] (
	[Id] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (255) NOT NULL ,
	[Disabled] [bit] NOT NULL ,
	[CallType] [varchar] (20) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[SECURITY_GROUP_PERMISSION]    Script Date: 2005-1-7 9:39:43 ******/
CREATE TABLE [dbo].[SECURITY_GROUP_PERMISSION] (
	[GROUP_ID] [varchar] (255) NOT NULL ,
	[PERMISSION_ID] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[USER_LOGIN]    Script Date: 2005-1-7 9:39:43 ******/
CREATE TABLE [dbo].[USER_LOGIN] (
	[USER_LOGIN_ID] [varchar] (255) NOT NULL ,
	[NAME] [varchar] (255) NULL ,
	[locale] [varchar] (255) NULL ,
	[CURRENT_PASSWORD] [varchar] (255) NULL ,
	[ENABLE] [varchar] (255) NULL ,
	[TELE_CODE] [varchar] (255) NULL ,
	[MOBILE_CODE] [varchar] (255) NULL ,
	[TITLE] [varchar] (255) NULL ,
	[EMAIL_ADDR] [varchar] (255) NULL ,
	[NOTE] [varchar] (255) NULL ,
	[ROLE] [varchar] (255) NULL ,
	[PARTY_ID] [varchar] (50) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[custConfigColumn]    Script Date: 2005-1-7 9:39:44 ******/
CREATE TABLE [dbo].[custConfigColumn] (
	[column_id] [int] IDENTITY (1, 1) NOT NULL ,
	[column_name] [varchar] (255) NOT NULL ,
	[column_type] [int] NOT NULL ,
	[column_index] [int] NOT NULL ,
	[table_type] [int] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[custConfigTable]    Script Date: 2005-1-7 9:39:44 ******/
CREATE TABLE [dbo].[custConfigTable] (
	[table_id] [int] IDENTITY (1, 1) NOT NULL ,
	[cust_id] [varchar] (50) NOT NULL ,
	[table_type] [int] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Attachment]    Script Date: 2005-1-7 9:39:44 ******/
CREATE TABLE [dbo].[Attachment] (
	[Attach_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[deleted] [tinyint] NOT NULL ,
	[Attach_GroupID] [varchar] (255) NOT NULL ,
	[Attach_Name] [varchar] (255) NOT NULL ,
	[Attach_MIME] [varchar] (255) NOT NULL ,
	[Attach_Size] [int] NOT NULL ,
	[title] [varchar] (255) NOT NULL ,
	[Attach_CUser] [varchar] (255) NULL ,
	[Attach_CDate] [datetime] NOT NULL ,
	[Attach_Content] [image] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Cons_Cost]    Script Date: 2005-1-7 9:39:44 ******/
CREATE TABLE [dbo].[Cons_Cost] (
	[Id] [numeric](19, 0) IDENTITY (1, 1) NOT NULL ,
	[userId] [varchar] (255) NOT NULL ,
	[yr] [int] NOT NULL ,
	[cost] [float] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Party_Responsibility_User]    Script Date: 2005-1-7 9:39:44 ******/
CREATE TABLE [dbo].[Party_Responsibility_User] (
	[Id] [int] IDENTITY (1, 1) NOT NULL ,
	[Party_Id] [varchar] (50) NULL ,
	[User_Login_Id] [varchar] (255) NULL ,
	[TypeId] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ProjEvent_ProjEventType]    Script Date: 2005-1-7 9:39:44 ******/
CREATE TABLE [dbo].[ProjEvent_ProjEventType] (
	[PEvent_Id] [int] NOT NULL ,
	[PET_Id] [int] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_Mstr]    Script Date: 2005-1-7 9:39:44 ******/
CREATE TABLE [dbo].[Proj_Mstr] (
	[proj_id] [varchar] (255) NOT NULL ,
	[proj_name] [varchar] (255) NULL ,
	[cust_id] [varchar] (50) NULL ,
	[dep_id] [varchar] (50) NULL ,
	[proj_status] [varchar] (255) NULL ,
	[proj_pm_user] [varchar] (255) NULL ,
	[proj_type] [varchar] (255) NULL ,
	[Proj_CAF_Flag] [varchar] (255) NULL ,
	[Proj_contract_No] [varchar] (255) NULL ,
	[total_sales] [varchar] (255) NULL ,
	[total_budget] [varchar] (255) NULL ,
	[start_date] [datetime] NULL ,
	[end_date] [datetime] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_TS_Forecast_Mstr]    Script Date: 2005-1-7 9:39:44 ******/
CREATE TABLE [dbo].[Proj_TS_Forecast_Mstr] (
	[tsm_id] [int] IDENTITY (1, 1) NOT NULL ,
	[tsm_userlogin] [varchar] (255) NULL ,
	[ts_status] [varchar] (255) NULL ,
	[ts_period] [varchar] (255) NULL ,
	[ts_updateDate] [datetime] NULL ,
	[ts_totalHours] [float] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_TS_Mstr]    Script Date: 2005-1-7 9:39:44 ******/
CREATE TABLE [dbo].[Proj_TS_Mstr] (
	[tsm_id] [int] IDENTITY (1, 1) NOT NULL ,
	[tsm_userlogin] [varchar] (255) NULL ,
	[ts_status] [varchar] (255) NULL ,
	[ts_period] [varchar] (255) NULL ,
	[ts_updateDate] [datetime] NULL ,
	[ts_totalHours] [float] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[SLA_MSTR]    Script Date: 2005-1-7 9:39:44 ******/
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

/****** Object:  Table [dbo].[USER_LOGIN_MODULE_GROUP]    Script Date: 2005-1-7 9:39:45 ******/
CREATE TABLE [dbo].[USER_LOGIN_MODULE_GROUP] (
	[USER_LOGIN_ID] [varchar] (255) NOT NULL ,
	[MODULE_GROUP_ID] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[USER_LOGIN_SECURITY_GROUP]    Script Date: 2005-1-7 9:39:45 ******/
CREATE TABLE [dbo].[USER_LOGIN_SECURITY_GROUP] (
	[USER_LOGIN_ID] [varchar] (255) NOT NULL ,
	[GROUP_ID] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[custConfigRow]    Script Date: 2005-1-7 9:39:45 ******/
CREATE TABLE [dbo].[custConfigRow] (
	[table_id] [int] NOT NULL ,
	[row_id] [int] IDENTITY (1, 1) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_Assign]    Script Date: 2005-1-7 9:39:45 ******/
CREATE TABLE [dbo].[Proj_Assign] (
	[pa_Id] [numeric](19, 0) IDENTITY (1, 1) NOT NULL ,
	[proj_id] [varchar] (255) NOT NULL ,
	[user_Id] [varchar] (255) NOT NULL ,
	[date_start] [datetime] NOT NULL ,
	[date_end] [datetime] NOT NULL ,
	[proj_assign_id] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_CTC]    Script Date: 2005-1-7 9:39:45 ******/
CREATE TABLE [dbo].[Proj_CTC] (
	[ctc_id] [numeric](19, 0) IDENTITY (1, 1) NOT NULL ,
	[ctc_proj_id] [varchar] (255) NOT NULL ,
	[f_fm_cd] [numeric](19, 0) NOT NULL ,
	[ctc_type] [varchar] (50) NOT NULL ,
	[ctc_amt] [float] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_Cost_Det]    Script Date: 2005-1-7 9:39:45 ******/
CREATE TABLE [dbo].[Proj_Cost_Det] (
	[pcdid] [int] IDENTITY (1, 1) NOT NULL ,
	[costCode] [int] NULL ,
	[proj_id] [varchar] (255) NULL ,
	[user_login_id] [varchar] (255) NULL ,
	[percentage] [float] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_Exp_Mstr]    Script Date: 2005-1-7 9:39:45 ******/
CREATE TABLE [dbo].[Proj_Exp_Mstr] (
	[em_id] [int] IDENTITY (1, 1) NOT NULL ,
	[em_proj_id] [varchar] (255) NULL ,
	[em_userlogin] [varchar] (255) NULL ,
	[em_status] [varchar] (255) NULL ,
	[em_period] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_Member_Group]    Script Date: 2005-1-7 9:39:45 ******/
CREATE TABLE [dbo].[Proj_Member_Group] (
	[Proj_Id] [varchar] (255) NOT NULL ,
	[User_Login_Id] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_PTC]    Script Date: 2005-1-7 9:39:45 ******/
CREATE TABLE [dbo].[Proj_PTC] (
	[ptc_id] [numeric](19, 0) IDENTITY (1, 1) NOT NULL ,
	[ptc_proj_id] [varchar] (255) NOT NULL ,
	[f_fm_cd] [numeric](19, 0) NOT NULL ,
	[ptc_type] [varchar] (50) NOT NULL ,
	[ptc_amt] [float] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_TS_Det]    Script Date: 2005-1-7 9:39:46 ******/
CREATE TABLE [dbo].[Proj_TS_Det] (
	[ts_id] [int] IDENTITY (1, 1) NOT NULL ,
	[tsm_id] [int] NULL ,
	[ts_proj_id] [varchar] (255) NULL ,
	[ts_projevent] [int] NULL ,
	[ts_hrs_user] [float] NULL ,
	[ts_hrs_confirm] [float] NULL ,
	[ts_status] [varchar] (255) NULL ,
	[ts_cafstatus_user] [varchar] (255) NULL ,
	[ts_cafstatus_confirm] [varchar] (255) NULL ,
	[ts_date] [datetime] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_TS_Forecast_Det]    Script Date: 2005-1-7 9:39:46 ******/
CREATE TABLE [dbo].[Proj_TS_Forecast_Det] (
	[ts_id] [int] IDENTITY (1, 1) NOT NULL ,
	[tsm_id] [int] NULL ,
	[ts_proj_id] [varchar] (255) NULL ,
	[ts_projevent] [int] NULL ,
	[ts_hrs_user] [float] NULL ,
	[ts_hrs_confirm] [float] NULL ,
	[ts_status] [varchar] (255) NULL ,
	[ts_cafstatus_user] [varchar] (255) NULL ,
	[ts_cafstatus_confirm] [varchar] (255) NULL ,
	[ts_date] [datetime] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[SLA_Category]    Script Date: 2005-1-7 9:39:46 ******/
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

/****** Object:  Table [dbo].[custConfigItem]    Script Date: 2005-1-7 9:39:46 ******/
CREATE TABLE [dbo].[custConfigItem] (
	[item_id] [int] IDENTITY (1, 1) NOT NULL ,
	[column_id] [int] NULL ,
	[row_id] [int] NULL ,
	[content] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[KB]    Script Date: 2005-1-7 9:39:46 ******/
CREATE TABLE [dbo].[KB] (
	[Id] [int] IDENTITY (1, 1) NOT NULL ,
	[SLC_Id] [int] NULL ,
	[CustomerId] [varchar] (50) NULL ,
	[OriginalCustomerId] [varchar] (50) NULL ,
	[Subject] [varchar] (255) NULL ,
	[ProblemDesc] [varchar] (255) NULL ,
	[ProblemAttachGroupID] [varchar] (255) NULL ,
	[SolutionAttachGroupID] [varchar] (255) NULL ,
	[Published] [tinyint] NULL ,
	[Solution] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Proj_Exp_Det]    Script Date: 2005-1-7 9:39:46 ******/
CREATE TABLE [dbo].[Proj_Exp_Det] (
	[ed_id] [int] IDENTITY (1, 1) NOT NULL ,
	[em_id] [int] NULL ,
	[exp_id] [int] NULL ,
	[ed_amt_user] [float] NULL ,
	[ed_amt_confirm] [float] NULL ,
	[ed_date] [datetime] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[SLA_Priority]    Script Date: 2005-1-7 9:39:46 ******/
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

/****** Object:  Table [dbo].[Call_Master]    Script Date: 2005-1-7 9:39:46 ******/
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

/****** Object:  Table [dbo].[CM_Action_History]    Script Date: 2005-1-7 9:39:47 ******/
CREATE TABLE [dbo].[CM_Action_History] (
	[CMAH_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[CMAH_Subject] [varchar] (255) NULL ,
	[CMAH_Desc] [varchar] (255) NULL ,
	[CMAH_Attachment_ID] [varchar] (255) NULL ,
	[CMAH_Cost] [float] NULL ,
	[CMAH_Date] [datetime] NULL ,
	[CMAH_CDate] [datetime] NULL ,
	[CMAH_MDate] [datetime] NULL ,
	[CMAH_CUser] [varchar] (255) NULL ,
	[CMAH_MUser] [varchar] (255) NULL ,
	[CMAH_Type] [int] NULL ,
	[CM_ID] [int] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[CM_History]    Script Date: 2005-1-7 9:39:47 ******/
CREATE TABLE [dbo].[CM_History] (
	[CMAH_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[CMAH_Desc] [varchar] (255) NULL ,
	[CMAH_CDate] [datetime] NULL ,
	[CMAH_MDate] [datetime] NULL ,
	[CMAH_CUser] [varchar] (255) NULL ,
	[CMAH_MUser] [varchar] (255) NULL ,
	[old_request_type] [int] NULL ,
	[new_reqeust_type] [int] NULL ,
	[old_priority] [int] NULL ,
	[new_priority] [int] NULL ,
	[CM_ID] [int] NULL ,
	[new_Party_ID] [varchar] (50) NULL ,
	[old_party_id] [varchar] (50) NULL ,
	[new_User_Login_ID] [varchar] (255) NULL ,
	[old_user_login_id] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[CM_Status_History]    Script Date: 2005-1-7 9:39:47 ******/
CREATE TABLE [dbo].[CM_Status_History] (
	[CMSH_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[CMSH_Status_Old] [int] NULL ,
	[CMSH_Status_New] [int] NULL ,
	[CMSH_Desc] [varchar] (255) NULL ,
	[CMSH_CDate] [datetime] NULL ,
	[CMSH_MDate] [datetime] NULL ,
	[CMSH_CUser] [varchar] (255) NULL ,
	[CMSH_MUser] [varchar] (255) NULL ,
	[CMAH_ID] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Call_Type] WITH NOCHECK ADD 
	CONSTRAINT [PK_Call_Type] PRIMARY KEY  CLUSTERED 
	(
		[type]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Currency] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
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
	 PRIMARY KEY  CLUSTERED 
	(
		[Exp_Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[FMonth] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[f_fm_cd]
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

ALTER TABLE [dbo].[PARTY] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[PARTY_ID]
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

ALTER TABLE [dbo].[ProjEventType] WITH NOCHECK ADD 
	CONSTRAINT [PK_ProjEventType] PRIMARY KEY  CLUSTERED 
	(
		[PET_Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_Cost_Type] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[typeid]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_Type] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[PT_Id]
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

ALTER TABLE [dbo].[Status_Type] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[status_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACTION_TYPE] WITH NOCHECK ADD 
	CONSTRAINT [PK_ACTION_TYPE] PRIMARY KEY  CLUSTERED 
	(
		[ActionId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[MODULE_GROUP_ASSOCIATE] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[MODULE_GROUP_ID],
		[MODULE_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PARTY_ROLE] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[PARTY_ID],
		[ROLE_TYPE_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ProjEvent] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[PEvent_Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_Cost_Mstr] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[costcode]
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

ALTER TABLE [dbo].[USER_LOGIN] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[USER_LOGIN_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[custConfigColumn] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[column_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[custConfigTable] WITH NOCHECK ADD 
	CONSTRAINT [PK_custConfigTable] PRIMARY KEY  CLUSTERED 
	(
		[table_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Attachment] WITH NOCHECK ADD 
	CONSTRAINT [PK__Attachment__5792F321] PRIMARY KEY  CLUSTERED 
	(
		[Attach_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Cons_Cost] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Party_Responsibility_User] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_Mstr] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[proj_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_TS_Forecast_Mstr] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[tsm_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_TS_Mstr] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[tsm_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[SLA_MSTR] WITH NOCHECK ADD 
	CONSTRAINT [PK_SLA_MSTR] PRIMARY KEY  CLUSTERED 
	(
		[SLA_ID]
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

ALTER TABLE [dbo].[custConfigRow] WITH NOCHECK ADD 
	CONSTRAINT [PK_custConfigRow] PRIMARY KEY  CLUSTERED 
	(
		[row_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_Assign] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[pa_Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_CTC] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[ctc_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_Cost_Det] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[pcdid]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_Exp_Mstr] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[em_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_Member_Group] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[Proj_Id],
		[User_Login_Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_PTC] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[ptc_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_TS_Det] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[ts_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_TS_Forecast_Det] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[ts_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[SLA_Category] WITH NOCHECK ADD 
	CONSTRAINT [PK_SLA_Category] PRIMARY KEY  CLUSTERED 
	(
		[SLC_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[custConfigItem] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[item_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[KB] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[Id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proj_Exp_Det] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[ed_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[SLA_Priority] WITH NOCHECK ADD 
	CONSTRAINT [PK_SLA_Priority] PRIMARY KEY  CLUSTERED 
	(
		[SLP_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Call_Master] WITH NOCHECK ADD 
	CONSTRAINT [PK_Call_Master] PRIMARY KEY  CLUSTERED 
	(
		[CM_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CM_Action_History] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[CMAH_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CM_History] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[CMAH_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CM_Status_History] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[CMSH_ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CustConfigTableType] WITH NOCHECK ADD 
	CONSTRAINT [DF_tableType_disabled] DEFAULT (0) FOR [disabled],
	CONSTRAINT [IX_CustConfigTableType] UNIQUE  NONCLUSTERED 
	(
		[type_name]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ACTION_TYPE] WITH NOCHECK ADD 
	CONSTRAINT [DF_ACTION_TYPE_ActionDisabled] DEFAULT (0) FOR [ActionDisabled]
GO

ALTER TABLE [dbo].[USER_LOGIN] WITH NOCHECK ADD 
	CONSTRAINT [DF_USER_LOGIN_locale] DEFAULT ('en') FOR [locale]
GO

ALTER TABLE [dbo].[SLA_MSTR] WITH NOCHECK ADD 
	CONSTRAINT [DF_SLA_MSTR_SLA_Active] DEFAULT ('N') FOR [SLA_Active]
GO

ALTER TABLE [dbo].[Call_Master] WITH NOCHECK ADD 
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

ALTER TABLE [dbo].[ACTION_TYPE] ADD 
	CONSTRAINT [FKE07CBFA3F99082D8] FOREIGN KEY 
	(
		[CallType]
	) REFERENCES [dbo].[Call_Type] (
		[type]
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

ALTER TABLE [dbo].[ProjEvent] ADD 
	CONSTRAINT [FK4061911DA04] FOREIGN KEY 
	(
		[PT]
	) REFERENCES [dbo].[Proj_Type] (
		[PT_Id]
	)
GO

ALTER TABLE [dbo].[Proj_Cost_Mstr] ADD 
	CONSTRAINT [FKD6EB5994224BF011] FOREIGN KEY 
	(
		[currency]
	) REFERENCES [dbo].[Currency] (
		[Curr_Id]
	),
	CONSTRAINT [FKD6EB5994368F3A] FOREIGN KEY 
	(
		[type]
	) REFERENCES [dbo].[Proj_Cost_Type] (
		[typeid]
	)
GO

ALTER TABLE [dbo].[Request_Type] ADD 
	CONSTRAINT [FK_Request_Type_Call_Type] FOREIGN KEY 
	(
		[CallType]
	) REFERENCES [dbo].[Call_Type] (
		[type]
	),
	CONSTRAINT [FK576B5F2AF99082D8] FOREIGN KEY 
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

ALTER TABLE [dbo].[USER_LOGIN] ADD 
	CONSTRAINT [FKC672F9D5758A0D34] FOREIGN KEY 
	(
		[PARTY_ID]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	)
GO

ALTER TABLE [dbo].[custConfigColumn] ADD 
	CONSTRAINT [FKD0CC7F2BA6543D0B] FOREIGN KEY 
	(
		[table_type]
	) REFERENCES [dbo].[CustConfigTableType] (
		[type_id]
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
	),
	CONSTRAINT [FKFF634159433AA687] FOREIGN KEY 
	(
		[cust_id]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FKFF634159A6543D0B] FOREIGN KEY 
	(
		[table_type]
	) REFERENCES [dbo].[CustConfigTableType] (
		[type_id]
	)
GO

ALTER TABLE [dbo].[Attachment] ADD 
	CONSTRAINT [FK1C935439A82A454] FOREIGN KEY 
	(
		[Attach_CUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

ALTER TABLE [dbo].[Cons_Cost] ADD 
	CONSTRAINT [FK5D11241BCE2B2E46] FOREIGN KEY 
	(
		[userId]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

ALTER TABLE [dbo].[Party_Responsibility_User] ADD 
	CONSTRAINT [FK8438C4634ABE0554] FOREIGN KEY 
	(
		[Party_Id]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK8438C463AF0DC7C5] FOREIGN KEY 
	(
		[User_Login_Id]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
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

ALTER TABLE [dbo].[Proj_Mstr] ADD 
	CONSTRAINT [FK41BD8646433AA687] FOREIGN KEY 
	(
		[cust_id]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK41BD86466C7969EB] FOREIGN KEY 
	(
		[proj_pm_user]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK41BD8646B0683F4B] FOREIGN KEY 
	(
		[dep_id]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK41BD8646CA5D36DC] FOREIGN KEY 
	(
		[proj_type]
	) REFERENCES [dbo].[Proj_Type] (
		[PT_Id]
	)
GO

ALTER TABLE [dbo].[Proj_TS_Forecast_Mstr] ADD 
	CONSTRAINT [FKBB0892AA9BEFD4D] FOREIGN KEY 
	(
		[tsm_userlogin]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

ALTER TABLE [dbo].[Proj_TS_Mstr] ADD 
	CONSTRAINT [FK80A615C2A9BEFD4D] FOREIGN KEY 
	(
		[tsm_userlogin]
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
	),
	CONSTRAINT [FKD6A51F7B20BFA4D7] FOREIGN KEY 
	(
		[SLA_CUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FKD6A51F7B214C8FE1] FOREIGN KEY 
	(
		[SLA_MUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FKD6A51F7B216DBD0F] FOREIGN KEY 
	(
		[SLA_Party]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
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

ALTER TABLE [dbo].[custConfigRow] ADD 
	CONSTRAINT [FK_custConfigRow_custConfigTable] FOREIGN KEY 
	(
		[table_id]
	) REFERENCES [dbo].[custConfigTable] (
		[table_id]
	),
	CONSTRAINT [FK9C5EA625CAA0FB2C] FOREIGN KEY 
	(
		[table_id]
	) REFERENCES [dbo].[custConfigTable] (
		[table_id]
	)
GO

ALTER TABLE [dbo].[Proj_Assign] ADD 
	CONSTRAINT [FKB3FA5C11ED90353D] FOREIGN KEY 
	(
		[proj_id]
	) REFERENCES [dbo].[Proj_Mstr] (
		[proj_id]
	),
	CONSTRAINT [FKB3FA5C11F73AEA2F] FOREIGN KEY 
	(
		[user_Id]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

ALTER TABLE [dbo].[Proj_CTC] ADD 
	CONSTRAINT [FKC8504630164F2C10] FOREIGN KEY 
	(
		[ctc_proj_id]
	) REFERENCES [dbo].[Proj_Mstr] (
		[proj_id]
	),
	CONSTRAINT [FKC8504630BBA859C0] FOREIGN KEY 
	(
		[f_fm_cd]
	) REFERENCES [dbo].[FMonth] (
		[f_fm_cd]
	)
GO

ALTER TABLE [dbo].[Proj_Cost_Det] ADD 
	CONSTRAINT [FK9B93D7237B9437A5] FOREIGN KEY 
	(
		[user_login_id]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK9B93D723E6A8235A] FOREIGN KEY 
	(
		[costCode]
	) REFERENCES [dbo].[Proj_Cost_Mstr] (
		[costcode]
	),
	CONSTRAINT [FK9B93D723ED90353D] FOREIGN KEY 
	(
		[proj_id]
	) REFERENCES [dbo].[Proj_Mstr] (
		[proj_id]
	)
GO

ALTER TABLE [dbo].[Proj_Exp_Mstr] ADD 
	CONSTRAINT [FK412052482AA8FFA7] FOREIGN KEY 
	(
		[em_userlogin]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK41205248FC3CC0A6] FOREIGN KEY 
	(
		[em_proj_id]
	) REFERENCES [dbo].[Proj_Mstr] (
		[proj_id]
	)
GO

ALTER TABLE [dbo].[Proj_Member_Group] ADD 
	CONSTRAINT [FKAB5A921C50C8C93D] FOREIGN KEY 
	(
		[Proj_Id]
	) REFERENCES [dbo].[Proj_Mstr] (
		[proj_id]
	),
	CONSTRAINT [FKAB5A921CAF0DC7C5] FOREIGN KEY 
	(
		[User_Login_Id]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

ALTER TABLE [dbo].[Proj_PTC] ADD 
	CONSTRAINT [FKC85076FDA5EC3FDD] FOREIGN KEY 
	(
		[ptc_proj_id]
	) REFERENCES [dbo].[Proj_Mstr] (
		[proj_id]
	),
	CONSTRAINT [FKC85076FDBBA859C0] FOREIGN KEY 
	(
		[f_fm_cd]
	) REFERENCES [dbo].[FMonth] (
		[f_fm_cd]
	)
GO

ALTER TABLE [dbo].[Proj_TS_Det] ADD 
	CONSTRAINT [FKD299DD35C624FB7D] FOREIGN KEY 
	(
		[ts_proj_id]
	) REFERENCES [dbo].[Proj_Mstr] (
		[proj_id]
	),
	CONSTRAINT [FKD299DD35CC79B52C] FOREIGN KEY 
	(
		[tsm_id]
	) REFERENCES [dbo].[Proj_TS_Mstr] (
		[tsm_id]
	),
	CONSTRAINT [FKD299DD35D12E979D] FOREIGN KEY 
	(
		[ts_projevent]
	) REFERENCES [dbo].[ProjEvent] (
		[PEvent_Id]
	)
GO

ALTER TABLE [dbo].[Proj_TS_Forecast_Det] ADD 
	CONSTRAINT [FK7C3F5CCDC624FB7D] FOREIGN KEY 
	(
		[ts_proj_id]
	) REFERENCES [dbo].[Proj_Mstr] (
		[proj_id]
	),
	CONSTRAINT [FK7C3F5CCDCC79B52C] FOREIGN KEY 
	(
		[tsm_id]
	) REFERENCES [dbo].[Proj_TS_Forecast_Mstr] (
		[tsm_id]
	),
	CONSTRAINT [FK7C3F5CCDD12E979D] FOREIGN KEY 
	(
		[ts_projevent]
	) REFERENCES [dbo].[ProjEvent] (
		[PEvent_Id]
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
	),
	CONSTRAINT [FKC565BA758A8C1B59] FOREIGN KEY 
	(
		[SLC_CUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FKC565BA758B190663] FOREIGN KEY 
	(
		[SLC_MUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FKC565BA75CA5CC392] FOREIGN KEY 
	(
		[SLA_ID]
	) REFERENCES [dbo].[SLA_MSTR] (
		[SLA_ID]
	)
GO

ALTER TABLE [dbo].[custConfigItem] ADD 
	CONSTRAINT [FKEF7218288014D6A4] FOREIGN KEY 
	(
		[column_id]
	) REFERENCES [dbo].[custConfigColumn] (
		[column_id]
	),
	CONSTRAINT [FKEF721828C8DC31A0] FOREIGN KEY 
	(
		[row_id]
	) REFERENCES [dbo].[custConfigRow] (
		[row_id]
	)
GO

ALTER TABLE [dbo].[KB] ADD 
	CONSTRAINT [FK9571892E5B9] FOREIGN KEY 
	(
		[CustomerId]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK9573467DA6A] FOREIGN KEY 
	(
		[OriginalCustomerId]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK95791F11890] FOREIGN KEY 
	(
		[SLC_Id]
	) REFERENCES [dbo].[SLA_Category] (
		[SLC_ID]
	)
GO

ALTER TABLE [dbo].[Proj_Exp_Det] ADD 
	CONSTRAINT [FKA742F7EF5C24412] FOREIGN KEY 
	(
		[em_id]
	) REFERENCES [dbo].[Proj_Exp_Mstr] (
		[em_id]
	),
	CONSTRAINT [FKA742F7EFB328D67D] FOREIGN KEY 
	(
		[exp_id]
	) REFERENCES [dbo].[ExpenseType] (
		[Exp_Id]
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
	),
	CONSTRAINT [FK7CEB771B3A3D1DA6] FOREIGN KEY 
	(
		[SLP_CUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK7CEB771B3ACA08B0] FOREIGN KEY 
	(
		[SLP_MUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK7CEB771BCA5DAC50] FOREIGN KEY 
	(
		[SLC_ID]
	) REFERENCES [dbo].[SLA_Category] (
		[SLC_ID]
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
	),
	CONSTRAINT [FK11EE7B6341E32732] FOREIGN KEY 
	(
		[CM_Company_ID]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK11EE7B6342464587] FOREIGN KEY 
	(
		[CM_Status]
	) REFERENCES [dbo].[Status_Type] (
		[status_id]
	),
	CONSTRAINT [FK11EE7B634DAE96EA] FOREIGN KEY 
	(
		[request_type]
	) REFERENCES [dbo].[Request_Type] (
		[Id]
	),
	CONSTRAINT [FK11EE7B636109660F] FOREIGN KEY 
	(
		[CM_Type]
	) REFERENCES [dbo].[Call_Type] (
		[type]
	),
	CONSTRAINT [FK11EE7B637CBFF8AF] FOREIGN KEY 
	(
		[CM_Contact_ID]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK11EE7B6391F11870] FOREIGN KEY 
	(
		[SLC_ID]
	) REFERENCES [dbo].[SLA_Category] (
		[SLC_ID]
	),
	CONSTRAINT [FK11EE7B6391F70143] FOREIGN KEY 
	(
		[SLP_ID]
	) REFERENCES [dbo].[SLA_Priority] (
		[SLP_ID]
	),
	CONSTRAINT [FK11EE7B639DF399AA] FOREIGN KEY 
	(
		[CM_Assigned_Party]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FK11EE7B63BF237A99] FOREIGN KEY 
	(
		[CM_CUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK11EE7B63BFB065A3] FOREIGN KEY 
	(
		[CM_MUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK11EE7B63CC297FC5] FOREIGN KEY 
	(
		[solved_user]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK11EE7B63D38E8487] FOREIGN KEY 
	(
		[CM_Assigned_User]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

ALTER TABLE [dbo].[CM_Action_History] ADD 
	CONSTRAINT [FK3A511C003D49510] FOREIGN KEY 
	(
		[CM_ID]
	) REFERENCES [dbo].[Call_Master] (
		[CM_ID]
	),
	CONSTRAINT [FK3A511C006EAFF700] FOREIGN KEY 
	(
		[CMAH_CUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK3A511C006F3CE20A] FOREIGN KEY 
	(
		[CMAH_MUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK3A511C00FB5840C8] FOREIGN KEY 
	(
		[CMAH_Type]
	) REFERENCES [dbo].[ACTION_TYPE] (
		[ActionId]
	)
GO

ALTER TABLE [dbo].[CM_History] ADD 
	CONSTRAINT [FKAED6219F3D49510] FOREIGN KEY 
	(
		[CM_ID]
	) REFERENCES [dbo].[Call_Master] (
		[CM_ID]
	),
	CONSTRAINT [FKAED6219F531FF8BC] FOREIGN KEY 
	(
		[old_priority]
	) REFERENCES [dbo].[SLA_Priority] (
		[SLP_ID]
	),
	CONSTRAINT [FKAED6219F5AA0D563] FOREIGN KEY 
	(
		[new_priority]
	) REFERENCES [dbo].[SLA_Priority] (
		[SLP_ID]
	),
	CONSTRAINT [FKAED6219F6870D909] FOREIGN KEY 
	(
		[new_reqeust_type]
	) REFERENCES [dbo].[SLA_Category] (
		[SLC_ID]
	),
	CONSTRAINT [FKAED6219F6EAFF700] FOREIGN KEY 
	(
		[CMAH_CUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FKAED6219F6F3CE20A] FOREIGN KEY 
	(
		[CMAH_MUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FKAED6219F89C8678D] FOREIGN KEY 
	(
		[old_user_login_id]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FKAED6219FC1C0CA02] FOREIGN KEY 
	(
		[old_request_type]
	) REFERENCES [dbo].[SLA_Category] (
		[SLC_ID]
	),
	CONSTRAINT [FKAED6219FDF7B242C] FOREIGN KEY 
	(
		[old_party_id]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FKAED6219FEAD660F3] FOREIGN KEY 
	(
		[new_Party_ID]
	) REFERENCES [dbo].[PARTY] (
		[PARTY_ID]
	),
	CONSTRAINT [FKAED6219FECE3EB46] FOREIGN KEY 
	(
		[new_User_Login_ID]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

ALTER TABLE [dbo].[CM_Status_History] ADD 
	CONSTRAINT [FK654FF1BC5F5CCA09] FOREIGN KEY 
	(
		[CMAH_ID]
	) REFERENCES [dbo].[CM_Action_History] (
		[CMAH_ID]
	),
	CONSTRAINT [FK654FF1BCB9112BD3] FOREIGN KEY 
	(
		[CMSH_Status_New]
	) REFERENCES [dbo].[Status_Type] (
		[status_id]
	),
	CONSTRAINT [FK654FF1BCB911305A] FOREIGN KEY 
	(
		[CMSH_Status_Old]
	) REFERENCES [dbo].[Status_Type] (
		[status_id]
	),
	CONSTRAINT [FK654FF1BCBC851EAE] FOREIGN KEY 
	(
		[CMSH_CUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	),
	CONSTRAINT [FK654FF1BCBD1209B8] FOREIGN KEY 
	(
		[CMSH_MUser]
	) REFERENCES [dbo].[USER_LOGIN] (
		[USER_LOGIN_ID]
	)
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.fn_addblank    Script Date: 2005-1-7 9:39:47 ******/
/****** Object:  Stored Procedure dbo.fn_addblank    Script Date: 2005-1-6 13:21:39 ******/

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

/****** Object:  Stored Procedure dbo.fn_addtab    Script Date: 2005-1-7 9:39:47 ******/

/****** Object:  Stored Procedure dbo.fn_addtab    Script Date: 2005-1-6 13:21:39 ******/
CREATE PROCEDURE fn_addtab  
	@schk varchar(255) output,@flen int,@nsplit int =0
/*
	@nsplie---增加字符长度，本程序里因为field之间有间隔2个空格，所以要算入字符长度
*/
AS
declare @ntmp int,@nlen int,@i int
select @schk=rtrim(@schk)
exec fn_getstrlen @schk,@nlen output
select @ntmp=ceiling((@flen-@nsplit-@nlen)/8.0)
select @schk=@schk+replace(space(@ntmp),' ',char(9))
--select @nlen=fn_getstrlen(@schk)

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.fn_getstrlen    Script Date: 2005-1-7 9:39:47 ******/

/****** Object:  Stored Procedure dbo.fn_getstrlen    Script Date: 2005-1-6 13:21:39 ******/

CREATE PROCEDURE fn_getstrlen 
	@schk varchar(255),@rlen int output
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
select @rlen=@ntmp

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.sp_insertrecord    Script Date: 2005-1-7 9:39:47 ******/

/****** Object:  Stored Procedure dbo.sp_insertrecord    Script Date: 2005-1-6 13:21:39 ******/

CREATE PROCEDURE sp_insertrecord	--插入警报记录
	 @subject varchar(255),@asparty varchar(50),@asuser varchar(255),@cmid int,@restime datetime,@soltime datetime,@clstime datetime,
	@name varchar(255),@status int,@statustype varchar(20),@ticket char(9),@accepttime datetime,@slpdesc varchar(255),@reparty varchar(50),@reuser varchar(255),
	@seq int output,@curtype int
AS
DECLARE @L1 int,@L2 int,@L3 int,@L4 int,@L5 int,@L6 int,@L7 int,@L8 int
--DECLARE @C1 varchar(13),@C2 varchar(12),@C3 varchar(40),@C4 varchar(20),@C5 varchar(20),@C6 varchar(10),@C7 varchar(20),@C8 varchar(12)
DECLARE @C1 varchar(16),@C2 varchar(16),@C3 varchar(48),@C4 varchar(24),@C5 varchar(24),@C6 varchar(16),@C7 varchar(24),@C8 varchar(16)
--SELECT @L1=13,@L2=12,@L3=40,@L4=20,@L5=20,@L6=10,@L7=20,@L8=12
SELECT @L1=16,@L2=16,@L3=48,@L4=24,@L5=24,@L6=16,@L7=24,@L8=16           /*取tab的整数倍*/

if @seq=0  /*当前party该类型第一条告警信息,初始化表头记录*/
begin
	insert into ##mailsend values(@curtype,1,' ')
	insert into ##mailsend values(@curtype,2,'Out off Warning '+case when @curtype=1 then 'Response' when @curtype=2 then 'Solved' else 'Closed' end+' time:')
	insert into ##mailsend values(@curtype,3,' ')
	select @C1='Ticket Number',@C2='Request Date',@C3='Description',@C4='Assignee',@C5='Requestor',@C6='Due Date',@C7='Priority',@C8='out-off days'
	exec fn_addtab @C1 output,@L1
	exec fn_addtab @C2 output,@L2,2
	exec fn_addtab @C3 output,@L3,2
	exec fn_addtab @C4 output,@L4,2
	exec fn_addtab @C5 output,@L5,2
	exec fn_addtab @C6 output,@L6,2
	exec fn_addtab @C7 output,@L7,2
	exec fn_addtab @C8 output,@L8,2
	insert into ##mailsend values(@curtype,4,@C1+'  '+@C2+'  '+@C3+'  '+@C4+'  '+@C5+'  '+@C6+'  '+@C7+'  '+@C8)
	--SELECT @C1+'  '+@C2+'  '+@C3+'  '+@C4+'  '+@C5+'  '+@C6+'  '+@C7+'  '+@C8
/*	insert into ##mailsend values(@curtype,4,CONVERT(CHAR(13),'Ticket Number')+'  '+
						CONVERT(CHAR(12),'Request Date')+'  '+
						CONVERT(CHAR(40),'Description')+'  '+
						CONVERT(CHAR(20),'Assignee')+'  '+
						CONVERT(CHAR(20),'Requestor')+'  '+
						CONVERT(CHAR(10),'Due Date')+'  '+
						CONVERT(CHAR(20),'Priority')+'  '+
						CONVERT(CHAR(12),'out-off days'))	*/
	select @C1=replace(space(@L1-4),' ','-'),@C2=replace(space(@L2-4),' ','-'),@C3=replace(space(@L3-4),' ','-'),@C4=replace(space(@L4-4),' ','-'),
		@C5=replace(space(@L5-4),' ','-'),@C6=replace(space(@L6-4),' ','-'),@C7=replace(space(@L7-4),' ','-'),@C8=replace(space(@L8-4),' ','-')
	/* 画表格线,-4是为了在后面补tab*/
	exec fn_addtab @C1 output,@L1
	exec fn_addtab @C2 output,@L2,2
	exec fn_addtab @C3 output,@L3,2
	exec fn_addtab @C4 output,@L4,2
	exec fn_addtab @C5 output,@L5,2
	exec fn_addtab @C6 output,@L6,2
	exec fn_addtab @C7 output,@L7,2
	exec fn_addtab @C8 output,@L8,2
	insert into ##mailsend values(@curtype,5,@C1+'  '+@C2+'  '+@C3+'  '+@C4+'  '+@C5+'  '+@C6+'  '+@C7+'  '+@C8)
	--SELECT @C1+'  '+@C2+'  '+@C3+'  '+@C4+'  '+@C5+'  '+@C6+'  '+@C7+'  '+@C8
/*	insert into ##mailsend values(@curtype,5,replace(space(@L1),' ','-')+'  '+
						replace(space(@L2),' ','-')+'  '+
						replace(space(@L3),' ','-')+'  '+
						replace(space(@L4),' ','-')+'  '+
						replace(space(@L5),' ','-')+'  '+
						replace(space(@L6),' ','-')+'  '+
						replace(space(@L7),' ','-')+'  '+
						replace(space(@L8),' ','-'))*/
	select @seq=6
end
/*正式插入警报记录*/
select @C1=@ticket,@C2=CONVERT(VARCHAR(10),@accepttime,120),@C3=@subject,@C4=@asparty+'-'+@asuser,@C5=@reparty+'-'+@reuser,@C7=@slpdesc
select @C6=convert(varchar(10),case when @curtype=1 then @restime when @curtype=2 then @soltime else @clstime end,120)
select @C8=str(case when @curtype=1 then DATEDIFF(day,@restime, getdate()) when @curtype=2 then  DATEDIFF(day,@soltime,getdate()) else  DATEDIFF(day,@clstime,getdate()) end)
exec fn_addtab @C1 output,@L1
exec fn_addtab @C2 output,@L2,2
exec fn_addtab @C3 output,@L3,2
exec fn_addtab @C4 output,@L4,2
exec fn_addtab @C5 output,@L5,2
exec fn_addtab @C6 output,@L6,2
exec fn_addtab @C7 output,@L7,2
exec fn_addtab @C8 output,@L8,2
insert into ##mailsend values(@curtype,@seq,@C1+'  '+@C2+'  '+@C3+'  '+@C4+'  '+@C5+'  '+@C6+'  '+@C7+'  '+@C8)
--SELECT @C1+'  '+@C2+'  '+@C3+'  '+@C4+'  '+@C5+'  '+@C6+'  '+@C7+'  '+@C8
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

/****** Object:  Stored Procedure dbo.sp_getWarningNotifyEmail    Script Date: 2005-1-7 9:39:47 ******/

/****** Object:  Stored Procedure dbo.sp_getWarningNotifyEmail    Script Date: 2005-1-6 13:21:39 ******/

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

/****** Object:  Stored Procedure dbo.sp_dailyemail    Script Date: 2005-1-7 9:39:47 ******/

/****** Object:  Stored Procedure dbo.sp_dailyemail    Script Date: 2005-1-6 13:21:39 ******/


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
			--select detail from ##formatmail
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

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

/****** Object:  Stored Procedure dbo.sp_cleanUnusedAttachment    Script Date: 2005-1-7 9:39:47 ******/

/****** Object:  Stored Procedure dbo.sp_cleanUnusedAttachment    Script Date: 2005-1-6 13:21:39 ******/
CREATE PROCEDURE dbo.sp_cleanUnusedAttachment AS

DELETE FROM Attachment WHERE Deleted = 1 OR 
	(NOT EXISTS(SELECT CM_ID FROM Call_Master c WHERE c.AttachmentID = Attachment.Attach_GroupID) AND
	 NOT EXISTS(SELECT CMAH_ID FROM CM_Action_History c WHERE c.CMAH_Attachment_ID = Attachment.Attach_GroupID) AND
	 NOT EXISTS(SELECT ID FROM KB WHERE KB.ProblemAttachGroupID = Attachment.Attach_GroupID OR KB.SolutionAttachGroupID = Attachment.Attach_GroupID)
	)

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Trigger dbo.tI_CallType    Script Date: 2005-1-7 9:39:47 ******/

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

