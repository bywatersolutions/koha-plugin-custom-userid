# koha-plugin-custom-userid

This plugin will allow users to generate a custom userid using template toolkit when registering a new patron

The plugin uses a new custom notice, USERID_TEMPLATE, that will be created on the initial install. When saving the patron this template will be applied and is passed
a patron object built from the form data. There will not be a borrowernumber defined as the patron has not been saved yet, but other fields from the borrower record should be available.

Care should be taken to ensure the defined template will generate unique user ids, otherwise saving the patron will fail unless a unique value is provided in the form to prevent auto-generation.

The 'Configure' button will redirect to the edit page for the necessary template.
