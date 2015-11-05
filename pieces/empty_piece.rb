class EmptyPiece < Piece
  def present?
    false
  end

  def possible_moves
    []
  end

  def to_s
    "   "
  end
end
