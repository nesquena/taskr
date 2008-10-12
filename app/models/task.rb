# == Schema Information
# Schema version: 20081012094223
#
# Table name: tasks
#
#  id          :integer         not null, primary key
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Task < ActiveRecord::Base
  
end
