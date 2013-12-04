require 'digest/sha1'

class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :name, :email, :approved, :password, :password_confirmation, :remember_me

  has_paper_trail on: [:update], only: [:current_sign_in_at, :current_sign_in_ip]

	validates :name, :presence => true, :length => { :maximum => 255 }
	validates :username, :presence => true, :length => { :maximum => 255 }

	scope :sorted, order("admins.name ASC")

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

end
