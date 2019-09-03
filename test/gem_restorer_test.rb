$LOAD_PATH.unshift File.expand_path(File.join(__dir__, '..', 'script'))

require 'restore_gems'
require 'minitest/autorun'

class GemRestorerTest < Minitest::Test
  def test_new
    assert GemRestorer.new
  end
end
