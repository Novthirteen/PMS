/*************************************************************************************
	阿赖目录树控件pretty模板程序 由赖国欣设计于2003年7月16日，保留所有权利！
**************************************************************************************/
function getScriptPath(js)
{
	js=js.toLowerCase()
	var script=document.getElementsByTagName("SCRIPT");
	for(var i=0;i<script.length;i++)
	{
		var s=script[i].src.toLowerCase()
		if(s.indexOf(js)!=-1)return s.replace(js,"")
	}
	return null
}

function getImagePath(img)
{
	img=img.toLowerCase()
	var imgList=document.getElementsByTagName("img");
	for(var i=0;i<imgList.length;i++)
	{
		var s=imgList[i].src
		if(s.indexOf(img)!=-1)return s.replace(img,"")
	}
	return null
}

function alai_tree_pretty(toObject)
{
	var path=getImagePath("logo1.jpg")
	if(path==null){alert("run alai_tree_pretty() fail, please load alai_tree.js first!");return;}
	var icons=new alai_imagelist()
	icons.path=path
	icons.add("blank","default")
	icons.add("blank","folderclose")
	icons.add("blank","folderopen")
	icons.add("expand_xp","expand")
	icons.add("collapse_xp","collapse")
	icons.add("misc_arrow","leaf")
	icons.add("misc_arrow","twig")
	
	var tree=new alai_tree(icons,18,toObject)
	tree.afteradd=function(srcNode)
	{
		if(srcNode.parent!=tree.root)srcNode.parent.icon.src=icons.item["folderopen"].src
	}
	tree.onexpand=function(srcNode)
	{
		srcNode.icon.src=icons.item["folderopen"].src
	}
	tree.oncollapse=function(srcNode)
	{
		srcNode.icon.src=icons.item["folderclose"].src
	}
	return tree
}
