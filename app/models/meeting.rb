class Meeting < ApplicationRecord
  belongs_to :room
  belongs_to :user
  validates :title, :meeting_end, :meeting_start, presence: true
  validate :end_date_is_after_start_date

  private

  def end_date_is_after_start_date
    return if meeting_end.blank? || meeting_start.blank?

    errors.add(:meeting_end, 'Fim da reunião deve ser depois do começo') if meeting_end < meeting_start
  end
end
