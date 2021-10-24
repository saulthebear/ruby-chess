class PositionError < ArgumentError
  def initialize(msg = 'Invalid position!')
    super
  end
end

class MoveError < ArgumentError
  def initialize(msg = 'Invalid move!')
    super
  end
end
