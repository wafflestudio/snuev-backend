# SNUEV Backend

[![Build Status](https://travis-ci.org/wafflestudio/snuev-backend.svg)](https://travis-ci.org/wafflestudio/snuev-backend)
[![Maintainability](https://api.codeclimate.com/v1/badges/0c22afff95fb49719426/maintainability)](https://codeclimate.com/github/wafflestudio/snuev-backend/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/0c22afff95fb49719426/test_coverage)](https://codeclimate.com/github/wafflestudio/snuev-backend/test_coverage)

This codebase is backend service powers SNUEV, a course evaluation system for SNU students.

If you have questions about the service, please contact via [master@wafflestudio.com](mailto:master@wafflestudio.com).

We are currently not open to contribution, but will prepare contribution guide soon.

## Getting Started

### Running locally

To be updated.

### Running locally using docker compose

After cloning the codebase,

```bash
  touch .env
  docker-compose build
  docker-compose run app rake db:create db:migrate
  docker-compose up
```

And the server will be running at http://localhost:3001.

### Configuring environment variables

| Environment Variable  |                                           |
|:----------------------|:------------------------------------------|
| DATABASE_URL          | -                                         |
| HTTP_HOST             | Application host. Mostly used by mailers. |
| SECRET_KEY_BASE       | -                                         |
| SMTP_ADDRESS          | Default: `smtp.gmail.com`                 |
| SMTP_DOMAIN           | -                                         |
| SMTP_PORT             | Default: `587`                            |
| SMTP_USER_NAME        | -                                         |
| SMTP_PASSWORD         | -                                         |
| WEB_BASE              | Base url of web client.                   |
| NEW_RELIC_LICENSE_KEY | New Relic license key.                    |

## Running spec

```bash
  docker-compose -f docker-compose.test.yml run test rails db:create db:migrate # initial setup
  docker-compose -f docker-compose.test.yml run test
```

## Running spec using guard

You can run rspec using guard to automatically run spec when codebase changes.

```bash
  docker-compose -f docker-compose.test.yml run test guard -c
```

## Contributing

Sorry, we are not open to public contribution currently.
