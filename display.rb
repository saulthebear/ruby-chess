require 'colorize'
require 'Set'
require_relative 'cursor'
require_relative 'board'

class Display
  attr_reader :cursor

  def initialize(board, show_moves: true, debug: false)
    @board = board
    @cursor = Cursor.new([0, 0], @board)
    @highlighted_positions = Set.new
    @show_moves = show_moves
    @debug = debug
  end

  def render
    highlight_threatened_squares(@cursor.cursor_pos) if @debug && @cursor.selected?
    highlight_valid_moves(@cursor.cursor_pos) if @show_moves && @cursor.selected?

    puts "   #{('a'..'h').to_a.join('  ')}"
    @board.rows.each_with_index do |row, row_index|
      row_str = row.each_with_index
                   .map { |piece, col_index| square(piece, row_index, col_index) }
                   .join
      puts "#{render_row_index(row_index)} #{row_str}"
    end

    display_debug_info if @debug
    nil
  end

  def render_row_index(row_index)
    ((row_index - 8) * -1).to_s
  end

  def display_debug_info
    puts "Cursor at: #{@cursor.cursor_pos}"
    puts "Selected?: #{@cursor.selected?}\n"
    puts "White in check? #{@board.in_check?(:white)}"
    puts "Black in check? #{@board.in_check?(:black)}"
    puts "White in checkmate? #{@board.checkmate?(:white)}"
    puts "Black in checkmate? #{@board.checkmate?(:black)}"
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

    return :light_red if highlighted?(pos)

    return :yellow if hover?(pos)

    light_square?(pos) ? :white : :light_black
  end

  def highlight_threatened_squares(pos)
    reset_highlights
    piece = @board[pos]
    return if piece.is_a?(NullPiece)

    @highlighted_positions = piece.threatens
  end

  def highlight_valid_moves(start_pos)
    reset_highlights
    piece = @board[start_pos]
    return if piece.is_a?(NullPiece)

    @highlighted_positions = piece.valid_moves
  end

  def reset_highlights
    @highlighted_positions = Set.new
  end

  def hover?(pos)
    @cursor.cursor_pos == pos
  end

  def selected?(pos)
    @cursor.selected? && hover?(pos)
  end

  def highlighted?(pos)
    @highlighted_positions.include?(pos)
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
