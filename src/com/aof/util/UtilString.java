/*
 * Created on 2004-5-13
 *
 */
package com.aof.util;

import java.util.*;

/**
 * @author xxp
 *
*/
public class UtilString {

	public static String removeSymbol(String value, char symbol) {
		
		if (value == null) {
			return null;
		}
		StringBuffer sb = new StringBuffer();
		for (int i0 = 0; i0 < value.length(); i0 ++) {
			char c = value.charAt(i0);
			
			if (c != symbol) {
				sb.append(c);
			}
		}
		
		return sb.toString();
	}
	
	public static String convertToSqlInPara(String value){
		String result = "";
		StringTokenizer oTokenizer = new StringTokenizer(value,",");			
		while (oTokenizer.hasMoreTokens()) 
		{ 
			String sNextToken = oTokenizer.nextToken();
			result = result+ "'"+sNextToken.toString()+"',";
		}
		if(result.length()>0){
			result = result.substring(0,result.length()-1);
			result = "( "+result+" )";			
		}
		return result;		
	}

	public static String toUtf8String(String s) {
		StringBuffer sb = new StringBuffer();
		for (int i=0;i<s.length();i++) {
			char c = s.charAt(i);
			if (c >= 0 && c <= 255) {
			sb.append(c);
			} else {
			byte[] b;
			try {
				b = Character.toString(c).getBytes("utf-8");
			} catch (Exception ex) {
				b = new byte[0];
			}
			for (int j = 0; j < b.length; j++) {
				int k = b[j];
				if (k < 0) k += 256;
				sb.append("%" + Integer.toHexString(k).
				toUpperCase());
			}
			}
		}
		return sb.toString();
		}	
}
