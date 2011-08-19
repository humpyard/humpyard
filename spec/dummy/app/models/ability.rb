class Ability
  include CanCan::Ability

  def initialize(user)
    if user == 'admin'
      can :manage, Humpyard::Page
      can :manage, Humpyard::Element
    else
      can :read, Humpyard::Page
    end
  end
end