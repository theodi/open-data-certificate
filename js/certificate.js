/*
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
  */
$(document).ready(function() {
	var updateCertificateHTML = function () {
		var certificateHTML =
			'<!DOCTYPE html>' +
			'<html>' +
			'<head>' +
			'<title>ODI Open Data Certificate</title>' +
			'<link href="' + document.location + '/../css/bootstrap.css" rel="stylesheet" media="screen" />' +
			'<link href="' + document.location + '/../css/certificate.css" rel="stylesheet" media="screen" />' +
			'</head>' + 
			'<body>' +
			'<div class="container">' +
			$('#certificate').html() +
			'</div>' +
			'</body>' +
			'</html>';
		$('#download-certificate').attr('href', 'data:text/html;charset=UTF-8,' + encodeURIComponent(certificateHTML));
	;

	$('input, select, textarea')
		.change(function () {
			var $field = $(this)
			,   $group = $field.parents('.control-group')
			,   val = $field.val()
			,   id = $field.attr('name')
			,   placeholderSelector = '.placeholder[data-field=' + id + ']'
			,   conditionalSelector = '.conditional[data-field=' + id + ']'
			,   $conditionals = $(conditionalSelector)
			;
			val = (val === undefined || val === null) ? '' : val.replace(/^\s+|\s+$/, '');
			// show error/success and update placeholders
			if (val === '') {
				$group.removeClass('success');
				if ($field.is('*[required]')) {
					$group.addClass('error');
				}
				$(placeholderSelector).each(function () {
					completePlaceholder($(this), val);
				});
			} else {
				$group
					.removeClass('error')
					.addClass('success');
				$(placeholderSelector).each(function () {
					completePlaceholder($(this), val);
				});
			}
			// fixing OGL for UK central government data unless it has OPSI exemption
			if ($field.attr('name') === 'publisher-opsi-exemption') {
				var $licenceFields = $('#content-licence, #data-licence')
				;
				if (val === 'false') {
					$licenceFields
						.find('option:selected')
							.removeAttr('selected')
						.end()
						.find('option[value=ogl]')
							.attr('selected', 'selected')
						.end()
						.attr('disabled', 'disabled')
						.parents('.control-group')
						.removeClass('error')
						.addClass('success');
				} else {
					$licenceFields
						.removeAttr('disabled');
				}
			}
			// update conditional sections
			$conditionals.each(function () {
				showHideConditional($(this), $field);
			});
			// update the certificate if it's not otherwise updated
			if ($conditionals.length === 0) {
				updateCertificateLevel();
			}
		});

		updateCertificateLevel();
})
