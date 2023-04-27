#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate
# 以下seed挿入完了済み。次回以降の挿入はbundle exec rake db:seed SECTION=*で挿入する。
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:migrate:reset
bundle exec rake db:seed SECTION=f_2
bundle exec rake db:seed SECTION=q_2
bundle exec rake db:seed SECTION=q_3
bundle exec rake db:seed SECTION=q_4
bundle exec rake db:seed SECTION=q_5