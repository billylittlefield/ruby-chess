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
