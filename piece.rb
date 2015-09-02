class Piece

  attr_reader :board, :color
  attr_accessor :pos, :moved

  def initialize(color, pos, board)
    @color = color
    @board = board
    @pos = pos
    @moved = false
  end

  def present?
    true
  end

  def moves
    possible_moves
  end

  def valid_moves
    moves.reject do |move|
      move_into_check?(move)
    end
  end

  def possible_moves
    raise NotImplementedError
  end

  def move_into_check?(end_pos)
    piece_moved = moved
    start_color = color
    start_orig_pos = pos.dup
    end_piece = board[*end_pos]
    if !end_piece.present?
      board.swap_piece(self, end_piece)
      move_into_check = board.in_check?(start_color)
      board.swap_piece(self, end_piece)
    else
      resurrected_piece = end_piece.deep_dup
      board.kill_piece(self, end_piece)
      move_into_check = board.in_check?(start_color)
      board.unkill_piece(resurrected_piece, end_pos, self, start_orig_pos)
    end
    self.moved = piece_moved
    move_into_check
  end

  def update_pos(new_pos)
    self.pos = new_pos
    self.moved = true
  end

  def deep_dup
    klass = self.class
    klass.new(color, pos.dup, board)
  end

  private

  def generate_all_deltas(delta_1, delta_2)
    [
      [delta_1, delta_2],
      [delta_1, -delta_2],
      [-delta_1, delta_2],
      [-delta_1, -delta_2],
      [delta_2, delta_1],
      [delta_2, -delta_1],
      [-delta_2, delta_1],
      [-delta_2, -delta_1],
    ].uniq
  end

  def pos_with_deltas(pos, deltas)
    deltas.map.with_index{ |row_or_col_delta, i| row_or_col_delta + pos[i] }
  end

end

module Slideable


  #Refactor to make more consise and readable
  def generate_possible_moves(delta_1, delta_2)
    possible_moves = []
    generate_all_deltas(delta_1, delta_2).each do |deltas|
      possible_moves += extend_in_direction(deltas)
    end
    possible_moves
  end

  def extend_in_direction(deltas)
    extended_moves = []
    unable_to_proceed = false
    shifted_pos = pos.dup
    until unable_to_proceed
      shifted_pos = pos_with_deltas(shifted_pos, deltas)
      break if !board.in_bounds?(shifted_pos)
      other_piece = board[*shifted_pos]
      if other_piece.color != color
        extended_moves << shifted_pos
      end
      unable_to_proceed = true if other_piece.present?
    end
    extended_moves
  end

end

module Steppable

  def generate_possible_moves(delta_1, delta_2)
    possible_moves = []
    generate_all_deltas(delta_1, delta_2).each do |deltas|
      shifted_pos = pos_with_deltas(pos, deltas)
      possible_moves << shifted_pos
    end
    possible_moves.select do |possible_move|
      piece = board[*possible_move] if board.in_bounds?(possible_move)
      piece && piece.color != color
    end
  end

end

class EmptyPiece < Piece
  def present?
    false
  end

  def possible_moves
    []
  end

  def to_s
    "  "
  end
end

class Pawn < Piece

  def possible_moves
    possible_diagonal_pawn_moves + possible_forward_pawn_moves
  end

  def possible_diagonal_pawn_moves
    pos_in_diagonals = []
    all_deltas_to_go_diagonal.each do |diag_deltas|
      pos_in_diagonals << pos_with_deltas(pos, diag_deltas)
    end
    pos_in_diagonals.select do |pos_in_diagonal|
      diag_piece = board[*pos_in_diagonal] if board.in_bounds?(pos_in_diagonal)
      diag_piece && diag_piece.present? && diag_piece.color != color
    end
  end

  def possible_forward_pawn_moves
    possible_forward_pawn_moves = []
    pos_in_front = pos_with_deltas(pos, deltas_to_go_forward)
    pos_2_in_front = pos_with_deltas(pos_in_front, deltas_to_go_forward)
    if !board[*pos_in_front].present?
      possible_forward_pawn_moves << pos_in_front
      if !board[*pos_2_in_front].present? && !moved
        possible_forward_pawn_moves << pos_2_in_front
      end
    end
    possible_forward_pawn_moves
  end

  def deltas_to_go_forward
    color == :white ? [-1, 0] : [1, 0]
  end

  def all_deltas_to_go_diagonal
    color == :white ? [[-1, 1], [-1, -1]] : [[1, 1], [1, -1]]
  end

  def to_s
    color == :white ? "♙ " : "♟ "
  end
end

class Rook < Piece
  include Slideable

  def possible_moves
    generate_possible_moves(1, 0)
  end

  def to_s
    color == :white ? "♖ " : "♜ "
  end

end

class Bishop < Piece
  include Slideable

  def possible_moves
    generate_possible_moves(1, 1)
  end

  def to_s
    color == :white ? "♗ " : "♝ "
  end
end

class Queen < Piece
  include Slideable

  def possible_moves
    generate_possible_moves(1, 1) + generate_possible_moves(1, 0)
  end

  def to_s
    color == :white ? "♕ " : "♛ "
  end
end

class Knight < Piece
  include Steppable

  def possible_moves
    generate_possible_moves(1, 2)
  end

  def to_s
    color == :white ? "♘ " : "♞ "
  end

end

class King < Piece
  include Steppable

  def possible_moves
    generate_possible_moves(1, 1) + generate_possible_moves(1, 0)
  end

  def to_s
    color == :white ? "♔ " : "♚ "
  end
end
