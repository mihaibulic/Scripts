#!/bin/bash

if [ $# -eq 0 ]; then
    echo -e "below are the options";
    echo -e "-p --perf: performance mode baby!";
    echo -e "-s --save: battery save mode";
    echo -e "-a --auto: so-so";
    exit;
fi

if [ "${1}" == "--perf" -o "${1}" == "-p" ]; then #remote backup
    sudo pm-powersave false;
    xbacklight -set 100;

    sudo echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
    sudo echo "performance" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
    sudo echo "performance" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
    sudo echo "performance" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
elif [ "${1}" == "--save" -o "${1}" == "-s" ]; then #remote backup
    sudo pm-powersave true;
    xbacklight -set 25;

    sudo echo "powersave" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
    sudo echo "powersave" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
    sudo echo "powersave" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
    sudo echo "powersave" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
elif [ "${1}" == "--auto" -o "${1}" == "-a" ]; then #remote backup
    xbacklight -set 62;

    sudo echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
    sudo echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor;
    sudo echo "ondemand" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor;
    sudo echo "ondemand" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor;
else
    echo -e "error: ${1} is an unrecognized option";
    exit;
fi

