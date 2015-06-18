require 'rrobots'

class Redrobot
   include Robot

   def initialize
     @aim = 90
     @gun_move = 1
     @left_border = false
     @swiping = false
     @swiped_add = 1
   end

   def turn_bot_gun
     if !@swiping && gun_heading == 0
       @swiping = true
     end
     if gun_heading > 20 && gun_heading < 340
       @swiping = false
     end
     if @swiping
       if gun_heading == 20
         @swiped_add = -1
       elsif gun_heading == 340
         @swiped_add = 1
       end
       turn_gun @swiped_add
     else
       small_gun_turn = gun_heading % 30
       if small_gun_turn > 0
         turn_gun 0 - small_gun_turn
       elsif gun_heading != 0
         if gun_heading > 180
           turn_gun 30
         else
           turn_gun -30
         end
       end
     end
   end

   def turn_it
     small_turn = heading % 10
     if small_turn > 0
       turn 0 - small_turn
     elsif heading != @aim
       turn -10
     end
     if !@left_border
       if x > size
         @aim = 180
       else
         @left_border = true
         @aim = 270
       end
     else
       if y <= size
         @aim = 270
       elsif y >= battlefield_height - size
         @aim = 90
       end
     end
   end

  def tick events
    accelerate 1
    turn_it
    turn_bot_gun
    fire 0.5
  end
end

