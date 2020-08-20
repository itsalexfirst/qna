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
    cannot :index, Award
    cannot :index, :search
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer]
    can %i[update destroy], [Question, Answer], { author_id: user.id }
    can :comment, [Question, Answer]

    can :best, Answer, question: { author_id: user.id }

    can [:vote_up, :vote_down], [Question, Answer] do |res|
      !user.author_of?(res)
    end

    can :destroy, ActiveStorage::Attachment, record: { author_id: user.id }
    can :index, Award, { user_id: user.id }
    can :destroy, Link, linkable: { author_id: user.id }

    can :create, Subscription
    can :destroy, Subscription, user_id: user.id

    can %i[index me], User

    can :index, :search
  end
end
