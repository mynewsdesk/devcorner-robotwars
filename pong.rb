require "rrobots"

class Pong
  include Robot

  def tick(events)
    @last_seen = time unless events["robot_scanned"].empty?

    if aligned?
      pong
    elsif found_wall?
      align!
    else
      find_wall!
    end
  end

  private

  def pong
    puts = time_since_last_seen

    fire 0.3

    aim_speed = 3

    if @aiming_up
      turn_gun_to_heading(90, aim_speed, true)
      @aiming_up = false if gun_heading == 90 || time_since_last_seen == 6
    else
      turn_gun_to_heading(270, aim_speed, false)
      @aiming_up = true if gun_heading == 270 || time_since_last_seen == 6
    end

    if @going_up
      accelerate 1
      @going_up = false if y <= 0 + size
    else
      accelerate -1
      @going_up = true if y >= battlefield_height - size
    end
  end

  def align!
    stop

    turn_to_heading(90)

    @aligned = heading == 90
  end

  def find_wall!
    puts "x: #{x} / #{battlefield_width - size}, y: #{y} / #{size}"

    turn_to_heading(0)

    fire 0.3
    turn_gun 10

    accelerate 1

    @found_wall = x >= battlefield_width - size
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
