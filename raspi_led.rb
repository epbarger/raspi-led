#!/usr/bin/env ruby

MODES = %w(none mmc0 timer oneshot heartbeat backlight gpio cpu0 default-on)

# Add the name of your mode here
CUSTOM_MODES = %w(ssh-user hot-temp high-avg-cpu turbo-on)

# Conditions added must return an integer
# 1 or greater will turn the LED on
# 0 will turn it off
CONDITIONS = { 
               'ssh-user'     => lambda{ `who | grep pts | wc -l`.to_i },
               'hot-temp'     => lambda{ `/opt/vc/bin/vcgencmd measure_temp`.match('[0-9]{2}')[0].to_i >= 60 ? 1 : 0 },
               'high-avg-cpu' => lambda{ (`uptime`.match('0\.[0-9]{2}')[0].to_f * 100).to_i >= 80 ? 1 : 0 },
               'turbo-on'     => lambda{ `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`.to_i > 700000 ? 1 : 0 } 
             }

$poll_rate = ARGV[1] ? ARGV[1].to_i : 5
$status = :off


### Methods ###

def led_on
  `echo 1 > /sys/class/leds/led0/brightness`
  $status = :on
end

def led_off
  `echo 0 > /sys/class/leds/led0/brightness`
  $status = :off
end

def print_modes
  puts "Custom Modes:"
  puts "\t#{CUSTOM_MODES.join(' ')}"
  puts "Firmware Modes:"
  puts "\t#{MODES.join(' ')}"
end


### Script ###

if ARGV[0]
  mode = ARGV[0]
else
  print_modes
  exit
end

if CUSTOM_MODES.include?(mode) && CONDITIONS[mode]
  `echo none > /sys/class/leds/led0/trigger`
  led_off
  while true
    if (CONDITIONS[mode].call >= 1) && ($status == :off)
      led_on
    elsif (CONDITIONS[mode].call == 0) && ($status == :on)
      led_off
    end
    sleep $poll_rate
  end

elsif MODES.include?(mode)
  led_off
  `echo #{mode} > /sys/class/leds/led0/trigger`
  exit

else
  puts "'#{mode}' is not a valid mode"
  print_modes
  abort
end
