require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should belong_to :user }
  it { should have_many :ratings }

  it 'have the by_top_rated scope' do
    expect(Post).to respond_to(:by_top_rated)
  end
end