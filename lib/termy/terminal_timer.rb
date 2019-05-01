require 'time'
require 'colorize'

ZERO_TIME = Time.new(0)

PRESETS = {one:'01:00:00', two:'00:45:00', three:'00:30:00', four:'00:15:00'}

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
      get_input(:home_handle_keys)
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
    get_input(:timer_handle_keys)
    render
  rescue Interrupt
    render
  end
  
  def get_tsecs(time_str)
    h, m, s = time_str.split(":").map(&:to_i)
    [h, m, s].map { |t| raise TimeFormatError if t.nil? }
    raise TimeError unless m.between?(0, 59) && s.between?(0, 59) && h.between?(0,24)
    tsecs = h*3600 + m*60 + s
    raise ZeroTimeError unless tsecs > 0
    tsecs
  end

  def set_tsecs(time_str)
    self.tsecs = get_tsecs(time_str)
    self.time_str = time_str
    self.max_tsecs = self.tsecs
  end

  def set_preset(preset)
    set_tsecs(PRESETS[preset])
  end

  def set_custom
    render_set_custom
    time_str = gets.chomp
    set_tsecs(time_str)
  rescue StandardError => e
    puts e.message
    sleep 1.25
    render_set_timer
    retry
  end

end