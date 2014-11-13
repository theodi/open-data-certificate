Dataset/Certificate search
==========================

The browse page can filter by various fields and return results in either [HTML][html], [Atom][atom] or [JSON][json].

[html]: https://certificates.theodi.org/datasets
[atom]: https://certificates.theodi.org/datasets.feed
[json]: https://certificates.theodi.org/datasets.json

Search parameters
-----------------

# jurisdiction

The `jurisdiction` is the set of questions that have been asked to determine the certificate. The value is a
[2 letter country code][iso3166] e.g `us` or `kr`.

Note the value for The United Kingdom is `gb` not `uk`.

[iso3166]: http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2

# publisher

The `publisher` is the name of the agency or department that has produced the dataset and is the an exact string match.
e.g. `Torbay Council`

# level

Limits by the certificates attained level, possible values are `basic`, `pilot`, `standard` and `exemplar`

# datahub

Filters the results by where the dataset is hosted. It is the domain name of the datahub e.g. `data.gov.uk`

# since

Limits the search results to certificates where the responses have been updated more recently than the specified date.

The value is expected to be in the format of an [ISO8601 datetime][time] such as `2014-10-28T10:30:00Z`
but can also be just a date such as `2014-10-28` which will default to the beginning of that day.

The date can also be an approximate date such as `2014` or `2014-10` in which case it will default to the 1st of
the day or the first of January if just the year is specified.

[time]: http://en.wikipedia.org/wiki/ISO_8601

# search

This runs a partial text search which matches any of the title of the certificate, the publishers name or
the full title of the jurisdiction (which will be the name of the country).
