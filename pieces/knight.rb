require_relative 'stepable'

class Knight < Piece
  include Stepable

  def move_diffs
    [
      [-1, -2],
      [1, -2],
      [-1, 2],
      [1, 2],
      [-2, 1],
      [-2, -1],
      [2, -1],
      [2, 1]
    ]
  end

  def symbol
    'K'
  end
end
