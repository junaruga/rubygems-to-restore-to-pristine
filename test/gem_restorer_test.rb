$LOAD_PATH.unshift File.expand_path(File.join(__dir__, '..', 'script'))

require 'restore_gems'
require 'minitest/autorun'

class GemRestorerTest < Minitest::Test
  def test_new
    assert GemRestorer.new
  end

  def test_each
    restorer = GemRestorer.new
    stub_string = <<~MESSAGE
      Ignoring byebug-11.0.1 because its extensions are not built. Try: gem pristine byebug --version 11.0.1
      Ignoring nio4r-2.5.1 because its extensions are not built. Try: gem pristine nio4r --version 2.5.1
    MESSAGE
    restorer.stub :gem_pristine_warnings, stub_string do
      h = {}
      restorer.each do |name, version|
        h[name] = version
      end
      assert_equal h.size, 2
      assert_equal h['byebug'], '11.0.1'
      assert_equal h['nio4r'], '2.5.1'
    end
  end
end
