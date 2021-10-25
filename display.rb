require 'colorize'
require_relative 'cursor'
require_relative 'board'

class Display
  attr_reader :cursor # For debugging

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], @board)
  end

  def render
    @board.rows.each_with_index do |row, row_index|
      row_str = row.each_with_index
                   .map { |piece, col_index| square(piece, row_index, col_index) }
                   .join
      puts row_str
    end
    nil
  end

  private

  def square(piece, row_index, col_index)
    background = square_color(row_index, col_index)
    piece_str = piece_to_string(piece)
    " #{piece_str} ".colorize(background: background)
  end

  def piece_to_string(piece)
    piece_color = if piece.is_a?(NullPiece)
                    :light_white
                  else
                    piece.color == :white ? :light_white : :black
                  end
    piece.symbol.colorize(color: piece_color)
  end

  def square_color(row_index, col_index)
    if @cursor.cursor_pos == [row_index, col_index]
      return @cursor.selected ? :green : :yellow
    end

    both_even = row_index.even? && col_index.even?
    both_odd = row_index.odd? && col_index.odd?
    both_even || both_odd ? :white : :light_black
  end
end

# For debugging
if __FILE__ == $PROGRAM_NAME
  d = Display.new(Board.new)
  c = d.cursor
  loop do
    system('clear')
    d.render
    puts " #{c.cursor_pos} "
    c.get_input
  end
end
