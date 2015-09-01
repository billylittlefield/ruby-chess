require './Piece'
require './Error'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    populate_board
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
    if start_piece.valid_moves.include?(end_pos)
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
    populate_pawns
    populate_other_pieces
    populate_empty_pieces
  end

  def populate_pawns
    [1, 6].each do |row|
      8.times do |col|
        pos = [row, col]
        self[row, col] = Pawn.new(:black, pos) if row == 1
        self[row, col] = Pawn.new(:white, pos) if row == 6
      end
    end
  end

  def populate_other_pieces
    [0, 7].each do |row|
      8.times do |col|
        pos = [row, col]
        case col
        when 0, 7
          self[row, col] = Rook.new(:black, pos) if row == 0
          self[row, col] = Rook.new(:white, pos) if row == 7
        when 1, 6
          self[row, col] = Knight.new(:black, pos) if row == 0
          self[row, col] = Knight.new(:white, pos) if row == 7
        when 2, 5
          self[row, col] = Bishop.new(:black, pos) if row == 0
          self[row, col] = Bishop.new(:white, pos) if row == 7
        when 3
          self[row, col] = Queen.new(:black, pos) if row == 0
          self[row, col] = Queen.new(:white, pos) if row == 7
        when 4
          self[row, col] = King.new(:black, pos) if row == 0
          self[row, col] = King.new(:white, pos) if row == 7
        end
      end
    end
  end

  def populate_empty_pieces
    [2, 3, 4, 5].each do |row|
      8.times do |col|
        pos = [row, col]
        self[row, col] = EmptyPiece.new(:empty, pos)
      end
    end
  end

end
