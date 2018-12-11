# frozen_string_literal: true

module PostManager
  class PeoplePostCreationService < ApplicationService
    def initialize(*args)
      @params = args.first
      @user = @params.delete(:user)
    end

    def call
      build_people_post(@params).tap do |post|
        post.attachments.concat(@params.delete(:attachments))
        unless post.public?
          load_aspects(@params[:aspect_ids])
          add_to_streams(post)
        end
      end
    end

    private

    attr_reader :user, :aspects

    def build_people_post(params)
      public = params[:public] || false
      post = user.build_post(:post, params[:post_message].merge(public: public))
      user.person.posts << post
      post
    end

    def load_aspects(aspect_ids)
      @aspects = user.aspects_from_ids(aspect_ids)
      raise AwesomeSkill::BadAspectsIDs if aspects.empty?
    end

    def add_to_streams(post)
      user.add_to_streams(post, aspects)
      post.attachments.each {|media| user.add_to_streams(media, aspects) }
    end
  end
end
