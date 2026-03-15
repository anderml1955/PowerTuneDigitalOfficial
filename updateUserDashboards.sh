#!/bin/sh
echo "copy new Dashboards"
# rsync -a -v --ignore-existing /home/pi/src/exampleDash/Logo/*.png /home/pi/Logo/
# rsync -a -v --ignore-existing /home/pi/src/exampleDash/Logo/*.gif /home/pi/Logo/
# rsync -a -v --ignore-existing /home/pi/src/exampleDash/UserDashboards/*.txt /home/pi/UserDashboards/
# Make github file the masters so any changes to them will always be sent.
rsync -a -v /home/pi/src/exampleDash/Logo/*.png /home/pi/Logo/
rsync -a -v /home/pi/src/exampleDash/Logo/*.gif /home/pi/Logo/
rsync -a -v /home/pi/src/exampleDash/UserDashboards/*.txt /home/pi/UserDashboards/

# Don't need this with the above changes to always overwrite the dash copies with github files
#echo "fix MFD"
#cp /home/pi/src/exampleDash/UserDashboards/MFD.txt /home/pi/UserDashboards/
#cp /home/pi/src/exampleDash/UserDashboards/s2000dash.txt /home/pi/UserDashboards/
