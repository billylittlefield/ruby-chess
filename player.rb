require_relative "display"

class Player
  def initialize(board)
    @display = Display.new(board)
  end

  def move
    select_pos
    #select end_pos
  end

  def select_pos
    result = nil
    until result
      @display.render
      result = @display.get_input
    end
    result
  end
end
