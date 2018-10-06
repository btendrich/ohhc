class ChildFile < ApplicationRecord
  self.inheritance_column = nil
  belongs_to :child
end
