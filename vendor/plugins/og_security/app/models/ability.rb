  class Ability
    include CanCan::Ability

    def initialize(user)
      if user
        can :manage, :all
      else
        can :manage, User
        can :new, Session
        can :new, Registration

        can :read, :all
        can :show, Page

        can :update, :all do |object_class, object|
          user && object_class.try(:user) == user
        end
        
      end
    end
  end