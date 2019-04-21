class PermissionsController < ApplicationController

  before_action :define_user, only: [:show, :update]

  def index
    @roles = Role.all
    logger.info "Roles found: #{@roles}"
  end

  def show
    logger.info "user roles"
    @roles = @user.roles
  end

  def update
    # Para simplificar, deletando todos os papeis existentes e recriando
    roles = @user.user_roles
    logger.info "Roles to delete: #{ roles.map{|r| r.id} }"
    roles.each do |role|
      logger.info "deleting role #{role.id}"
      role.destroy
    end
    role_ids = params['roleIds']
    logger.info "User Roles: #{@user.user_roles.size} - Roles to add: #{role_ids}"
    role_ids.each do |id|
      logger.info("Role ID: #{id}")
      role = Role.find(id)
      @user.user_roles.create(role: role)
    end
    logger.info("User Roles: #{@user.roles}")
    render json: {}, status: :ok
  end

  private

    def define_user
      registration = params[:registration]
      @user = User.where('registration = ?', registration).first
      if @user.nil?
        # Usuário ainda não existente no banco local. necessario cria-lo
        @user = User.new(name: 'nao importa', registration: registration)
        @user.save
      end
    end

end