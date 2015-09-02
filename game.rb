require_relative "board"
require_relative "player"
require "byebug"

class Game
  attr_reader :board

  def initialize
    @board = Board.new
    @player1 = Player.new(@board, :white)
    @player2 = Player.new(@board, :black)
    @players = [@player1, @player2]
  end

  def run
    until @board.game_over?
      pos = @players.first.move
      next_player
    end
    @player1.display.render
    puts "Game over! #{@player.last} won!!"
  end

  def next_player
    @players.rotate!
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new.run
end
