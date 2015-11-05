require_relative 'slideable'

class Rook < Piece
  include Slideable

  def possible_moves
    generate_possible_moves(1, 0)
  end

  def to_s
    color == :white ? " ♖ " : " ♜ "
  end

end
