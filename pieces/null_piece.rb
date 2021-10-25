require 'Singleton'

class NullPiece < Piece
  include Singleton
  def initialize
    super(nil, nil, nil)
  end

  def symbol
    ' '
  end
end
