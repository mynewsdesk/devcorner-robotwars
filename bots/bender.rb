require 'rrobots'

class Bender
  include Robot

  def tick events
    turn_radar 1 if time == 0
    turn_gun 30 if time < 3

    if energy < 30
      accelerate(2)
      if x > battlefield_width || x < 80
        if y >= battlefield_height - 150 || y >= 80
          turn 2
        end
      else
        if y >= battlefield_width - 150 || y >= 80
          turn 2
        end
      end
      fire 0.1 unless events['robot_scanned'].empty?
    else
      accelerate(2)
      if x > 1400 || x < 80 || y > 1400 || y < 80
        turn 5
        accelerate(1)
      end
      unless events['robot_scanned'].empty?
        fire 1
      end
    end
  end

end

