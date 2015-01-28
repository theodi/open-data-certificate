# How to apply translations

## Use rake task [experimental]

Make sure `saxon` is installed

    brew install saxon

and this should update translations

    bundle exec rake translations:update TRANSLATIONS=translations.xlsx COUNTRY={country code eg. CZ} LANG={lang code eg. cz}

## Or manually run the commands

1. With a Translation file in the format of `example-translation.xlsx`, copy the
first and third columns of the first worksheet  (The reference and the translation),
and separate them by a colon and a space `: ` and save in `temp`

    # note path to {sheet1 filename} is relative to the location of auto-translate.xsl
    # {country code} is in capitals, eg. MX, CZ
    saxon -s:prototype/jurisdictions/certificate.{country code}.xml -xsl:prototype/auto-translate.xsl -o:prototype/temp/certificate.{country code}.xml translationFile=temp/{sheet1 filename}

2. Verify that the translation has worked, and then move the resulting file to
the `jurisdictions` directory

3. Repeat step 1 with the second worksheet

4. Run the following:

    # note {language code} is lower case, eg. en, cz
    saxon -s:prototype/translations/certificate.en.xml -xsl:prototype/auto-translate.xsl -o:prototype/temp/certificate.{language code}.xml translationFile=temp/{sheet2 filename}

5. Verify that the translation has worked, and then move the resulting file to
the `translations` directory

6. Finally, run:

    saxon -s:prototype/jurisdictions/ -xsl:prototype/surveyor.xsl -o:prototype/temp/
