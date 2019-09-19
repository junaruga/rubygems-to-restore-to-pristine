# rubygems-to-restore-to-pristine

[![Build Status](https://travis-ci.org/junaruga/rubygems-to-restore-to-pristine.svg?branch=master)](https://travis-ci.org/junaruga/rubygems-to-restore-to-pristine)

A script to reinstall gems included in a `gem pristine` warning related to [this issue](https://github.com/rubygems/rubygems/issues/1968).

```
$ gem -v
Ignoring byebug-11.0.1 because its extensions are not built. Try: gem pristine byebug --version 11.0.1
Ignoring nio4r-2.5.1 because its extensions are not built. Try: gem pristine nio4r --version 2.5.1
3.0.3

$ wget https://raw.githubusercontent.com/junaruga/rubygems-to-restore-to-pristine/master/script/restore_gems.rb

$ ruby restore_gems.rb

$ gem -v
3.0.3
```
