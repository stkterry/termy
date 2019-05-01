require "io/console"

KEYMAP = {
  # home keys
  "t" => :set_timer,
  " " => :space,
  "r" => :reset,
  "s" => :start,
  "\r" => :return,
  "\u0003" => :ctrl_c,
  # timer features keys
  "1" => :one,
  "2" => :two,
  "3" => :three,
  "4" => :four,
  "c" => :custom
}.freeze

module TimerInput

  private
  def get_input(handle)
    key = KEYMAP[read_char]
    self.send handle, key
  end

  def read_char
    STDIN.echo = false # stops the console from printing return values

    STDIN.raw! # in raw mode data is given as is to the program--the system
                # doesn't preprocess special characters such as control-c

    input = STDIN.getc.chr # STDIN.getc reads a one-character string as a
                            # numeric keycode. chr returns a string of the
                            # character represented by the keycode.
                            # (e.g. 65.chr => "A")

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil # read_nonblock(maxlen) reads
                                                  # at most maxlen bytes from a
                                                  # data stream; it's nonblocking,
                                                  # meaning the method executes
                                                  # asynchronously; it raises an
                                                  # error if no data is available,
                                                  # hence the need for rescue

      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true # the console prints return values again
    STDIN.cooked! # the opposite of raw amode :)

    return input
  end

  def home_handle_keys(key)
    case key
    when :return, :space, :start
      toggle_timer
    when :reset
      toggle_reset
    when :set_timer
      set_timer
    when :ctrl_c
      goodbye!
      Process.exit(0)
    end
  end

  def timer_handle_keys(key)
    case key
    when :one, :two, :three, :four
      set_preset(key)
    when :custom
      set_custom
    when :ctrl_c
      render
    else
      get_input(:timer_handle_keys)
    end
  end

end