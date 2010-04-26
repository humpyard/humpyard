class Ability
  include CanCan::Ability

  def initialize(user)
    # Add abilities to manage pages and elements here, e.g.:
    
    #if user.is_admin?
    #  can :manage, Humpyard::Page
    #  can :manage, Humpyard::Element
    #else
    #  can :read, Humpyard::Page
    #end
  end
end