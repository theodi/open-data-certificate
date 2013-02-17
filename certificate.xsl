<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs">

<xsl:output method="html" doctype-public="XSLT-compat" encoding="UTF-8" indent="yes" />
	
<xsl:key name="fields" match="question" use="@id" />

<xsl:template match="questionnaire">
	<html>
	  <head>
	    <title>ODI Open Data Certificate</title>
	    <link href="css/bootstrap.min.css" rel="stylesheet" media="screen" />
	    <link href="css/certificate.css" rel="stylesheet" media="screen" />
	  </head>
	  <body>
	    <div class="container">
	      <div class="page-header">
	        <h1>Open Data Certificate <small>from the Open Data Institute</small></h1>
	      </div>
	      <p class="lead">All open data is good, but some is better than others. This tool gives you a certificate that will help people understand the open data you are publishing.</p>
	      <form id="questionnaire" class="form-horizontal">
	        <div class="accordian">
	        	<xsl:apply-templates select="group" />
	        </div>
	      </form>
	      <div id="certificate-container" class="well">
	        <div id="certificate">
	          <h1><span class="placeholder" data-field="certificate-level"></span> Open Data Certificate</h1>
	        	<xsl:apply-templates select="certificate" />
	        </div>
	        <p>
	          <a id="download-certificate" href="#" target="_new" class="btn btn-primary">Download Certificate</a>
	        </p>
	      </div>
	      <div id="improvements">
	        <div class="page-header">
	          <h1>Improving Your Open Data</h1>
	        </div>
	        <p class="lead">
	          You can improve the way you are publishing open data to make it more useful.
	        </p>
	        <ul id="improvements-bronze" class="unstyled">
	        </ul>
	        <ul id="improvements-silver" class="unstyled">
	        </ul>
	        <ul id="improvements-gold" class="unstyled">
	        </ul>
	      </div>
	    </div>
	  	<!--
	    <footer class="footer">
	      <div class="container">
	        <a rel="license" href="http://creativecommons.org/licenses/by/2.0/uk/deed.en_GB"><img style="border-width:0" src="http://i.creativecommons.org/l/by/2.0/uk/80x15.png" alt="Creative Commons Licence" /></a> <a href="http://www.theodi.org">Open Data Institute</a>
	      </div>
	    </footer>
	    -->
	
	    <!--
	    <script src="http://code.jquery.com/jquery-latest.js"></script>
	    -->
	    <script src="js/jquery-latest.js"></script>
	    <script src="js/bootstrap.min.js"></script>
	    <script src="js/certificate.js"></script>
	  </body>
	</html>
</xsl:template>

<xsl:template match="questionnaire/group">
  <div class="accordion-group">
    <div class="accordion-heading">
      <h2>
        <a class="accordion-toggle" data-toggle="collapse" data-parent="#questionnaire" href="#{@id}"><xsl:apply-templates select="label" /></a>
      </h2>
    </div>
    <div id="{@id}" class="accordion-body collapse{if (position() = 1) then ' in' else ''}">
      <div class="accordion-inner">
      	<xsl:apply-templates select="label/following-sibling::*" />
      </div>
    </div>
  </div>
</xsl:template>

<xsl:template match="group/group">
	<fieldset id="{@id}">
		<legend><xsl:apply-templates select="label/node()" /></legend>
		<xsl:apply-templates select="label/following-sibling::*" />
	</fieldset>
</xsl:template>

<xsl:template match="question">
	<xsl:variable name="id" as="xs:string" select="if (ancestor::repeat) then concat(@id, '-0') else @id" />
	<div class="control-group">
		<label class="control-label" for="{$id}"><xsl:apply-templates select="label" /></label>
		<div class="controls">
			<xsl:apply-templates select="label/following-sibling::*[1]">
				<xsl:with-param name="id" select="$id" tunnel="yes" />
			</xsl:apply-templates>
			<xsl:apply-templates select="help, requirement, if[.//requirement]" mode="label">
				<xsl:with-param name="id" select="$id" tunnel="yes" />
			</xsl:apply-templates>
			<xsl:apply-templates select="label/following-sibling::*[position() > 1]">
				<xsl:with-param name="id" select="$id" tunnel="yes" />
			</xsl:apply-templates>
		</div>
	</div>
</xsl:template>

<xsl:template match="input">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<input type="text" class="span5" id="{$id}" name="{$id}">
		<xsl:sequence select="@type, @placeholder, @required" />
	</input>
</xsl:template>

<!--
<xsl:template match="input[@type = 'url']">
	<div class="input-prepend">
		<span class="add-on">http://</span>
		<xsl:next-match />
	</div>
</xsl:template>

<xsl:template match="input[@type = 'email']">
	<div class="input-prepend">
		<span class="add-on">mailto:</span>
		<xsl:next-match />
	</div>
</xsl:template>
-->

<xsl:template match="radioset">
	<xsl:apply-templates select="option" />
</xsl:template>

<xsl:template match="radioset/option">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<label class="radio">
		<input type="radio" name="{$id}">
			<xsl:sequence select="@value" />
			<xsl:apply-templates select="label/node()" />
		</input>
		<xsl:apply-templates select="help, requirement" mode="label">
			<xsl:with-param name="id" select="concat($id, '-', @value)" tunnel="yes" />
		</xsl:apply-templates>
		<xsl:apply-templates select="* except label">
			<xsl:with-param name="id" select="concat($id, '-', @value)" tunnel="yes" />
		</xsl:apply-templates>
	</label>
</xsl:template>

<xsl:template match="yesno">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<label class="radio inline"><input type="radio" name="{$id}" value="true" /> Yes</label>
	<label class="radio inline"><input type="radio" name="{$id}" value="false" /> No</label>
</xsl:template>

<xsl:template match="textarea">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<textarea class="span5" id="{$id}" name="{$id}" rows="3">
		<xsl:text>&#xA;</xsl:text>
	</textarea>
</xsl:template>

<xsl:template match="select">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<select class="span5" id="{$id}" name="{$id}">
		<xsl:apply-templates select="@required, @multiple" />
		<xsl:apply-templates />
	</select>
</xsl:template>

<xsl:template match="label">
	<xsl:apply-templates />
</xsl:template>
	
<xsl:template match="help" mode="label">
	<xsl:param name="id" as="xs:string" tunnel="yes" required="yes" />
	<button type="button" class="btn btn-link" data-toggle="collapse" data-target="#{$id}-help">
		<i class="icon-question-sign"></i>
	</button>
</xsl:template>

<xsl:template match="requirement" mode="label" />

<xsl:template match="requirement[@level]" mode="label">
	<xsl:param name="id" as="xs:string" tunnel="yes" required="yes" />
	<xsl:text> </xsl:text>
	<span class="label label-{@level}" data-toggle="collapse" data-target="#{$id}-requirement">
		<i class="icon-star icon-white"></i>
		<xsl:text> </xsl:text>
		<xsl:value-of select="concat(upper-case(substring(@level, 1, 1)), substring(@level, 2))" />
	</span>
</xsl:template>
	
<xsl:template match="help">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<span id="{$id}-help" class="help-block collapse"><xsl:apply-templates /></span>
</xsl:template>
	
<xsl:template match="requirement">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<div id="{$id}-requirement" class="requirement collapse" data-level="{if (@level = 'gold') then 'silver' else if (@level = 'silver') then 'bronze' else 'basic'}" data-field="{$id}">
		<xsl:if test="not(@value) and not(@not-value)">
			<xsl:attribute name="data-if-equals" select="../@value" />
		</xsl:if>
		<xsl:apply-templates select="@value, @not-value" />
		<p class="alert alert-info">
			<a href="#{$id}-requirement">
				<span class="label label-{@level}"><i class="icon-star icon-white"></i> <xsl:value-of select="concat(upper-case(substring(@level, 1, 1)), substring(@level, 2))" /></span>
			</a>
			<xsl:text> </xsl:text>
			<xsl:apply-templates />
		</p>
	</div>
</xsl:template>

<xsl:template match="requirement[not(@level)]">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<xsl:variable name="field" as="xs:string" select="if (@field) then @field else $id" />
	<div class="conditional" data-field="{$field}" data-if-equals="{@not-value}">
		<div class="requirement">
			<p class="alert alert-error"><xsl:apply-templates /></p>
		</div>
	</div>
</xsl:template>

<xsl:template match="if/requirement[not(@level)]" priority="10">
	<div class="requirement">
		<p class="alert alert-error"><xsl:apply-templates /></p>
	</div>
</xsl:template>

<xsl:template match="certificate">
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="repeat">
	<div class="repeated">
		<xsl:apply-templates select="label/following-sibling::*" />
		<div class="control-group repeat-controls">
			<div class="controls">
				<button type="button" class="btn btn-primary repeat-add"><i class="icon-plus-sign icon-white"></i> Another <xsl:value-of select="label" /></button>
			</div>
		</div>
	</div>
</xsl:template>

<xsl:template match="if" mode="label">
	<span class="conditional" data-field="{@field}">
		<xsl:apply-templates select="@value | @not-value" />
		<xsl:apply-templates mode="label" />
	</span>
</xsl:template>

<xsl:template match="if">
	<div class="conditional" data-field="{@field}">
		<xsl:apply-templates select="@value | @not-value" />
		<xsl:apply-templates />
	</div>
</xsl:template>

<xsl:template match="if/@value | requirement/@value">
	<xsl:attribute name="data-if-equals" select="." />
</xsl:template>

<xsl:template match="if/@not-value | requirement/@not-value">
	<xsl:attribute name="data-not-equals" select="." />
</xsl:template>

<xsl:template match="placeholder">
	<xsl:variable name="field" as="element(question)?" select="key('fields', @ref)" />
	<span class="placeholder{if ($field/input/@type = 'url') then ' placeholder-url' else ''}" data-field="{@ref}" data-placeholder="{.}">
		<xsl:apply-templates />
	</span>
</xsl:template>

<xsl:template match="node()|@*" mode="#all">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()" mode="#current" />
	</xsl:copy>
</xsl:template>

<xsl:template match="processing-instruction('xml-stylesheet')" />

</xsl:stylesheet>