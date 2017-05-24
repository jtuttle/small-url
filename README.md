# Small URL - A URL shortener.

Small URL is a standalone API-only Rails app that can be used to generate and visit shortened URLs. Each small URL is generated by converting its database row ID of the URL to a base-30 alphabet that includes the numbers 0-9 and lower-case letters with vowels removed (to prevent accidental profanity). See the Apipie docs for further usage information.

## Features

* Verifies that the provided long URL returns a non-404 response.

* Maintains a visit count for each URL.

* Ability to permanently disable small URLs to prevent further visits.

* Optionally specify a UUID to associate a URL with an owner.

* Salts and encrypts original URLs before inserting into the database for enhanced user privacy.

* Apipie documentation and parameter validation.