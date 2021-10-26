class Player
  attr_reader :color
  
  def initialize(color, display)
    @color = color
    @display = display
  end

  def make_move(_board)
    raise NotImplementedError
  end
end
