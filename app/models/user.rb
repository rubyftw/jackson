class User < ActiveRecord::Base
  has_many :responses
  has_many :events, through: :responses
  has_many :created_events, class_name: "Event", foreign_key: :created_by

  def attending?(event)
    events.include?(event)
  end

  def gravatar(size = 500)
    "http://www.gravatar.com/avatar/#{ Digest::MD5.hexdigest(email.downcase) }?s=#{ size }&d=retro"
  rescue
    avatar_url.presence || random_avatar
  end

  def self.authorize(auth)
    user = User.where(provider: auth.provider, uid: auth.uid).first_or_initialize
    user.first_name ||= auth.info.first_name.presence  || auth.info.name.split(' ').first
    user.last_name  ||= auth.info.last_name.presence   || auth.info.name.split(' ').last
    user.email      ||= auth.info.email
    user.avatar_url ||= auth.info.image
    user.token      ||= auth.credentials.token
    user.auth_hash    = auth.to_h

    user.tap(&:save)
  end

  protected

  def random_avatar(size = 500)
    [
      "http://placekitten.com/#{ size }/#{ size }",
      "http://www.avatarpro.biz/avatar?s=#{ size }",
      "http://placedog.com/#{ size }/#{ size }",
      "http://lorempixel.com/#{ size }/#{ size }",
    ].sample
  end
end
