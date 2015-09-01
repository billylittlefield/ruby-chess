require './display.rb'
class Piece

  attr_reader :pos, :board, :color

  def initialize(color, pos, board)
    @color = color
    @board = board
    @pos = pos
  end

  def present?
    true
  end

  def moves
    possible_moves
  end

  def valid_moves
    valid_moves
  end

  def possible_moves
    raise NotImplementedError
  end

  def update_pos(new_pos)
    self.pos = new_pos
  end

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

end

module Slideable

  def generate_possible_moves(delta_1, delta_2)
    possible_moves = []
    generate_all_deltas(delta_1, delta_2).each do |deltas|
      unable_to_proceed = false
      until unable_to_proceed
        # puts deltas
        # sleep(1)
        shifted_pos = deltas.map.with_index{|delta, index| delta + pos[index]}
        break unless board.in_bounds?(shifted_pos)
        other_piece = board[*shifted_pos]
        if other_piece.color != color
          possible_moves << shifted_pos
          unable_to_proceed = true if other_piece.present?
          # puts "a + #{shifted_pos} + #{unable_to_proceed}"
        else
          unable_to_proceed = true
          # puts "b + #{other_piece.pos}"
        end
        deltas.map! {|delta| delta.zero? ? 0 : (delta + 1) }
        # puts "Deltas are: #{deltas}"
      end
    end
    possible_moves
  end

end

module Steppable

  def generate_possible_moves(delta_1, delta_2)
    possible_moves = []
    generate_all_deltas(delta_1, delta_2).each do |deltas|
      shifted_pos = deltas.map.with_index{|delta, index| delta + pos[index]}
      possible_moves << shifted_pos
    end

    possible_moves.select do |possible_move|
      piece = board[*possible_move]
      piece.color != color && board.in_bounds?(possible_move)
    end
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
  include Slideable

  def possible_moves
    generate_possible_moves(1, 0)
  end

  def to_s
    "R "
  end

end

class Bishop < Piece
  include Slideable

  def possible_moves
    generate_possible_moves(1, 1)
  end

  def to_s
    "B "
  end
end

class Queen < Piece
  include Slideable

  def possible_moves
    generate_possible_moves(1, 1) + generate_possible_moves(1, 0)
  end

  def to_s
    "Q "
  end
end

class Knight < Piece
  include Steppable

  def possible_moves
    generate_possible_moves(1, 2)
  end

  def to_s
    "N "
  end

end

class King < Piece
  include Steppable

  def possible_moves
    generate_possible_moves(1, 1) + generate_possible_moves(1, 0)
  end

  def to_s
    "K "
  end
end

if __FILE__ == $PROGRAM_NAME
  load 'board.rb'
  board = Board.new
  @display = Display.new(board)
  @display.render
  board[1,2] = EmptyPiece.new(:empty, [1,2], self)
  board[1,3] = EmptyPiece.new(:empty, [1,3], self)
  board[1,4] = EmptyPiece.new(:empty, [1,4], self)
  q = board[0,3]
  @display.render
  p q.possible_moves
end
