require 'colorize'
require_relative 'cursor'

class Display
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], @board)
  end

  def render
    @board.rows.each_with_index do |row, row_index|
      square_color = row_index.even? ? :white : :light_black
      squares = []
      row.each do |piece|
        squares << square_string(piece, square_color)
        square_color = toggle_square_color(square_color)
      end
      puts squares.join
    end
    nil
  end

  private

  def toggle_square_color(color)
    color == :white ? :light_black : :white
  end

  def piece_to_string(piece)
    piece_color = if piece.is_a?(NullPiece)
                    :light_white
                  else
                    piece.color == :white ? :light_white : :black
                  end
    piece.symbol.colorize(color: piece_color)
  end

  def square_string(piece, square_color)
    piece_str = piece_to_string(piece)
    " #{piece_str} ".colorize(background: square_color)
  end
end
