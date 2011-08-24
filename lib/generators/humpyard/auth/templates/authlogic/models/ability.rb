class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_admin?
      can :manage, Humpyard::Page
      can :manage, Humpyard::Element
      can :manage, Humpyard::Asset
    else
      can :show, Humpyard::Page
      can :show, Humpyard::Element
      can :show, Humpyard::Asset
    end
  end
end