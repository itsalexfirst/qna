require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should allow_value('https://gist.github.com').for(:url) }
  it { should_not allow_value('gist').for(:url) }

  describe '#gist?' do
    let!(:question) { create(:question) }
    let!(:gist_url) { create(:link, linkable: question, url: 'https://gist.github.com/itsalexfirst/da7bbbaf7c2863b2ffbe5935e4b8cb21') }
    let!(:test_url) { create(:link, linkable: question, url: 'https://yandex.ru') }

    it 'link is gist' do
      expect(gist_url).to be_gist
    end

    it 'link is not gist' do
      expect(test_url).to_not be_gist
    end
  end
end
