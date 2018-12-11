# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Awesome Skills

    ## Requirements

        - Ruby 2.5.1
        - Bundler: http://bundler.io/
        - Postgres: https://postgresapp.com/
        - FFMPEG: https://ffmpeg.org/ffprobe.html is a command line toolbox to manipulate, convert and stream multimedia content.
        - Redis: https://redis.io/

* How to Install
`bundle install`

setup database
`rails db:create`
`rails db:migrate`

Configure your ENV:
`cp .env.example .env`

#Development mode only
`gem install mailcatcher` Please don't put mailcatcher into your Gemfile. It will conflict with your applications gems at some point.

