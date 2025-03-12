#!/bin/bash

ip_address=$(cat /home/s4njer/.config/bin/target)

if [ $ip_address ]; then
  echo "%{F#E05F65}󰓾 %{F#DEE1E6}$ip_address"
else
  echo "%{F#E05F65}󰓾 %{F#DEE1E6}No target"
fi
