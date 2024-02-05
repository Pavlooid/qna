# frozen_string_literal: true

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
    can :create, [Question, Answer, Comment, Link, Subscribe]
    can :update, [Question, Answer], author_id: user.id
    can :destroy, [Question, Answer, Link], author_id: user.id
    can :destroy, Subscribe, user: user
    can :destroy, ActiveStorage::Attachment do |file|
      user.author_of?(file.record)
    end
    can [:like, :dislike], [Question, Answer] do |resource|
      user.not_author_of?(resource)
    end
    can :destroy, Link, linkable: { author_id: user.id }
    can :best, Answer, question: { author_id: user.id }
    can :me, User
  end
end
