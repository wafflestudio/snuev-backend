# SNUEV Backend

[![Build Status](https://travis-ci.org/wafflestudio/snuev-backend.svg)](https://travis-ci.org/wafflestudio/snuev-backend)

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

## Running spec

```bash
  docker-compose -f docker-compose.test.yml run test rails db:create db:migrate # initial setup
  docker-compose -f docker-compose.test.yml run test
```

## Contributing

Sorry, we are not open to public contribution currently.
