require "colorize"
require_relative "piece"
require "byebug"

class Board

  def initialize
    @grid = Array.new(8) { Array.new(8) { EmptyPiece.new } }
  end

  def render
    @grid.each_with_index do |row, r_idx|
      row.each_with_index do |cell, c_idx|
        color = (r_idx + c_idx) % 2 == 0? :red : :black
        print cell.render.colorize(:background => color)
      end
      puts
    end
    puts
  end

  def valid_move?
  end

end

b = Board.new
b.render
