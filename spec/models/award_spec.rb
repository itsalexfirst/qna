require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user).optional(true) }
  it { should validate_presence_of :title }

  it 'have one attached image' do
    expect(Award.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
