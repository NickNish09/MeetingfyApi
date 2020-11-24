class DateTime
  def self.next(week_day = 'monday')
    date  = parse(week_day)
    delta = date > now ? 0 : 7
    date + delta
  end
end