/*
 * $Id: SequenceUtil.java,v 1.1 2004/11/10 01:39:03 nicebean Exp $
 *
 *  Copyright (c) 2001, 2002 The Open For Business Project - www.ofbiz.org
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a
 *  copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included
 *  in all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 *  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 *  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
 *  OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
 *  THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package com.aof.core.persistence.util;

import java.sql.*;
import java.util.*;
import javax.transaction.*;

import org.apache.log4j.Logger;


import com.aof.core.persistence.jdbc.DatabaseConnection;

/**
 * Sequence Utility to get unique sequences from named sequence banks
 * Uses a collision detection approach to safely get unique sequenced ids in banks from the database
 *
 * @author     <a href="mailto:jonesde@ofbiz.org">David E. Jones</a>
 * @version    $Revision: 1.1 $
 * @since      2.0
 */
public class SequenceUtil {

    
	Logger loger = Logger.getLogger(SequenceUtil.class.getName());
	
    Map sequences = new Hashtable();
    
    
    String tableName;
    String nameColName;
    String idColName;

    private SequenceUtil() {}

    public SequenceUtil(String seqEntity, String nameFieldName, String idFieldName ,String seqName) {
		this.tableName = seqEntity;
		this.nameColName = nameFieldName;
		this.idColName = idFieldName;
    }

    public Long getNextSeqId(String seqName) {
        SequenceBank bank = (SequenceBank) sequences.get(seqName);

        if (bank == null) {
            bank = new SequenceBank(seqName, this);
            sequences.put(seqName, bank);
        }
        return bank.getNextSeqId();
    }

    class SequenceBank {

        public static final long bankSize = 10;
        public static final long startSeqId = 10000;
        public static final int minWaitNanos = 500000;   // 1/2 ms
        public static final int maxWaitNanos = 1000000;  // 1 ms
        public static final int maxTries = 5;

        long curSeqId;
        long maxSeqId;
        String seqName;
        SequenceUtil parentUtil;

        public SequenceBank(String seqName, SequenceUtil parentUtil) {
            this.seqName = seqName;
            this.parentUtil = parentUtil;
            curSeqId = 0;
            maxSeqId = 0;
            fillBank();
        }

        public synchronized Long getNextSeqId() {
            if (curSeqId < maxSeqId) {
                Long retSeqId = new Long(curSeqId);

                curSeqId++;
                return retSeqId;
            } else {
                fillBank();
                if (curSeqId < maxSeqId) {
                    Long retSeqId = new Long(curSeqId);

                    curSeqId++;
                    return retSeqId;
                } else {
                    loger.error("[SequenceUtil.SequenceBank.getNextSeqId] Fill bank failed, returning null");
                    return null;
                }
            }
        }

        protected synchronized void fillBank() {
            // no need to get a new bank, SeqIds available
            if (curSeqId < maxSeqId) return;

            long val1 = 0;
            long val2 = 0;

            // NOTE: the fancy ethernet type stuff is for the case where transactions not available
            boolean manualTX = true;

            Connection connection = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                connection = DatabaseConnection.getConnection();
            } catch (Exception sqle) {
                loger.info("[SequenceUtil.SequenceBank.fillBank]: Unable to esablish a connection with the database... Error was:");
                loger.info(sqle.getMessage());
            } 
  
            String sql = null;

            try {
                try {
                    connection.setAutoCommit(false);
                } catch (SQLException sqle) {
                    manualTX = false;
                }

				DatabaseConnection.beginTrans(connection);
                stmt = connection.createStatement();
                int numTries = 0;

                while (val1 + bankSize != val2) {
                    sql = "SELECT " + parentUtil.idColName + " FROM " + parentUtil.tableName + " WHERE " + parentUtil.nameColName + "='" + this.seqName + "'";
                    rs = stmt.executeQuery(sql);
                    if (rs.next()) {
                        val1 = rs.getInt(parentUtil.idColName);
                    } else {
                        loger.info("[SequenceUtil.SequenceBank.fillBank] first select failed: trying to add " +
                            "row, result set was empty for sequence: " + seqName);
                        try {
                            if (rs != null) rs.close();
                        } catch (SQLException sqle) {
                            loger.info("Error closing result set in sequence util");
                        }
                        sql = "INSERT INTO " + parentUtil.tableName + " (" + parentUtil.nameColName + ", " + parentUtil.idColName + ") VALUES ('" + this.seqName + "', " + startSeqId + ")";
                        if (stmt.executeUpdate(sql) <= 0) return;
                        continue;
                    }
                    try {
                        if (rs != null) rs.close();
                    } catch (SQLException sqle) {
                        loger.info("Error closing result set in sequence util");
                    }

                    sql = "UPDATE " + parentUtil.tableName + " SET " + parentUtil.idColName + "=" + parentUtil.idColName + "+" + SequenceBank.bankSize + " WHERE " + parentUtil.nameColName + "='" + this.seqName + "'";
                    if (stmt.executeUpdate(sql) <= 0) {
                        loger.info("[SequenceUtil.SequenceBank.fillBank] update failed, no rows changes for seqName: " + seqName);
                        return;
                    }

                    sql = "SELECT " + parentUtil.idColName + " FROM " + parentUtil.tableName + " WHERE " + parentUtil.nameColName + "='" + this.seqName + "'";
                    rs = stmt.executeQuery(sql);
                    if (rs.next()) {
                        val2 = rs.getInt(parentUtil.idColName);
                    } else {
                        loger.info("[SequenceUtil.SequenceBank.fillBank] second select failed: aborting, result " +
                            "set was empty for sequence: " + seqName);
                        try {
                            if (rs != null) rs.close();
                        } catch (SQLException sqle) {
                            loger.info("Error closing result set in sequence util");
                        }
                        return;
                    }
                    try {
                        if (rs != null) rs.close();
                    } catch (SQLException sqle) {
                        loger.info("Error closing result set in sequence util");
                    }

                    if (val1 + bankSize != val2) {
                        if (numTries >= maxTries) {
                            loger.error("[SequenceUtil.SequenceBank.fillBank] maxTries (" + maxTries + ") reached, giving up.");
                            return;
                        }
                        // collision happened, wait a bounded random amount of time then continue
                        int waitTime = (new Double(Math.random() * (maxWaitNanos - minWaitNanos))).intValue() + minWaitNanos;

                        try {
                            this.wait(0, waitTime);
                        } catch (Exception e) {
                            loger.info("Error waiting in sequence util");
                        }
                    }

                    numTries++;
                }

                curSeqId = val1;
                maxSeqId = val2;

                DatabaseConnection.commitTrans(connection);
            } catch (SQLException sqle) {
            	DatabaseConnection.rockbackTrans(connection);
                loger.info("[SequenceUtil.SequenceBank.fillBank] SQL Exception while executing the following:\n" +
                    sql + "\nError was:");
                
                return;
            } catch (Exception e){
				DatabaseConnection.rockbackTrans(connection);
				loger.info("[SequenceUtil.SequenceBank.fillBank] SQL Exception while executing the following:\n" +
					sql + "\nError was:");
                
				return;
            }finally {
                try {
                    if (stmt != null) stmt.close();
                } catch (SQLException sqle) {
                    loger.info("Error closing statement in sequence util");
                }
                try {
                    if (connection != null) connection.close();
                } catch (SQLException sqle) {
                    loger.info("Error closing connection in sequence util");
                }
            }
            

        }
    }
}
