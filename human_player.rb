require_relative 'player'

class HumanPlayer < Player
  def make_move(_board)
    cursor = @display.cursor
    cursor.get_input
  end
end
