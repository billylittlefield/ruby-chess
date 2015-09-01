require "colorize"
require_relative "cursorable"

class Display
  include Cursorable

  attr_reader :board

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
    @selected_pos = nil
  end

  def build_grid
    @board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :yellow
    elsif [i, j] == @selected_pos
      bg = :light_green
    elsif !@selected_pos.nil? && board[*@selected_pos].valid_moves.include?([i, j])
      bg = :light_green
    elsif (i + j).odd?
      bg = :blue
    else
      bg = :light_white
    end
    { background: bg, color: :black }
  end

  def render
    system("clear")
    puts "Please select a position to move from and to."
    build_grid.each { |row| puts row.join }
    puts "  " * 50
  end

  def reset_selected_pos
    @selected_pos = nil
  end

  def set_selected_pos(pos)
    @selected_pos = pos.dup
  end
end
