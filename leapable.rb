require "artoo"

$tick = 0

connection :leapmotion, :adaptor => :leapmotion, :port => '127.0.0.1:6437'
device :leapmotion, :driver => :leapmotion, :connection => :leapmotion

connection :sphero, :adaptor => :sphero, :port => '0.0.0.0:9998'
device :sphero, :driver => :sphero, :connection => :sphero

work do
  on sphero, :collision => :on_collision
  sphero.set_color :red
  on leapmotion, :open => :on_open
  on leapmotion, :frame => :on_frame
  on leapmotion, :close => :on_close
end

def on_open(*args)
  puts args
  sphero.roll 30, 0
end

def on_frame(*args)
  frame = args[1]

  $tick += 1
  return unless $tick % 60 == 0
  if hand = frame.hands[0]
    x, y, z = hand.palmPosition
    puts y
    z *= -1
    degrees = Math.atan2(z, x) * (180 / Math::PI)
    direction = (degrees < 0 ? [degrees + 365, 365].min : degrees).round
    puts direction
    sphero.roll 50, direction
  end
end

# def on_frame(*args)
#   frame = args[1]
#   $tick += 1
#   return unless $tick % 60 == 0
#   if hand = frame.hands[0]
#     x, z, y = hand.palmPosition
#     puts "#{x}, #{y}"
#     y *= -1 if x < 0
#     ox, oy = [0, 1]
#     magnitude = Math.sqrt( (x*x) + (y*y) )
#     nx, ny = [x / magnitude, y / magnitude]
#     dot_product = (nx * ox) + (ny * oy)
#     go_forward = [Math.acos(dot_product) * 180 / Math::PI, 365].min
#     puts go_forward
#     sphero.roll 50, go_forward.round
#   end
# end

def on_close(*args)
  puts "Closed"
  puts args
end

def on_collision(*args)
  puts "Hit"
end
