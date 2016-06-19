module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      before_action :except_current_user, only: :index
      authorize_resource class: User

      def me
        respond_with current_resource_owner
      end

      def index
        respond_with @profiles
      end

      protected

      def except_current_user
        @profiles = User.where.not(id: current_resource_owner.id)
      end
    end
  end
end
