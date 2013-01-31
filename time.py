#!/usr/bin/python
# breaks down time management for 1 week based on schedule (run with <time for hw> <time for misc stuff> as args)
# must edit to change time for sleep (ln 15), eating (ln 16), class (ln 17), and work (ln 18)

import sys

if sys.argv[1] == "--help" or sys.argv[1] == "-h":
    print "breaks down how to spend time\n"
    print "run as ./time <hw time> <misc time>"
    exit()

hw=sys.argv[1]
misc=sys.argv[2]
week = 168 #7*24
sleep = 9*7 #8 hours/day + wake up time
food = 2*7 #2 hours/day
class_time = 15+5 #15 hours of class, 5 hrs of travel time to/from
work_time = 22+3 #22 hours of work, 3 hrs of travel time to/from

print "\n*********************************************************"
print "Total time:\t\t\t\t" + str(week)

left = week-sleep-food
if left < 0:
    print "\n...wait.  This is impossible!"
    exit()
print "Time left after necessary things:\t" + str(left)

left -= class_time+work_time
if left < 0:
    print "\n...wait.  This is impossible!"
    exit()
print "Time left after class/work:\t\t" +str(left)

left -= (int(hw)+int(misc))
if left < 0:
    print "\n...wait.  This is impossible!"
    exit()
print "Time left after hw/misc:\t\t" +str(left)

left *= 0.8
print "Time left after inaccuracies:\t\t" +str(left)

if left > 5:
    pa = 5
    left -= 5;
else:
    pa = left
    left = 0

if left > 0:
    pf = left/2
    af = left/2
    left = 0
else:
    pf = 0
    af = 0

print "\nProductive fun:\t\t\t\t" + str(pf) 
print "Active fun:\t\t\t\t" + str(af)
print "Passive activities:\t\t\t" + str(pa)
print "*********************************************************\n"
