class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    if user.admin?
      can :manage, :all
    elsif user.manager?
      can [:read, :create, :update], :all
    elsif user.content_writer?
      can :update, :all
    elsif user.user?
      can :read, :all
    end
  end
end
