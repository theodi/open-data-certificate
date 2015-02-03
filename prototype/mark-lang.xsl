<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:local="#local"
	exclude-result-prefixes="xs local">

<xsl:output method="xml" indent="yes" />

<xsl:param name="lang" as="xs:string">language</xsl:param>
<xsl:template match="@xml:lang">
  <xsl:attribute name="xml:lang"><xsl:value-of select="$lang"/></xsl:attribute>
</xsl:template>

<xsl:template match="node()|@*" >
  <xsl:copy>
    <xsl:apply-templates select="node()|@*" />
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
