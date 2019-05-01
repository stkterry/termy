require 'colorize'

def t_opt(string)
  string.colorize(color: :light_blue).bold.underline
end

SS = t_opt("S")
RR = t_opt("R")
TT = t_opt("T")
CC = t_opt("C")
ONE = t_opt("1")
TWO = t_opt("2")
THREE = t_opt("3")
FOUR = t_opt("4")
CTRLC = t_opt("Ctrl-C")
CLOCK_FACES = ["🕧", "🕛", "🕦", "🕚", "🕥", "🕙", "🕤", "🕘", "🕣", "🕗", "🕢", 
  "🕖", "🕡", "🕕", "🕠", "🕔", "🕟", "🕓", "🕞", "🕒", "🕝", "🕑", "🕜", "🕐"].freeze

module TimerRender
  private
  def render(time = ZERO_TIME + self.tsecs)
    system("clear")
    bg = timer_color(time)
    puts timer_header.colorize(color: :black, background: bg)
    puts "Remaining: #{time.strftime('%H:%M:%S')}"
    self.stopped ? timer_opts : (puts "Pause: #{CTRLC}")
  end

  def timer_color(time)
    if time < ZERO_TIME + self.max_tsecs / 10
      :red
    elsif time < ZERO_TIME + self.max_tsecs / 3
      :yellow
    else
      :green
    end
  end

  def timer_opts
    puts "#{SS}tart  #{RR}eset  #{TT}imer"
    puts "Exit: #{CTRLC}       "
  end
  
  def timer_header
    "       Timer       "
  end

  def timer_return
    "Return: #{CTRLC}"
  end

  def render_set_custom
    puts "New Timer: HH:MM:SS"
  end

  def custom_presets
    ["#{CC}ustom", "#{ONE} #{PRESETS[:one]}", "#{TWO} #{PRESETS[:two]}", 
     "#{THREE} #{PRESETS[:three]}", "#{FOUR} #{PRESETS[:four]}"]
  end

  def render_set_timer
    system("clear")
    puts timer_header.colorize(color: :black, background: :green)
    puts custom_presets
    puts timer_return
  end

  def flash_over
    bg = :red
    while true
    bg = (bg == :red ? :yellow : :red)
    system("clear")
    puts "    Time Is Up!    ".colorize(color: :black, background: bg)
    puts "     00:00:00      ".colorize(color: :black, background: bg)
    puts "  #{CTRLC} to reset  "
    sleep 0.5
    end
  end

  def goodbye!
    system("clear")
    puts timer_header.colorize(color: :white, background: :light_black)
    puts "My people need me..."
    sleep 0.5
    system("clear")
  end

end