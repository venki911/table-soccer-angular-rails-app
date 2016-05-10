# create_table "users", force: :cascade do |t|
#   t.string   "provider",               default: "email", null: false
#   t.string   "uid",                    default: "",      null: false
#   t.string   "encrypted_password",     default: "",      null: false
#   t.string   "reset_password_token"
#   t.datetime "reset_password_sent_at"
#   t.datetime "remember_created_at"
#   t.integer  "sign_in_count",          default: 0,       null: false
#   t.datetime "current_sign_in_at"
#   t.datetime "last_sign_in_at"
#   t.string   "current_sign_in_ip"
#   t.string   "last_sign_in_ip"
#   t.string   "confirmation_token"
#   t.datetime "confirmed_at"
#   t.datetime "confirmation_sent_at"
#   t.string   "unconfirmed_email"
#   t.string   "email",                                    null: false
#   t.string   "first_name"
#   t.string   "last_name"
#   t.boolean  "is_admin",               default: false
#   t.integer  "rank",                   default: 1000
#   t.json     "tokens"
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.string   "avatar"
# end

class User < ActiveRecord::Base

  before_save :downcase_email

  has_many :teams_users, dependent: :destroy
  has_many :teams, through: :teams_users
  has_many :user_results

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable,
         :omniauthable
  include DeviseTokenAuth::Concerns::User

  # Override default DeviseTokenAuth params
  DeviseTokenAuth::OmniauthCallbacksController.class_eval do
    def assign_provider_attrs(user, auth_hash)
      user.assign_attributes({
                                 first_name: auth_hash['info']['first_name'],
                                 last_name:     auth_hash['info']['last_name'],
                                 email:    auth_hash['info']['email'],
                                 avatar: auth_hash['info']['picture']
                             })
    end
  end
  DeviseTokenAuth::Url.class_eval do
    def self.generate(url, params = {})
      uri = URI(url)

      res = "#{uri.scheme}://#{uri.host}"
      res += ":#{uri.port}" if (uri.port and uri.port != 80 and uri.port != 443)
      res += "#{uri.path}" if uri.path
      query = [uri.query, params.to_query].reject(&:blank?).join('&')
      res += "##{uri.fragment}" if uri.fragment
      res += "?#{query}"

      return res
    end
  end
  DeviseTokenAuth::PasswordsController.class_eval do
    def edit
      @resource = resource_class.reset_password_by_token({
                                                             reset_password_token: resource_params[:reset_password_token]
                                                         })

      if @resource and @resource.id
        client_id  = SecureRandom.urlsafe_base64(nil, false)
        token      = SecureRandom.urlsafe_base64(nil, false)
        token_hash = BCrypt::Password.create(token)
        expiry     = (Time.now + DeviseTokenAuth.token_lifespan).to_i

        @resource.tokens[client_id] = {
            token:  token_hash,
            expiry: expiry
        }

        # ensure that user is confirmed
        @resource.skip_confirmation! if @resource.devise_modules.include?(:confirmable) && !@resource.confirmed_at

        # allow user to change password once without current_password
        @resource.allow_password_change = true

        @resource.save!

        yield if block_given?

        redirect_to(DeviseTokenAuth::Url.generate(params[:redirect_url], {
            token:          token,
            client_id:      client_id,
            reset_password: true,
            config:         params[:config]
        }))
      else
        render_edit_error
      end
    end
  end

  validates :first_name, :last_name, :email, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255 },
            format: {with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  mount_uploader :avatar, AvatarUploader

  def downcase_email
    self.email = email.downcase
  end

  def self.order_by_ids(ids)
    order_by = ["case"]
    ids.each_with_index.map do |id, index|
      order_by << "WHEN id='#{id}' THEN #{index}"
    end
    order_by << "end"
    order(order_by.join(" "))
  end

end
