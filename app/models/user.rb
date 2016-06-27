class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :vkontakte, :twitter]

  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :votes
  has_many :comments
  has_many :authorizations, dependent: :destroy

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    return User.new unless email
    user = User.where(email: email).first

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    user.create_auth(auth)
    user
  end

  def self.send_daily_digest
    questions = Question.where(created_at: Time.now.yesterday.all_day)

    if questions.present?
      find_each.each do |user|
        DailyMailer.delay.digest(user, questions)
      end
    end
  end

  def create_auth(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
