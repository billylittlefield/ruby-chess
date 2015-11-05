require_relative "display"

class Player

  attr_reader :board, :color, :display, :name

  def initialize(name, board, color)
    @display = Display.new(board)
    @name = name
    @board = board
    @color = color
  end

  def move
    @display.render
    start_pos = get_start_pos
    @display.render
    start_piece = board[*start_pos]
    end_pos = get_end_pos(start_piece)
    @display.reset_selected_pos
    board.move(start_pos, end_pos)
  rescue SamePieceSelectedError
    @display.render
    puts "Same piece selected, it is now unselected."
    @display.reset_selected_pos
    retry
  end

  def select_pos
    result = nil
    until result
      result = @display.get_input
      @display.render
    end
    result
  end

  def get_start_pos
    start_pos = select_pos
    @display.highlighted_moves = board[*start_pos].valid_moves
    selected_piece = board[*start_pos]
    raise EmptyPieceSelected if !selected_piece.present?
    raise WrongColorSelected if selected_piece.color != color
    @display.set_selected_pos(start_pos)
    start_pos
  rescue EmptyPieceSelected
    @display.render
    puts "Empty piece was selected, please pick a piece of your color"
    retry
  rescue WrongColorSelected
    @display.render
    puts "Wrong color piece selected, please pick a piece of your color"
    retry
  end

  def get_end_pos(start_piece)
    end_pos = select_pos
    @display.highlighted_moves = [] if @display.highlighted_moves.include?(end_pos)
    raise SamePieceSelectedError if end_pos == start_piece.pos
    raise InvalidMoveError if !start_piece.valid_moves.include?(end_pos)
    end_pos
  rescue InvalidMoveError
   retry
  end

  def to_s
    name
  end

end
