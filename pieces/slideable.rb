module Slideable

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
