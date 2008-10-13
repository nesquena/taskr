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
  validates_length_of :description, :within => 3..20, :message => "must be specified"
  
  
end
