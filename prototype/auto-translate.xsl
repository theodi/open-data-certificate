<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:local="#"
	exclude-result-prefixes="#all">

<xsl:output method="xml" indent="yes" />

<xsl:strip-space elements="*"/>

<xsl:variable name="translation">
	<translation>
		<xsl:for-each select="tokenize(unparsed-text('jurisdictions/temp/certificate.FR.fr.txt'), '\n')">
			<translation id="{substring-before(., ': ')}">
				<xsl:analyze-string select="substring-after(., ': ')" regex="(&lt;\s?strong\s?&gt;([^&lt;]+)&lt;\s?/\s?strong\s?&gt;)|(&lt;\s?em\s?&gt;([^&lt;]+)&lt;\s?/\s?em\s?&gt;)|(&lt;\s?a href\s?=\s?&quot;([^&quot;]+)&quot;\s?&gt;([^&lt;]+)&lt;\s?/\s?a\s?&gt;)">
					<xsl:matching-substring>
						<xsl:choose>
							<xsl:when test="regex-group(1) != ''">
								<strong><xsl:value-of select="normalize-space(regex-group(2))" /></strong>
							</xsl:when>
							<xsl:when test="regex-group(3) != ''">
								<em><xsl:value-of select="normalize-space(regex-group(4))" /></em>
							</xsl:when>
							<xsl:otherwise>
								<a href="{normalize-space(regex-group(6))}"><xsl:value-of select="normalize-space(regex-group(7))" /></a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:matching-substring>
					<xsl:non-matching-substring>
						<xsl:value-of select="." />
					</xsl:non-matching-substring>
				</xsl:analyze-string>
			</translation>
		</xsl:for-each>
	</translation>
</xsl:variable>

<xsl:key name="translation" match="translation" use="@id" />

<xsl:template match="/">
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="*">
	<xsl:variable name="id" as="xs:string" select="local:id(.)" />
	<xsl:variable name="translation" as="element(translation)?" select="key('translation', $id, $translation)" />
	<xsl:copy>
		<xsl:apply-templates select="@*" />
		<xsl:choose>
			<xsl:when test="exists($translation)">
				<xsl:sequence select="$translation/node()" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:copy>
</xsl:template>

<xsl:template match="@*">
	<xsl:variable name="id" as="xs:string" select="local:id(.)" />
	<xsl:variable name="translation" as="element(translation)?" select="key('translation', $id, $translation)" />
	<xsl:choose>
		<xsl:when test="exists($translation)">
			<xsl:attribute name="{name()}" select="$translation" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:function name="local:id" as="xs:string">
	<xsl:param name="item" />
	<xsl:value-of>
		<xsl:apply-templates select="$item" mode="local:id" />
	</xsl:value-of>
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