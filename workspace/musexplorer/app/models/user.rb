class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true

  has_many :tips
  has_many :votes
  has_many :posts
  has_many :replies
  has_many :pieces, through: :piece_users
  has_many :piece_users, dependent: :destroy
  has_many :flags, dependent: :destroy

  enum role: { user: 0, admin: 1 }
  enum teacher: { student: 0, teacher: 1 }

  def average_level(instrument_id)
    if self.pieces.any?
      self.pieces.joins(:instruments).where(instruments: {id: instrument_id}).average(:level).to_f
    else
      1
    end
  end
end
