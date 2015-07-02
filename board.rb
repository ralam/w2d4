require "colorize"
require_relative "piece"

class Board

  def initialize
    @grid = Array.new(8) { Array.new(8) { [EmptyPiece.new] } }
  end

  def render
  end

end
