# Holds functionality common to all chess pieces
class Piece

  attr_reader :color, :board
  attr_accessor :pos

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
  end

  def to_s() end

  def empty?() end

  # @returns [Array] positions this piece can move to
  def moves() end

  def symbol
    'Piece'
  end

  def inspect
    "<#{color} #{symbol} #{pos}>"
  end
end
