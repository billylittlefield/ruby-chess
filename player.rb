require_relative "display"

class Player

  attr_reader :board

  def initialize(board)
    @display = Display.new(board)
    @board = board
  end

  def move
    start_pos = select_pos
    end_pos = select_pos
    board.move(start_pos, end_pos)
  rescue InvalidMoveError
    puts "Invalid move, please pick a valid move"
    retry
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
