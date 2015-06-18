require 'rrobots'

class Ultimate
  include Robot

  def tick events
    turn 5
    fire 0.1
  end
end
