require 'colorize'
require 'Set'
require_relative 'cursor'
require_relative 'board'

class Display
  attr_reader :cursor # For debugging
  attr_accessor :highlighted_positions

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], @board)
    @highlighted_positions = Set.new
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

  def add_highlight(*positions)
    @highlighted_positions += positions
  end

  private

  def square(piece, row_index, col_index)
    background = square_color([row_index, col_index])
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

  def square_color(pos)
    return :green if selected?(pos)
    return :light_yellow if highlighted?(pos) && hover?(pos)

    return highlighted_color(pos) if highlighted?(pos)

    return :yellow if hover?(pos)

    light_square?(pos) ? :white : :light_black
  end
  # def square_color(pos)
  #   return highlighted_and_selected_color(pos) if highlighted?(pos) && hover?(pos)

  #   return highlighted_color(pos) if highlighted?(pos)

  #   return :yellow if hover?(pos)

  #   light_square?(pos) ? :white : :light_black
  # end

  def hover?(pos)
    @cursor.cursor_pos == pos
  end

  def selected?(pos)
    @cursor.selected && hover?(pos)
  end

  def highlighted?(pos)
    @highlighted_positions.include?(pos)
  end

  def highlighted_color(pos)
    light_square?(pos) ? :light_red : :red
  end

  def highlighted_and_selected_color(pos)
    light_square?(pos) ? :light_magenta : :magenta
  end

  # Light or dark square?
  def light_square?(pos)
    row_index, col_index = pos
    both_even = row_index.even? && col_index.even?
    both_odd = row_index.odd? && col_index.odd?
    both_even || both_odd
  end
end

# For debugging
if __FILE__ == $PROGRAM_NAME
  d = Display.new(Board.new)
  c = d.cursor
  d.add_highlight([3,3], [3,5])
  loop do
    system('clear')
    d.render
    puts " #{c.cursor_pos} "
    c.get_input
  end
end
