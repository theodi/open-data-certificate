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
						<xsl:with-param name="countryName" tunnel="yes" select="ISO_3166-1_Country_name" />
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="$defaultCertificate">
						<xsl:with-param name="country" tunnel="yes" select="$code" />
						<xsl:with-param name="countryName" tunnel="yes" select="ISO_3166-1_Country_name" />
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

<xsl:template match="questionnaire/help">
	<xsl:param name="country" as="xs:string" tunnel="yes" required="yes" />
	<xsl:param name="countryName" as="xs:string" tunnel="yes" required="yes" />
	<help>
		<p><strong>This has been generated based on a default<xsl:if test="$country = $european"> for EU countries</xsl:if> and needs to be localised for <xsl:value-of select="if (contains($countryName, ',')) then local:titleCase(concat(substring-after($countryName, ', '), ' ', substring-before($countryName, ','))) else local:titleCase($countryName)" />. Please help us! Contact <a href="mailto:certificate@theodi.org">certificate@theodi.org</a></strong></p>
		<xsl:sequence select="node()" />
	</help>
</xsl:template>

<xsl:template match="node()|@*">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()" />
	</xsl:copy>
</xsl:template>

<xsl:function name="local:titleCase" as="xs:string">
	<xsl:param name="string" as="xs:string" />
	<xsl:value-of>
		<xsl:for-each select="tokenize($string, ' ')">
			<xsl:choose>
				<xsl:when test=". = ('AND', 'OF')">
					<xsl:value-of select="lower-case(.)" />
				</xsl:when>
				<xsl:when test=". = ('U.S.')">
					<xsl:value-of select="." />
				</xsl:when>
				<xsl:when test="starts-with(., '(')">
					<xsl:value-of select="concat(upper-case(substring(., 1, 2)), lower-case(substring(., 3)))" />
				</xsl:when>
				<xsl:when test="starts-with(., 'D''')">
					<xsl:value-of select="concat(upper-case(substring(., 1, 3)), lower-case(substring(., 4)))" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(upper-case(substring(., 1, 1)), lower-case(substring(., 2)))" />
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="position() != last()">
				<xsl:text> </xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:value-of>
</xsl:function>

</xsl:stylesheet>