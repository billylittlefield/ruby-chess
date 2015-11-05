require_relative './steppable'

class Knight < Piece
  include Steppable

  def possible_moves
    generate_possible_moves(1, 2)
  end

  def to_s
    color == :white ? " ♘ " : " ♞ "
  end

end
