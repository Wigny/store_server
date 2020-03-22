#!/bin/bash

set -e

psql -c 'create user dart with createdb;' -U postgres
psql -c "alter user dart with password 'dart';" -U postgres
psql -c 'create database dart_test;' -U postgres
psql -c 'grant all on database dart_test to dart;' -U postgres

pub get

pub run test -j 1 -r expanded $RUNNER_ARGS
