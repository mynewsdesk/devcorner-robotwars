require 'rrobots'

class Therminator
  include Robot

  @@INSULTS = [
    "This is the END for you, you gutter-crawling cur!",
    "Soon you´ll be wearing my sword like a shish kebab!",
    "My handkerchief will wipe up your blood!",
    "People fall at my feet when they see me coming.",
    "I once owned a dog that was smarter then you.",
    "You make me want to puke.",
    "Nobody´s ever drawn blood from me and no body ever will.",
    "You fight like a dairy farmer.",
    "I got this scar on my face during a mighty struggle!",
    "Have you stopped wearing diapers yet?",
    "I´ve heard you were a contemptible sneak.",
    "You´re no match for my brains, you poor fool.",
    "You have the manners of a begger.",
    "I´m not going to take your insolence sitting down!",
    "There are no words for how disgusting you are.",
    "I´ve spoken with apes more polite then you",
  ]

  def tick(events)
    if time == 0
      @acceleration = 1
      @gun_rotation = 1
      @confused = 0
      @seen_target = false
      turn_gun 0
      turn_radar 0
      turn 0
    end

    @events = events

    turn_gun(10 * @gun_rotation)
    unless @events['robot_scanned'].empty?
      @seen_target = true
      fire 3
    end

    if @events['robot_scanned'].empty? and @seen_target
      @gun_rotation = -@gun_rotation
      @seen_target = false
    end

    insult
    flee
    confuse

    if rand(100) == 0 and speed == (8 * @acceleration)
      @acceleration = -@acceleration
    end
  end

  def insult
    if rand(100) == 0
      say @@INSULTS.shuffle.first
    end
  end

  def flee
    accelerate @acceleration

    if hitting_top_border? or hitting_bottom_border? or hitting_left_border? or hitting_right_border?
      turn(10)
      turn_gun(-10)
    end

    if rand(50) == 0
      @confused = 5
    end
  end

  def confuse
    return if @confused == 0

    turn(10)
    turn_gun(-10)

    @confused = @confused - 1
  end

  def hitting_top_border?
    return y < 100
  end

  def hitting_bottom_border?
    return y > (battlefield_height - 100)
  end

  def hitting_left_border?
    return x < 100
  end

  def hitting_right_border?
    return x > (battlefield_width - 100)
  end
end

