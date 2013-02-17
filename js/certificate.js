$(document).ready(function() {
	var
		conditionSatisfied = function ($conditional, $field) {
			var 
				val = $field.is(':radio') ? $field.filter(':checked').val() : $field.val(),
				equals = $conditional.attr('data-if-equals'),
				notEquals = $conditional.attr('data-not-equals');
			val = (val === undefined || val === null) ? '' : val.replace(/^\s+|\s+$/, '');
			if (equals !== undefined) {
				return val === equals;
			} else if (notEquals !== undefined) {
				return val !== notEquals;
			}
		}

	, showHideConditional = function ($conditional, $field) {
			if (conditionSatisfied($conditional, $field)) {
				$conditional.slideDown({complete: updateCertificateLevel});
			} else {
				$conditional.slideUp({complete: updateCertificateLevel});
			}
		}

	, completePlaceholder = function ($placeholder, val) {
			if (val === '' || val === undefined || val === null) {
				$placeholder.text($placeholder.attr('data-placeholder'));
			} else {
				if ($placeholder.hasClass('placeholder-url')) {
					var 
						url = /^https?:\/\//.test(val) ? val : 'http://' + val;
						val = val.replace(/^https?:\/\//, '');
					$placeholder.html('<a href="' + url + '">' + val + '</a>');
				} else {
					$placeholder.text(val);
				}
			}
		}

	, updateCertificateLevel = function () {
			var level = 'gold'
			,   capitalised
			,   certificateHTML
			,   improvements = {
			    	'basic': '',
			    	'bronze': '',
			    	'silver': ''
					}
			;
			console.log('updating certificate level');
			if ($('.control-group.error, .requirement:not([data-level])').is(':visible')) {
				$('#certificate-container').hide();
				$('#improvements').hide();
			} else {
				$('#certificate-container').show();
				$('.requirement[data-level]:visible')
					.each(function () {
						var $requirement = $(this)
						,   $field = $('*[name=' + $requirement.attr('data-field') + ']')
						,   requirementLevel = $requirement.attr('data-level')
						,   improvement = '<li>' + $requirement.find('p').html() + '</li>'
						;
						if (conditionSatisfied($requirement, $field)) {
							if (level === 'gold') {
								level = requirementLevel !== 'gold' ? requirementLevel : level;
							} else if (level === 'silver') {
								level = requirementLevel === 'bronze' || requirementLevel === 'basic' ? requirementLevel : level;
							} else if (level === 'bronze') {
								level = requirementLevel === 'basic' ? requirementLevel : level;
							}
							improvements[requirementLevel] += improvement;
						}
					});
				capitalised = level === 'basic' ? '' : level.charAt(0).toUpperCase() + level.slice(1) + ' Star';
				$('.placeholder[data-field=certificate-level]').text(capitalised);
				certificateHTML =
					'<!DOCTYPE html>' +
					'<html>' +
					'<head>' +
					'<title>ODI Open Data Certificate</title>' +
					'<link href="' + document.location + '/../css/bootstrap.min.css" rel="stylesheet" media="screen" />' +
    			'<link href="' + document.location + '/../css/certificate.css" rel="stylesheet" media="screen" />' +
					'</head>' + 
					'<body>' +
					'<div class="container">' +
					$('#certificate').html() +
					'</div>' +
					'</body>' +
					'</html>';
				$('#download-certificate').attr('href', 'data:text/html;charset=UTF-8,' + encodeURIComponent(certificateHTML));
				if (improvements['basic'] !== '' || improvements['bronze'] !== '' || improvements['silver'] !== '') {
					$('#improvements').show();
					$('#improvements-bronze').html(improvements['basic']);
					$('#improvements-silver').html(improvements['bronze']);
					$('#improvements-gold').html(improvements['silver']);
				} else {
					$('#improvements').hide();
				}
			}
		}
	;

	$('.conditional')
		.each(function () {
			var $conditional = $(this)
			,   id = $conditional.attr('data-field')
			,   $field = $('*[name=' + id + ']')
			;
			showHideConditional($conditional, $field);
		});

	$('.placeholder')
		.each(function () {
			var $placeholder = $(this)
			,   id = $placeholder.attr('data-field')
			,   $field = $('*[name=' + id + ']')
			,   val = $field.val()
			;
			val = (val === undefined || val === null) ? '' : val.replace(/^\s+|\s+$/, '');
			completePlaceholder($placeholder, val);
		});

	$('.repeated')
		.each(function () {
			var $repeated = $(this)
			,   $controls = $repeated.next('.repeat-controls')
			;
			$controls
				.attr('data-count', 0)
				.find('.repeat-add')
					.click(function () {
						var count = parseInt($controls.attr('data-count')) + 1
						,   $clone = $repeated.clone()
						;
						$clone
							.find('*[id]')
								.each(function () {
									$(this).attr('id', $(this).attr('id').replace(/\d+$/, count));
								})
							.end()
							.find('*[data-target]')
								.each(function () {
									$(this).attr('data-target', $(this).attr('data-target').replace(/\d+$/, count));
								})
							.end()
							.find('*[name]')
								.each(function () {
									$(this).attr('name', $(this).attr('name').replace(/\d+$/, count));
								})
							.end()
							.find('*[for]')
								.each(function () {
									$(this).attr('for', $(this).attr('for').replace(/\d+$/, count));
								})
							.end();
						$controls.before($clone);
					});
		});

	$('.control-group')
		.each(function () {
			var $input = $(this).find('input, select, textarea')
			,   val = $input.val()
			;
			val = (val === undefined || val === null) ? '' : val.replace(/^\s+|\s+$/, '');
			if ($input.is(':radio')) {
				if ($input.is(':checked')) {
					$(this).addClass('success');
				} else {
					$(this).addClass('error');
				}
			} else if (val === '') {
				if ($input.is('*[required]')) {
					$(this).addClass('error');
				}
			} else {
				$(this).addClass('success');
			}
		});

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
