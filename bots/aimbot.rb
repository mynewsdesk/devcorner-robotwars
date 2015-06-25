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

    if enemy_seen_recently(50)
      if gun_heat == 0
        say "--FRESH MEAT!--"
        case @last_enemy_dist
        when 0...100
          say "--YOU DIE!--"
          fire 3
        when 100...500
          say "--MUAHAHA!--"
          fire 2
        when 500...1000
          say "--BANG!--"
          fire 0.5
        else fire 0.2
        end
      end
    else
      turn_gun 10
      fire 0.1
    end

    accelerate 1 unless speed == 8
  end

  def actual_direction
    if x > (battlefield_width - 80) || x < 80 || y > (battlefield_height - 80) || y < 80
      10
    elsif has_aim?
      3
    else
      turn_direction
    end
  end

  def enemy_seen_recently(since = 100)
    enemy_seen
    @last_enemy_seen ||= 0
    (time - @last_enemy_seen) < since
  end

  def enemy_seen
    was_seen = has_aim?
    @last_enemy_dist ||= 0
    if was_seen
      @last_enemy_seen = time
      @last_enemy_dist = events["robot_scanned"][0][0].to_i
    end
    was_seen
  end

  def has_aim?
    !events["robot_scanned"].empty?
  end

  def spread_fire power
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
