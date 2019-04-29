class TimeFormatError < StandardError
  def initialize(msg = "Incorrect format.")
    super
  end
end
class TimeError < StandardError
  def initialize(msg = "HH is between 0-24, MM & SS between 0-59")
    super
  end
end
class ZeroTimeError < StandardError
  def initialize(msg = "Timer can't be zero.")
    super
  end
end