#!/bin/bash

set -ex

gem -v

gem pristine byebug --version 11.0.1
gem pristine nio4r --version 2.5.1
