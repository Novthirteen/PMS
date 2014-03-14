<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html"></xsl:output>

  <xsl:template match="tree">
    <div id="treeroot">
    <xsl:apply-templates/>
    </div>
  </xsl:template>

 <xsl:template match="branch">
    <div class="node">
      <xsl:attribute name="desc"><xsl:value-of select="@desc"/></xsl:attribute>
      <xsl:attribute name="type"><xsl:value-of select="@branchroot"/></xsl:attribute>
      <xsl:attribute name="id">D<xsl:value-of select="@id"/></xsl:attribute>
      <img _src="closed.gif" width="11" height="11" align="absmiddle" style="margin-right:5px">
        <xsl:attribute name="id">I<xsl:value-of select="@id"/></xsl:attribute>
        <xsl:attribute name="_id"><xsl:value-of select="@id"/></xsl:attribute>
      </img>
	  <input type="checkbox"  style="border:0px" >
	  	<xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
	  	<xsl:attribute name="name"><xsl:value-of select="@check" /></xsl:attribute>
	  	<xsl:attribute name="value"><xsl:value-of select="@id" /></xsl:attribute>
	  	<xsl:attribute name="onclick"><xsl:value-of select="@onclick" /></xsl:attribute>
	  	<xsl:attribute name="checked"><xsl:value-of select="@status" /></xsl:attribute>
	  </input> 
	  <input type="hidden" >
	  	<xsl:attribute name="name"><xsl:value-of select="@parentid" /></xsl:attribute>
	  	<xsl:attribute name="value"><xsl:value-of select="@parent" /></xsl:attribute>
	  	<xsl:attribute name="onclick"><xsl:value-of select="@onclick" /></xsl:attribute>
	  </input> 
	  <input type="hidden" >
	  	<xsl:attribute name="name"><xsl:value-of select="@descid" /></xsl:attribute>
	  	<xsl:attribute name="value"><xsl:value-of select="@desc" /></xsl:attribute>
	  	<xsl:attribute name="onclick"><xsl:value-of select="@onclick" /></xsl:attribute>
	  </input> 
      <span class="clsNormal">
        <xsl:attribute name="id">N<xsl:value-of select="@id"/></xsl:attribute>
        <xsl:attribute name="_id"><xsl:value-of select="@id"/></xsl:attribute>
        <xsl:value-of select="@desc"/>
      </span>
    </div>
    <span class="branch">
      <xsl:attribute name="id">B<xsl:value-of select="@id"/></xsl:attribute>
      <xsl:attribute name="_id"><xsl:value-of select="@id"/></xsl:attribute>
      <xsl:attribute name="desc"><xsl:value-of select="@desc"/></xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="leaf">
    <div class="node" >
      <xsl:attribute name="desc"><xsl:value-of select="@desc"/></xsl:attribute>
       <xsl:attribute name="type"><xsl:value-of select="@branchroot"/></xsl:attribute>
      <xsl:attribute name="id">D<xsl:value-of select="@id"/></xsl:attribute>
      <img _src="doc.gif" width="11" height="11" align="absmiddle" style="margin-right:5px">
        <xsl:attribute name="id">I<xsl:value-of select="@id"/></xsl:attribute>
        <xsl:attribute name="_id"><xsl:value-of select="@id"/></xsl:attribute>
      </img>
	  <input type="checkbox" style="border:0px" >
	  	<xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
	  	<xsl:attribute name="name"><xsl:value-of select="@check" /></xsl:attribute>
	  	<xsl:attribute name="value"><xsl:value-of select="@id" /></xsl:attribute>
	  	<xsl:attribute name="onclick"><xsl:value-of select="@onclick" /></xsl:attribute>
	  	<xsl:attribute name="checked"><xsl:value-of select="@status" /></xsl:attribute>
	  </input> 
	  <input type="hidden" >
	  	<xsl:attribute name="name"><xsl:value-of select="@parentid" /></xsl:attribute>
	  	<xsl:attribute name="value"><xsl:value-of select="@parent" /></xsl:attribute>
	  	<xsl:attribute name="onclick"><xsl:value-of select="@onclick" /></xsl:attribute>
	  </input> 
	  <input type="hidden" >
	  	<xsl:attribute name="name"><xsl:value-of select="@descid" /></xsl:attribute>
	  	<xsl:attribute name="value"><xsl:value-of select="@desc" /></xsl:attribute>
	  	<xsl:attribute name="onclick"><xsl:value-of select="@onclick" /></xsl:attribute>
	  </input> 
     <span class="clsNormal">
        <xsl:attribute name="id">N<xsl:value-of select="@id"/></xsl:attribute>
        <xsl:attribute name="_id"><xsl:value-of select="@id"/></xsl:attribute>
        <xsl:value-of select="@desc"/>
      </span>
     </div>
  </xsl:template>
</xsl:stylesheet>