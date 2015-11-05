# Chess

Fully functioning two-player chess playable in the terminal. Written in Ruby.

## Installation

To play the game, simply download the repository here from GitHub and save on your computer. After unzipping, open a terminal and 'cd' to the directory in which you saved it. The GameStart is located in the 'game.rb' file, so simply type 'ruby game.rb' and the game will start.

## Features

* Piece selection with arrow-key input in the terminal with Cursorable module
* Move validation prevents you from putting yourself in check
* Move path options highlighted when 'hovering' over piece
* Custom error messages for easy debugging during develoment:
  * IllegalMove
  * NoKingFound
  * EmptyPieceSelected
  * SamePieceSelected
  * WrongColorSelected
* Piece ineritance for 'slideable' and 'steppable' pieces (ie, queens vs. knights)

## Code

The gameboard itself is stored as a 2D array and utilizes Ruby's syntactic sugar for easy setting and getting on the grid. Each piece tracks its position and color to allow the move validation logic to work.

Move validation is the trickiest component of writing chess, given the variety of move styles. Queens, bishops, and rooks can move indefinitely in a direction until they run into an obstacle. Knights, kings, and pawns can only perform one 'step' at a time, be it 1-forward, or 1-diagonal, or 2-forward-1-side. Pawns are especially difficult given their ability to attack diagonally and move forward 2 at the start of the game.

In order to DRY all this logic out, I implemented two modules: 'Slideable' and 'Steppable'. These modules were responsible for one key method: generating possible moves. Here you can compare the two modules:
```ruby
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
```
```ruby
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
```

Notice the delta_1 and delta_2 input for each generate_possible_moves method. The parent 'piece' class contains a 'generate_all_deltas' method that will output every permutation of the give deltas by changing order and sign (+/-). For example, if a knight is in the center of a blank chess board, it has 8 possible moves. [+2,+1], [+2, -1], [+1, -2], etc. All possible moves are generated, and then pruned to account for out-of-bounds and whether another piece of the same color is already occupying the possible destination square. The Slideable module also includes a move extension method that continues in a direction until it is unable to proceed. Pawns are a special beast that have a class-specific methods for moving.

In addition to validating whether a move is out-of-bounds or runs into a piece of the same color, we have to check if a given move would put the player into check. In chess, it is illegal to put yourself in check -- that wouldn't be any fun if you sandbagged the game, either intentionally or not! To check for check, there are two possible approaches:

1. Duplicate the board-state into a temporary board, make the move on the temp board, and return true/false if the new board-state is in check
2. Actually make the move on the current board (but do not render), check for check, then 'undo' the move

In this version, I elected to use the latter approach. Undoing the move for a given piece was trivial if the piece was moving to a blank square, but things get a little more complicated if a piece takes [kills] an enemy piece first. The logic for taking an enemy piece is absolute. To get around this, I implemented a 'resurrect' method that essentially saves the starting/ending positions for both the moved piece and killed piece to allow for easy undo. Here is the full method for checking check:
```ruby
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
```

## Improvements

There are a few improvements I would still like to make to this side project. First, I'd like to code the logic for the more-obscure [en passant][enpassant] and [castling][castling] rules. Additionally, I think the board display could be improved (granted, it is chess in the terminal, so there are limitations) for easier playability. Mainly, a larger board and possible timer implementation. All in all, this project was excellent for practicing inheritance in Ruby and creating a DRY code base.

[enpassant]: https://en.wikipedia.org/wiki/En_passant
[castling]: https://en.wikipedia.org/wiki/Castling
