/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */

package com.aof.webapp.action;

/**
 * @author Paige Li 
 * @version 2004-12-19
 */
public class ComPageCtl extends ComBeanInf {

	public static final int TOP_PAGE = 1;

	private int maxPage = 0;

	private int currentPage = 0;

	private int allPage = 0;

	private int recCount = 0;

	private boolean sortFlag = true;

	private String preSort = "none";

	public boolean setPage(int maxPage, int recCount) {

		boolean next = false;

		sortFlag = true;
		preSort = "none";

		this.recCount = recCount;
		if (this.recCount > 0) {
			this.allPage = recCount / maxPage;
			if (recCount % maxPage > 0) {
				this.allPage++;
			}
		} else {
			this.allPage = 0;
		}
		this.currentPage = 1;
		this.maxPage = maxPage;

		if (this.allPage > this.currentPage) {
			next = true;
		}
		return (next);
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public boolean setTopPage() {

		boolean next = false;

		this.currentPage = 1;
		if (this.allPage > this.currentPage) {
			next = true;
		}
		return (next);
	}

	public boolean setEndPage() {

		boolean prev = false;

		this.currentPage = this.allPage;
		if (this.currentPage > 1) {
			prev = true;
		}
		return (prev);
	}

	public boolean nextPage() {

		boolean next = false;

		this.currentPage++;
		if (this.allPage > this.currentPage) {
			next = true;
		}
		return (next);
	}

	public boolean prevPage() {

		boolean prev = false;

		this.currentPage--;
		if (this.currentPage > 1) {
			prev = true;
		}
		return (prev);
	}

	public String getPageInf() {

		String inf = null;
		boolean next = false;
		boolean prev = false;

		if (this.currentPage > 1) {
			prev = true;
		}

		if (this.allPage > this.currentPage) {
			next = true;
		}

		if (prev && next) {
			inf = "all";
		} else if (next) {
			inf = "next";
		} else if (prev) {
			inf = "prev";
		} else {
			inf = "none";
		}
		return (inf);
	}

	public boolean hasPrev() {
		return (this.currentPage > 1);
	}

	public boolean hasNext() {
		return (this.allPage > this.currentPage);
	}

	public int getMaxPage() {
		return (this.maxPage);
	}

	public int getOffset() {
		return ((this.currentPage - 1) * this.maxPage);
	}

	public int getRecordCount() {
		return (this.recCount);
	}

	public void setSortFlag(boolean sortFlag) {
		this.sortFlag = sortFlag;
	}

	public boolean getSortFlag() {
		return (this.sortFlag);
	}

	public void setPreSort(String preSort) {
		this.preSort = preSort;
	}

	public String getPreSort() {
		return (this.preSort);
	}

	public int getAllPage() {

		return this.allPage;
	}

	public int getCurrentPage() {
		return currentPage;
	}

}
