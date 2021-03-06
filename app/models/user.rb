class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :identities
  has_many :projects

  def self.from_omniauth(auth, current_user)

    identity = Identity.find_or_initialize_by(provider: auth.provider,
                                              uid: auth.uid.to_s,

    )
    identity.token = auth.credentials.token
    identity.username = auth.info.name
    identity.image = auth.info.image
    identity.email = auth.info.email
    identity.save

    if identity.user.blank?
      user = current_user
      identity.user = user
      identity.save
    end

    identity
  end
  # def fetch_details(auth)
  #   self.email = auth.info.email
  #   self.provider = auth.provider
  #   self.uid = auth.uid
  # end
  #
  #   def self.new_with_session(params, session)
  #     if session['devise.user_attributes']
  #       new(session['devise.user_attributes'], without_protection: true) do |user|
  #       user.attributes = params
  #       user.valid?
  #
  #       end
  #     else
  #       super
  #     end
  #   end
  #
  #
  # def email_required?
  #   super && provider.blank?
  # end
  # def password_required?
  #   super && provider.blank?
  # end
end
