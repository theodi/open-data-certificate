# How to apply translations

1. With a Translation file in the format of `example-translation.xlsx`, copy the
first and third columns of the first worksheet  (The reference and the translation),
and separate them by a colon and a space `: ` and save in `temp`

2. Change the source in line 10 to point to your newly-created text file, then run
the following:

    saxon -s:prototype/jurisdictions/certificate.{country code}.xml -xsl:prototype/auto-translate.xsl -o:prototype/temp/certificate.{country code}.xml

3. Verify that the translation has worked, and then move the resulting file to
the `jurisdictions` directory

4. Repeat step 1 with the second worksheet

5. Run the following:

    saxon -s:prototype/translations/certificate.en.xml -xsl:prototype/auto-translate.xsl -o:prototype/temp/certificate.{language code}.xml

6. Verify that the translation has worked, and then move the resulting file to
the `translations` directory

7. Finally, run:

    saxon -s:prototype/jurisdictions/ -xsl:prototype/surveyor.xsl -o:prototype/temp/
