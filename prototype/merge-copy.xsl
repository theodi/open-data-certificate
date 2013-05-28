<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs">

<xsl:variable name="copy" as="document-node()" select="doc('translations/odc.UK.en.xml')" />

<xsl:key name="questions" match="questions/*" use="name()" />
<xsl:key name="requirements" match="labels/*" use="name()" />
<xsl:key name="groups" match="labels/*" use="name()" />

<xsl:template match="/">
	<xsl:result-document href="merged.xml">
		<xsl:apply-templates />
	</xsl:result-document>
</xsl:template>

<xsl:template match="node()|@*">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()" />
	</xsl:copy>
</xsl:template>

<xsl:template match="group//group/label">
	<xsl:variable name="label" as="xs:string?" select="key('groups', ../@id, $copy)/title" />
	<label>
		<xsl:apply-templates select="@*" />
		<xsl:choose>
			<xsl:when test="$label">
				<xsl:value-of select="$label" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>No label for <xsl:value-of select="../@id" /></xsl:message>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</label>
</xsl:template>

<xsl:template match="group//group/help">
	<xsl:variable name="help" as="xs:string?" select="key('groups', ../@id, $copy)/help_text" />
	<help>
		<xsl:apply-templates select="@*" />
		<xsl:choose>
			<xsl:when test="$help">
				<xsl:value-of select="$help" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>No help for <xsl:value-of select="../@id" /></xsl:message>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</help>
</xsl:template>

<xsl:template match="question/label">
	<xsl:variable name="label" as="xs:string?" select="key('questions', ../@id, $copy)/text" />
	<label>
		<xsl:apply-templates select="@*" />
		<xsl:choose>
			<xsl:when test="$label">
				<xsl:value-of select="$label" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>No label for <xsl:value-of select="../@id" /></xsl:message>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</label>
</xsl:template>

<xsl:template match="question/help">
	<xsl:variable name="help" as="xs:string?" select="key('questions', ../@id, $copy)/help_text" />
	<help>
		<xsl:apply-templates select="@*" />
		<xsl:choose>
			<xsl:when test="$help">
				<xsl:value-of select="$help" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>No help for <xsl:value-of select="../@id" /></xsl:message>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</help>
</xsl:template>

<xsl:template match="@placeholder">
	<xsl:variable name="label" as="xs:string?" select="key('questions', ancestor::question/@id, $copy)/answers/a_1/text" />
	<xsl:attribute name="placeholder">
		<xsl:choose>
			<xsl:when test="$label">
				<xsl:value-of select="$label" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>No placeholder for question <xsl:value-of select="ancestor::question/@id" /></xsl:message>
				<xsl:value-of select="." />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:attribute>
</xsl:template>

<xsl:template match="radioset/option/label | checkboxset/option/label">
	<xsl:variable name="value" as="xs:string" select="translate(../@value, '.-', '__')" />
	<xsl:variable name="label" as="xs:string?" select="key('questions', ancestor::question/@id, $copy)/answers/*[name() = $value]/text" />
	<label>
		<xsl:apply-templates select="@*" />
		<xsl:choose>
			<xsl:when test="$label">
				<xsl:value-of select="$label" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>No label for option <xsl:value-of select="../@value" /> in <xsl:value-of select="ancestor::question/@id" /></xsl:message>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</label>
</xsl:template>

<xsl:template match="radioset/option/help | checkboxset/option/help">
	<xsl:variable name="value" as="xs:string" select="translate(../@value, '.-', '__')" />
	<xsl:variable name="help" as="xs:string?" select="key('questions', ancestor::question/@id, $copy)/answers/*[name() = $value]/help_text" />
	<help>
		<xsl:apply-templates select="@*" />
		<xsl:choose>
			<xsl:when test="$help">
				<xsl:value-of select="$help" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>No help for option <xsl:value-of select="../@value" /> in <xsl:value-of select="ancestor::question/@id" /></xsl:message>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</help>
</xsl:template>

<xsl:template match="select/option">
	<xsl:variable name="value" as="xs:string" select="translate(@value, '.-', '__')" />
	<xsl:variable name="label" as="xs:string?" select="key('questions', ancestor::question/@id, $copy)/answers/*[name() = $value]/text" />
	<option>
		<xsl:apply-templates select="@*" />
		<xsl:choose>
			<xsl:when test="$label">
				<xsl:value-of select="$label" />
			</xsl:when>
			<xsl:when test="$value != ''">
				<xsl:message>No label for option <xsl:value-of select="@value" /> in <xsl:value-of select="ancestor::question/@id" /></xsl:message>
				<xsl:apply-templates />
			</xsl:when>
		</xsl:choose>
	</option>
</xsl:template>

<xsl:template match="requirement">
	<xsl:variable name="requirement" as="xs:string">
		<xsl:choose>
			<xsl:when test="@level">
				<xsl:value-of select="concat(@level, '_', count(preceding::requirement[@level = current()/@level]) + 1)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('basic_', count(preceding::requirement[empty(@level)]) + 1)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="label" as="xs:string?" select="key('requirements', $requirement, $copy)/text" />
	<requirement>
		<xsl:apply-templates select="@*" />
		<xsl:choose>
			<xsl:when test="$label">
				<xsl:value-of select="$label" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>No label for requirement "<xsl:value-of select="." />"</xsl:message>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</requirement>
</xsl:template>

</xsl:stylesheet>