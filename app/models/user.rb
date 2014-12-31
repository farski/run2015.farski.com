class User < ActiveRecord::Base
  has_many :activities

  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  def self.find_for_oauth(auth, signed_in_resource = nil)
    user = find_by(uid: auth.uid, provider: auth.provider)

    if user.nil?
      user = User.new(
        uid: auth.uid,
        provider: auth.provider,
        forename: auth.info.first_name,
        surname: auth.info.last_name,
        token: auth.credentials.token,
        password: Devise.friendly_token[0,20],
        email: auth.info.email
      )
      user.save!
    end

    user
  end
end
