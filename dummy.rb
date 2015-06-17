require 'rrobots'

class Dummy
  include Robot

  def tick events
    if x > 1400 || x < 80 || y > 1400 || y < 80
      turn 5
      say "turning"
    end
    fire 1 unless events['robot_scanned'].empty?
    accelerate 1 unless speed == 8
  end
end
