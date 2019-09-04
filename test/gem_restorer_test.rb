$LOAD_PATH.unshift File.expand_path(File.join(__dir__, '..', 'script'))

require 'restore_gems'
require 'minitest/autorun'

class GemRestorerTest < Minitest::Test
  def test_new
    assert GemRestorer.new
  end

  def test_each
    restorer = GemRestorer.new
    restorer.stub :gem_pristine_warnings, stub_gem_warnings do
      h = {}
      restorer.each do |name, version|
        h[name] = version
      end
      assert_equal h.size, 2
      assert_equal h['byebug'], '11.0.1'
      assert_equal h['nio4r'], '2.5.1'
    end
  end

  def test_run
    restorer = GemRestorer.new
    restorer.stub :gem_pristine_warnings, stub_gem_warnings do
      out_cmds = []
      stub_sh = proc do |cmd|
        out_cmds << cmd
      end
      restorer.stub :sh, stub_sh do
        restorer.run
        assert_equal out_cmds.size, 4
        assert_equal out_cmds[0], 'gem uninstall -x byebug'
        assert_equal out_cmds[1], 'gem install byebug -v 11.0.1 --user-install'
        assert_equal out_cmds[2], 'gem uninstall -x nio4r'
        assert_equal out_cmds[3], 'gem install nio4r -v 2.5.1 --user-install'
      end
    end
  end

  def stub_gem_warnings
    stub_string = <<~MESSAGE
      Ignoring byebug-11.0.1 because its extensions are not built. Try: gem pristine byebug --version 11.0.1
      Ignoring nio4r-2.5.1 because its extensions are not built. Try: gem pristine nio4r --version 2.5.1
    MESSAGE
    stub_string
  end
end
