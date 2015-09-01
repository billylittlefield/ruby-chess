class Piece

  attr_reader :pos

  def initialize(color, pos)
    @color = color
    @pos = pos
  end

  def present?
    true
  end

  def update_pos(new_pos)
    self.pos = new_pos
  end

end

class EmptyPiece < Piece
  def present?
    false
  end

  def to_s
    "  "
  end
end

class Pawn < Piece
  def to_s
    "P "
  end
end

class Rook < Piece
  def to_s
    "R "
  end
end

class Bishop < Piece
  def to_s
    "B "
  end
end

class Queen < Piece
  def to_s
    "Q "
  end
end

class Knight < Piece
  def to_s
    "N "
  end
end

class King < Piece
  def to_s
    "K "
  end
end
