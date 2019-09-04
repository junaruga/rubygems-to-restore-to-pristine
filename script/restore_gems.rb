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
      .*
      Try:\sgem\spristine\s([^ ]+)\s--version\s([^ ]+)
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
