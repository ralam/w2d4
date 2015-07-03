require "byebug"

class Piece
  attr_reader :pos, :color, :king, :board

  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
    @king = false
  end

  def make_king
    @king = true
  end

  def move_diffs
    if @king
      directions = [[-1, -1], [-1, 1],[1, -1], [1, 1]]
    elsif @color == :W
      directions = [[-1, -1], [-1, 1]]
    else
      directions = [[1, -1], [1, 1]]
    end

    directions
  end

  def perform_slide(finish_pos)
    unless valid_slide?(@pos, finish_pos)
      return false
    end
    start = @pos
    @pos = finish_pos
    @board[start] = EmptyPiece.new()
    @board[finish_pos] = self
    maybe_promote(self)

    return true
  end

  def valid_slide?(start, finish_pos)
    move_diffs.include?([finish_pos[0] - start[0], finish_pos[1] - start[1]]) &&
      finish_pos.all? { |el| el.between?(0,7) } &&
      @board[finish_pos].empty_piece?
  end

  def maybe_promote(piece)
    if @pos.first == 0 && @color == :W || @pos.first == 7 && @color == :B
      make_king
    end
  end

  def perform_jump(finish_pos)
    unless valid_jump?(@pos, finish_pos)
      return false
    end
    start = @pos
    middle = find_jumped_cell(start, finish_pos)
    @pos = finish_pos
    @board[start] = EmptyPiece.new()
    @board[middle] = EmptyPiece.new()
    @board[finish_pos] = self
    maybe_promote(self)

    return true
  end

  def find_jumped_cell(start, finish)
    delta_x = (finish.first - start.first) / 2
    delta_y = (finish.last - start.last) / 2
    jumped_cell = [start.first + delta_x, start.last + delta_y]
  end

  def valid_jump?(start, finish_pos)
    finish_pos.all? { |el| el.between?(0,7) } &&
      enemy?(@board[find_jumped_cell(start, finish_pos)]) &&
      @board[finish_pos].empty_piece? &&
      (start.first - finish_pos.first).abs == 2 &&
      (start.last - finish_pos.last).abs == 2
  end

  def empty_piece?
    false
  end

  def enemy?(piece)
    @color != piece.color
  end

  def render
    if @king
      if @color == :B
        " \u25CB ".encode('utf-8').colorize(:color => :black)
      else
        " \u25CB ".encode('utf-8').colorize(:color => :white)
      end
    elsif @color == :B
      " \u25CF ".encode('utf-8').colorize(:color => :black)
    else
      " \u25CF ".encode('utf-8').colorize(:color => :white)
    end
  end

  def valid_move_seq?(list_of_moves)
    temp_board = @board.dup
    temp_piece = temp_board[@pos]
    temp_piece.board.render
    first_move = list_of_moves[0]

    if temp_piece.perform_slide(first_move)
      temp_piece.perform_slide(first_move)
      return true
    elsif temp_piece.perform_jump(first_move)
      list_of_moves.each do |move|
        if temp_piece.perform_jump(first_move)
          temp_piece.perform_jump(move)
          true
        else
          return false
        end
      end
    else
      return false
    end
  end

  def dup(empty_board)
    Piece.new(@color, @pos, empty_board)
  end

  def perform_moves(list_of_moves)
    if valid_move_seq?(list_of_moves)
      perform_moves!(list_of_moves)
    else
      raise InvalidMoveError.new "Invalid move!"
    end
  end
end

class EmptyPiece < Piece

  def initialize
  end

  def render
    "   "
  end

  def empty_piece?
    true
  end

  def enemy?(piece)
    false
  end

  def dup
    EmptyPiece.new()
  end
end

class InvalidMoveError < StandardError
end
