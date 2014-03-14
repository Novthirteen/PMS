package com.aof.core.persistence.jdbc;

/**
 *  User JDBC Create access Database connection.
*   @author Xuxingping
*   @version 1.0
*/

import java.sql.*;
import java.util.*;
import java.io.FileInputStream;
import java.io.IOException;

import org.apache.log4j.Logger;

import com.aof.util.*;

   
public class DatabaseConnection{
    
    protected static Logger log = Logger.getLogger(DatabaseConnection.class.getName());
  
  	public static Connection getDataSourceConnection( ){
  		return null;
  	}
    
    /**
     * Gets connection by filename and object( a key string)
     * 
     */
    public static Connection getConnection( String filename, String sobject ) {
        Connection conn = null;
        Properties prop = new Properties();

        try {
        	
            prop.load(new FileInputStream(filename));
            String dataType = "";
            if( sobject.equals("") ) {
                dataType = prop.getProperty("dataType");
            } else {
                dataType = prop.getProperty(sobject + "-dataType");
                if( dataType == null || dataType.equals("")) {
                    //log.info(sobject + "-dataType is null. program load [dataType]." );
                    dataType = prop.getProperty("dataType");
                    sobject = "default";
                }
            }
            //log.info("data type is " + dataType );
            String objectName = prop.getProperty( sobject );
            //log.info("ready connection to "+ objectName);
            //Gets connection object by dataType
            if (dataType.equalsIgnoreCase("oracle") || dataType.equalsIgnoreCase("mysql")) {
                conn = getConnectionFromOracle817(prop, objectName);
            } else {
                if (dataType.equalsIgnoreCase("sqlserver")) {
                    conn = getConnectionFromSqlServer(prop, objectName);
                } else {
                    if(dataType.equalsIgnoreCase("odbc")) {
                        conn = getConnectionFromODBC(prop, objectName);
                    }else{
                    	if(dataType.equalsIgnoreCase("localdb2")){
                    		conn = getConnectionFromLocalDB2(prop,objectName);
                    	}else{
							if(dataType.equalsIgnoreCase("netdb2")){
								conn = getConnectionFromNetDB2(prop,objectName);
							}
                    	}
                    }
                } 
            }
        } catch (IOException ioe) {
            log.error("��ȡ���������ļ�datasource.propertiesʱ����" + ioe.getMessage());
			ioe.printStackTrace();          
        } catch (Exception ex) {
            log.error("�޷��������ݿ����ӣ�"  + ex.getMessage());
            ex.printStackTrace();
        }
        
        /*
        try {
            //conn.setTransactionIsolation( conn.TRANSACTION_READ_COMMITTED);
        } catch( Exception ex ) {
            log.error ("��������ȼ�ʧ��...������ܲ�������ʹ��");
        }
        */
        return conn;
    }
    
    /**
     * Gets a jdbc connection by properties file.
     */
    /*
    public static Connection getConnection( String filename, Map objectMap ) {
        String objectName = "";
        
        if( objectMap.containsKey("supplierId")) {
            objectName =  "_" + objectMap.get("supplierId");
        } 
        if( objectMap.containsKey("branchId")) {
            objectName =  objectName + "_" + objectMap.get("branchId");
        } 
        if( objectMap.containsKey("anotherKey")) {
            objectName =  objectName + "_" + objectMap.get("anotherKey");
        } 
        
        if( objectName.equals("") ) {
            objectName = "default"; 
        }
        log.info("objectName= "+objectName);
        return getConnection( filename, objectName );
    }
 
    public static Connection getConnection(Map objectMap) {
        return getConnection( getDefaultFileName(), objectMap );
    }
    
    public static Connection getConnection(String object ) {
        return getConnection( getDefaultFileName(), object );   
    }
    */
   /**
     * Call method getConnection() the it will use default file.
     */
    public static Connection getConnection(){
        //Gets default config file
        return getConnection( getDefaultFileName(), "default");
    }
    
    public static String getDefaultFileName() {
        return PropertiesUtil.getProperty("datasource");  
    }
    
    public static void beginTrans(Connection conn) throws Exception {
        try {
            conn.setAutoCommit( false );
        } catch( Exception ex ) {
            throw new Exception("��������ʧ�ܣ�" + ex.getMessage());
        }
    }
    
    public static boolean commitTrans(Connection conn) {
        try {
            if( !conn.getAutoCommit() ) {
                conn.commit();
                conn.setAutoCommit(true);
            }
            return true;
        } catch( Exception ex ) {
            log.info ("�����ύʧ��" + ex.getMessage());
        }
        return false;
    }
    
    /**
     * rockback trans
     */
    public static boolean rockbackTrans( Connection conn ) {
        try {
            if( !conn.getAutoCommit() ) {
                conn.rollback();
                conn.setAutoCommit(true);
            }   
            return true;
        } catch( Exception ex ) {
            log.info ("����ع�ʧ��" + ex.getMessage());    
        }
        return false;
    }


    /**
     * for the UFSystem 
     */
    public static Connection getUFSystemConn () throws Exception {
        final String DATABASE_NAME = "UFSystem";

        String connStr = null;

        String portNumber = "1433";     //Default portNumber is 1433
        String linkURI = "com.microsoft.jdbc.sqlserver.SQLServerDriver";

        Connection conn = null;
        try{
            Properties prop = new Properties();

            prop.load(new FileInputStream(getDefaultFileName() ) );
            
            String defaultStr =  prop.getProperty ("default");
            String serverName = prop.getProperty (defaultStr + ".ServerName");
            String userName = prop.getProperty(defaultStr+".UserName");
            String pwd = prop.getProperty(defaultStr+".Password");

            if ( prop.containsKey (defaultStr + ".PortNumber")){
                portNumber = prop.getProperty (defaultStr+".PortNumber");
            }
            
            if(prop.containsKey(defaultStr+".LinkURI")){
                linkURI = prop.getProperty(defaultStr+".LinkURI");
            }


            connStr = "jdbc:microsoft:sqlserver://"+serverName+":"+portNumber+";";

            connStr += "DatabaseName="+ DATABASE_NAME+";";
            connStr += "User="+userName+";Password="+pwd;


            Class.forName(linkURI);
            conn = DriverManager.getConnection(connStr);
        }catch(SQLException sqle){
            log.error("���ӵ�UFSystem ���ݿ�ʱ����"+sqle.getMessage());
            
        }catch(Exception e){
            log.error("ȡ��UFSystem���ݿ�����ʱ����"+e.getMessage());

        }
        return conn;
    }





    /**
     * Gets a connection for sqlserver by datasource.properties
     */
    private static Connection getConnectionFromSqlServer(Properties prop,String name) throws Exception {
        String connStr = null;
        String serverName = null;       //IP Address or hostName
        String databaseName = null;
        String userName = null;
        String password = null;
        String portNumber = "1433";     //Default portNumber is 1433
        String linkURI = "com.microsoft.jdbc.sqlserver.SQLServerDriver";

        String fileName = null;         //Define for file sqlDB.properties
        Connection conn = null;
        try{
            if(prop.containsKey(name+".ServerName")){
                serverName = prop.getProperty(name+".ServerName");
                
            }else{
                log.info ("û�������������ļ�������ServerName��");
                return null;
            }

            if(prop.containsKey(name+".UserName")){
                userName = prop.getProperty(name+".UserName");
                
            }else{
                log.info ("û�������������ļ�������UserName��");
                return null;
            }

            if(prop.containsKey(name+".Password")){
                password = prop.getProperty(name+".Password");
            }else{
                log.info ("û�������������ļ�������Password��");
                return null;
            }

            if(prop.containsKey(name+".DatabaseName")){
                databaseName = prop.getProperty(name+".DatabaseName");
            }
            if(prop.containsKey(name+".PortNumber")){
                portNumber = prop.getProperty(name+".PortNumber");
            }
            if(prop.containsKey(name+".LinkURI")){
                linkURI = prop.getProperty(name+".LinkURI");
            }

        }catch(Exception e){
            log.info ("��ȡ���ݿ����������ļ�ʱ����"+e.getMessage());
            throw e;
        }

        connStr = "jdbc:microsoft:sqlserver://"+serverName+":"+portNumber+";";

        if(databaseName != null){
            connStr += "DatabaseName="+databaseName+";";
        }
        connStr += "User="+userName+";Password="+password;
		
        try{
            Class.forName(linkURI);
            conn = DriverManager.getConnection(connStr);
        }catch(SQLException sqle){
            log.info ("���ӵ�SQLServer���ݿ�ʱ����"+sqle.getMessage());
            throw sqle;
        }catch(Exception e){
            log.info("ȡ�����ݿ�����ʱ����"+e.getMessage());
            throw e;
        }
        return conn;
    }

    /**
     * Gets a connection for oracle by datasource.properties
     */
    private static Connection getConnectionFromOracle817(Properties prop,String name) throws Exception{

        Connection conn = null;

        try{//get the connection properties

            String driver = prop.getProperty(name + ".jdbc-driver");
            String uri = prop.getProperty(name + ".jdbc-uri");
            String username = prop.getProperty(name + ".jdbc-username");
            String password = prop.getProperty(name + ".jdbc-password");
            log.info("driver: "+driver);
            log.info("uri: "+uri);
            log.info("username: "+username);
            log.info("password: ******");
            //instance the driver
            Class.forName ( driver);//.newInstance();

            conn = DriverManager.getConnection ( uri, username, password);

        }catch(Exception e){
            log.info ("���ݿ�����ʧ��." + e.getMessage());
            throw e;
        }
        return conn;
    }

    /**
     * Gets a connection for access
     */
    private static Connection getConnectionFromODBC(Properties prop, String name) throws Exception {
        Connection conn = null;
        
        try {
            //Gets connection setting value
            String driver = prop.getProperty(name + ".jdbc-driver");
            String uri = prop.getProperty(name + ".jdbc-uri");
            String username = prop.getProperty(name + ".jdbc-username");
            String password = prop.getProperty(name + ".jdbc-password");
            log.info("driver: " + driver);
            log.info("uri: " + uri);
            log.info("username: " + username);
            log.info("password: ******");
            //instance the driver
            Class.forName(driver);
            conn = DriverManager.getConnection(uri, username, password);
        } catch (SQLException sqle) {
            log.info ("���ӵ�Access���ݿ�ʱ����" + sqle.getMessage());
            throw sqle;
        } catch (Exception e) {
            log.info("ȡ�����ݿ�����ʱ����" + e.getMessage());
            throw e;
        }
        return conn;
    }

	/**
	 * Gets a connection for db2
	 */
	private static Connection getConnectionFromLocalDB2(Properties prop, String name) throws Exception {
		Connection conn = null;
        
		try {
			//Gets connection setting value
			String driver = prop.getProperty(name + ".jdbc-driver");
			String uri = prop.getProperty(name + ".jdbc-uri");
			String username = prop.getProperty(name + ".jdbc-username");
			String password = prop.getProperty(name + ".jdbc-password");
			//log.info("driver: " + driver);
			//log.info("uri: " + uri);
			//log.info("username: " + username);
			//log.info("password: ******");
			//instance the driver
			Class.forName(driver);
			conn = DriverManager.getConnection(uri, username, password);
		} catch (SQLException sqle) {
			log.info ("���ӵ�DB2���ݿ�ʱ����" + sqle.getMessage());
			throw sqle;
		} catch (Exception e) {
			log.info("ȡ�����ݿ�����ʱ����" + e.getMessage());
			throw e;
		}
		return conn;
	}

	/**
	 * Gets a connection for db2
	 */
	private static Connection getConnectionFromNetDB2(Properties prop, String name) throws Exception {
		Connection conn = null;
        
		try {
			//Gets connection setting value
			String driver = prop.getProperty(name + ".jdbc-driver");
			String uri = prop.getProperty(name + ".jdbc-uri");
			String username = prop.getProperty(name + ".jdbc-username");
			String password = prop.getProperty(name + ".jdbc-password");
			log.info("driver: " + driver);
			log.info("uri: " + uri);
			log.info("username: " + username);
			log.info("password: ******");
			//instance the driver
			Class.forName(driver);
			conn = DriverManager.getConnection(uri, username, password);
		} catch (SQLException sqle) {
			log.info ("���ӵ�DB2���ݿ�ʱ����" + sqle.getMessage());
			throw sqle;
		} catch (Exception e) {
			log.info("ȡ�����ݿ�����ʱ����" + e.getMessage());
			throw e;
		}
		return conn;
	}

    /**
     * ִ��һ��SQL
     */
    public static ResultSet executeSql(Connection conn, String strSql) {
		Statement ps = null;
        try {
            return  conn.createStatement().executeQuery( strSql );
        } catch( Exception ex ) {
            //Ignore the  
            return null;
        }finally {
			if (ps != null) {
				try {
					ps.close();
				} catch (SQLException sqle) {
					log.error(sqle.getMessage());
				}
			}
		}        
    }
    
    public static int executeUpdate(Connection conn, String strSql){
    	int result = -1;
    	try{
    		return conn.createStatement().executeUpdate( strSql );
    	}catch( SQLException sqle){
			sqle.printStackTrace();
    	}finally{
			return -1;
    	}
    }
    
    public static void closeConnection(Connection conn){
    	try{
    		if(conn!=null) conn.close();
    	}catch(Exception e){
    		e.printStackTrace();
    	}
    }
    
	   
    public static Connection getConnectionFromMfgPro(String filename, String name) throws Exception {
		Connection conn = null;
		Properties prop = new Properties();

		try {
			prop.load(new FileInputStream(filename));
			//Gets connection setting value
			String driver = prop.getProperty(name + ".jdbc-driver");
			String uri = prop.getProperty(name + ".jdbc-uri");
			String username = prop.getProperty(name + ".jdbc-username");
			String password = prop.getProperty(name + ".jdbc-password");
			Class.forName(driver);
			conn = DriverManager.getConnection(uri, username, password);
		} catch (SQLException sqle) {
			log.info ("���ӵ�MFG/PRO "+name+"���ݿ�ʱ����" + sqle.getMessage());
			throw sqle;
		} catch (Exception e) {
			log.info("ȡ�����ݿ�����ʱ����" + e.getMessage());
			throw e;
		}
		return conn;
    	
    }
    

}