require 'rrobots'

class Aimbot
  include Robot

  attr_accessor :turn_direction

  def initialize
    @turn_direction = -10
    @hits_ago = 3
  end

  def tick events
    turn actual_direction

    if time % 30 == 0
      @turn_direction == change_direction
    end

    if has_aim?
      @hits_ago = 0
    else
      @hits_ago += 1
    end

    if has_aim? || @hits_ago < 10
      if close_distance?
        fire 3
      else
        fire 1
      end
    else
      fire 0.3
      turn_gun 3 - actual_direction
    end

    accelerate 1 unless speed == 8
  end

  def actual_direction
    if x > (battlefield_width - 80) || x < 80 || y > (battlefield_height - 80) || y < 80
      10
    elsif has_aim?
      0
    else
      turn_direction
    end
  end

  def has_aim?
    !events['robot_scanned'].empty?
  end

  def change_direction
    if time.modulo(10).zero?
      @turn_direction = [-1, 1][rand(2)]
    end
  end

  def close_distance?
    return false if events['robot_scanned'].first.nil?
    events['robot_scanned'].first.first < 333
  end
end
