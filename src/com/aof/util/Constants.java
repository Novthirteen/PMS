/*
 * $Header: /home/cvsroot/HelpDesk/src/com/aof/util/Constants.java,v 1.1 2004/11/10 01:39:03 nicebean Exp $
 * $Revision: 1.1 $
 * $Date: 2004/11/10 01:39:03 $
 *
 * ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ====================================================================
 */


package com.aof.util;


/**
 * 维持用户登陆系统后运行信息
 *
 * @author Xingping Xu
 * @version $Revision: 1.1 $ $Date: 2004/11/10 01:39:03 $
 */

public final class Constants {




	/**
     * The package name for this application.
     */
    public static final String Package = "com.aof";


    /**
     * 缓存数据库记录
     */
    public static final String DATABASE_KEY = "DATABASE_KEY";
    /**
     * 缓存HibernateSession连结
     */
	public static final String HIBERNATE_SESSION_KEY = "AOFSESSION";
	/**
	 * Catch the SecurityHandler
	 */
	public static final String SECURITY_HANDLER_KEY = "AOFSECURITY";


    /**
     * 缓存用户信息记录
     */
    public static final String USERLOGIN_KEY = "USERLOGIN_KEY";
	public static final String USERID_KEY = "USERID_KEY";
	public static final String USERNAME_KEY = "USERNAME_KEY";
	public static final String MODELS_KEY = "MODEL_KEY";
	public static final String SECURITY_KEY = "SECURITY_KEY";
	
	public static final String USER_ROLE_KEY="USER_ROLE_KEY";
	public static final String PARTY_KEY = "PARTY_KEY";
	public static final String TRUE_PARTY_KEY = "TRUE_PARTY_KEY";
	
	public static final String ERROR_KEY = "ERROR_KEY";

	public static final String USERLOGIN_ROLE_KEY = "USERLOGIN_ROLE_KEY";
	public static final String SUB_PARTY_KEY = "SUB_PARTY_KEY";
	
	//Transaction Category defination
	public final static String TRANSACATION_CATEGORY_EXPENSE = "Expense";
	public final static String TRANSACATION_CATEGORY_CAF = "CAF";
	public final static String TRANSACATION_CATEGORY_ALLOWANCE = "Allowance";
	public final static String TRANSACATION_CATEGORY_BILLING_ACCEPTANCE = "ProjBill";
	public final static String TRANSACATION_CATEGORY_PAYMENT_ACCEPTANCE = "ProjPayment";
	public final static String TRANSACATION_CATEGORY_OTHER_COST = "OtherCost";
	public final static String TRANSACATION_CATEGORY_DOWN_PAYMENT = "Down-Payment";
	public final static String TRANSACATION_CATEGORY_CREDIT_DOWN_PAYMENT = "Credit-Down-Payment";
	
	//Billing Status defination
	public final static String BILLING_STATUS_DRAFT = "Draft";
	public final static String BILLING_STATUS_WIP = "WIP";
	public final static String BILLING_STATUS_COMPLETED = "Completed";
	
	//PAYMENT Status defination
	public final static String PAYMENT_STATUS_DRAFT = "Draft";
	public final static String PAYMENT_STATUS_WIP = "WIP";
	public final static String PAYMENT_STATUS_COMPLETED = "Completed";
	
	//PAYMENT SETTLEMENT TRANSACTION STATUS
	public final static String POST_PAYMENT_TRANSACTION_STATUS_DRAFT = "Draft";
	public final static String POST_PAYMENT_TRANSACTION_STATUS_POST = "Post";
	public final static String POST_PAYMENT_TRANSACTION_STATUS_PAID = "Paid";
	public final static String POST_PAYMENT_TRANSACTION_STATUS_REJECTED = "Rejected";
	
	//POST PAYMENT Status defination
	public final static String POST_PAYMENT_STATUS_DRAFT = "Draft";
	public final static String POST_PAYMENT_STATUS_WIP = "WIP";
	public final static String POST_PAYMENT_STATUS_COMPLETED = "Completed";
	
	//PAYMENT confirm Status defination
	public final static String PAYMENT_CONFIRM_STATUS_DRAFT = "Draft";
	public final static String PAYMENT_CONFIRM_STATUS_COMPLETED = "Completed";
	
	//Billing Type defination
	public final static String BILLING_TYPE_DOWN_PAYMENT = "Down Payment";
	public final static String BILLING_TYPE_NORMAL = "Normal";
	
//	payment Type defination
	public final static String PAYMENT_TYPE_DOWN_PAYMENT = "Down Payment";
	public final static String PAYMENT_TYPE_NORMAL = "Normal";
	
	//Invoice Status defination
	public final static String INVOICE_STATUS_UNDELIVERED = "Undelivered";
	public final static String INVOICE_STATUS_DELIVERED = "Delivered";
	public final static String INVOICE_STATUS_CONFIRMED = "Confirmed";
	public final static String INVOICE_STATUS_CANCELED = "Cancelled";
	public final static String INVOICE_STATUS_INPROSESS = "In Process";
	public final static String INVOICE_STATUS_COMPLETED = "Completed";
	
	//Invoice Type defination
	public final static String INVOICE_TYPE_NORMAL = "Normal";
	public final static String INVOICE_TYPE_LOST_RECORD = "Lost Record";
	
	//EMS deliver type defination
	public final static String EMS_TYPE_EMS_DELIVER = "EMS Deliver";
	public final static String EMS_TYPE_OTHER_DELIVER = "Other Deliver";
	
	public final static String ONLINE_USER_KEY = "ONLINE_USER_KEY";
	public final static String ONLINE_USER_LISTENER = "ONLINE_USER_LISTENER";
	public final static String ONLINE_USER_IP_ADDRESS = "ONLINE_USER_IP_ADDRESS";
	
	//Payment Status defination
	public final static String PAYMENT_INVOICE_STATUS_DRAFT = "Draft";
	public final static String PAYMENT_INVOICE_STATUS_CONFIRMED = "Confirmed";
	public final static String PAYMENT_INVOICE_STATUS_CANCELED = "Cancelled";
	
	//Receipt Status defination
	public final static String RECEIPT_STATUS_DRAFT = "Draft";
	public final static String RECEIPT_STATUS_WIP = "WIP";
	public final static String RECEIPT_STATUS_COMPLETED = "Completed";
	

	//Supplier Invoice Status defination
	public final static String SUPPLIER_INVOICE_PAY_STATUS_DRAFT = "Draft";
	public final static String SUPPLIER_INVOICE_PAY_STATUS_WIP = "WIP";
	public final static String SUPPLIER_INVOICE_PAY_STATUS_COMPLETED = "Completed";
	public final static String SUPPLIER_INVOICE_SETTLE_STATUS_DRAFT = "Draft";
	public final static String SUPPLIER_INVOICE_SETTLE_STATUS_WIP = "WIP";
	public final static String SUPPLIER_INVOICE_SETTLE_STATUS_COMPLETED = "Completed";

	//Payment Type defination
	public final static String PAYMENT_INVOICE_TYPE_NORMAL = "Normal";
	public final static String PAYMENT_INVOICE_TYPE_LOST_RECORD = "Lost Record";
	
	public final static String CONTRACT_PROFILE_STATUS_UNSIGNED ="Unsigned";
	public final static String CONTRACT_PROFILE_STATUS_SIGNED ="Signed";
	public final static String CONTRACT_PROFILE_STATUS_CANCEL ="Cancel";
	public final static String CONTRACT_PROFILE_STATUS_CLOSED ="Closed";
	
	//StepGroup Disable Flag Status defination
	public final static String STEP_GROUP_DISABLE_FLAG_STATUS_YES = "Y";
	public final static String STEP_GROUP_DISABLE_FLAG_STATUS_NO = "N";
	
	//StepActivity Critical Flag Status defination
	public final static String STEP_ACTIVITY_CRITICAL_FLAG_STATUS_YES = "Y";
	public final static String STEP_ACTIVITY_CRITICAL_FLAG_STATUS_NO = "N";
	
	//BidMaster Status defination
	public final static String BID_MASTER_STATUS_WIP = "WIP";
	public final static String BID_MASTER_STATUS_WIN = "Win";
	public final static String BID_MASTER_STATUS_WON = "Won";
	public final static String BID_MASTER_STATUS_WITHDRAWED = "Withdrawed";
	public final static String BID_MASTER_STATUS_PENDING = "Pending";
	public final static String BID_MASTER_STATUS_LOST = "Lost";
	
}
