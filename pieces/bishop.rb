require_relative 'slideable'

class Bishop < Piece
  include Slideable

  def possible_moves
    generate_possible_moves(1, 1)
  end

  def to_s
    color == :white ? " ♗ " : " ♝ "
  end
end
