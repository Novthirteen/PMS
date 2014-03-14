/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.util;

import java.io.*;
import java.util.*;

import org.apache.log4j.Logger;
import org.apache.struts.upload.FormFile;

/**
 * @author xxp 
 * @version 2003-7-19
 *
 */
public class UploadFile {
	Logger log = Logger.getLogger(UploadFile.class.getName());
	/**
	 * @param fileData
	 * @param writeFileName
	 * @return
	 */
	public String execUploadContentFile(InputStream fileData,String writeFileName){
		try{
			Properties prop = new Properties();
			log.info(PropertiesUtil.getProperty("uploadpath"));
			prop.load( new FileInputStream(PropertiesUtil.getProperty("uploadpath")) );
            
			String writeFileToPath = prop.getProperty ("CONTENT_WRITE_PATH");
			String urlFileToPath = prop.getProperty("CONTENT_VIEW_URL_PATH");
			
			String fileName = writeFileToPath + writeFileName;
			String urlName = urlFileToPath + writeFileName;
			
			boolean writeFile = true;

			String data = null;		

			log.info("写入文件路径:" + fileName);				
			log.info("写入数据库路径:" + urlName);
			
			//retrieve the file data
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			InputStream stream = fileData;

			if (!writeFile) {  
				return null;
				/*
				//only write files out that are less than 1MB
				if (fileSize < (4 * 1024000)) {

					byte[] buffer = new byte[8192];
					int bytesRead = 0;
					while ((bytesRead = stream.read(buffer, 0, 8192)) != -1) {
						baos.write(buffer, 0, bytesRead);
					}
					data = new String(baos.toByteArray());
				} else {
					data =
						new String(
							"The file is greater than 4MB, "
								+ " and has not been written to stream."
								+ " File Size: "
								+ fileSize
								+ " bytes. This is a"
								+ " limitation of this particular web application, hard-coded"
								+ " in org.apache.struts.webapp.upload.UploadAction");
				}
				*/
			} else {
				
				//write the file to the file specified
				log.info("开始写入上传文件"+fileName);
				//OutputStream bos = new FileOutputStream(UtilString.toUtf8String(fileName));
				OutputStream bos = new FileOutputStream(fileName);
				int bytesRead = 0;
				byte[] buffer = new byte[8192];
				while ((bytesRead = stream.read(buffer, 0, 8192)) != -1) {
					bos.write(buffer, 0, bytesRead);
				}
				bos.close();
				data =
					"The file has been written to \""
						+ writeFileToPath
						+ "\"";
				log.info(data);
			}
			//close the stream
			stream.close();
			return urlName;
		}catch(Exception e){
			e.printStackTrace();
			log.error(e.getMessage());
			return null;
		}
	}
	/**
	 * @param fileData
	 * @param fileSize
	 * @param writeFileName
	 * @return
	 */
	public String execUploadFile(InputStream fileData,int fileSize,String writeFileName)  {
		 
		try{
			Properties prop = new Properties();
			log.info(PropertiesUtil.getProperty("uploadpath"));
			prop.load( new FileInputStream(PropertiesUtil.getProperty("uploadpath")) );
            
			String writeFileToPath = prop.getProperty ("WRITE_PATH");
			String fileName = writeFileToPath + writeFileName;
			
			boolean writeFile = true;

			//retrieve the file size
			String size = (fileSize + " bytes");
			String data = null;		

			log.info("写入文件路径:" + fileName);				
			log.info("写入的文件大小:" + fileSize);
			
			//retrieve the file data
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			InputStream stream = fileData;

			if (!writeFile) {  
				return null;
				/*
				//only write files out that are less than 1MB
				if (fileSize < (4 * 1024000)) {

					byte[] buffer = new byte[8192];
					int bytesRead = 0;
					while ((bytesRead = stream.read(buffer, 0, 8192)) != -1) {
						baos.write(buffer, 0, bytesRead);
					}
					data = new String(baos.toByteArray());
				} else {
					data =
						new String(
							"The file is greater than 4MB, "
								+ " and has not been written to stream."
								+ " File Size: "
								+ fileSize
								+ " bytes. This is a"
								+ " limitation of this particular web application, hard-coded"
								+ " in org.apache.struts.webapp.upload.UploadAction");
				}
				*/
			} else {
				
				//write the file to the file specified
				log.info("开始写入上传文件"+fileName);
				OutputStream bos = new FileOutputStream(fileName);
				int bytesRead = 0;
				byte[] buffer = new byte[8192];
				while ((bytesRead = stream.read(buffer, 0, 8192)) != -1) {
					bos.write(buffer, 0, bytesRead);
				}
				bos.close();
				data =
					"The file has been written to \""
						+ writeFileToPath
						+ "\"";
				log.info(data);
			}
			//close the stream
			stream.close();
			return fileName;
		}catch(Exception e){
			e.printStackTrace();
			log.error(e.getMessage());
			return null;
		}
			
	}

}
