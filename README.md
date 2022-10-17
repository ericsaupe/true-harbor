# True Harbor

True Harbor is a tool to help Foster Agencies place children in foster homes.

## Development

- `bin/setup` to install dependencies
- `rails generate_data # optional` to generate sample data
- `bin/dev` to start the server

### Subdomains

- True Harbor is multitenant and uses the subdomain to switch between organizations. By default, `www` is used purely for marketing and landing page purposes while all other subdomains should be considered organizations. The generated sample data will create a `demo` subdomain that can be used for logging in.

## Testing

- `bin/test` to run the test suite

