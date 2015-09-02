require_relative "board"
require_relative "player"
require "byebug"

class Game
  attr_reader :board

  def initialize
    @board = Board.new
    @player1 = Player.new("Billy", @board, :white)
    @player2 = Player.new("Vic", @board, :black)
    @players = [@player1, @player2]
  end

  def run
    until game_over?
      current_player.move
      next_player!
    end
    current_player.display.render
    puts "Game over! #{@players.last} won!!"
  end

  def next_player!
    @players.rotate!
  end

  private

  def current_player
    @players.first
  end

  def game_over?
    @board.game_over?
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.run
end
