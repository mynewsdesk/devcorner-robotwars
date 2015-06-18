require 'rrobots'

class T800
  include Robot

  MAX_SPEED = 8

  attr_accessor :last_degree, :last_distance, :gun_heading_left_or_right, :last_fired_at

  def tick(events)

    if near_corner?
      turn 5
      accelerate 1
    else

      unless events['robot_scanned'].empty?
        self.last_degree = radar_heading

        turn_towards_enemy(radar_heading, events['robot_scanned'].first.first)

        fire! 1
        @fire_more = 3

        say "PUT DA TOY BACK ON DA CARPET"
        accelerate 1 unless speed == 8
      else
        if time - @last_fired_at.to_i > 300
          @last_degree = 360 - last_degree
          turn -10
        else

          if @fire_more.to_i > 0
            @fire_more =- 1
            fire! 0.1
          end
          accelerate -1 unless speed > 1

          if radar_heading > gun_pendulum_max_degree
            @gun_heading_left_or_right = "right"
          elsif radar_heading < gun_pendulum_min_degree
            @gun_heading_left_or_right = "left"
          end

          if gun_heading_left_or_right == "left"
            turn_gun 5
          else
            turn_gun -5
          end
        end
      end
    end

  end

  def gun_pendulum_max_degree
    last_degree + 90
  end

  def gun_pendulum_min_degree
    last_degree - 90
  end

  def gun_heading_left_or_right
    @gun_heading_left_or_right || "left"
  end

  def turn_towards_enemy(enemy_degree, enemy_distance)
    if enemy_degree > last_degree
      turn 10
    else
      turn -10
    end

    self.last_degree = enemy_degree
    self.last_distance = enemy_distance
  end

  def near_corner?
    x > 1400 || x < 80 || y > 1400 || y < 80
  end

  def fire!(strength)
    self.last_fired_at = time
    fire strength
  end

  def last_degree
    @last_degree.to_i
  end

  def last_distance
    @last_distance.to_i
  end
end

