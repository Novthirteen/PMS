/*
 * Created on 2004-11-10
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.aof.webapp.form;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

/**
 * @author shilei
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
/**
 * An abstract base class for ActionForms that adds support for automatic
 * formatting and unformatting of string values and for the transfer of the
 * resulting values between itself and the given bean. The
 * <code>populate()</code> method provides an entry point to this
 * functionality, while the <code>keysToSkip()</code> method allows subclasses
 * to specify fields that should not be populated.
 * <p>
 * Additional methods are provided to allow subclasses to override formatting
 * defaults. The <code>setDefaultString()</code> method allows callers to
 * specify overrides for the default string used to represent a
 * <code>null</code> for a given property. Similarly, the
 * <code>setFormatterType()</code> method allows callers to specify a
 * formatting type other than the default for a given property.
 * <p>
 * Developers can also specify validation rules by invoking
 * <code>addRange()</code> to add a range validation or
 * <code>addRequiredFields() to add required field validations for an
 * array of property names.
 */
public class BaseForm extends ActionForm {
	/** Indicates that conversion is from string to object */
	public final static int TO_OBJECT = 0;

	/** Indicates that conversion is from object to string */
	public final static int TO_STRING = 1;

	/** Formatter class to use for given property. Overrides default. */
	private Map formatMap = new HashMap();

	/** The value object associated with this form */
	private transient Object bean;

	/** The validation rules for this form */
	private Map validationMap = new HashMap();

	/**
	 * The strings to display when null values are encountered. Keys correspond
	 * to fields in the Form. The presence of a given key indicates that the
	 * value provided in the map should be used instead of the normal default
	 * string.
	 */
	private Map defaultStringMap = new HashMap();

	/**
	 * Populates the bean associated with this form and returns an ActionErrors
	 * populated with validation errors, if any.
	 * 
	 * @return Validation errors.
	 */
	public ActionErrors validate(ActionMapping mapping,
			HttpServletRequest request) {
		/*ActionErrors errors = populate(this.bean, TO_OBJECT);
		return errors;*/
		return null;
	}

	/**
	 * Populates the form with values from the given bean, converting Java types
	 * to formatted string values suitable for presentation in the user
	 * interface. Conversions are applied automatically by introspecting the
	 * type of each property and finding the appropriate Formatter class to use
	 * based on the type information.
	 * <p>
	 * This behavior can be customized by calling
	 * <code>setFormatterType(String key, Class type)</code> with an
	 * alternative Formatter class for a given property name.
	 * <p>
	 * If null values are encountered in the bean, MyForm will be populated with
	 * the default string supplied by the Formatter, unless the default has been
	 * overridden by calling to
	 * <code>setDefaultString(String key, String value)</code> with an
	 * alternative string.
	 * 
	 * @param bean
	 *            The bean to populate
	 * @return Validation errors
	 */
	public ActionErrors populate(Object bean) {
		return populate(bean, TO_STRING);
	}

	/**
	 * Adds an entry for the provided rule to the validation map.
	 * 
	 * @param key
	 *            The name of the property to which the rule applies
	 * @param rule
	 *            The name of the rule
	 * @param value
	 *            A value or values used in executing the rule
	 */
	public void addValidationRule(String key, String rule, Object value) {
		Map values = (Map) validationMap.get(key);
		if (values == null) {
			values = new HashMap();
			validationMap.put(key, values);
		}
		values.put(rule, value);
	}

	/**
	 * Associates the ¡°required field¡± rule with the provided keys
	 * 
	 * @param keys
	 *            The names of the required fields
	 */
	public void addRequiredFields(String[] keys) {
		for (int i = 0; i < keys.length; i++) {
			addValidationRule(keys[i], "required", Boolean.TRUE);
		}
	}

	/**
	 * Adds a range rule for the provided key
	 * 
	 * @param key
	 *            The name of the property to which the rule applies
	 * @param min
	 *            The minimum allowable value
	 * @param max
	 *            The maximum allowable value
	 */
	public void addRange(String key, Comparable min, Comparable max) {
		Range range = new Range(min, max);
		addValidationRule(key, "range", range);
	}

	/**
	 * Sets the default value to display for the given key when the property
	 * value in the associated bean is <code>null</code>.
	 * 
	 * @param key
	 *            the name of the property
	 * @param value
	 *            the value to display
	 */
	public void setDefaultString(String key, String value) {
		defaultStringMap.put(key, value);
	}

	/**
	 * Sets the default Formatter class to use for the given key
	 * 
	 * @param key
	 *            the name of the property
	 * @param value
	 *            the value to display
	 */
	public void setFormatter(String key, Formatter formatter) {
		formatMap.put(key, formatter);
	}

	public Object getBean() {
		return bean;
	}

	public void setBean(Object bean) {
		this.bean = bean;
	}

	/**
	 * Transfers values to and from the given bean, depending on the value of
	 * <code>mode</code>. If the given mode is <code>TO_STRING</code>,
	 * populates the instance by introspecting the specified bean, converting
	 * any typed values to formatted strings, and then using reflection to
	 * invoke its own String-based setter methods. If the mode is
	 * <code>TO_OBJECT</code>, performs the inverse operation, unformatting
	 * and converting properties of the MyForm instance and populating the
	 * resulting values in the given bean.
	 * <p>
	 * If null values are encountered in the bean, MyForm will be populated with
	 * the default string associated with the given type. The default null
	 * values can be overridden by calling
	 * <code>setDefaultString(String key, String value)</code> with an
	 * alternative string. The default Formatter to use can be overridden by
	 * calling <code>setFormatterType(String key, Class type)</code> with an
	 * alternative Formatter class.
	 * <p>
	 * You ordinarily don¡¯t call this method directly; it is called
	 * automatically by <code>validate()</code>.
	 * 
	 * @param bean
	 *            An object containing the values to be populated
	 * @param mode
	 *            Whether conversion is to String or to Java type
	 * @return Validation errors
	 */
	public ActionErrors populate(Object bean, int mode) {
		String errorMsg = "Unable to format values from bean: " + bean;
		Map valueMap = mapRepresentation(bean);
		ActionErrors errors = new ActionErrors();
		if (mode == TO_STRING)
			setBean(bean);
		Iterator keyIter = valueMap.keySet().iterator();
		while (keyIter.hasNext()) {
			String currKey = (String) keyIter.next();
			Object currValue = valueMap.get(currKey);
			try {
				ActionErrors currErrors = populateProperty(bean, currKey,
						currValue, mode);
				errors.add(currErrors);
			} catch (InstantiationException ie) {
				throw new FormattingException(errorMsg, ie);
			} catch (IllegalAccessException iae) {
				throw new FormattingException(errorMsg, iae);
			} catch (InvocationTargetException ite) {
				throw new FormattingException(errorMsg, ite);
			} catch (NoSuchMethodException nsme) {
				throw new FormattingException(errorMsg, nsme);
			}
		}
		return errors;
	}

	/**
	 * Converts the provided object either from a String to a Java type or vice
	 * versa, depending on the value of <code>mode</code>.
	 * 
	 * @param type
	 *            The class of the associated bean property
	 * @param key
	 *            The name of the associated bean property
	 * @param obj
	 *            The object to convert
	 * @param mode
	 *            Whether conversion is to String or to Java type
	 * @return The converted object
	 */
	protected Object convert(Class type, String key, Object obj, int mode)
			throws InstantiationException, IllegalAccessException,
			NoSuchMethodException, InvocationTargetException {
		Object convertedObj = null;
		Formatter formatter = getFormatter(key, type);
		try {
			switch (mode) {
			case TO_OBJECT:
				convertedObj = formatter.unformat((String) obj);
				break;
			case TO_STRING:
				if (obj == null) {
					convertedObj = (String) defaultStringMap.get(key);
				} else {
					convertedObj = formatter.format(obj);
				}
				break;
			default:
				throw new RuntimeException("Unknown mode: " + mode);
			}
		} catch (FormattingException e) {
			e.setFormatter(formatter);
			throw e;
		}
		return convertedObj;
	}

	/**
	 * Populates the property identified by the provided key. Handling is
	 * provided for nested properties and Lists of nested properties.
	 * 
	 * @param bean
	 *            The Java bean that contains the property
	 * @param key
	 *            The name of the property
	 * @param obj
	 *            The new value for the property
	 * @param mode
	 *            Whether to populate the bean or the form
	 */
	protected ActionErrors populateProperty(Object bean, String key,
			Object obj, int mode) throws InstantiationException,
			IllegalAccessException, NoSuchMethodException,
			InvocationTargetException {
		Object target = (mode == TO_STRING ? this : bean);
		Class type = PropertyUtils.getPropertyType(bean, key);
		ActionErrors errors = new ActionErrors();
		Object value = null;
		if (mode == TO_STRING) {
			value = convert(type, key, obj, mode);
		} else {
			try {
				String errorKey = null;
				value = convert(type, key, obj, mode);
				if (!validateRequired(key, (String) obj))
					errorKey = "error.required";
				else if (!validateRange(key, value))
					errorKey = "error.range";
				if (errorKey != null)
					errors.add(key, new ActionError(errorKey));
			} catch (FormattingException e) {
				String errorKey = e.getFormatter().getErrorKey();
				errors.add(key, new ActionError(errorKey));
			}
		}
		PropertyUtils.setSimpleProperty(target, key, value);
		return errors;
	}

	/**
	 * Returns <code>false</code> if there is a rule corresponding to the
	 * provided key and the given value does not fall within it;
	 * <code>true</code> otherwise.
	 * 
	 * @param key
	 *            The key under which the rule is stored
	 * @param value
	 *            The value to be validated
	 * @return The result of the validation
	 */
	protected boolean validateRange(String key, Object value) {
		Map rules = (Map) validationMap.get(key);
		if (rules == null)
			return true;
		Range range = (Range) rules.get("range");
		return range == null || range.isInRange((Comparable) value);
	}

	/**
	 * Returns <code>false</code> if the provided value is a required field
	 * and is blank or null; <code>true</code> otherwise.
	 * 
	 * @param key
	 *            The name of the field to be validated
	 * @param value
	 *            The value to be validated
	 * @return The result of the validation
	 */
	protected boolean validateRequired(String key, String value) {
		Map rules = (Map) validationMap.get(key);
		if (rules == null)
			return true;
		Boolean required = (Boolean) rules.get("required");
		if (required == null)
			return true;
		boolean isRequired = required.booleanValue();
		boolean isBlank = (value == null || value.trim().equals(""));
		return !(isRequired && isBlank);
	}

	/**
	 * Returns a Map containing the values from the provided Java bean, keyed by
	 * field name. Entries having keys that match any of the strings returned by
	 * <code>keysToSkip()</code> will be removed.
	 * 
	 * @param bean
	 *            the Java bean from which to create the Map
	 * @return a Map containing values from the provided bean
	 */
	protected Map mapRepresentation(Object bean) {
		String errorMsg = "Unable to format values from bean: " + bean;
		Map formMap=null;
		Map beanMap = null;
		Map returnMap=new HashMap();
		//		 PropertyUtils.describe() uses Introspection to generate a Map
		//		 of values from its argument, keyed by field name.
		try {
			beanMap = PropertyUtils.describe(bean);
			formMap=PropertyUtils.describe(this);
		} catch (IllegalAccessException iae) {
			throw new FormattingException(errorMsg, iae);
		} catch (InvocationTargetException ite) {

			throw new FormattingException(errorMsg, ite);
		} catch (NoSuchMethodException nsme) {
			throw new FormattingException(errorMsg, nsme);
		}
		//		 Remove keys for properties that shouldn¡¯t be populated.
		Iterator keyIter = keysToSkip().iterator();
		while (keyIter.hasNext()) {
			String key = (String) keyIter.next();
			beanMap.remove(key);
		}
		keyIter=beanMap.keySet().iterator();
		while(keyIter.hasNext())
		{
			String key = (String) keyIter.next();
			if(formMap.containsKey(key))
			{
				returnMap.put(key,beanMap.get(key));
			}
		}
		
		return returnMap;
	}
	
	/**
	 * Returns an array of keys, representing values that should not be
	 * populated for the current form instance. Subclasses that override this
	 * method to provide additional keys to be skipped should be sure to call
	 * <code>super</code>
	 * 
	 * @return an array of keys to be skipped
	 */
	protected ArrayList keysToSkip() {
		ArrayList keysToSkip = new ArrayList();
		keysToSkip.add("class");
		keysToSkip.add("servletWrapper");
		keysToSkip.add("multipartRequestHandler");
		keysToSkip.add("bean");
		keysToSkip.add("");
		return keysToSkip;
	}
	
	/**
	 * Returns a Formatter for the provided type. If the provided key matches an
	 * entry in the formatMap, the Formatter type indicated by the entry is used
	 * instead of the default for the given type.
	 * 
	 * @param key
	 *            The name of the property to be formatted
	 * @param type
	 *            The type of the property to be formatted
	 * @return A Formatter
	 */
	protected Formatter getFormatter(String key, Class type) {
		Formatter formatter = (Formatter) formatMap.get(key);
		if (formatter == null)
			formatter= Formatter.getFormatter(type);
		return formatter;
		
	}
}

