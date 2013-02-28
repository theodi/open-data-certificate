<!--
  © 2013 Open Data Institute

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  -->
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
	    <link href="bootstrap/css/bootstrap.css" rel="stylesheet" media="screen" />
	    <link href="css/certificate.css" rel="stylesheet" media="screen" />
	  </head>
	  <body>
	  	<div id="alpha-banner" class="alert alert-danger">
	  		<p>
	  			This is an <strong>alpha version</strong> of the ODI's Open Data Certificate. Comments on both the content and the usability of the questionnaire are very welcome. Please add <a href="https://github.com/theodi/open-data-certificate/issues">issues on github</a> or contact <a href="mailto:certificate@theodi.org">certificate@theodi.org</a>.
	  		</p>
	  	</div>
	  	<header id="header">
	  		<div class="container">
	  			<div class="branding">
	  				<a id="logo" rel="home" title="Home" href="http://theodi.org/">
	  					<img width="131" height="54" class="b_png" alt="Home" src="http://theodi.org/sites/default/files/logo.png" />
	  				</a>
	  				<hgroup id="name-and-slogan">
	  					<h1 id="site-name">
	  						<a rel="home" title="Open Data Institute" href="http://theodi.org/">
	  							<img width="326" height="30" class="b_png" alt="Open Data Institute" src="http://theodi.org/sites/default/files/logo_a.png" />                            
	  						</a>
	  					</h1>
	  					<h2 id="site-slogan">Knowledge for everyone</h2>
	  				</hgroup>
	  			</div>
	  			<nav>
	  				<div id="mainnav" class="navbar navbar-inverse">
	  					<div class="navbar-inner">
	  						<a class="brand" href="#">Open Data Certificate</a>
	  						<ul class="nav">
	  							<li class="active"><a href="#questionnaire">Questionnaire</a></li>
	  							<li class="divider-vertical"></li>
	  							<li><a href="#certificate">Certificate</a></li>
	  							<li class="divider-vertical"></li>
	  							<li><a href="#improvements">Improvements</a></li>
	  							<li class="divider-vertical"></li>
	  							<li><a href="index.html">About</a></li>
	  						</ul>
	  					</div>
	  				</div>
	  			</nav>
	  		</div>
	  	</header>
	  	<div class="container">
	  		<div id="secondarynav" class="navbar">
	  			<div class="navbar-inner">
	  				<ul class="nav nav-pills">
	  					<xsl:for-each select="group">
	  						<li>
	  							<xsl:if test="position() = 1"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
	  							<a href="#{@id}"><xsl:value-of select="replace(label, ' Information$', '')" /></a>
	  						</li>
	  					</xsl:for-each>
	  				</ul>
	  			</div>
	  		</div>
	  		<section>
	  			<p class="lead">All open data is good, but some is better than others. This tool gives you a certificate that will help people understand the open data you are publishing.</p>
	  			<div class="accordion" id="main-help-accordion">
	  				<div class="accordion-group">
	  					<div class="accordion-heading">
	  						<a href="#main-help" class="accordion-toggle" data-parent="#main-help-accordion" data-toggle="collapse">Help</a>
	  					</div>
	  					<div id="main-help" class="accordion-body collapse in">
	  						<div class="accordion-inner">
	  							<div class="row-fluid">
	  								<div class="span4">
	  									<p>Questions marked with a label must be answered to gain that level of the certificate.</p>
	  								</div>
	  								<div class="span4">
	  									<p class="text-center">
	  										<span class="label label-bronze"><i class="icon-star icon-white"></i> Bronze</span>
	  										<xsl:text> </xsl:text>
	  										<span class="label label-silver"><i class="icon-star icon-white"></i> Silver</span>
	  										<xsl:text> </xsl:text>
	  										<span class="label label-gold"><i class="icon-star icon-white"></i> Gold</span>
	  									</p>
	  								</div>
	  								<div class="span4">
	  									<p>Click on question marks <i class="icon-question-sign"></i> or labels to find out more about what to enter.
	  									</p>
	  								</div>
	  							</div>
	  							<hr />
	  							<div class="row-fluid">
	  								<div class="span4 text-center">
	  									<div class="control-group error">
	  										<div class="control-label"><label for="exampleError">Red fields are required</label></div>
	  										<div class="controls"><input id="exampleError" type="text" placeholder="Required Field" required="required" /></div>
	  									</div>
	  								</div>
	  								<div class="span4 text-center">
	  									<div class="control-group">
	  										<div class="control-label"><label for="exampleField">Black fields are optional</label></div>
	  										<div class="controls"><input id="exampleField" type="text" placeholder="Optional Field" /></div>
	  									</div>
	  								</div>
	  								<div class="span4 text-center">
	  									<div class="control-group success">
	  										<div class="control-label"><label for="exampleSuccess">Green fields are complete</label></div>
	  										<div class="controls"><input id="exampleSuccess" type="text" value="Complete Field" /></div>
	  									</div>
	  								</div>
	  							</div>
	  						</div>
	  					</div>
	  				</div>
	  			</div>
	  		</section>
	      <form id="questionnaire" class="form-horizontal">
        	<xsl:apply-templates select="group" />
	      </form>
	  		<section id="certificate-container" class="well" data-bind="visible: certificateLevel() !== 'none'">
  				<div id="certificate">
  					<h1><span class="placeholder" data-bind="text: certificateLevelLabel"></span> Open Data Certificate</h1>
  					<xsl:apply-templates select="certificate" />
  				</div>
	  			<!--
  				<p>
  					<a id="download-certificate" href="#" target="_new" class="btn btn-primary">Download Certificate</a>
  				</p>
  				-->
	  		</section>
	  		<section id="improvements" data-bind="visible: certificateLevel() !== 'none' &amp;&amp; certificateLevel() !== 'gold'">
  				<div class="page-header">
  					<h1>Improving Your Open Data</h1>
  				</div>
  				<p class="lead">
  					You can improve the way you are publishing open data to make it more useful.
  				</p>
  				<div id="improvements-bronze" class="unstyled">
  					<xsl:apply-templates mode="requirementList">
  						<xsl:with-param name="level" select="'bronze'" tunnel="yes" />
  					</xsl:apply-templates>
  				</div>
  				<div id="improvements-silver" class="unstyled">
  					<xsl:apply-templates mode="requirementList">
  						<xsl:with-param name="level" select="'silver'" tunnel="yes" />
  					</xsl:apply-templates>
  				</div>
  				<div id="improvements-gold" class="unstyled">
  					<xsl:apply-templates mode="requirementList">
  						<xsl:with-param name="level" select="'gold'" tunnel="yes" />
  					</xsl:apply-templates>
  				</div>
	  		</section>
	    </div>
	  	<footer id="footer">
	  		<div class="container">
	  			<nav>
	  				<ul>
	  					<li><a href="/privacy-policy">Privacy Policy</a></li>
	  					<li><a href="/terms-of-use">Terms of Use</a></li>
	  					<li><a href="/cookie-policy">Cookie Policy</a></li>
	  					<li><a href="/feedback">Feedback</a></li>
	  				</ul>
	  			</nav>
	  			<p>
	  				<a rel="license" href="http://creativecommons.org/licenses/by-sa/2.0/uk/deed.en_GB">
	  					<img style="border-width:0" src="http://i.creativecommons.org/l/by-sa/2.0/uk/80x15.png" alt="Creative Commons Licence" />
	  				</a>
	  				<xsl:text> </xsl:text>
	  				<a href="http://www.theodi.org">Open Data Institute</a> · 
	  				<a href="http://www.openstreetmap.org/?lat=51.522205&amp;lon=-0.08176500000001852&amp;zoom=16&amp;layers=T&amp;mlat=51.52210&amp;mlon=-0.08343">65 Clifton Street, London EC2A 4JE</a> · 
	  				<a href="mailto:info@theodi.org">info@theodi.org</a> · 
	  				Company <a href="http://opencorporates.com/companies/gb/08030289">08030289</a> · 
	  				VAT 143 7796 80
	  			</p>
	  		</div>
	  	</footer>
	  	
	    <script src="js/jquery-1.9.1.min.js"></script>
	    <script src="bootstrap/docs/assets/js/bootstrap.min.js"></script>
	  	<script src="js/knockout-2.2.1.js"></script>
	  	<script type="text/javascript">
	  		var certificateViewModel = function () {
		  			var certificate = this;
			  		<xsl:apply-templates mode="viewModel" />
		  			certificate.certificateLevel = ko.computed(function () {
		  				var unmetRequirements = {
		  						basic: 0,
		  						bronze: 0,
		  						silver: 0,
		  						gold: 0
		  					}
		  				;
		  				<xsl:apply-templates mode="unmetRequirements" />
		  				if (unmetRequirements.basic > 0) {
		  					return 'none';
		  				} else if (unmetRequirements.bronze > 0) {
		  					return 'basic';
		  				} else if (unmetRequirements.silver > 0) {
		  					return 'bronze';
		  				} else if (unmetRequirements.gold > 0) {
		  					return 'silver';
		  				} else {
		  					return 'gold';
		  				}
		  			}, certificate);
		  			certificate.certificateLevelLabel = ko.computed(function () {
		  				var level = this.certificateLevel()
		  				;
		  				if (level === 'none' || level === 'basic') {
		  					return '';
		  				} else {
		  					return level.substring(0, 1).toUpperCase() + level.substring(1);
		  				}
		  			}, certificate);
		  		}
		  	,   certificate = new certificateViewModel()
	  		;
	  		
	  		ko.applyBindings(certificate);
	  	</script>
	  	<!--
	    <script src="js/certificate.js"></script>
	    -->
	  </body>
	</html>
</xsl:template>

<xsl:template match="questionnaire/group">
	<section id="{@id}">
		<div class="page-header">
			<p class="bookmark">
				<a href="#{@id}"><i class="icon icon-bookmark icon-white"></i></a><br />
				<a href="#{preceding-sibling::group[1]/@id}"><i class="icon icon-chevron-up icon-white"></i></a><br />
				<a href="#{following-sibling::group[1]/@id}"><i class="icon icon-chevron-down icon-white"></i></a>
			</p>
			<h1><xsl:apply-templates select="label" /></h1>
		</div>
		<xsl:apply-templates select="@jurisdiction" />
		<xsl:apply-templates select="label/following-sibling::*" />
	</section>
</xsl:template>

<xsl:template match="group/group">
	<fieldset id="{@id}">
		<legend><xsl:apply-templates select="label/node()" /></legend>
		<xsl:apply-templates select="@jurisdiction" />
		<xsl:apply-templates select="label/following-sibling::*" />
	</fieldset>
</xsl:template>

<xsl:template match="@jurisdiction">
	<p class="alert alert-warning">
		<xsl:text>This version of the certificate is designed to be used within </xsl:text>
		<xsl:choose>
			<xsl:when test=". = 'UK'">the UK</xsl:when>
		</xsl:choose>
		<xsl:text>. Please </xsl:text>
		<a href="mailto:certificate@theodi.org">contact us</a>
		<xsl:text> if you want to use the certificate in other jurisdictions.</xsl:text>
	</p>
</xsl:template>

<xsl:template match="question">
	<div class="control-group">
		<xsl:attribute name="data-bind">
			<xsl:text>css: {</xsl:text>
			<xsl:text> success: </xsl:text><xsl:value-of select="concat(@id, '() !== ''''')" />
			<xsl:if test="*[@required = 'required'] or radioset or yesno">
				<xsl:text>, error: </xsl:text><xsl:value-of select="concat(@id, '() === ''''')" />
			</xsl:if>			
			<xsl:text>}</xsl:text>
		</xsl:attribute>
		<label class="control-label">
			<xsl:if test="not(yesno or radioset)">
				<xsl:choose>
					<xsl:when test="ancestor::repeat">
						<xsl:attribute name="data-bind">attr: { for: '<xsl:value-of select="@id" />-' + $index() }</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="for" select="@id" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:apply-templates select="label" />
		</label>
		<div class="controls">
			<xsl:apply-templates select="label/following-sibling::*[1]">
				<xsl:with-param name="id" select="@id" tunnel="yes" />
			</xsl:apply-templates>
			<xsl:apply-templates select="help, requirement, if[.//requirement]" mode="label">
				<xsl:with-param name="id" select="@id" tunnel="yes" />
			</xsl:apply-templates>
			<xsl:apply-templates select="label/following-sibling::*[position() > 1]">
				<xsl:with-param name="id" select="@id" tunnel="yes" />
			</xsl:apply-templates>
		</div>
	</div>
</xsl:template>

<xsl:template match="input">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<input type="text" class="span5">
		<xsl:apply-templates select="." mode="dataBind" />
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
		<input type="radio">
			<xsl:apply-templates select=".." mode="dataBind" />
			<xsl:sequence select="@value" />
			<xsl:apply-templates select="label/node()" />
		</input>
		<xsl:apply-templates select="help, requirement" mode="label">
			<xsl:with-param name="id" select="concat($id, @value)" tunnel="yes" />
		</xsl:apply-templates>
		<xsl:apply-templates select="* except label">
			<xsl:with-param name="id" select="concat($id, @value)" tunnel="yes" />
		</xsl:apply-templates>
	</label>
</xsl:template>

<xsl:template match="yesno">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<label class="radio inline"><input type="radio" value="true"><xsl:apply-templates select="." mode="dataBind" /></input> Yes</label>
	<label class="radio inline"><input type="radio" value="false"><xsl:apply-templates select="." mode="dataBind" /></input> No</label>
</xsl:template>

<xsl:template match="textarea">
	<textarea class="span5" rows="3">
		<xsl:apply-templates select="." mode="dataBind" />
		<xsl:text>&#xA;</xsl:text>
	</textarea>
</xsl:template>

<xsl:template match="select">
	<select class="span5">
		<xsl:apply-templates select="." mode="dataBind" />
		<xsl:apply-templates select="@required, @multiple" />
		<xsl:apply-templates />
	</select>
</xsl:template>

<xsl:template match="*" mode="dataBind" priority="10">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<xsl:variable name="valueType" as="xs:string" select="if (self::yesno or self::radioset) then 'checked' else 'value'" />
	<xsl:variable name="bind">
		<xsl:value-of select="$valueType" />: <xsl:value-of select="$id" />
		<xsl:if test="$valueType = 'value'">
			<xsl:text>, valueUpdate: 'afterkeydown'</xsl:text>
		</xsl:if>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="ancestor::repeat">
			<xsl:attribute name="data-bind"><xsl:value-of select="$bind" />, attr: {<xsl:if test="not(self::yesno or self::radioset)"> id: '<xsl:value-of select="$id" />-' + $index(),</xsl:if> name: '<xsl:value-of select="$id" />-' + $index() }</xsl:attribute>
		</xsl:when>
		<xsl:otherwise>
			<xsl:if test="not(self::yesno or self::radioset)">
				<xsl:attribute name="id" select="$id" />
			</xsl:if>
			<xsl:attribute name="name" select="$id" />
			<xsl:attribute name="data-bind"><xsl:value-of select="$bind" /></xsl:attribute>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="label">
	<xsl:apply-templates />
</xsl:template>
	
<xsl:template match="help" mode="label">
	<xsl:param name="id" as="xs:string" tunnel="yes" required="yes" />
	<button type="button" class="btn btn-link" data-toggle="collapse">
		<xsl:choose>
			<xsl:when test="ancestor::repeat">
				<xsl:attribute name="data-bind">attr: { 'data-target': '#<xsl:value-of select="$id" />-' + $index() + '-help' }</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="data-target">#<xsl:value-of select="$id" />-help</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<i class="icon-question-sign"></i>
	</button>
</xsl:template>

<xsl:template match="requirement" mode="label" />

<xsl:template match="requirement[@level]" mode="label">
	<xsl:param name="id" as="xs:string" tunnel="yes" required="yes" />
	<xsl:text> </xsl:text>
	<span class="label label-{@level}" data-toggle="collapse">
		<xsl:choose>
			<xsl:when test="ancestor::repeat">
				<xsl:attribute name="data-bind">attr: { 'data-target': '#<xsl:value-of select="$id" />-' + $index() + '-requirement' }</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="data-target">#<xsl:value-of select="$id" />-requirement</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<i class="icon-star icon-white"></i>
		<xsl:text> </xsl:text>
		<xsl:value-of select="concat(upper-case(substring(@level, 1, 1)), substring(@level, 2))" />
	</span>
</xsl:template>
	
<xsl:template match="help">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<span class="help-block collapse">
		<xsl:choose>
			<xsl:when test="ancestor::repeat">
				<xsl:attribute name="data-bind">attr: { id: '<xsl:value-of select="$id" />-' + $index() + '-help' }</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="id"><xsl:value-of select="$id" />-help</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates />
	</span>
</xsl:template>
	
<xsl:template match="requirement">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<div class="requirement collapse">
		<xsl:choose>
			<xsl:when test="ancestor::repeat">
				<xsl:attribute name="data-bind">attr: { id: '<xsl:value-of select="$id" />-' + $index() + '-requirement' }</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="id"><xsl:value-of select="$id" />-requirement</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<p class="alert alert-info">
			<a>
				<xsl:choose>
					<xsl:when test="ancestor::repeat">
						<xsl:attribute name="data-bind">attr: { href: '#<xsl:value-of select="$id" />-' + $index() + '-requirement' }</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="href">#<xsl:value-of select="$id" />-requirement</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<span class="label label-{@level}"><i class="icon-star icon-white"></i> <xsl:value-of select="concat(upper-case(substring(@level, 1, 1)), substring(@level, 2))" /></span>
			</a>
			<xsl:text> </xsl:text>
			<xsl:apply-templates />
		</p>
	</div>
</xsl:template>

<xsl:template match="requirement[not(@level)]">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<div class="conditional" data-bind="visible: !({@test})">
		<div class="requirement">
			<p class="alert alert-error"><xsl:apply-templates /></p>
		</div>
	</div>
</xsl:template>

<xsl:template match="if/requirement[not(@level)]" priority="10">
	<xsl:choose>
		<xsl:when test="@test">
			<xsl:next-match />
		</xsl:when>
		<xsl:otherwise>
			<div class="requirement">
				<p class="alert alert-error"><xsl:apply-templates /></p>
			</div>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
	
<xsl:template match="certificate">
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="repeat">
	<div class="repeated" data-bind="foreach: {@id}">
		<div class="well">
			<div class="control-group">
				<div class="controls">
					<button type="button" class="btn btn-info pull-right" data-bind="click: $parent.{@id}Remove, disable: $parent.{@id}().length === 1"><i class="icon-remove icon-white"></i> Delete <xsl:value-of select="label" /></button>
				</div>
			</div>
			<xsl:apply-templates select="label/following-sibling::*" />
		</div>
	</div>
	<div class="control-group repeat-controls">
		<div class="controls">
			<button type="button" class="btn btn-primary" data-bind="click: {@id}Add"><i class="icon-plus icon-white"></i> Add <xsl:value-of select="label" /></button>
		</div>
	</div>
</xsl:template>

<xsl:template match="label//if">
	<span class="conditional" data-bind="visible: {@test}">
		<xsl:apply-templates />
	</span>
</xsl:template>

<xsl:template match="if" mode="label">
	<span class="conditional" data-bind="visible: {@test}">
		<xsl:apply-templates mode="label" />
	</span>
</xsl:template>

<xsl:template match="if">
	<div class="conditional" data-bind="visible: {@test}">
		<xsl:apply-templates />
	</div>
</xsl:template>

<xsl:template match="placeholder">
	<xsl:variable name="field" as="element(question)?" select="key('fields', @ref)" />
	<span class="placeholder" data-bind="text: {@ref}{if ($field/input/@type = 'url') then concat('attr: { href: ', @ref, ' }') else ''}" data-placeholder="{.}">
		<xsl:apply-templates />
	</span>
</xsl:template>

<xsl:template match="node()" mode="viewModel unmetRequirements requirementList" priority="-0.1">
	<xsl:apply-templates mode="#current" />
</xsl:template>
<xsl:template match="text()" mode="viewModel unmetRequirements requirementList" />

<xsl:template match="question" mode="viewModel">
	<xsl:param name="model" as="xs:string" select="'certificate'" tunnel="yes" />
	<xsl:value-of select="concat($model, '.', @id, ' = ko.observable('''');&#xA;')" />
</xsl:template>

<xsl:template match="repeat" mode="viewModel">
	<xsl:param name="model" as="xs:string" select="'certificate'" tunnel="yes" />
	<xsl:value-of select="concat('var ', @id, 'ViewModel = function () {&#xA;')" />
		<xsl:value-of select="concat('var ', @id, ' = this;&#xA;')" />
		<xsl:apply-templates mode="viewModel">
			<xsl:with-param name="model" select="@id" tunnel="yes" />
		</xsl:apply-templates>
	<xsl:text>};&#xA;</xsl:text>
	<xsl:value-of select="concat($model, '.', @id, ' = ko.observableArray([new ', @id, 'ViewModel()]);&#xA;')" />
	<xsl:value-of select="concat($model, '.', @id, 'Add = function () {&#xA;')" />
		<xsl:value-of select="concat('var ', @id, ' = new ', @id, 'ViewModel();&#xA;')" />
		<xsl:value-of select="concat($model, '.', @id, '.push(', @id, ');&#xA;')" />
	<xsl:text>};&#xA;</xsl:text>
	<xsl:value-of select="concat($model, '.', @id, 'Remove = function (', @id, ') {&#xA;')" />
	<xsl:value-of select="concat($model, '.', @id, '.remove(', @id, ');&#xA;')" />
	<xsl:text>};&#xA;</xsl:text>
</xsl:template>

<xsl:template match="question[*/@required = 'required']" mode="unmetRequirements">
	<xsl:param name="model" as="xs:string" select="'certificate'" tunnel="yes" />
	if (<xsl:value-of select="concat($model, '.', @id, '() === ''''')" />) unmetRequirements['basic']++;
</xsl:template>

<xsl:template match="if" mode="unmetRequirements">
	<xsl:param name="model" as="xs:string" select="'certificate'" tunnel="yes" />
	if (<xsl:value-of select="concat($model, '.', @test)" />) {&#xA;<xsl:apply-templates mode="unmetRequirements" />&#xA;}
</xsl:template>

<xsl:template match="radioset[option/requirement]" mode="unmetRequirements">
	<xsl:param name="model" as="xs:string" select="'certificate'" tunnel="yes" />
	<xsl:variable name="id" as="xs:string" select="../@id" />
	<xsl:variable name="options" as="element(option)+" select="option" />
	<xsl:variable name="levels" as="xs:string+" select="('basic', 'bronze', 'silver', 'gold')" />
	<xsl:for-each select="$levels">
		<xsl:variable name="level" as="xs:string" select="." />
		<xsl:variable name="sameOrHigher" as="xs:string+" select="$levels[position() >= index-of($levels, $level)]" />
		<xsl:variable name="options" as="element(option)*" select="$options[$level = 'basic' or requirement/@level = $sameOrHigher]" />
		<xsl:text>if (</xsl:text>
		<xsl:for-each select="$options">
			<xsl:value-of select="concat($model, '.', $id, '() !== ''', @value, '''')" />
			<xsl:if test="position() != last()"> &amp;&amp; </xsl:if>
		</xsl:for-each>) unmetRequirements['<xsl:value-of select="$level" />']++;
	</xsl:for-each>
</xsl:template>

<xsl:template match="requirement" mode="unmetRequirements">
	<xsl:param name="model" as="xs:string" select="'certificate'" tunnel="yes" />
	<xsl:variable name="level" as="xs:string" select="if (@level) then @level else 'basic'" />
	<xsl:choose>
		<xsl:when test="@test">if (!(<xsl:value-of select="concat($model, '.', @test)" />))</xsl:when>
		<xsl:otherwise>if (<xsl:value-of select="concat($model, '.', ancestor::question/@id, '() === ''''')" />)</xsl:otherwise>
	</xsl:choose> unmetRequirements['<xsl:value-of select="$level" />']++; 
</xsl:template>

<xsl:template match="repeat" mode="unmetRequirements">
	<xsl:param name="model" as="xs:string" select="'certificate'" tunnel="yes" />
	<xsl:value-of select="concat('$(', $model, '.', @id, '()).each(function () {')" />
	<xsl:value-of select="concat('var ', @id, ' = this;')" />
	<xsl:apply-templates mode="unmetRequirements">
		<xsl:with-param name="model" select="@id" tunnel="yes" />
	</xsl:apply-templates>
	<xsl:text>});</xsl:text>
</xsl:template>

<xsl:template match="repeat" mode="requirementList">
	<xsl:param name="level" as="xs:string" tunnel="yes" required="yes" />
	<xsl:if test=".//requirement/@level = $level">
		<div data-bind="foreach: {@id}">
			<xsl:apply-templates mode="requirementList" />
		</div>
	</xsl:if>
</xsl:template>

<xsl:template match="if" mode="requirementList">
	<xsl:param name="level" as="xs:string" tunnel="yes" required="yes" />
	<xsl:if test=".//requirement/@level = $level">
		<div data-bind="visible: {@test}">
			<xsl:apply-templates mode="requirementList" />
		</div>
	</xsl:if>
</xsl:template>

<xsl:template match="radioset[option/requirement/@level]" mode="requirementList">
	<xsl:param name="level" as="xs:string" tunnel="yes" required="yes" />
	<xsl:variable name="levels" as="xs:string+" select="('bronze', 'silver', 'gold')" />
	<xsl:variable name="levelOrAbove" as="xs:string+" select="$levels[position() >= index-of($levels, $level)]" />
	<xsl:variable name="options" as="element(option)*" select="option[requirement/@level = $levelOrAbove]" />
	<xsl:if test="$options">
		<div>
			<xsl:attribute name="data-bind">
				<xsl:text>visible: </xsl:text>
				<xsl:for-each select="$options">
					<xsl:value-of select="ancestor::question/@id" />() !== '<xsl:value-of select="@value" /><xsl:text>'</xsl:text>
					<xsl:if test="position() != last()"> &amp;&amp; </xsl:if>
				</xsl:for-each>
			</xsl:attribute>
			<xsl:for-each select="$options/requirement[@level = $level]">
				<p>
					<a href="#{ancestor::question/@id}">
						<span class="label label-{@level}"><i class="icon-star icon-white"></i> <xsl:value-of select="concat(upper-case(substring(@level, 1, 1)), substring(@level, 2))" /></span>
					</a>
					<xsl:text> </xsl:text>
					<xsl:apply-templates />
				</p>
			</xsl:for-each>
		</div>
	</xsl:if>
</xsl:template>

<xsl:template match="requirement" mode="requirementList">
	<xsl:param name="level" as="xs:string" tunnel="yes" required="yes" />
	<xsl:if test="@level = $level">
		<div>
			<xsl:attribute name="data-bind">
				<xsl:text>visible: </xsl:text>
				<xsl:choose>
					<xsl:when test="@test">!(<xsl:value-of select="@test" />)</xsl:when>
					<xsl:otherwise><xsl:value-of select="ancestor::question/@id" />() === ''</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<p>
				<a href="#{ancestor::question/@id}">
					<span class="label label-{@level}"><i class="icon-star icon-white"></i> <xsl:value-of select="concat(upper-case(substring(@level, 1, 1)), substring(@level, 2))" /></span>
				</a>
				<xsl:text> </xsl:text>
				<xsl:apply-templates />
			</p>
		</div>
	</xsl:if>
</xsl:template>

<xsl:template match="node()|@*" mode="#all">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()" mode="#current" />
	</xsl:copy>
</xsl:template>

<xsl:template match="processing-instruction('xml-stylesheet')" />
<xsl:template match="comment()" priority="1" />
	
</xsl:stylesheet>