package com.aof.util;

import java.text.DecimalFormat;

import org.apache.taglibs.display.ColumnDecorator;
import org.displaytag.exception.DecoratorException;

public class DisplayTagNullFormatWrapper extends ColumnDecorator{

	public String decorate(Object b) throws DecoratorException {
		if(b == null)
			return "0";
		else
			return b.toString();
	}


	

}
