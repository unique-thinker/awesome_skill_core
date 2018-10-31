# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AspectVisibility, type: :model do
  it { should belong_to(:aspect) }
  it { should belong_to(:shareable) }

  let(:post) { create(:post) }
  let(:post_in_aspect) { create(:post_in_aspect) }
  let(:aspect) { create(:aspect) }
  let(:picture_with_same_id) { create(:picture, id: post_in_aspect.id) }

  describe '.create' do
    it 'creates object when attributes are fine' do
      expect {
        AspectVisibility.create(shareable: post, aspect: aspect)
      }.to change(AspectVisibility, :count).by(1)
    end

    it 'doesn\'t allow duplicating objects' do
      expect {
        AspectVisibility
          .create(shareable: post_in_aspect, aspect: post_in_aspect.aspects.first)
          .save!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'makes difference between shareable types' do
      expect {
        AspectVisibility.create(shareable: picture_with_same_id, aspect: post_in_aspect.aspects.first).save!
      }.not_to raise_error
    end
  end
end
