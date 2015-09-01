require './piece'
require './error'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    populate_board
    nil
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, mark)
    @grid[row][col] = mark
  end

  def move(start_pos, end_pos)
    start_piece = self[*start_pos]
    end_piece = self[*end_pos]
    if start_piece.moves.include?(end_pos)
      move_piece(start_piece, end_piece)
    else
      raise InvalidMoveError
    end
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def game_over?
    false
  end

  def rows
    @grid
  end

  private

  def move_piece(start_piece, end_piece)
    s = start_piece.pos
    e = end_piece.pos
    start_piece.update_pos(e)
    end_piece.update_pos(s)
    self[s], self[e] = self[e], self[s]
  end

  def populate_board
    populate_pieces(:pawn)
    populate_pieces(:other_pieces)
    populate_pieces(:empty)
  end

  def populate_pieces(kind_of_piece)
    case kind_of_piece
    when :pawn
      selected_rows = [1, 6]
    when :other_pieces
      selected_rows = [0, 7]
    when :empty
      selected_rows = [2, 3, 4, 5]
      color = kind_of_piece
    else
      raise InvalidPieceError
    end
    selected_rows.each do |row|
      8.times do |col|
        pos = [row, col]
        color ||= selected_rows.first == row ? :black : :white
        instantiate_and_set_piece(kind_of_piece, color, pos)
      end
    end
  end

  def instantiate_and_set_piece(kind_of_piece, color, pos)
    if kind_of_piece == :pawn
      self[*pos] = Pawn.new(color, pos, self)
    elsif kind_of_piece == :other_pieces
      case pos[1]
      when 0, 7
        self[*pos] = Rook.new(color, pos, self)
      when 1, 6
        self[*pos] = Knight.new(color, pos, self)
      when 2, 5
        self[*pos] = Bishop.new(color, pos, self)
      when 3
        self[*pos] = Queen.new(color, pos, self)
      when 4
        self[*pos] = King.new(color, pos, self)
      else
        raise ColumnOutOfRangeError
      end
    else
      self[*pos] = EmptyPiece.new(color, pos, self)
    end
  end

end
