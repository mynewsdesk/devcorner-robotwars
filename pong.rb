require "rrobots"

class Pong
  include Robot

  MAX_SPEED = 8
  TAUNTS = [
    "See you in hell!",
    "Hahaha",
    "Burn!!",
    "Too easy!",
    "FTW!",
    "Muahahaha",
    "LOL!",
  ]
  FIRE_SPEED = 0.1
  AIM_SPEED = 4
  TURN_TICKS = 3

  def tick(events)
    @last_seen = time unless events["robot_scanned"].empty?
    fire FIRE_SPEED

    if aligned?
      pong!
    elsif found_wall?
      align!
    else
      find_wall!
    end

    taunt! if !events["got_hit"].empty? || !events["robot_scanned"].empty?
  end

  private

  def pong!
    puts = time_since_last_seen

    if @aiming_up
      turn_gun_to_heading(90, AIM_SPEED, true)
      @aiming_up = false if gun_heading == 90 || time_since_last_seen == TURN_TICKS
    else
      turn_gun_to_heading(270, AIM_SPEED, false)
      @aiming_up = true if gun_heading == 270 || time_since_last_seen == TURN_TICKS
    end

    if @going_up
      accelerate 1 unless speed > MAX_SPEED
      @going_up = false if y <= 0 + size
    else
      accelerate -1 unless speed < -MAX_SPEED
      @going_up = true if y >= battlefield_height - size
    end
  end

  def align!
    stop

    turn_to_heading(90)

    if heading == 90
      @aligned = true
      say "Pong!!"
    end
  end

  def find_wall!
    say "To the death!!"

    turn_to_heading(0)

    turn_gun_to_heading(180)

    accelerate 1

    if x >= battlefield_width - size
      @found_wall = true
    end
  end

  def taunt!
    say TAUNTS.sample
  end

  def aligned?
    @aligned
  end

  def found_wall?
    @found_wall
  end

  def turn_to_heading(degrees)
    return if heading == degrees

    if heading + 10 > degrees
      turn degrees - heading
    else
      turn 10
    end
  end

  def turn_gun_to_heading(degrees, speed = 10, negative_movement = false)
    return if gun_heading == degrees

    almost_there = gun_heading.send(negative_movement ? "-" : "+", speed).send(negative_movement ? "<" : ">", degrees)
    if almost_there
      turn_gun degrees.send(negative_movement ? "-" : "+", gun_heading)
    else
      turn_gun negative_movement ? -speed : speed
    end
  end

  def time_since_last_seen
    return 1000 unless @last_seen

    time - @last_seen
  end
end
