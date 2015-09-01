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
    grid
  end

  def in_check?(color)
    opp_color = (color == :white) ? :black : :white
    king_pos = find_king(color)
    each do |piece|
      return true if piece.color != color && piece.moves.include?(king_pos)
    end
    false
  end

  def each(&prc)
    grid.each do |row|
      row.each do |cell|
        prc.call(cell)
      end
    end
  end

  def find_king(color)
    each do |piece|
      return piece.pos if piece.is_a?(King) && piece.color == color
    end
    raise NoKingFoundError
  end

  private

  def move_piece(start_piece, end_piece)
    if end_piece.present?
      kill_piece(start_piece, end_piece)
    else
      swap_piece(start_piece, end_piece)
    end
  end

  def swap_piece(start_piece, end_piece)
    s = start_piece.pos
    e = end_piece.pos
    start_piece.update_pos(e)
    end_piece.update_pos(s)
    temp = self[*s]
    self[*s] = self[*e]
    self[*e] = temp
  end

  def kill_piece(start_piece, end_piece)
    piece_killed = EmptyPiece.new(:empty, end_piece.pos, self)
    self[*end_piece.pos] = piece_killed 
    swap_piece(start_piece, piece_killed)
  end

  def populate_board
    populate_pieces(:pawn)
    populate_pieces(:other_pieces)
    populate_pieces(:empty)
  end

  def populate_pieces(kind_of_piece)
    case kind_of_piece
    when :pawn         ; selected_rows = [1, 6]
    when :other_pieces ; selected_rows = [0, 7]
    when :empty        ; selected_rows = [2, 3, 4, 5]
    else
      raise InvalidPieceError
    end
    selected_rows.each do |row|
      8.times do |col|
        pos = [row, col]
        color = (selected_rows.first == row) ? :black : :white
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
      self[*pos] = EmptyPiece.new(:empty, pos, self)
    end
  end

end
