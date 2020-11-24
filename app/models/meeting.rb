class Meeting < ApplicationRecord
  belongs_to :room
  belongs_to :user
  validates :title, :meeting_end, :meeting_start, presence: true
  validate :end_date_is_after_start_date
  validate :start_date_is_after_now
  validate :is_in_week_day
  validate :is_in_commercial_hour

  private

  def end_date_is_after_start_date
    return if meeting_end.blank? || meeting_start.blank?

    errors.add(:meeting_end, 'Fim da reunião deve ser depois do começo') if meeting_end < meeting_start
  end

  def start_date_is_after_now
    return if meeting_end.blank? || meeting_start.blank?

    errors.add(:meeting_start, 'Reunião deve ser no futuro') if meeting_start < DateTime.now
  end

  def is_in_commercial_hour
    return if meeting_end.blank? || meeting_start.blank?
    start_of_commercial_hour = 8 # 8:00
    end_of_commercial_hour = 18 # 18:00
    start_time = meeting_start.beginning_of_day + start_of_commercial_hour.hours # gets the 8am on current day
    end_time = meeting_start.beginning_of_day + end_of_commercial_hour.hours # gets the 6pm on current day

    # not valid unless the datetime is a commercial hour
    unless meeting_start.between?(start_time, end_time) and meeting_end.between?(start_time, end_time)
      errors.add(:meeting_start,
                 "Reunião deve ser no em horário
                 comercial (#{start_of_commercial_hour}:00 - #{end_of_commercial_hour}:00)")
    end
  end

  def is_in_week_day
    return if meeting_end.blank? || meeting_start.blank?
    # if is on weekend, return an error
    errors.add(:meeting_start, 'Reunião deve ser em um dia de semana') if meeting_start.on_weekend?
  end
end
