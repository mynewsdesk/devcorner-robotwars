require 'rrobots'

class Scanner
  include Robot

  def initialize
    @segments = []
    set_mode "rough_scan"
  end

  def tick events
    if @mode == "rough_scan"
      scan(360)
    end

    if @mode == "scan"
      scan(60)
    end

    if @mode == "scan_ended" && @previous_mode == "rough_scan"
      @scan_quadrant = get_closest_quadrant
      set_mode "move_radar"
    elsif @mode == "scan_ended" && @previous_mode == "scan"
      @scan_quadrant = get_closest_quadrant
      @target = @scan_quadrant[:start]
      set_mode "turn_away", 10
    end

    if @mode == "turn_away"
      turn_away
    end

    if @mode == "escape"
      escape
    end

    if @mode == "move_radar"
      move_radar_to_closest
    end
  end

  def scan(total)
    width = total / 6

    @segments << get_scan_segment(width)

    if @segments.count > 6
      set_mode "scan_ended"
    end
  end

  def get_scan_segment(width)
    current_radar_heading = radar_heading
    turn_radar width

    segment = {
      start: current_radar_heading,
      end: current_radar_heading + width,
      closest_robot: battlefield_height + battlefield_width
    }

    unless events['robot_scanned'].empty?
      segment[:closest_robot] = events['robot_scanned'].min.first
    end

    segment
  end

  def get_closest_quadrant
    @segments.min do |a, b|
      a[:closest_robot] <=> b[:closest_robot]
    end
  end

  def move_radar_to_closest
    start = @scan_quadrant[:start]

    turn_radar 10

    if (radar_heading - start) < 20
      @mode = "scan"
    end
  end

  def turn_away
    target_direction = @target - 90

    if heading < target_direction
      turn 5
    else
      turn -5
    end

    if [heading, target_direction].max - [heading, target_direction].min < 20
      set_mode "escape"
    end

    stabalize_gun

    fire(0.1)

    @mode_frames += 1

    if @mode_frames > @mode_duration
      set_mode "escape", 2
    end
  end

  def escape
    accelerate 2
    stabalize_gun
    fire(0.2)

    @mode_frames += 1

    if @mode_frames > @mode_duration
      set_mode "rough_scan"
    end
  end

  def stabalize_gun
    target = heading - 90

    if gun_heading < target
      turn_gun(-10)
    elsif gun_heading > target
      turn_gun(10)
    end
  end

  def set_mode(new_mode, frames = 0)
    # puts "#{new_mode} #{frames}"
    @previous_mode = @mode
    @mode = new_mode
    @mode_frames = 0
    @mode_duration = frames
  end
end

