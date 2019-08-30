# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
  2.6.2
## SETUP
1. RUN `bundle install`

2. RUN `bundle exec rails db:create`, `bundle exec rails db:migrate`, `bundle exec rails db:seed`


3. Create a `local_env.yml` inside of /config (i.e. /config/local_env.yml) & replace the values with your own!

   ```yml
    GITHUB_APP_ID: ‘ID’
    GITHUB_APP_SECRET: ‘SECRET-KEY-GITHUB’
    GOOGLE_APP_ID: ‘ID'
    GOOGLE_APP_SECRET: ‘SECRET-KEY-GOOGLE'
    FACEBOOK_APP_ID: ‘ID’
    FACEBOOK_APP_SECRET: ‘SECRET-KEY-FACEBOOK’

   ```
