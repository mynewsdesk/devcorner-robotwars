```
 __  __                             _        _
|  \/  |_  _ _ _  _____ __ _____ __| |___ __| |__
| |\/| | || | ' \/ -_) V  V (_-</ _` / -_|_-< / /
|_|  |_|\_, |_||_\___|\_/\_//__/\__,_\___/__/_\_\
        |__/    robotwars
```

Setup
==================================
    # Clone this repo

    # Install the project dependencies
    $ bundle install

    # Run the sample robots to see it in action
    $ bundle exec rrobots Dreadnought Dummy

    # Now go make your own!

Rules
==================================
* The methods listed below are intentionally of very basic nature, you are free to unleash the whole power of ruby to create higher level functions (e.g. move_to, fire_at and so on).

* You are not allowed however to read, write or use in any way information not resolved from the above methods (like using ObjectSpace and so on).

* No external libraries can be used, everything must be contained in one file

* Submit your final code through a private message to @woll before 18:00


How-to
==================================
Some words of explanation: The gun is mounted on the body, if you turn the body the gun will follow. In a simmilar way the radar is mounted on the gun. The radar scans everything it sweeps over in a single tick (100
degrees if you turn your body, gun and radar in the same direction) but will report only the distance of scanned robots, not the angle. If you want more precission you have to turn your radar slower.

The battlefield that the tournament will be played on will have another resolution than your local system so don't work with definite numbers when calculating boundaries for example.

The game runs at 16 FPS.

### Available methods: ###
    battlefield_height  #the height of the battlefield
    battlefield_width   #the width of the battlefield
    energy              #your remaining energy (if this drops below 0 you are dead)
    gun_heading         #the heading of your gun, 0 pointing east, 90 pointing
                        #north, 180 pointing west, 270 pointing south
    gun_heat            #your gun heat, if this is above 0 you can't shoot
    heading             #your robots heading, 0 pointing east, 90 pointing north,
                        #180 pointing west, 270 pointing south
    size                #your robots radius, if x <= size you hit the left wall
    radar_heading       #the heading of your radar, 0 pointing east,
                        #90 pointing north, 180 pointing west, 270 pointing south
    time                #ticks since match start
    speed               #your speed (-8/8)
    x                   #your x coordinate, 0...battlefield_width
    y                   #your y coordinate, 0...battlefield_height
    accelerate(param)   #accelerate (max speed is 8, max accelerate is 1/-1,
                        #negative speed means moving backwards)
    stop                #accelerates negative if moving forward (and vice versa),
                        #may take 8 ticks to stop (and you have to call it every tick)
    fire(power)         #fires a bullet in the direction of your gun,
                        #power is 0.1 - 3, this power will heat your gun
    turn(degrees)       #turns the robot (and the gun and the radar),
                        #max 10 degrees per tick
    turn_gun(degrees)   #turns the gun (and the radar), max 30 degrees per tick
    turn_radar(degrees) #turns the radar, max 60 degrees per tick
    dead                #true if you are dead
    say(msg)            #shows msg above the robot on screen
    broadcast(msg)      #broadcasts msg to all bots (they receive 'broadcasts'
                        #events with the msg and rough direction)

### Useful resources: ###

http://rubydoc.info/gems/rrobots/0.0.1/frames

https://github.com/ralreegorganon/rrobots

http://rubyforge.org/forum/?group_id=1109

## Thanks
Thanks to https://github.com/ruby-meetup-resources/robotwars, we used their repo to make this one
Thanks to https://github.com/ralreegorganon/rrobots for making this possible through their fork

If you also want to say thanks to the contributors.. just click the image below ;)

[![Thank ruby-meetup](https://raw.githubusercontent.com/thankadeveloper/thankadeveloper/master/app/assets/images/badge.png)](http:/thankadeveloper.org?repo=ruby-meetup-resources/robotwars)
[![Thank ralreegorganon](https://raw.githubusercontent.com/thankadeveloper/thankadeveloper/master/app/assets/images/badge.png)](http:/thankadeveloper.org?repo=ralreegorganon/rrobots)
