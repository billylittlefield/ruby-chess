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
    if board.in_bounds?(pos_in_front) && !board[*pos_in_front].present?
      possible_forward_pawn_moves << pos_in_front
      if !moved && !board[*pos_2_in_front].present? 
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
    color == :white ? " ♙ " : " ♟ "
  end
end
