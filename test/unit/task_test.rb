require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  should_ensure_length_in_range :description, (3..20)
end
