#!/bin/bash

set -ex

gem -v

ruby script/restore_gems.rb

# Test if the stderr is empty without "gem pristine" warnings.
gem -v 2> gem_v_stderr.txt
[ -f gem_v_stderr.txt -a ! -s gem_v_stderr.txt ]
