<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:local="http://theodi.org/ns/func"
	exclude-result-prefixes="#all">

<xsl:variable name="countries" as="document-node()" select="doc('country_names_and_code_elements.xml')" />
<xsl:key name="countries" match="ISO_3166-1_Country_name" use="../ISO_3166-1_Alpha-2_Code_element" />

<xsl:template match="/">
	<xsl:variable name="merged" as="document-node()">
		<xsl:document>
			<xsl:apply-templates select="questionnaire" mode="merge" />
		</xsl:document>
	</xsl:variable>
	<xsl:variable name="structure" as="element()">
		<xsl:apply-templates select="$merged/questionnaire" mode="structure" />
	</xsl:variable>
	<xsl:result-document href="../../surveys/odc_questionnaire.{if (questionnaire/@jurisdiction = 'GB') then 'UK' else questionnaire/@jurisdiction}.rb" method="text">
		<xsl:apply-templates select="$structure" mode="syntax" />
	</xsl:result-document>
	<xsl:result-document href="../../surveys/translations/odc.{if (questionnaire/@jurisdiction = 'GB') then 'UK' else questionnaire/@jurisdiction}.{questionnaire/@xml:lang}.yml" method="text">
		<xsl:apply-templates select="$merged/questionnaire" mode="translation" />
	</xsl:result-document>
</xsl:template>

<!-- MERGE -->

<xsl:template match="questionnaire" mode="merge">
	<xsl:variable name="langPath" as="xs:string" select="concat('translations/certificate.', @xml:lang, '.xml')" />
	<xsl:choose>
		<xsl:when test="doc-available($langPath)">
			<xsl:variable name="langVersion" as="element()" select="doc($langPath)/questionnaire" />
			<questionnaire>
				<xsl:sequence select="@*" />
				<xsl:sequence select="$langVersion/@yes, $langVersion/@no" />
				<xsl:sequence select="help" />
				<xsl:sequence select="$langVersion/levels" />
				<xsl:sequence select="$langVersion/group[1]" />
				<xsl:sequence select="group" />
				<xsl:sequence select="$langVersion/group[position() > 1]" />
			</questionnaire>
		</xsl:when>
		<xsl:otherwise>
			<xsl:message terminate="yes">Could not find version of certificate in language <xsl:value-of select="@xml:lang" /> at <xsl:value-of select="$langPath" /></xsl:message>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- STRUCTURE -->

<xsl:template match="questionnaire" mode="structure">
	<survey label="{@jurisdiction}"
		full_title="{local:titleCase(key('countries', @jurisdiction, $countries))}"
		default_mandatory="false" 
		status="{@status}">
		<xsl:attribute name="description">
			<xsl:apply-templates select="help/*" mode="html" />
		</xsl:attribute>
		<translations en="default" />
		<xsl:apply-templates select="group" mode="structure" />
	</survey>
</xsl:template>

<xsl:template match="questionnaire/group" mode="structure">
	<xsl:element name="section_{@id}">
		<xsl:attribute name="label" select="label" />
		<xsl:attribute name="description" select="help" />
		<xsl:if test="not(preceding-sibling::group)">
			<xsl:attribute name="display_header">false</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates select="* except label" mode="structure" />
	</xsl:element>
</xsl:template>

<xsl:template match="group//group" mode="structure">
	<_group>
		<_group>
			<xsl:element name="label_group_{count(preceding::group) + 1}">
				<xsl:attribute name="label"><xsl:apply-templates select="label" mode="html" /></xsl:attribute>
				<xsl:attribute name="help_text"><xsl:apply-templates select="help" mode="html" /></xsl:attribute>
				<xsl:attribute name="customer_renderer">/partials/fieldset</xsl:attribute>
			</xsl:element>
			<xsl:apply-templates select="." mode="conditions" />
		</_group>
	</_group>
	<xsl:apply-templates select="* except (label, help)" mode="structure" />
</xsl:template>

<xsl:template match="repeat" mode="structure">
	<_group>
		<repeater label="{label}">
			<_group>
				<xsl:apply-templates select="." mode="conditions" />
			</_group>
			<xsl:apply-templates select="* except label" mode="structure" />
		</repeater>
	</_group>
</xsl:template>

<xsl:template match="question" mode="structure">
	<_group>
		<_group>
			<xsl:element name="q_{@id}">
				<xsl:attribute name="discussion_topic" select="concat(if (ancestor::group[@id = 'legal']) then concat(lower-case(/questionnaire/@jurisdiction), '_') else '', @id)" />
				<xsl:attribute name="label">
					<xsl:apply-templates select="label" mode="html" />
				</xsl:attribute>
				<xsl:if test="@display">
					<xsl:attribute name="display_on_certificate" select="true()" />
					<xsl:attribute name="text_as_statement" select="@display" />
				</xsl:if>
				<xsl:if test="help">
					<xsl:attribute name="help_text"><xsl:apply-templates select="help" mode="html" /></xsl:attribute>
					<xsl:if test="help/@more">
						<xsl:attribute name="help_text_more_url" select="help/@more" />
					</xsl:if>
				</xsl:if>
				<xsl:if test="(radioset or select or checkboxset) and .//requirement[not(ancestor::option)]">
					<xsl:attribute name="requirement" select=".//requirement[not(ancestor::option)]/local:requirementId(.)" separator=", " />
				</xsl:if>
				<xsl:choose>
					<xsl:when test="radioset | yesno | select">
						<xsl:attribute name="pick">one</xsl:attribute>
						<xsl:sequence select="*/@required" />
						<xsl:if test="select">
							<xsl:attribute name="display_type">dropdown</xsl:attribute>
						</xsl:if>
					</xsl:when>
					<xsl:when test="checkboxset">
						<xsl:attribute name="pick">any</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:sequence select="*/@required" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:apply-templates select="." mode="conditions" />
			<xsl:apply-templates select="label/following-sibling::*[1]" mode="structure" />
		</_group>
		<xsl:apply-templates select=".//requirement" mode="structure" />
	</_group>
</xsl:template>

<xsl:template match="help" mode="structure" />
	
<xsl:template match="input" mode="structure">
	<xsl:element name="a_1">
		<xsl:attribute name="label" select="@placeholder" />
		<xsl:attribute name="type" select="'string'" />
		<xsl:apply-templates select="@*" mode="structure" />
		<xsl:if test="..//requirement">
			<xsl:attribute name="requirement" select="..//requirement/local:requirementId(.)" separator=", " />
		</xsl:if>
	</xsl:element>
</xsl:template>

<xsl:template match="radioset | checkboxset | select" mode="structure">
	<xsl:apply-templates mode="structure" />
</xsl:template>

<xsl:template match="radioset/option | checkboxset/option" mode="structure">
	<xsl:element name="a_{local:token(@value)}">
		<xsl:attribute name="label"><xsl:apply-templates select="label" mode="html" /></xsl:attribute>
		<xsl:if test="ancestor::question/@display">
			<xsl:attribute name="text_as_statement">
				<xsl:choose>
					<xsl:when test="@display">
						<xsl:value-of select="@display" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="label" mode="html" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="help">
			<xsl:attribute name="help_text"><xsl:apply-templates select="help" mode="html" /></xsl:attribute>
			<xsl:if test="help/@more">
				<xsl:attribute name="help_text_more_url" select="help/@more" />
			</xsl:if>
		</xsl:if>
		<xsl:if test="requirement">
			<xsl:attribute name="requirement" select="local:requirementId(requirement)" />
		</xsl:if>
	</xsl:element>
</xsl:template>

<xsl:template match="select/option" mode="structure">
	<xsl:if test=". != ''">
		<xsl:element name="a{if (@value) then concat('_', local:token(@value)) else ''}">
			<xsl:attribute name="label"><xsl:apply-templates select="node()" mode="html" /></xsl:attribute>
			<xsl:if test="ancestor::question/@display">
				<xsl:attribute name="text_as_statement">
					<xsl:choose>
						<xsl:when test="@display">
							<xsl:value-of select="@display" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="." />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
		</xsl:element>
	</xsl:if>
</xsl:template>

<xsl:template match="yesno" mode="structure">
	<a_false label="{(//questionnaire/@no, 'no')[1]}">
		<xsl:if test="@yes or @no">
			<xsl:attribute name="text_as_statement" select="@no" />
		</xsl:if>
	</a_false>
	<a_true label="{(//questionnaire/@yes, 'yes')[1]}">
		<xsl:if test="@yes or @no">
			<xsl:attribute name="text_as_statement" select="@yes" />
		</xsl:if>
		<xsl:if test="..//requirement">
			<xsl:attribute name="requirement" select="..//requirement/local:requirementId(.)" separator=", " />
		</xsl:if>
	</a_true>
</xsl:template>

<xsl:template match="@placeholder | @required" mode="structure">
	<xsl:sequence select="." />
</xsl:template>

<xsl:template match="@type" mode="structure">
	<xsl:attribute name="input_type" select="." />
</xsl:template>

<xsl:template match="if" mode="structure">
	<xsl:apply-templates mode="structure" />
</xsl:template>

<xsl:template match="requirement" mode="structure">
	<_group>
		<xsl:element name="label_{local:requirementId(.)}">
			<xsl:attribute name="label">
				<xsl:apply-templates select="." mode="html" />
			</xsl:attribute>
			<xsl:attribute name="custom_renderer" select="concat('/partials/requirement_', if (@level) then @level else 'basic')" />
			<xsl:attribute name="requirement" select="local:requirementId(.)" />
		</xsl:element>
		<xsl:variable name="conditions" as="element()">
			<xsl:apply-templates select="." mode="conditions" />
		</xsl:variable>
		<dependency>
			<xsl:attribute name="rule">
				<xsl:apply-templates select="$conditions" mode="rule" />
			</xsl:attribute>
		</dependency>
		<xsl:for-each select="$conditions/descendant-or-self::condition">
			<xsl:element name="condition_{local:conditionId(.)}">
				<xsl:sequence select="@value" />
			</xsl:element>
		</xsl:for-each>
	</_group>
</xsl:template>

<xsl:template match="*" mode="structure">
	<xsl:message>No template for element <xsl:value-of select="ancestor-or-self::*/name()" separator="/" /></xsl:message>
</xsl:template>
<xsl:template match="@*" mode="structure">
	<xsl:message>No template for attribute <xsl:value-of select="name()" /></xsl:message>
</xsl:template>

<!-- CONDITIONS -->

<xsl:template match="*" mode="conditions">
	<xsl:if test="ancestor::if">
		<xsl:variable name="conditions" as="element()">
			<and>
				<xsl:apply-templates select="ancestor::if" mode="conditions" />
			</and>
		</xsl:variable>
		<dependency>
			<xsl:attribute name="rule">
				<xsl:apply-templates select="$conditions" mode="rule" />
			</xsl:attribute>
		</dependency>
		<xsl:for-each select="$conditions//condition">
			<xsl:element name="condition_{local:conditionId(.)}">
				<xsl:sequence select="@value" />
			</xsl:element>
		</xsl:for-each>
	</xsl:if>
</xsl:template>

<xsl:template match="requirement" mode="conditions">
	<xsl:choose>
		<xsl:when test="@test">
			<xsl:apply-templates select="@test" mode="conditions" />
		</xsl:when>
		<xsl:when test="ancestor::question/input">
			<condition value=":q_{ancestor::question/@id}, '==', {{:string_value => '', :answer_reference => '1'}}" />
		</xsl:when>
		<xsl:when test="ancestor::question/yesno">
			<condition value=":q_{ancestor::question/@id}, '==', :a_false" />
		</xsl:when>
		<xsl:when test="parent::option">
			<xsl:choose>
				<xsl:when test="ancestor::radioset">
					<xsl:variable name="options" as="element(option)+" select="ancestor::radioset/option" />
					<xsl:variable name="levels" as="xs:string+" select="/questionnaire/levels/level/@id" />
					<xsl:variable name="level" as="xs:string" select="if (@level) then @level else 'basic'" />
					<xsl:variable name="sameOrHigher" as="xs:string+" select="$levels[position() >= index-of($levels, $level)]" />
					<xsl:variable name="options" as="element(option)*" select="$options[$level = 'basic' or requirement/@level = $sameOrHigher]" />
					<and>
						<xsl:for-each select="$options">
							<condition value=":q_{ancestor::question/@id}, '!=', :a_{local:token(@value)}" />
						</xsl:for-each>
					</and>
				</xsl:when>
				<xsl:otherwise>
					<condition value=":q_{ancestor::question/@id}, '!=', :a_{local:token(parent::option/@value)}" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="ancestor::question/checkboxset or ancestor::question/radioset" />
		<xsl:otherwise>
			<xsl:message>Not that easy: <xsl:value-of select="ancestor::question/@id" /></xsl:message>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="if//requirement" mode="conditions">
	<and>
		<xsl:for-each select="ancestor::if">
			<xsl:apply-templates select="." mode="conditions" />
		</xsl:for-each>
		<xsl:next-match />
	</and>
</xsl:template>

<xsl:template match="if" mode="conditions">
	<xsl:apply-templates select="@test" mode="conditions" />
</xsl:template>

<xsl:template match="@test" mode="conditions">
	<xsl:sequence select="local:parseTest(., exists(parent::requirement))" />
</xsl:template>

<!-- RULE -->

<xsl:template match="and | or" mode="rule">
	<xsl:variable name="operation" as="xs:string" select="name()" />
	<xsl:if test="ancestor::*">(</xsl:if>
	<xsl:for-each select="*">
		<xsl:apply-templates select="." mode="rule" />
		<xsl:if test="position() != last()">
			<xsl:text> </xsl:text>
			<xsl:value-of select="$operation" />
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:for-each>
	<xsl:if test="ancestor::*">)</xsl:if>
</xsl:template>

<xsl:template match="condition" mode="rule">
	<xsl:value-of select="local:conditionId(.)" />
</xsl:template>

<xsl:template match="node()" mode="rule">
	<xsl:message terminate="yes">Unexpected condition for rule: <xsl:sequence select="." /></xsl:message>
</xsl:template>

<!-- HTML -->
	
<xsl:template match="help" mode="html">
	<xsl:apply-templates mode="html" />
</xsl:template>

<xsl:template match="label | requirement" mode="html">
	<xsl:apply-templates mode="html" />
</xsl:template>

<xsl:template match="p" mode="html">
	<xsl:text>&lt;p&gt;</xsl:text>
	<xsl:apply-templates mode="html" />
	<xsl:text>&lt;/p&gt;</xsl:text>
</xsl:template>

<xsl:template match="em" mode="html">
	<xsl:text>&lt;em&gt;</xsl:text>
	<xsl:apply-templates mode="html" />
	<xsl:text>&lt;/em&gt;</xsl:text>
</xsl:template>

<xsl:template match="strong" mode="html">
	<xsl:text>&lt;strong&gt;</xsl:text>
	<xsl:apply-templates mode="html" />
	<xsl:text>&lt;/strong&gt;</xsl:text>
</xsl:template>

<xsl:template match="a" mode="html">
	<xsl:text>&lt;a href="</xsl:text>
	<xsl:value-of select="@href" />
	<xsl:text>"&gt;</xsl:text>
	<xsl:apply-templates mode="html" />
	<xsl:text>&lt;/a&gt;</xsl:text>
</xsl:template>

<xsl:template match="code" mode="html">
	<xsl:text>&lt;code&gt;</xsl:text>
	<xsl:apply-templates mode="html" />
	<xsl:text>&lt;/code&gt;</xsl:text>
</xsl:template>

<xsl:template match="var" mode="html">
	<xsl:text>&lt;var&gt;</xsl:text>
	<xsl:apply-templates mode="html" />
	<xsl:text>&lt;/var&gt;</xsl:text>
</xsl:template>

<xsl:template match="*" mode="html">
	<xsl:message>No template for html version of element <xsl:value-of select="name()" /></xsl:message>
	<xsl:apply-templates mode="html" />
</xsl:template>

<!-- MARKDOWN -->

<xsl:template match="help" mode="markdown">
	<xsl:apply-templates mode="markdown" />
</xsl:template>

<xsl:template match="label | requirement" mode="markdown">
	<xsl:apply-templates mode="markdown" />
</xsl:template>

<xsl:template match="em" mode="markdown">
	<xsl:text>*</xsl:text>
	<xsl:apply-templates mode="markdown" />
	<xsl:text>*</xsl:text>
</xsl:template>

<xsl:template match="strong" mode="markdown">
	<xsl:text>**</xsl:text>
	<xsl:apply-templates mode="markdown" />
	<xsl:text>**</xsl:text>
</xsl:template>

<xsl:template match="a" mode="markdown">
	<xsl:text>[</xsl:text>
	<xsl:apply-templates mode="markdown" />
	<xsl:text>](</xsl:text>
	<xsl:value-of select="@href" />
	<xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="code" mode="markdown">
	<xsl:text>`</xsl:text>
	<xsl:apply-templates mode="markdown" />
	<xsl:text>`</xsl:text>
</xsl:template>

<xsl:template match="var" mode="markdown">
	<xsl:text>&lt;var&gt;</xsl:text>
	<xsl:apply-templates mode="markdown" />
	<xsl:text>&lt;/var&gt;</xsl:text>
</xsl:template>

<xsl:template match="*" mode="markdown">
	<xsl:message>No template for markdown version of element <xsl:value-of select="name()" /></xsl:message>
	<xsl:apply-templates mode="markdown" />
</xsl:template>

<!-- SYNTAX -->

<xsl:template match="_group" mode="syntax">
	<xsl:param name="indent" as="xs:string" select="''" tunnel="yes" />
	<xsl:for-each select="*">
		<xsl:apply-templates select="." mode="syntax" />
		<xsl:if test="position() != last()">
			<xsl:text>&#xA;</xsl:text>
		</xsl:if>
	</xsl:for-each>
	<xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="translations | *[starts-with(name(), 'section_')]" mode="syntax">
	<xsl:param name="indent" as="xs:string" select="''" tunnel="yes" />
	<xsl:next-match />	
	<xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="meta_map" mode="syntax">
	<xsl:param name="indent" as="xs:string" select="''" tunnel="yes" />
	<xsl:text>:</xsl:text>
	<xsl:value-of select="name()" />
	<xsl:text> => {&#xA;</xsl:text>
	<xsl:for-each select="@*">
		<xsl:value-of select="concat($indent, '  ')" />
		<xsl:value-of select="name()" />
		<xsl:text>: </xsl:text>
		<xsl:value-of select="local:rubyQuotedText(.)" />
		<xsl:if test="position() != last()">,</xsl:if>
		<xsl:text>&#xA;</xsl:text>
	</xsl:for-each>
	<xsl:value-of select="$indent" />
	<xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="*" mode="syntax">
	<xsl:param name="indent" as="xs:string" select="''" tunnel="yes" />
	<xsl:value-of select="$indent" />
	<xsl:value-of select="name()" />
	<xsl:text> </xsl:text>
	<xsl:for-each select="@label, @type, (@* except (@label, @type)), meta_map">
		<xsl:if test="position() > 1">
			<xsl:text>,&#xA;</xsl:text>
			<xsl:value-of select="$indent" />
			<xsl:text>  </xsl:text>
		</xsl:if>
		<xsl:apply-templates select="." mode="syntax">
			<xsl:with-param name="indent" tunnel="yes" select="concat($indent, '  ')" />
		</xsl:apply-templates>
	</xsl:for-each>
	<xsl:if test="* except meta_map">
		<xsl:text> do</xsl:text>
		<xsl:text>&#xA;&#xA;</xsl:text>
		<xsl:apply-templates select="node() except meta_map" mode="syntax">
			<xsl:with-param name="indent" select="concat($indent, '  ')" tunnel="yes" />
		</xsl:apply-templates>
		<xsl:value-of select="$indent" />
		<xsl:text>end</xsl:text>
		<xsl:text>&#xA;</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="@*" mode="syntax">
	<xsl:text>:</xsl:text>
	<xsl:value-of select="name()" />
	<xsl:text> => </xsl:text>
	<xsl:value-of select="local:rubyQuotedText(.)" />
</xsl:template>

<xsl:template match="@label" mode="syntax">
	<xsl:sequence select="local:rubyQuotedText(.)" />
</xsl:template>

<xsl:template match="@type" mode="syntax">
	<xsl:text>:</xsl:text>
	<xsl:value-of select="." />
</xsl:template>

<xsl:template match="@value" mode="syntax">
	<xsl:value-of select="." />
</xsl:template>

<!-- properties whose values are tokens rather than strings -->
<xsl:template match="@required | @input_type | @pick | translations/@en | @discussion_topic" mode="syntax">
	<xsl:text>:</xsl:text>
	<xsl:value-of select="name()" />
	<xsl:text> => :</xsl:text>
	<xsl:value-of select="." />	
</xsl:template>

<xsl:template match="*[not(@custom_renderer)]/@requirement" mode="syntax">
	<xsl:text>:requirement => [</xsl:text>
	<xsl:for-each select="tokenize(., ', ')">
		<xsl:text>'</xsl:text>
		<xsl:value-of select="." />
		<xsl:text>'</xsl:text>
		<xsl:if test="position() != last()">, </xsl:if>
	</xsl:for-each>
	<xsl:text>]</xsl:text>
</xsl:template>

<!-- properties whose values are boolean values rather than strings -->
<xsl:template match="@display_header | @display_on_certificate" mode="syntax">
	<xsl:text>:</xsl:text>
	<xsl:value-of select="name()" />
	<xsl:text> => </xsl:text>
	<xsl:value-of select="." />	
</xsl:template>

<xsl:template match="text()" mode="syntax" />

<!-- TRANSLATION -->

<xsl:template match="questionnaire" mode="translation">
	<xsl:text>title: </xsl:text>
	<xsl:value-of select="local:yamlQuotedText(@jurisdiction)" />
	<xsl:text>&#xA;</xsl:text>
	<xsl:text>full_title: </xsl:text>
	<xsl:value-of select="local:yamlQuotedText(local:titleCase(key('countries', @jurisdiction, $countries)))" />
	<xsl:text>&#xA;</xsl:text>
	<xsl:text>description: </xsl:text>
	<xsl:variable name="description">
		<xsl:apply-templates select="help/*" mode="html" />
	</xsl:variable>
	<xsl:value-of select="local:yamlQuotedText($description)" />
	<xsl:text>&#xA;</xsl:text>
	<xsl:text>survey_sections:&#xA;</xsl:text>
	<xsl:apply-templates select="group" mode="translation" />
	<xsl:text>questions:&#xA;</xsl:text>
	<xsl:for-each select="group">
		<xsl:text># </xsl:text>
		<xsl:value-of select="label" />
		<xsl:text>&#xA;</xsl:text>
		<xsl:apply-templates select=".//question" mode="translation" />
	</xsl:for-each>
	<xsl:text>labels:&#xA;</xsl:text>
	<xsl:apply-templates select="group//group" mode="translation" />
	<xsl:for-each select="group">
		<xsl:text># </xsl:text>
		<xsl:value-of select="label" />
		<xsl:text> Requirements&#xA;</xsl:text>
		<xsl:apply-templates select=".//requirement" mode="translation" />
	</xsl:for-each>
</xsl:template>

<xsl:template match="group" mode="translation">
	<xsl:text>  </xsl:text>
	<xsl:value-of select="@id" />
	<xsl:text>:&#xA;</xsl:text>
	<xsl:text>    title: </xsl:text>
	<xsl:variable name="title">
		<xsl:apply-templates select="label" mode="html" />
	</xsl:variable>
	<xsl:value-of select="local:yamlQuotedText($title)" />
	<xsl:text>&#xA;</xsl:text>
	<xsl:apply-templates select="help" mode="translation" />
</xsl:template>

<xsl:template match="question" mode="translation">
	<xsl:text>  </xsl:text>
	<xsl:value-of select="@id" />
	<xsl:text>:&#xA;</xsl:text>
	<xsl:text>    text: </xsl:text>
	<xsl:variable name="text">
		<xsl:apply-templates select="label" mode="html" />
	</xsl:variable>
	<xsl:value-of select="local:yamlQuotedText($text)" />
	<xsl:text>&#xA;</xsl:text>
	<xsl:if test="@display">
		<xsl:text>    text_as_statement: </xsl:text>
		<xsl:value-of select="local:yamlQuotedText(@display)" />
		<xsl:text>&#xA;</xsl:text>
	</xsl:if>
	<xsl:apply-templates select="help" mode="translation" />
	<xsl:text>    answers:&#xA;</xsl:text>
	<xsl:choose>
		<xsl:when test="input">
			<xsl:text>      a_1:&#xA;</xsl:text>
			<xsl:text>        text: </xsl:text>
			<xsl:value-of select="local:yamlQuotedText(input/@placeholder)" />
			<xsl:text>&#xA;</xsl:text>
		</xsl:when>
		<xsl:when test="yesno">
			<xsl:text>      a_false:&#xA;</xsl:text>
			<xsl:text>        text: </xsl:text>
			<xsl:value-of select="(//questionnaire/@no, 'no')[1]" />
			<xsl:text>&#xA;</xsl:text>
			<xsl:if test="yesno/@yes or yesno/@no">
				<xsl:text>        text_as_statement: </xsl:text>
				<xsl:value-of select="local:yamlQuotedText((yesno/@no, '')[1])" />
				<xsl:text>&#xA;</xsl:text>
			</xsl:if>
			<xsl:text>      a_true:&#xA;</xsl:text>
			<xsl:text>        text: </xsl:text>
			<xsl:value-of select="(//questionnaire/@yes, 'yes')[1]" />
			<xsl:text>&#xA;</xsl:text>
			<xsl:if test="yesno/@yes or yesno/@no">
				<xsl:text>        text_as_statement: </xsl:text>
				<xsl:value-of select="local:yamlQuotedText((yesno/@yes, '')[1])" />
				<xsl:text>&#xA;</xsl:text>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select=".//option[@value]">
				<xsl:text>      </xsl:text>
				<xsl:value-of select="local:token(@value)" />
				<xsl:text>:&#xA;</xsl:text>
				<xsl:text>        text: </xsl:text>
				<xsl:variable name="text">
					<xsl:choose>
						<xsl:when test="label">
							<xsl:apply-templates select="label" mode="html" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="." />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="local:yamlQuotedText($text)" />
				<xsl:text>&#xA;</xsl:text>
				<xsl:apply-templates select="help" mode="translation">
					<xsl:with-param name="indent" select="'        '" />
				</xsl:apply-templates>
				<xsl:if test="ancestor::question/@display">
					<xsl:text>        text_as_statement: </xsl:text>
					<xsl:variable name="text_as_statement">
						<xsl:choose>
							<xsl:when test="@display">
								<xsl:value-of select="@display" />
							</xsl:when>
							<xsl:when test="label">
								<xsl:apply-templates select="label" mode="html" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="." />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:value-of select="local:yamlQuotedText($text_as_statement)" />
					<xsl:text>&#xA;</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="requirement" mode="translation">
	<xsl:text>  </xsl:text>
	<xsl:value-of select="local:requirementId(.)" />
	<xsl:text>:&#xA;</xsl:text>
	<xsl:text>    text: </xsl:text>
	<xsl:variable name="text">
		<xsl:apply-templates select="." mode="html" />
	</xsl:variable>
	<xsl:value-of select="local:yamlQuotedText($text)" />
	<xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="help" mode="translation">
	<xsl:param name="indent" as="xs:string" select="'    '" />
	<xsl:value-of select="$indent" />
	<xsl:text>help_text: </xsl:text>
	<xsl:variable name="help_text">
		<xsl:apply-templates select="." mode="html" />
	</xsl:variable>
	<xsl:value-of select="local:yamlQuotedText($help_text)" />
	<xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="*" mode="translation" />

<!-- FUNCTIONS -->

<xsl:function name="local:token" as="xs:string">
	<xsl:param name="string" as="xs:string" />
	<xsl:sequence select="translate($string, '.-', '__')" />
</xsl:function>

<xsl:function name="local:requirementId" as="xs:string">
	<xsl:param name="requirement" as="element(requirement)" />
	<xsl:choose>
		<xsl:when test="$requirement/@level">
			<xsl:value-of select="concat($requirement/@level, '_', count($requirement/preceding::requirement[@level = $requirement/@level]) + 1)" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="concat('basic_', count($requirement/preceding::requirement[empty(@level)]) + 1)" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:function>

<xsl:function name="local:conditionId" as="xs:string">
	<xsl:param name="condition" as="element(condition)" />
	<xsl:number select="$condition" format="A" level="any" />
</xsl:function>

<xsl:function name="local:rubyQuotedText" as="xs:string">
	<xsl:param name="string" as="xs:string" />
	<xsl:sequence select="concat('''', replace($string, '''', '\\'''), '''')" />
</xsl:function>

<xsl:function name="local:yamlQuotedText" as="xs:string">
	<xsl:param name="string" as="xs:string" />
	<xsl:sequence select="concat('&quot;', replace($string, '&quot;', '\\&quot;'), '&quot;')" />
</xsl:function>

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
			<xsl:if test="position() != last()"><xsl:text> </xsl:text></xsl:if>
		</xsl:for-each>
	</xsl:value-of>
</xsl:function>

<xsl:function name="local:parseTest" as="element()">
	<xsl:param name="test" as="xs:string" />
	<xsl:param name="reverse" as="xs:boolean" />
	<xsl:choose>
		<xsl:when test="contains($test, '||')">
			<or>
				<xsl:for-each select="tokenize($test, '\|\|')">
					<xsl:sequence select="local:parseTest(normalize-space(.), $reverse)" />
				</xsl:for-each>
			</or>
		</xsl:when>
		<xsl:when test="contains($test, '&amp;&amp;')">
			<and>
				<xsl:for-each select="tokenize($test, '&amp;&amp;')">
					<xsl:sequence select="local:parseTest(normalize-space(.), $reverse)" />
				</xsl:for-each>
			</and>
		</xsl:when>
		<xsl:otherwise>
			<xsl:analyze-string select="$test" regex="^\(?this\.([a-zA-Z]+)\(\) (===|!==) '([^']*)'\)?$">
				<xsl:matching-substring>
					<condition>
						<xsl:attribute name="value">
							<xsl:text>:q_</xsl:text>
							<xsl:value-of select="regex-group(1)" />
							<xsl:text>, </xsl:text>
							<xsl:choose>
								<xsl:when test="regex-group(2) = '==='">
									<xsl:choose>
										<xsl:when test="$reverse">'!='</xsl:when>
										<xsl:otherwise>'=='</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="$reverse">'=='</xsl:when>
										<xsl:otherwise>'!='</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text>, </xsl:text>
							<xsl:choose>
								<xsl:when test="regex-group(3) = ''">{:string_value => '', :answer_reference => '1'}</xsl:when>
								<xsl:otherwise>
									<xsl:text>:a_</xsl:text>
									<xsl:value-of select="local:token(regex-group(3))" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</condition>
				</xsl:matching-substring>
				<xsl:non-matching-substring>
					<xsl:analyze-string select="$test" regex="^\(?this\.([a-zA-Z]+)(\(\)\.([a-z]+))?\)?$">
						<xsl:matching-substring>
							<condition>
								<xsl:attribute name="value">
									<xsl:text>:q_</xsl:text>
									<xsl:value-of select="regex-group(1)" />
									<xsl:text>, </xsl:text>
									<xsl:choose>
										<xsl:when test="$reverse">'!='</xsl:when>
										<xsl:otherwise>'=='</xsl:otherwise>
									</xsl:choose>
									<xsl:text>, :a_</xsl:text>
									<xsl:choose>
										<xsl:when test="regex-group(3) = ''">true</xsl:when>
										<xsl:otherwise><xsl:value-of select="local:token(regex-group(3))" /></xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
							</condition>
						</xsl:matching-substring>
						<xsl:non-matching-substring>
							<xsl:message terminate="yes">Couldn't parse <xsl:value-of select="$test" /></xsl:message>
						</xsl:non-matching-substring>
					</xsl:analyze-string>
				</xsl:non-matching-substring>
			</xsl:analyze-string>
		</xsl:otherwise>
	</xsl:choose>
</xsl:function>

</xsl:stylesheet>