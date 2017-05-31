require 'rails_helper'

module Logical
  describe UrlCreator do
    describe "#create" do
      let(:new_url) { "http://www.url.com" }
      let(:owner_identifier) { Logical::Uuid.generate }

      it "creates a new small URL" do
        expect { Logical::UrlCreator.new(new_url, owner_identifier).create }.
          to change { Physical::SmallUrl.count }.
          from(0).to(1)
      end

      it "encrypts the original URL correctly" do
        small_url = Logical::UrlCreator.new(new_url, owner_identifier).create
        expect(Logical::UrlEncryptor.new(small_url.salt).
               decrypt(small_url.encrypted_url)).
          to eq(new_url)
      end

      it "uses a 32-byte salt" do
        small_url = Logical::UrlCreator.new(new_url, owner_identifier).create
        expect(small_url.salt.length).to eq(64)
      end
      
      it "creates a new owner when a new owner param is given" do
        expect { Logical::UrlCreator.new(new_url, owner_identifier).create }.
          to change { Physical::Owner.count }.
          from(0).to(1)
        expect(Physical::Owner.find_by(external_identifier: owner_identifier)).to_not be_nil
      end

      it "creates a small URL with a nil owner when no owner specified" do
        Logical::UrlCreator.new(new_url, nil).create
        expect(Physical::SmallUrl.last.owner).
          to be_nil
      end

      context "owner already exists" do
        let!(:owner) { FactoryGirl.create(:owner) }

        it "creates a small URL with the existing owner ID" do
          small_url = Logical::UrlCreator.new(new_url, owner.external_identifier).create
          expect(small_url.owner_id).to eq(owner.id)
        end
      end
    end
  end
end
