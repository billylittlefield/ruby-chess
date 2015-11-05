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
    piece_moved_already = self.moved
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
    self.moved = piece_moved_already
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
      [-delta_2, -delta_1]
    ].uniq
  end

  def pos_with_deltas(pos, deltas)
    deltas.map.with_index{ |row_or_col_delta, i| row_or_col_delta + pos[i] }
  end
end
