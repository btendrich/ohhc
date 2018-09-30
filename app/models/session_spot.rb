class SessionSpot < ApplicationRecord
  belongs_to :child
  belongs_to :hosting_session
  belongs_to :spot_status
end
