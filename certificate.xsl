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
	xmlns:local="#"
	exclude-result-prefixes="xs local">

<xsl:output method="html" doctype-public="XSLT-compat" encoding="UTF-8" indent="yes" />
	
<xsl:key name="fields" match="question" use="@id" />

<xsl:template match="questionnaire">
	<!-- bit of validation-->
	<xsl:for-each-group select="//question" group-by="@id">
		<xsl:if test="count(current-group()) > 1">
			<xsl:message terminate="yes">More than one question with the id "<xsl:value-of select="@id" />"</xsl:message>
		</xsl:if>
	</xsl:for-each-group>
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
	  							<li data-bind="css: {{ disabled: certificateLevel() === 'none' }}">
	  								<a href="#certificate">Certificate</a>
	  							</li>
	  							<li class="divider-vertical"></li>
	  							<li data-bind="css: {{ disabled: certificateLevel() === 'none' || certificateLevel() === '{levels/level[last()]/@id}' }}">
	  								<a href="#improvements">Improvements</a>
	  							</li>
	  							<li class="divider-vertical"></li>
	  							<li><a href="index.html">About</a></li>
	  						</ul>
	  						<span class="label pull-right" style="margin-top: 10px;"><xsl:value-of select="@version" /></span>
	  					</div>
	  				</div>
	  			</nav>
	  		</div>
	  	</header>
	  	<div class="container">
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
	  								<div class="span6">
	  									<p>Questions marked with a label must be answered to gain that level of the certificate.</p>
	  								</div>
	  								<div class="span6">
	  									<p>Click on question marks <i class="icon-question-sign"></i> or labels to find out more about what to enter.
	  									</p>
	  								</div>
	  							</div>
	  							<div class="row-fluid">
	  								<div class="span12 improvements">
  										<xsl:for-each select="levels/level">
  											<div class="improvement">
  												<span class="improvement-label">
  													<span class="label label-{if (position() = 1) then 'info' else @id}">
  														<i class="icon-star icon-white"></i>
  														<xsl:text> </xsl:text>
  														<xsl:value-of select="local:capitalise(@id)" />
  													</span>
  												</span>
  												<span class="improvement-desc"><xsl:value-of select="." /></span>
  											</div>
  										</xsl:for-each>
	  								</div>
	  							</div>
	  						</div>
	  					</div>
	  				</div>
	  			</div>
	  		</section>
	      <form id="questionnaire" class="form-horizontal">
	      	<section>
	      		<div class="page-header">
	      			<h2>Questionnaire</h2>
	      		</div>
	      		<xsl:apply-templates select="group[1]/preceding-sibling::* except levels" />
	      		<hr />
	      		<ul class="nav nav-tabs">
	      			<xsl:for-each select="group">
	      				<li>
	      					<xsl:if test="position() = 1"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
	      					<a href="#{@id}" data-toggle="tab">
	      						<xsl:value-of select="replace(label, ' Information$', '')" />
	      						<xsl:text> </xsl:text>
	      						<xsl:apply-templates select="/questionnaire/levels/level[1]" mode="statusIndicator">
	      							<xsl:with-param name="group" select="@id" tunnel="yes" />
	      						</xsl:apply-templates>
	      					</a>
	      				</li>
	      			</xsl:for-each>
	      		</ul>
	      		<div class="tab-content">
	      			<xsl:apply-templates select="group" />
	      		</div>
	      	</section>
	      </form>
	  		<section id="certificate-container" class="well" data-bind="visible: certificateLevel() !== 'none'">
  				<div id="certificate">
  					<h1><span class="placeholder" data-bind="text: certificateLevelLabel"></span> Open Data Certificate</h1>
  					<xsl:apply-templates select="certificate" />
  				</div>
  				<p>
  					<a id="download-certificate" data-bind="attr: {{ href: certificateHTML }}" target="_new" class="btn btn-primary">Download Certificate</a>
  				</p>
	  		</section>
	  		<section id="improvements" data-bind="visible: certificateLevel() !== '{levels/level[last()]/@id}'">
  				<div class="page-header">
  					<h1>Improving Your Open Data</h1>
  				</div>
  				<p class="lead">
  					You can improve the way you are publishing open data to make it more useful.
  				</p>
	  			<xsl:for-each select="levels/level[position() > 1]">
	  				<div id="improvements-{@id}" class="improvements">
	  					<xsl:apply-templates select="/questionnaire" mode="requirementList">
	  						<xsl:with-param name="level" select="@id" tunnel="yes" />
	  					</xsl:apply-templates>
	  				</div>
	  				<xsl:if test="position() != last()"><hr /></xsl:if>
	  			</xsl:for-each>
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
		  					<xsl:for-each select="levels/level">
		  						<xsl:value-of select="@id" />: 0,
		  					</xsl:for-each>
		  					}
		  				;
		  				<xsl:apply-templates mode="unmetRequirements" />
		  				if (unmetRequirements.<xsl:value-of select="levels/level[1]/@id" /> > 0) {
		  					return 'none';
		  				<xsl:for-each select="levels/level[position() > 1]">
		  				} else if (unmetRequirements.<xsl:value-of select="@id" /> > 0) {
		  					return '<xsl:value-of select="preceding-sibling::level[1]/@id" />';
		  				</xsl:for-each>
		  				} else {
		  					return '<xsl:value-of select="levels/level[last()]/@id" />';
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
		  			certificate.certificateHTML = ko.computed(function () {
		  				var location = document.location.toString().replace(/#.+$/, '') 
			  			, certificateHTML =
				  				'&lt;!DOCTYPE html>' +
					  			'&lt;html>' +
					  				'&lt;head>' +
					  					'&lt;title>ODI Open Data Certificate&lt;/title>' +
					  					'&lt;link href="' + location + '/../bootstrap/css/bootstrap.css" rel="stylesheet" media="screen" />' +
					  					'&lt;link href="' + location + '/../css/certificate.css" rel="stylesheet" media="screen" />' +
					  				'&lt;/head>' + 
					  				'&lt;body>' +
					  					'&lt;div class="container">' +
					  						$('#certificate').html() +
					  					'&lt;/div>' +
					  				'&lt;/body>' +
					  			'&lt;/html>'
	  					;
	  					return 'data:text/html;charset=UTF-8,' + encodeURIComponent(certificateHTML);
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

<xsl:template match="level" mode="statusIndicator">
	<xsl:param name="group" as="xs:string" required="yes" tunnel="yes" />
	<span class="badge badge-circular badge-{if (empty(preceding-sibling::level)) then 'important' else if (empty(preceding-sibling::level[2])) then 'info' else preceding-sibling::level[1]/@id}" 
		data-bind="visible: {$group}Status().{@id} > 0, text: {$group}Status().{@id}, attr: {{ title: 'You have ' + {$group}Status().{@id} + ' question' + ({$group}Status().{@id} > 1 ? 's' : '') + ' left to answer before you get to {@id} level' }}"></span>
	<xsl:choose>
		<xsl:when test="following-sibling::level">
			<span data-bind="visible: {$group}Status().{@id} === 0">
				<xsl:apply-templates select="following-sibling::level[1]" mode="statusIndicator" />
			</span>
		</xsl:when>
		<xsl:otherwise>
			<span class="badge badge-circular badge-{@id}" data-bind="visible: {$group}Status().{@id} === 0"
				title="You have reached {@id} level">
				<i class="icon icon-white icon-star"></i>
			</span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="questionnaire/group">
	<div class="tab-pane{if (preceding-sibling::group) then '' else ' active'}" id="{@id}">
		<xsl:apply-templates select="@jurisdiction" />
		<xsl:apply-templates select="label/following-sibling::*" />
		<ul class="pager">
			<li class="previous{if (not(preceding-sibling::group)) then ' disabled' else ''}">
				<a data-toggle="tab" href="#{preceding-sibling::group[1]/@id}">
					<xsl:text>&#x2190; Previous</xsl:text>
				</a>
			</li>
			<li class="next{if (not(following-sibling::group)) then ' disabled' else ''}">
				<a data-toggle="tab" href="#{following-sibling::group[1]/@id}">
					<xsl:text>Next &#x2192;</xsl:text>
				</a>
			</li>
		</ul>
	</div>
</xsl:template>

<xsl:template match="group//group">
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
		<xsl:text> if you want to use the certificate in other countries.</xsl:text>
	</p>
</xsl:template>

<xsl:template match="question">
	<div class="control-group">
		<label class="control-label">
			<xsl:if test="not(yesno or radioset or checkboxset)">
				<xsl:choose>
					<xsl:when test="ancestor::repeat">
						<xsl:attribute name="data-bind">attr: { for: '<xsl:value-of select="@id" />-' + $index() }</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="for" select="@id" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="*/@required">
				<span class="badge badge-circular badge-{if (*/@required = 'required') then 'important' else */@required} pull-left" data-bind="visible: {@id}Status() === '{*/@required}'">
					<i class="icon icon-white icon-remove" title="Required{if (*/@required != 'required') then concat(' for ', */@required, ' certificate') else ''}"></i>
				</span>
			</xsl:if>
			<span class="badge badge-circular badge-success pull-left" data-bind="visible: {@id}Status() === 'complete'">
				<i class="icon icon-white icon-ok" title="Complete"></i>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="label" />
		</label>
		<div class="controls">
			<xsl:apply-templates select="help" mode="label">
				<xsl:with-param name="id" select="@id" tunnel="yes" />
			</xsl:apply-templates>
			<xsl:apply-templates select="label/following-sibling::*[1]">
				<xsl:with-param name="id" select="@id" tunnel="yes" />
			</xsl:apply-templates>
			<xsl:apply-templates select="requirement, if[.//requirement]" mode="label">
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
		<xsl:sequence select="@type, @placeholder, @required[. = 'required']" />
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

<xsl:template match="radioset | checkboxset">
	<xsl:apply-templates select="option" />
</xsl:template>

<xsl:template match="radioset/option">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<xsl:apply-templates select="help" mode="label">
		<xsl:with-param name="id" select="concat($id, @value)" tunnel="yes" />
	</xsl:apply-templates>
	<label class="radio">
		<input type="radio">
			<xsl:apply-templates select=".." mode="dataBind" />
			<xsl:sequence select="@value" />
			<xsl:apply-templates select="label/node()" />
		</input>
		<xsl:apply-templates select="requirement" mode="label">
			<xsl:with-param name="id" select="concat($id, @value)" tunnel="yes" />
		</xsl:apply-templates>
		<xsl:apply-templates select="* except label">
			<xsl:with-param name="id" select="concat($id, @value)" tunnel="yes" />
		</xsl:apply-templates>
	</label>
</xsl:template>

<xsl:template match="checkboxset/option">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<xsl:apply-templates select="help" mode="label">
		<xsl:with-param name="id" select="concat($id, @value)" tunnel="yes" />
	</xsl:apply-templates>
	<label class="checkbox">
		<input type="checkbox">
			<xsl:apply-templates select=".." mode="dataBind">
				<xsl:with-param name="id" select="concat($id, local:capitalise(@value))" tunnel="yes" />
			</xsl:apply-templates>
			<xsl:sequence select="@value" />
			<xsl:apply-templates select="label/node()" />
		</input>
		<xsl:apply-templates select="requirement" mode="label">
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
		<xsl:apply-templates select="@required[. = 'required'], @multiple" />
		<xsl:apply-templates />
	</select>
</xsl:template>

<xsl:template match="*" mode="dataBind" priority="10">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<xsl:variable name="valueType" as="xs:string" select="if (self::yesno or self::radioset or self::checkboxset) then 'checked' else 'value'" />
	<xsl:variable name="bind">
		<xsl:value-of select="$valueType" />: <xsl:value-of select="$id" />
		<xsl:if test="$valueType = 'value'">
			<xsl:text>, valueUpdate: 'afterkeydown'</xsl:text>
		</xsl:if>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="ancestor::repeat">
			<xsl:attribute name="data-bind"><xsl:value-of select="$bind" />, attr: {<xsl:if test="not(self::yesno or self::radioset or self::checkboxset)"> id: '<xsl:value-of select="$id" />-' + $index(),</xsl:if> name: '<xsl:value-of select="$id" />-' + $index() }</xsl:attribute>
		</xsl:when>
		<xsl:otherwise>
			<xsl:if test="not(self::yesno or self::radioset or self::checkboxset)">
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
	<button type="button" class="btn btn-link btn-{if (parent::option) then 'option-' else ''}help" data-toggle="collapse">
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
		<xsl:value-of select="local:capitalise(@level)" />
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
		<xsl:if test="@more">
			<a class="pull-right" href="{@more}" target="_new">Read more...</a>
		</xsl:if>
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
				<span class="label label-{@level}"><i class="icon-star icon-white"></i> <xsl:value-of select="local:capitalise(@level)" /></span>
			</a>
			<xsl:text> </xsl:text>
			<xsl:apply-templates />
		</p>
	</div>
</xsl:template>

<xsl:template match="requirement[not(@level)]">
	<xsl:param name="id" as="xs:string" tunnel="yes" />
	<div class="conditional" data-bind="visible: !({if (@test) then local:knockoutTest(@test) else if (ancestor::question/yesno) then concat($id, '() === ''true''') else concat($id, 'Status() === ''complete''')})">
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
	<span class="conditional" data-bind="visible: {local:knockoutTest(@test)}">
		<xsl:apply-templates />
	</span>
</xsl:template>

<xsl:template match="if" mode="label">
	<span class="conditional" data-bind="visible: {local:knockoutTest(@test)}">
		<xsl:apply-templates mode="label" />
	</span>
</xsl:template>

<xsl:template match="if">
	<div class="conditional" data-bind="visible: {local:knockoutTest(@test)}">
		<xsl:apply-templates />
	</div>
</xsl:template>

<xsl:template match="placeholder">
	<xsl:variable name="field" as="element(question)?" select="key('fields', @ref)" />
	<span class="placeholder" data-bind="text: {@ref}{if ($field/input/@type = 'url') then concat('attr: { href: ', @ref, ' }') else ''}" data-placeholder="{.}">
		<xsl:apply-templates />
	</span>
</xsl:template>

<xsl:template match="node()" mode="viewModel unmetRequirements statusCalculation requirementList" priority="-0.1">
	<xsl:apply-templates mode="#current" />
</xsl:template>
<xsl:template match="text()" mode="viewModel unmetRequirements statusCalculation requirementList" />

<xsl:template match="questionnaire/group" mode="viewModel">
	<xsl:param name="model" as="xs:string" select="'certificate'" tunnel="yes" />
	<xsl:apply-templates mode="viewModel" />
	<xsl:value-of select="concat($model, '.', @id, 'Status = ko.computed(function () {&#xA;')" />
	<xsl:text>  var unmetRequirements = { answered: 0, </xsl:text>
	<xsl:for-each select="../levels/level">
		<xsl:value-of select="@id" />: 0<xsl:if test="position() != last()">, </xsl:if>
	</xsl:for-each>
	<xsl:text> }&#xA;</xsl:text>
	<xsl:text>  ;&#xA;</xsl:text>
	<xsl:apply-templates mode="unmetRequirements" />
	<xsl:text>  return unmetRequirements;&#xA;</xsl:text>
	<xsl:text>});&#xA;</xsl:text>
</xsl:template>

<xsl:template match="question" mode="viewModel">
	<xsl:param name="model" as="xs:string" select="'certificate'" tunnel="yes" />
	<xsl:variable name="function" as="xs:string" select="concat($model, '.', @id)" />
	<xsl:value-of select="concat($function, ' = ko.observable('''');&#xA;')" />
	<xsl:value-of select="concat($function, 'Status = ko.computed(function () {&#xA;')" />
	<xsl:text>  var status;&#xA;</xsl:text>
	<xsl:choose>
		<xsl:when test="*/@required">
			<xsl:value-of select="concat('  if (', $function, '() === '''') status = ''', */@required, ''';&#xA;')" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="concat('  if (', $function, '() === '''') status = ''optional'';&#xA;')" />
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>  else status = 'complete';&#xA;</xsl:text>
	<xsl:text>  return status;&#xA;</xsl:text>
	<xsl:text>});&#xA;</xsl:text>
</xsl:template>

<xsl:template match="question[checkboxset]" mode="viewModel">
	<xsl:param name="model" as="xs:string" select="'certificate'" tunnel="yes" />
	<xsl:variable name="function" as="xs:string" select="concat($model, '.', @id)" />
	<xsl:for-each select="checkboxset/option">
		<xsl:value-of select="concat($function, local:capitalise(@value), ' = ko.observable(false);&#xA;')" />
	</xsl:for-each>
	<xsl:value-of select="concat($function, ' = ko.computed(function () {&#xA;')" />
	<xsl:text>  return {</xsl:text>
	<xsl:for-each select="checkboxset/option">
		<xsl:value-of select="concat('    ', @value, ': ', $function, local:capitalise(@value), '()')" />
		<xsl:if test="position() != last()">,</xsl:if>
		<xsl:text>&#xA;</xsl:text>
	</xsl:for-each>
	<xsl:text>  };&#xA;</xsl:text>
	<xsl:text>  return value;&#xA;</xsl:text>
	<xsl:text>});&#xA;</xsl:text>
	<xsl:value-of select="concat($function, 'Status = ko.computed(function () {&#xA;')" />
	<xsl:text>  var status;&#xA;</xsl:text>
	<xsl:for-each select="checkboxset/option">
		<xsl:if test="position() > 1">else </xsl:if>
		<xsl:text>if (</xsl:text>
		<xsl:value-of select="concat($function, local:capitalise(@value), '()')" />
		<xsl:text>) status = 'complete';&#xA;</xsl:text>
	</xsl:for-each>
	<xsl:text>  else status = '</xsl:text>
	<xsl:choose>
		<xsl:when test="checkboxset/@required"><xsl:value-of select="checkboxset/@required" /></xsl:when>
		<xsl:otherwise>optional</xsl:otherwise>
	</xsl:choose>
	<xsl:text>';&#xA;</xsl:text>
	<xsl:text>  return status;&#xA;</xsl:text>
	<xsl:text>});&#xA;</xsl:text>
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

<xsl:template match="question" mode="unmetRequirements">
	<xsl:param name="model" as="xs:string" select="'certificate'" tunnel="yes" />
	if (<xsl:value-of select="concat($model, '.', @id, 'Status() === ''complete''')" />) unmetRequirements['answered']++;
	else if (<xsl:value-of select="concat($model, '.', @id, 'Status() === ''required''')" />) unmetRequirements['basic']++;
	else if (<xsl:value-of select="concat($model, '.', @id, 'Status() !== ''optional''')" />) unmetRequirements[<xsl:value-of select="concat($model, '.', @id, 'Status()')" />]++;
	<xsl:apply-templates mode="unmetRequirements" />
</xsl:template>

<xsl:template match="if" mode="unmetRequirements">
	<xsl:param name="model" as="xs:string" select="'certificate'" tunnel="yes" />
	if (<xsl:value-of select="local:jsTest(@test, $model)" />) {&#xA;<xsl:apply-templates mode="#current" />&#xA;}
</xsl:template>

<xsl:template match="radioset[option/requirement]" mode="unmetRequirements">
	<xsl:param name="model" as="xs:string" select="'certificate'" tunnel="yes" />
	<xsl:variable name="id" as="xs:string" select="../@id" />
	<xsl:variable name="options" as="element(option)+" select="option" />
	<xsl:variable name="levels" as="xs:string+" select="/questionnaire/levels/level/@id" />
	<xsl:for-each select="$levels">
		<xsl:variable name="level" as="xs:string" select="." />
		<xsl:variable name="sameOrHigher" as="xs:string+" select="$levels[position() >= index-of($levels, $level)]" />
		<xsl:variable name="options" as="element(option)*" select="$options[$level = 'basic' or requirement/@level = $sameOrHigher]" />
		<xsl:if test="$level = 'basic' or exists($options)">
			<xsl:text>if (</xsl:text>
			<xsl:if test="$level = 'basic'">
				<xsl:value-of select="concat($model, '.', $id, '() !== '''' &amp;&amp; ')" />
			</xsl:if>
			<xsl:for-each select="$options">
				<xsl:value-of select="concat($model, '.', $id, '() !== ''', @value, '''')" />
				<xsl:if test="position() != last()"> &amp;&amp; </xsl:if>
			</xsl:for-each>) unmetRequirements['<xsl:value-of select="$level" />']++;
		</xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template match="requirement" mode="unmetRequirements">
	<xsl:param name="model" as="xs:string" select="'certificate'" tunnel="yes" />
	<xsl:variable name="level" as="xs:string" select="if (@level) then @level else 'basic'" />
	<xsl:choose>
		<xsl:when test="@test">if (!(<xsl:value-of select="local:jsTest(@test, $model)" />))</xsl:when>
		<xsl:when test="ancestor::question/yesno">if (<xsl:value-of select="concat($model, '.', ancestor::question/@id, '() !== ''true''')" />)</xsl:when>
		<xsl:otherwise>if (<xsl:value-of select="concat($model, '.', ancestor::question/@id, 'Status() !== ''complete''')" />)</xsl:otherwise>
	</xsl:choose> unmetRequirements['<xsl:value-of select="$level" />']++; 
</xsl:template>

<xsl:template match="checkboxset/option/requirement" mode="unmetRequirements">
	<xsl:param name="model" as="xs:string" select="'certificate'" tunnel="yes" />
	<xsl:variable name="id" as="xs:string" select="ancestor::question/@id" />
	<xsl:variable name="level" as="xs:string" select="if (@level) then @level else 'basic'" />
	<xsl:text>if (!</xsl:text>
	<xsl:value-of select="concat($model, '.', $id, local:capitalise(../@value), '()')" />) unmetRequirements['<xsl:value-of select="$level" />']++; 
</xsl:template>

<xsl:template match="repeat" mode="unmetRequirements">
	<xsl:param name="model" as="xs:string" select="'certificate'" tunnel="yes" />
	<xsl:value-of select="concat('$(', $model, '.', @id, '()).each(function () {')" />
	<xsl:value-of select="concat('var ', @id, ' = this;')" />
	<xsl:apply-templates mode="#current">
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
		<div data-bind="visible: {local:knockoutTest(@test)}">
			<xsl:apply-templates mode="requirementList" />
		</div>
	</xsl:if>
</xsl:template>

<xsl:template match="radioset[option/requirement/@level]" mode="requirementList">
	<xsl:param name="level" as="xs:string" tunnel="yes" required="yes" />
	<xsl:variable name="levels" as="xs:string+" select="/questionnaire/levels/level/@id" />
	<xsl:variable name="levelOrAbove" as="xs:string*" select="$levels[position() >= index-of($levels, $level)]" />
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
				<p class="improvement">
					<a class="improvement-label" href="#{ancestor::question/@id}" data-toggle="tab" data-target="#{ancestor::group[last()]/@id}">
						<span class="label label-{@level}"><i class="icon-star icon-white"></i> <xsl:value-of select="local:capitalise(@level)" /></span>
					</a>
					<span class="improvement-desc">
						<xsl:apply-templates />
					</span>
				</p>
			</xsl:for-each>
		</div>
	</xsl:if>
</xsl:template>

<xsl:template match="requirement" mode="requirementList">
	<xsl:param name="level" as="xs:string" tunnel="yes" required="yes" />
	<xsl:if test="@level = $level">
		<p class="improvement">
			<xsl:attribute name="data-bind">
				<xsl:text>visible: </xsl:text>
				<xsl:choose>
					<xsl:when test="@test">!(<xsl:value-of select="local:knockoutTest(@test)" />)</xsl:when>
					<xsl:otherwise><xsl:value-of select="ancestor::question/@id" />() === ''</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<a class="improvement-label" href="#{ancestor::question/@id}" data-toggle="tab" data-target="#{ancestor::group[last()]/@id}">
				<span class="label label-{@level}"><i class="icon-star icon-white"></i> <xsl:value-of select="local:capitalise(@level)" /></span>
			</a>
			<span class="improvement-desc">
				<xsl:apply-templates />
			</span>
		</p>
	</xsl:if>
</xsl:template>

<xsl:template match="checkboxset/option/requirement" mode="requirementList">
	<xsl:param name="level" as="xs:string" tunnel="yes" required="yes" />
	<xsl:if test="@level = $level">
		<p class="improvement">
			<xsl:attribute name="data-bind">
				<xsl:text>visible: </xsl:text>
				<xsl:value-of select="concat('!', ancestor::question/@id, local:capitalise(../@value), '()')" />
			</xsl:attribute>
			<a class="improvement-label" href="#{ancestor::question/@id}">
				<span class="label label-{@level}"><i class="icon-star icon-white"></i> <xsl:value-of select="local:capitalise(@level)" /></span>
			</a>
			<span class="improvement-desc">
				<xsl:apply-templates />
			</span>
		</p>
	</xsl:if>
</xsl:template>

<xsl:template match="node()|@*" mode="#all">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()" mode="#current" />
	</xsl:copy>
</xsl:template>

<xsl:template match="processing-instruction('xml-stylesheet')" />
<xsl:template match="comment()" priority="1" />
	
<xsl:function name="local:capitalise" as="xs:string">
	<xsl:param name="string" as="xs:string" />
	<xsl:sequence select="concat(upper-case(substring($string, 1, 1)), substring($string, 2))" />
</xsl:function>

<xsl:function name="local:knockoutTest" as="xs:string">
	<xsl:param name="string" as="xs:string" />
	<xsl:sequence select="replace($string, 'this\.', '')" />
</xsl:function>

<xsl:function name="local:jsTest" as="xs:string">
	<xsl:param name="string" as="xs:string" />
	<xsl:param name="model" as="xs:string" />
	<xsl:sequence select="replace($string, 'this\.', concat($model, '.'))" />
</xsl:function>
	
</xsl:stylesheet>