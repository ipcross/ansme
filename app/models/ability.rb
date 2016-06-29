class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user: user
    can :edit, Question, user: user
    can :destroy, [Question, Answer], user: user
    can :set_best, Answer, question: { user_id: user.id }
    can :vote_up, [Question, Answer] { |votable| votable.user_id != user.id }
    can :vote_down, [Question, Answer] { |votable| votable.user_id != user.id }
    can :delete_vote, [Question, Answer] { |votable| votable.user_id != user.id }
    can :me, User, id: user.id
    can :create, Subscription, user_id: user.id
    can :destroy, Subscription, user_id: user.id
  end
end
