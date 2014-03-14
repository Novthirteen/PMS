
//  QuickMenu Pro, Copyright (c) 1998 - 2003, OpenCube Inc. - http://www.opencube.com


/**********************************************************************************************
**********************************************************************************************

                              Bullet and Icon Image Library  

**********************************************************************************************
**********************************************************************************************/



/*-------------------------------------------
Bullet and Icon image library - Unlimited bullet
or icon images may be defined below and then associated
with any sub menu items within the 'Sub Menu Structure 
and Text' section of this data file.  Relative 
positioned icon images may also be associated
with any main menu item in the 'main menu items' section.
--------------------------------------------*/


    //Relative positioned icon images (flow with main menu or sub item text)

	dqm__icon_image0 = "images/bullet.gif"
	dqm__icon_rollover0 = "images/bullet_hl.gif"
	dqm__icon_image_wh0 = "13,8"

	

    //Absolute positioned icon images (coordinate positioned, sub menus only)

	dqm__2nd_icon_image0 = "images/arrow.gif"
	dqm__2nd_icon_rollover0 = "images/arrow.gif"
	dqm__2nd_icon_image_wh0 = "13,10"
	dqm__2nd_icon_image_xy0 = "0,4"





/**********************************************************************************************
**********************************************************************************************

                              Main Menu Settings  

**********************************************************************************************
**********************************************************************************************/



/*---------------------------------------------
Main Item Widths and Heights
-----------------------------------------------*/

	
	dqm__main_width = 120			//default main item widths
	dqm__main_height = 22			//default main item heights
	
	//dqm__main_widthX			//specific main item widths
	//dqm__main_heightX			//specific main item heights


	dqm__main_width0 = 60;
	/*
	dqm__main_width2X = 140;
	dqm__main_width3X = 140;
	dqm__main_width4X = 140;
	*/
	dqm__main_width6 = 100;
/*---------------------------------------------
Main Menu Borders Dividers and Layout
-----------------------------------------------*/


	dqm__main_horizontal =true		//align menu bar horizontally or vertically

	dqm__main_border_width = 1;		//the thickness of the border in pixels
	dqm__main_border_color = "#666666"	//HEX color or set width to 0 for no borders


	dqm__main_use_dividers = true		//When true the item gap setting is ignored
						//and the border width and color are used to
						//separate each main menu item.
						
							
	dqm__main_item_gap = 5			//the gap between main menu items in pixels
	

	dqm__align_items_bottom_and_right = true	//align items of different size to the bottom
							//or right edge of the largest main menu item
							//depending on the horizontal or vertical layout
							//of the main menu bar - false aligns items to
							//the top and left

/*---------------------------------------------
Menu Item Background and Text Colors
-----------------------------------------------*/


	dqm__main_bgcolor = "#666666"		//default color for all items, HEX or 'transparent'
	dqm__main_bgcolorX = "#666666"		//specific menu item color, HEX or 'transparent'
	
	dqm__main_hl_bgcolor = "#555555"	//HEX color value or set to 'transparent'
	dqm__main_hl_bgcolorX = "#eeeeee"

	dqm__main_textcolor = "#FFFFFF"
	dqm__main_textcolorX = "#FFFFFF"

	dqm__main_hl_textcolor = "#FFFFFF"
	dqm__main_hl_textcolorX = "#ff0000"



/*---------------------------------------------
Menu Item Font Settings
-----------------------------------------------*/


	dqm__main_fontfamily = "Verdana"	//Any available system font     
	dqm__main_fontsize = 13			//Defined with pixel sizing  	
	dqm__main_textdecoration = "normal"	//set to: 'normal', or 'underline'
	dqm__main_fontweight = "BOLD"		//set to: 'normal', or 'bold'
	dqm__main_fontstyle = "normal"		//set to: 'normal', or 'italic' 	


	//rollover effect
	
	dqm__main_hl_textdecoration = "normal"



/*---------------------------------------------
Main Menu Margins and Text Alignment
-----------------------------------------------*/


	dqm__main_text_alignment = "center"		//set to: 'left', 'center' or 'right'
	dqm__main_margin_top = 4
	dqm__main_margin_bottom = 0
	dqm__main_margin_left = 0
	dqm__main_margin_right = 0



	//specific settings

	dqm__main_text_alignmentX = "center"		//set to: 'left', 'center' or 'right'
	dqm__main_margin_topX = 0
	dqm__main_margin_bottomX = 0



/*---------------------------------------------
Optional Status Bar Text
-----------------------------------------------*/

   
	//dqm__status_text0 = "Sample text - Main Menu Item 0"
	//dqm__status_text1 = "Sample text - Main Menu Item 1"



/*---------------------------------------------
Main Menu Items (Text, URL's, and Icons)
-----------------------------------------------*/


	
    //Main Menu 0

	dqm__maindesc0 = "首页"
	dqm__micon_index0 = 0
	dqm__url0 = "./"



    //Main Menu 1

	dqm__maindesc1 = "分销渠道管理"
	dqm__micon_index1 = 0
	dqm__url1 = "../documents/sample_link.htm"



    //Main Menu 2

	dqm__maindesc2 = "供应商渠道管理"
	dqm__micon_index2 = 0
	dqm__url2 = "../documents/sample_link.htm"



    //Main Menu 3

	dqm__maindesc3 = "系统管理"
	dqm__micon_index3 = 0
	dqm__url3 = "../documents/sample_link.htm"



    //Main Menu 4

	dqm__maindesc4 = "内容管理"
	dqm__micon_index4 = 0
	dqm__url4 = "../documents/sample_link.htm"



/**********************************************************************************************
**********************************************************************************************

                              Sub Menu Settings

**********************************************************************************************
**********************************************************************************************/


/*-------------------------------------------
Colors, Borders, Dividers, and more...
--------------------------------------------*/


	dqm__sub_menu_width = 130      		//default sub menu widths
	dqm__sub_xy = "0,0"            		//default sub x,y coordinates - defined relative
						//to the top-left corner of parent image or sub menu
   

	dqm__urltarget = "_self"		//default URL target: _self, _parent, _new, or "my frame name"

	dqm__border_width = 1
	dqm__divider_height = 1			//这里设置子菜单边框

	dqm__border_color = "#666666"		//Hex color or 'transparent'
	dqm__menu_bgcolor = "#ffffff"		//Hex color or 'transparent'
	dqm__hl_bgcolor = "#FF0000"		

	dqm__mouse_off_delay = 1		//defined in milliseconds (activated after mouse stops)
	dqm__nn4_mouse_off_delay = 1		//defined in milliseconds (activated after leaving sub)



/*-------------------------------------------
Font settings and margins
--------------------------------------------*/
   

    //Font settings

	dqm__textcolor = "#333333"
	dqm__fontfamily = "Verdana"		//Any available system font     
	dqm__fontsize = 11			//Defined with pixel sizing  	
	dqm__fontsize_ie4 = 9			//Defined with point sizing
	dqm__textdecoration = "normal"		//set to: 'normal', or 'underline'
	dqm__fontweight = "normal"		//set to: 'normal', or 'bold'
	dqm__fontstyle = "normal"		//set to: 'normal', or 'italic' 	


    //Rollover font settings

	dqm__hl_textcolor = "#FFFFFF"
	dqm__hl_textdecoration = "normal"	//set to: 'normal', or 'underline'



    //Margins and text alignment

	dqm__text_alignment = "left"		//set to: 'left', 'center' or 'right'
	dqm__margin_top = 3
	dqm__margin_bottom = 3
	dqm__margin_left = 5
	dqm__margin_right = 4



/*---------------------------------------------
Optional Status Bar Text
-----------------------------------------------*/


	dqm__show_urls_statusbar = false

	//dqm__status_text1_0 = "Sample text - Main Menu Item 1, Sub Item 0"	
	//dqm__status_text1_0 = "Sample text - Main Menu Item 1, Sub Item 1"	



/*-------------------------------------------
Internet Explorer Transition Effects
--------------------------------------------*/


    //Options include - none | fade | pixelate |iris | slide | gradientwipe | checkerboard | radialwipe | randombars | randomdissolve |stretch

	dqm__sub_menu_effect = "fade"
	dqm__sub_item_effect = "none"


    //Define the effect duration in seconds below.
   
	dqm__sub_menu_effect_duration = .4
	dqm__sub_item_effect_duration = .4


    //Specific settings for various transitions.

	dqm__effect_pixelate_maxsqare = 25
	dqm__effect_iris_irisstyle = "CIRCLE"		//CROSS, CIRCLE, PLUS, SQUARE, or STAR
	dqm__effect_checkerboard_squaresx = 14
	dqm__effect_checkerboard_squaresY = 14
	dqm__effect_checkerboard_direction = "RIGHT"	//UP, DOWN, LEFT, RIGHT


    //Opacity and drop shadows.

	dqm__sub_menu_opacity = 100			//1 to 100
	dqm__dropshadow_color = "none"			//Hex color value or 'none'
	dqm__dropshadow_offx = 5			//drop shadow width
	dqm__dropshadow_offy = 5			//drop shadow height



/*-------------------------------------------
Browser Bug fixes and Workarounds
--------------------------------------------*/


    //Mac offset fixes, adjust until sub menus position correctly.
   
	dqm__os9_ie5mac_offset_x = 5
	dqm__os9_ie5mac_offset_Y = 10

	dqm__osx_ie5mac_offset_x = 5
	dqm__osx_ie5mac_offset_Y = 10

	dqm__ie4mac_offset_x = -10
	dqm__ie4mac_offset_Y = -45


    //Mac offset fixes, adjust until main menu items line up correctly

	dqm__mainitems_os9_ie5mac_offset_x = 10
	dqm__mainitems_os9_ie5mac_offset_y = 15

	dqm__mainitems_osx_ie5mac_offset_x = 10
	dqm__mainitems_osx_ie5mac_offset_y = 15



    //Netscape 4 resize bug workaround.

	dqm__nn4_reaload_after_resize = true
	dqm__nn4_resize_prompt_user = false
	dqm__nn4_resize_prompt_message = "To reinitialize the navigation menu please click the 'Reload' button."
   

    //Set to true if the menu is the only item on the HTML page.

	dqm__use_opera_div_detect_fix = true


    //Pre-defined sub menu item heights for the Espial Escape browser.

	dqm__escape_item_height = 20
	dqm__escape_item_height0_0 = 70
	dqm__escape_item_height0_1 = 70


/*---------------------------------------------
Exposed menu events
----------------------------------------------*/


    //Reference additional onload statements here.

	//dqm__onload_code = "alert('custom function - onload')"


    //The 'X' indicates the index number of the sub menu group or item.

	dqm__showmenu_codeX = "status = 'custom show menu function call - menu0'"
	dqm__hidemenu_codeX = "status = 'custom hide menu function call - menu0'"
	dqm__clickitem_codeX_X = "alert('custom Function - Menu Item 0_0')"



/*---------------------------------------------
Specific Sub Menu Settings
----------------------------------------------*/


    //The following settings may be defined for specific sub menu groups.
    //The 'X' represents the index number of the sub menu group.

	dqm__border_widthX = 10;
	dqm__divider_heightX = 5;		
	dqm__border_colorX = "#0000ff";     
	dqm__menu_bgcolorX = "#ff0000"
	dqm__hl_bgcolorX = "#00ff00"
	dqm__hl_textcolorX = "#ff0000"
	dqm__text_alignmentX = "left"


    //The following settings may be defined for specific sub menu items.
    //The 'X' represents the index number of the sub menu item.

	dqm__hl_subdescX = "custom highlight text"
	dqm__urltargetX = "_new"




/*---------------------------------------------
Specific Sub Menu Settings
----------------------------------------------*/
  


    //Sub Menu 0
    
	dqm__sub_xy0 = "-61,22"
	dqm__sub_menu_width0 = 60

	dqm__subdesc0_0 = "<font color='#000000'><u>退出</u></font>"
	//dqm__subdesc0_1 = "<font color='#000000'><u>Page Attachment</u></font><br>View the source of this HTML page for additional help with page integration."

	dqm__icon_index0_0 = 0
	//dqm__icon_index0_1 = 0

	dqm__url0_0 = "../documents/sample_link.htm"
	//dqm__url0_1 = "../documents/sample_link.htm"
    

    //Sub Menu 1

	dqm__sub_xy1 = "-120,22"
	dqm__sub_menu_width1 = 120

	dqm__subdesc1_0 = "物料需求计划"
	dqm__subdesc1_1 = "采购订单"
	dqm__subdesc1_2 = "总装线计划"
	
	dqm__icon_index1_0 = 0
	dqm__icon_index1_1 = 0
	dqm__icon_index1_2 = 0

	
	dqm__url1_2 = "../documents/sample_link.htm"
	dqm__url1_3 = "../documents/sample_link.htm"
	dqm__url1_4 = "../documents/sample_link.htm"
	dqm__url1_5 = "../documents/sample_link.htm"

    

    //Sub Menu 1_0
    /*
	dqm__sub_xy1_0 = "-4,2"
	dqm__sub_menu_width1_0 = 120

	dqm__subdesc1_0_0 = "DHTML Menu"
	dqm__subdesc1_0_1 = "DHTML Tree"
	dqm__subdesc1_0_2 = "Vertical Scroll"
	dqm__subdesc1_0_3 = "Scroll Window"
	
	dqm__icon_index1_0_0 = 0
	dqm__icon_index1_0_1 = 0
	dqm__icon_index1_0_2 = 0
	dqm__icon_index1_0_3 = 0
	
	dqm__url1_0_0 = "../documents/sample_link.htm"
	dqm__url1_0_1 = "../documents/sample_link.htm"
	dqm__url1_0_2 = "../documents/sample_link.htm"
	dqm__url1_0_3 = "../documents/sample_link.htm"



    //Sub Menu 1_1

	dqm__sub_xy1_1 = "-4,2"
	dqm__sub_menu_width1_1 = 100

	dqm__subdesc1_1_0 = "J & J"
	dqm__subdesc1_1_1 = "Memorex"
	dqm__subdesc1_1_2 = "Ouidad"
	
	dqm__icon_index1_1_0 = 0
	dqm__icon_index1_1_1 = 0
	dqm__icon_index1_1_2 = 0
	
	dqm__url1_1_0 = "../documents/sample_link.htm"
	dqm__url1_1_1 = "../documents/sample_link.htm"
	dqm__url1_1_2 = "../documents/sample_link.htm"
    */


    //Sub Menu 2

	dqm__sub_xy2 = "-120,22"
	dqm__sub_menu_width2 = 120

	dqm__subdesc2_0 = "整车发运" 
	dqm__subdesc2_1 = "销售预测"
	dqm__subdesc2_2 = "库存管理"
	dqm__subdesc2_3 = "销售记录"
	
	dqm__icon_index2_0 = 0
	dqm__icon_index2_1 = 0
	dqm__icon_index2_2 = 0
	dqm__icon_index2_3 = 0
	
	dqm__url2_0 = "../documents/sample_link.htm"
	dqm__url2_1 = "../documents/sample_link.htm"
	dqm__url2_2 = "../documents/sample_link.htm"
	dqm__url2_3 = "../documents/sample_link.htm"



    //Sub Menu 3

	dqm__sub_xy3 = "-120,22"
	dqm__sub_menu_width = 120

	dqm__subdesc3_0 = "机构维护"
	dqm__subdesc3_1 = "权限维护"
	dqm__subdesc3_2 = "模块维护"
	dqm__subdesc3_4 = "参数设置"
	
	dqm__icon_index3_0 = 0
	dqm__icon_index3_1 = 0
	dqm__icon_index3_2 = 0
	dqm__icon_index3_4 = 0
	
	dqm__url3_0 = "../documents/sample_link.htm"
	dqm__url3_1 = "../documents/sample_link.htm"
	dqm__url3_2 = "../documents/sample_link.htm"
	dqm__url3_4 = "../documents/sample_link.htm"


    //Sub Menu 4

	dqm__sub_xy4 = "-120,22"
	dqm__sub_menu_width4 = 120

	dqm__subdesc4_0 = "内容维护"
	
	dqm__icon_index4_0 = 0
	
	dqm__url4_0 = "../documents/sample_link.htm"
