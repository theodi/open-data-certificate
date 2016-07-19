# API

Certificates can be created and updated using the JSON API.

The API methods are:

- GET `/jurisdictions` - This method provides a list of the available jurisdictions and associated information
- GET `/datasets/schema` - This method provides the list of questions, their types and possible choices. You must specify your jurisdiction by title with the `jurisdiction` GET parameter
- POST `/datasets` - This method allows you to create a new dataset, it will be automatically published if valid
- POST `/datasets/:id/certificates` - This method allows you to update a dataset, it will be automatically published if valid


## Authentication

Each user can access their API token from their account page. This token is required to authenticate with the API.
The request should authenticated with Basic HTTP Authentication, using the user's email address as the username and token as the password i.e. `john@example.com:ad54965ec45d78ab6f`.

## Questionnaire schema

The schema method returns a hash where each question is identified by its key in the hash. Each question also has one of
the following types: `string`, `radio`, `checkbox` and `repeating`. Radio and checkbox types will also have an options hash,
which specifies the allowed options, which should be identified by their key.

Questions which are required to publish the dataset will also have `required: true`.

An example:

    {"schema": {
        "dataTitle": {
            "question": "What's a good title for this data?",
            "type": "string",
            "required": true
        },
        "publisherRights": {
            "question": "Do you have the rights to publish the data as open data?",
            "type": "radio",
            "required": true,
            "options": {
                "yes": "yes, you have the right to publish the data as open data",
                "no": "no, you don't have the right to publish the data as open data",
                "unsure": "you don't know whether you have the right to publish the data as open data"
            }
        },
        "versionManagement": {
            "question": "How do you publish a series of the same dataset?",
            "type": "checkbox",
            "required": false,
            "options": {
                "url": "as a single URL",
                "consistent": "as consistent URLs for each release",
                "list": "as a list of releases"
            }
        },
        "administrators": {
            "question": "Who is responsible for administrating this data?",
            "type": "repeating",
            "required": false
        }
    }}

## Posting to a dataset

To create or update a dataset data should be sent in the format (using the above schema):

    {
        "jurisdiction": "GB",
        "dataset": {
            "dataTitle": "My open data",
            "publisherRights": "unsure",
            "versionManagement": ["url", "list"],
            "administrators": ["John Smith"]
        }
    }


- Checkbox and radio fields should use the option key from the schema
- Checkbox and repeating fields should be sent as an array

The request should contain a Content-Type header with the value `application/json`.

If your request has a `documentationUrl`, the system will attempt to use
that dataset's metadata (for example: if it is hosted in a [CKAN](http://ckan.org/)
repository or marked up with [DCAT](http://theodi.org/guides/marking-up-your-dataset-with-dcat))
to autocomplete as many questions as possible.

You will then get a response in this format:

    {
      "success": "pending",
      "dataset_id": 123,
      "dataset_url": "http://certificates.theodi.org/datasets/123.json"
    }

You can then make a request to the `dataset_url` to get the final response.
There may be a delay before your dataset is created, so if you get a `success`
state of `pending`, please try again in a few seconds.