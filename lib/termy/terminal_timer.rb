require 'time'
require 'colorize'

ZERO_TIME = Time.new(0)

class TerminalTimer
  include TimerInput
  include TimerRender

  attr_accessor :stopped, :tsecs, :time_str, :max_tsecs
  attr_reader :zero_time
  def initialize(time_str = '00:15:00')
    @tsecs = get_tsecs(time_str)
    @max_tsecs = self.tsecs
    @time_str = time_str
    @stopped = true
  end

  def run
    render
    while true
      get_input
    end
  end

  private

  def flash_over!
    flash_over
    rescue Interrupt
      toggle_reset
  end

  def start
    until self.stopped || self.tsecs < 0
      render(ZERO_TIME + self.tsecs)
      sleep 1
      self.tsecs -= 1
    end
    flash_over!
    rescue Interrupt
      toggle_timer
  end

  def toggle_timer
    self.stopped = !self.stopped
    start unless self.stopped
    render
  end

  def toggle_reset
    self.stopped = true
    self.tsecs = get_tsecs(self.time_str)
    render
  end

  def set_timer
    render_set_timer
    time_str = gets.chomp
    get_tsecs(time_str)
    self.time_str = time_str
    self.max_tsecs = self.tsecs
    render
  rescue Interrupt
    render
  rescue StandardError => e
    puts e.message
    sleep 1.25
    retry
  end
  
  def get_tsecs(time_str)
    h, m, s = time_str.split(":").map(&:to_i)
    [h, m, s].map { |t| raise TimeFormatError if t.nil? }
    raise TimeError unless m.between?(0, 59) && s.between?(0, 59) && h.between?(0,24)
    self.tsecs = h*3600 + m*60 + s
    raise ZeroTimeError unless tsecs > 0
    tsecs
  end

end