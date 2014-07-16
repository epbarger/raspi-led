#!/usr/bin/env ruby

`sh -c 'echo none > /sys/class/leds/led0/trigger'`    # disable trigger
poll_rate = ARGV[0] ? ARGV[0].to_i : 5                # set polling rate (default 5)
status = :off

while true
  ssh_user_count = `who | grep pts | wc -l`.to_i
  if (ssh_user_count > 0) && (status == :off)
    `sh -c 'echo 1 > /sys/class/leds/led0/brightness'`
     status = :on
  elsif (ssh_user_count == 0) && (status == :on)
    `sh -c 'echo 0 > /sys/class/leds/led0/brightness'`
     status = :off
  end

  sleep poll_rate
end
