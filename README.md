# Activities

A [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) microservice for activities for the Game Night app. The activities specification is defined using Swagger and hosted on [Apiary.io](http://docs.s3activities.apiary.io/#).

## How to Use

Docker images are defined for the web server and database environments. You can build them manually or use the make targets defined in `Makefile`. For example, if you'd like to build and start the database environment with seeded data:

```bash
$ make db_run_seed
```

## How to test

[add later]
