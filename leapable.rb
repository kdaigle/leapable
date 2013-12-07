require "artoo"

$tick = 0

$health = 3
HEALTH_COLORS = {
  3 => [0, 255, 0],
  2 => [255, 255, 0],
  1 => [255, 140, 0],
  0 => [255, 0, 0]
}

$hands_seen = false

$started_at = nil
$game_over = false

connection :leapmotion, :adaptor => :leapmotion, :port => '127.0.0.1:6437'
device :leapmotion, :driver => :leapmotion, :connection => :leapmotion

connection :sphero, :adaptor => :sphero, :port => '0.0.0.0:9998'
device :sphero, :driver => :sphero, :connection => :sphero

work do
  sphero.set_color :white
  sphero.roll 40, 90
  on sphero, :collision => :on_collision
  on leapmotion, :frame => :on_frame
end

def hit
  puts "Hit"
  $health -= 1
  set_color_by_health
  game_over if $health <= 0
end

def game_over
  sphero.stop
  puts "Game Over! Your time: #{Time.now - $started_at}"
  $game_over = true
end

def set_color_by_health
  sphero.set_color *HEALTH_COLORS[$health]
end

def on_frame(*args)
  return if $game_over
  frame = args[1]

  $tick += 1
  return unless $tick % 65 == 0
  if hand = frame.hands[0]
    unless $hands_seen
      $hands_seen = true
      $started_at = Time.now
      puts "Started: #{$started_at}"
    end
    min_speed = 60
    max_speed = 120
    x, y, z = hand.palmPosition
    speed = y < 150 ? 50 : (y / 300) * max_speed
    z *= -1
    x *= -1
    degrees = Math.atan2(z, x) * (180 / Math::PI)
    direction = (degrees < 0 ? [degrees + 360, 360].min : [degrees, 360].min).round
    puts direction
    set_color_by_health
    sphero.roll speed, direction
  elsif $hands_seen
    sphero.set_color :white
    sphero.stop
  end
end

def on_collision(*args)
  x, y, z, axis, x_mag, y_mag, speed, timestamp = args[1].body
  hit if [x_mag, y_mag].max > 46
end
