<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:local="http://theodi.org/ns/func"
	exclude-result-prefixes="#all">
	
<xsl:variable name="european" as="xs:string+" select="
	'AT',
	'BE',
	'BG',
	'HR',
	'CY',
	'CZ',
	'DK',
	'EE',
	'FI',
	'FR',
	'DE',
	'GR',
	'HU',
	'IE',
	'IT',
	'LV',
	'LT',
	'LU',
	'MT',
	'NL',
	'PL',
	'PT',
	'RO',
	'SK',
	'SI',
	'ES',
	'SE',
	'GB'
" />

<xsl:variable name="defaultCertificate" as="document-node()" select="doc('defaults/certificate.xml')" />
<xsl:variable name="europeanCertificate" as="document-node()" select="doc('defaults/certificate.EU.xml')" />
	
<xsl:template match="ISO_3166-1_List_en">
	<xsl:apply-templates select="ISO_3166-1_Entry" />
</xsl:template>

<xsl:template match="ISO_3166-1_Entry">
	<xsl:variable name="code" as="xs:string" select="ISO_3166-1_Alpha-2_Code_element" />
	<xsl:variable name="filename" as="xs:string" select="concat('jurisdictions/certificate.', $code, '.xml')" />
	<xsl:if test="not(doc-available($filename))">
		<xsl:result-document href="{$filename}">
			<xsl:choose>
				<xsl:when test="$code = $european">
					<xsl:apply-templates select="$europeanCertificate">
						<xsl:with-param name="country" tunnel="yes" select="$code" />
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="$defaultCertificate">
						<xsl:with-param name="country" tunnel="yes" select="$code" />
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:result-document>
	</xsl:if>
</xsl:template>

<xsl:template match="@jurisdiction">
	<xsl:param name="country" as="xs:string" tunnel="yes" required="yes" />
	<xsl:attribute name="jurisdiction" select="$country" />
</xsl:template>

<xsl:template match="node()|@*">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()" />
	</xsl:copy>
</xsl:template>

</xsl:stylesheet>