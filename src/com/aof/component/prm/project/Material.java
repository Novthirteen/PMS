/* ====================================================================
 *
 * Copyright (c) Atos Origin INFORMATION TECHNOLOGY All rights reserved.
 *
 * ==================================================================== *
 */
package com.aof.component.prm.project;

import java.util.Date;
import java.util.Set;

import com.aof.component.domain.party.UserLogin;

public class Material {
	private Long id;
	private String category;
	private Double amount;
	private CurrencyType currency;
	private Double exchangeRate;
	private ProjectMaster project;
	private Date acceptanceDate;
	private UserLogin projectManager;
	private Double quantity;
	private String description;
	private UserLogin createUser;
	private Date createDate;
	private Double totalEstimateQuantity;
	private Double price;
	private Long index;
	public Long getIndex() {
		return index;
	}
	public void setIndex(Long index) {
		this.index = index;
	}
	/**
	 * @return Returns the acceptanceDate.
	 */
	public Date getAcceptanceDate() {
		return acceptanceDate;
	}
	/**
	 * @param acceptanceDate The acceptanceDate to set.
	 */
	public void setAcceptanceDate(Date acceptanceDate) {
		this.acceptanceDate = acceptanceDate;
	}
	/**
	 * @return Returns the amount.
	 */
	public Double getAmount() {
		return amount;
	}
	/**
	 * @param amount The amount to set.
	 */
	public void setAmount(Double amount) {
		this.amount = amount;
	}
	/**
	 * @return Returns the currency.
	 */
	public CurrencyType getCurrency() {
		return currency;
	}
	/**
	 * @param currency The currency to set.
	 */
	public void setCurrency(CurrencyType currency) {
		this.currency = currency;
	}
	/**
	 * @return Returns the description.
	 */
	public String getDescription() {
		return description;
	}
	/**
	 * @param description The description to set.
	 */
	public void setDescription(String description) {
		this.description = description;
	}
	/**
	 * @return Returns the exchangeRate.
	 */
	public Double getExchangeRate() {
		return exchangeRate;
	}
	/**
	 * @param exchangeRate The exchangeRate to set.
	 */
	public void setExchangeRate(Double exchangeRate) {
		this.exchangeRate = exchangeRate;
	}
	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @return Returns the project.
	 */
	public ProjectMaster getProject() {
		return project;
	}
	/**
	 * @param project The project to set.
	 */
	public void setProject(ProjectMaster project) {
		this.project = project;
	}
	/**
	 * @return Returns the projectManager.
	 */
	public UserLogin getProjectManager() {
		return projectManager;
	}
	/**
	 * @param projectManager The projectManager to set.
	 */
	public void setProjectManager(UserLogin projectManager) {
		this.projectManager = projectManager;
	}
	/**
	 * @return Returns the quantity.
	 */
	public Double getQuantity() {
		return quantity;
	}
	/**
	 * @param quantity The quantity to set.
	 */
	public void setQuantity(Double quantity) {
		this.quantity = quantity;
	}
	/**
	 * @return Returns the createDate.
	 */
	public Date getCreateDate() {
		return createDate;
	}
	/**
	 * @param createDate The createDate to set.
	 */
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	/**
	 * @return Returns the createUser.
	 */
	public UserLogin getCreateUser() {
		return createUser;
	}
	/**
	 * @param createUser The createUser to set.
	 */
	public void setCreateUser(UserLogin createUser) {
		this.createUser = createUser;
	}
	/**
	 * @return Returns the category.
	 */
	public String getCategory() {
		return category;
	}
	/**
	 * @param category The category to set.
	 */
	public void setCategory(String category) {
		this.category = category;
	}
	/**
	 * @return Returns the totalEstimateQuantity.
	 */
	public Double getTotalEstimateQuantity() {
		return totalEstimateQuantity;
	}
	/**
	 * @param totalEstimateQuantity The totalEstimateQuantity to set.
	 */
	public void setTotalEstimateQuantity(Double totalEstimateQuantity) {
		this.totalEstimateQuantity = totalEstimateQuantity;
	}
	public Double getPrice() {
		return price;
	}
	public void setPrice(Double price) {
		this.price = price;
	}
	
}
