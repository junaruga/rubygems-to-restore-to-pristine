require 'open3'
require 'strscan'

class GemRestorer
  GEM_V_CMD = 'gem -v'

  def each
    gem_pristine_warnings.each_line do |line|
      p "line #{line}"
      sc = StringScanner.new(line)
      next unless sc.scan(gem_pristine_regex)

      name = sc[1]
      version = sc[2]
      p "name #{name}, version: #{version}"
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
      Try: gem pristine (.+?) --version (.+?) # name and version
      $
    /x
  end
end
