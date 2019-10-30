##
# This script is to restore gem packages by reinstalling.
#
# = Usage
#
# Here is the example. restore_gems.rb reinstalls the gem packages in
# "gem pristine" warnings. After running the script, the warnings are
# suppressed.
#
#  $ gem -v
#  Ignoring byebug-11.0.1 because its extensions are not built. \
#    Try: gem pristine byebug --version 11.0.1
#  Ignoring nio4r-2.5.1 because its extensions are not built. \
#    Try: gem pristine nio4r --version 2.5.1
#  3.0.3
#
#  $ ruby restore_gems.rb
#
#  $ gem -v
#  3.0.3

require 'open3'

class GemRestorer
  GEM_V_CMD = 'gem -v'

  def run
    each do |name, version|
      sh("gem uninstall -x #{name}")
      sh("gem install #{name} -v #{version} --user-install")
    end
  end

  def each
    gem_pristine_warnings.each_line do |line|
      line.rstrip!
      next unless line =~ gem_pristine_regex

      name = Regexp.last_match(1)
      version = Regexp.last_match(2)
      yield name, version
    end
  end

  def gem_pristine_warnings
    _, stderr, status = Open3.capture3(GEM_V_CMD)
    raise "failed command #{gem_v_cmd}" unless status.success?

    stderr
  end

  # /usr/share/rubygems/rubygems/basic_specification.rb
  # https://github.com/ruby/ruby/blob/v2_6_3/lib/rubygems/basic_specification.rb#L74
  def gem_pristine_regex
    /
      ^
      Ignoring
      .* # some characters
      Try:\sgem\spristine\s([^ ]+)\s--version\s([^ ]+) # name and version
      $
    /x
  end

  def sh(cmd)
    raise "Failed command: #{cmd}" unless system(cmd)
  end
end

if $PROGRAM_NAME == __FILE__
  restorer = GemRestorer.new
  restorer.run
end
