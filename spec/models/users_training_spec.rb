require 'rails_helper'

RSpec.describe UsersTraining, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :training }
end
