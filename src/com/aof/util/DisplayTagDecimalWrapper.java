package com.aof.util;

import java.text.DecimalFormat;

import org.apache.taglibs.display.ColumnDecorator;
import org.displaytag.exception.DecoratorException;

public class DisplayTagDecimalWrapper extends ColumnDecorator {

	public String decorate(Object b) throws DecoratorException {
		if(b!=null){
		DecimalFormat df = new DecimalFormat();
		df.setMaximumFractionDigits(2);
		df.setMinimumFractionDigits(2);
		return df.format(b);
		}
		else
			return "0.00";
	}

}
