require 'rrobots'

class Bobo
  include Robot

  def tick events
    @enemy_found = 0 if time == 0
    say "HahahaHAHAHAHahahaHAHAHahahAHAHAHahahaHAHAHahahahahAHAHAHAhahaha"

    if x > battlefield_width-100 || x < 80 || y > battlefield_height-100 || y < 80
      turn 5
    else
      random_movement
    end

    scan_for_enemies events
    fire_at_enemy

    accelerate 1 unless speed == 8
  end

  def random_movement
    a = -10
    b = 10
    degrees = (b-a)*Random.new.rand + a
    turn degrees
  end

  def scan_for_enemies events
    @enemy_found = radar_heading unless events['robot_scanned'].empty?
    turn_radar 60
  end

  def fire_in_a_circle
    fire 0.1
    turn_gun 10
  end

  def fire_at_enemy
    puts "gun_heading: #{gun_heading} radar_heading: #{radar_heading} enemy_found: #{@enemy_found}"
    turn_gun 10 if gun_heading < @enemy_found-30
    turn_gun 5 if gun_heading < @enemy_found-6
    turn_gun 1 if gun_heading < @enemy_found-1
    turn_gun -10 if gun_heading > @enemy_found+30
    turn_gun -5 if gun_heading > @enemy_found+6
    turn_gun -1 if gun_heading > @enemy_found+1
    fire 0.1
  end
end
