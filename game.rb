require_relative "board"
require_relative "player"

class Game
  attr_reader :board
  
  def initialize
    @board = Board.new
    @player = Player.new(@board)
  end

  def run
    until @board.game_over?
      pos = @player.move
    end
    puts "Hooray, the board is filled!"
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.run
end
