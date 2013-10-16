<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:local="#">

<xsl:output method="text" />

<xsl:strip-space elements="*"/>

<xsl:template match="/">
	<xsl:for-each select=".//*[text() and not(parent::*[text() and *])] | .//*/(@display, @placeholder, @yes, @no)">
		<xsl:apply-templates select="." />
		<xsl:text>&#xA;</xsl:text>
	</xsl:for-each>
</xsl:template>

<xsl:template match="*">
	<xsl:value-of select="local:id(.)" />: <xsl:apply-templates />
</xsl:template>

<xsl:template match="@*">
	<xsl:value-of select="local:id(.)" />: <xsl:value-of select="." />
</xsl:template>

<xsl:template match="strong">
	<xsl:text>&lt;strong&gt;</xsl:text>
	<xsl:apply-templates />
	<xsl:text>&lt;/strong&gt;</xsl:text>
</xsl:template>

<xsl:template match="a">
	<xsl:text>&lt;a href="</xsl:text>
	<xsl:value-of select="@href" />
	<xsl:text>"&gt;</xsl:text>
	<xsl:apply-templates />
	<xsl:text>&lt;/a&gt;</xsl:text>
</xsl:template>

<xsl:template match="em">
	<xsl:text>&lt;em&gt;</xsl:text>
	<xsl:apply-templates />
	<xsl:text>&lt;/em&gt;</xsl:text>
</xsl:template>

<xsl:function name="local:id">
	<xsl:param name="item" />
	<xsl:apply-templates select="$item" mode="local:id" />
</xsl:function>

<xsl:template match="*" mode="local:id">
	<xsl:apply-templates select="parent::*" mode="local:id" />
	<xsl:text>/</xsl:text>
	<xsl:value-of select="count(preceding-sibling::*) + 1" />
</xsl:template>

<xsl:template match="@*" mode="local:id">
	<xsl:apply-templates select="parent::*" mode="local:id" />
	<xsl:text>/@</xsl:text>
	<xsl:value-of select="name()" />
</xsl:template>

</xsl:stylesheet>