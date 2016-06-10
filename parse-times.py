import sys
from datetime import datetime
import time

# create output file

output = open("parsed.times", "w")

# open file, read lines
# must provideo file name to parse

fp = open(sys.argv[1],'r+')
fpLines = fp.readlines()

# create reference time of installs
# divide by lines, splut by spaces
# drop last two entrieds, combine date entries
# datetime to format time

firstLine = fpLines[0]
firstLine = list(firstLine.split())
firstLine = firstLine[:6]
firstLine[2:6] = [' '.join(firstLine[2:6])]
dateLine = firstLine[2]
referenceDate  = datetime.strptime(dateLine, "%a %b %d %H:%M:%S")
print("Reference Date: ", referenceDate)

# loop through and repeat for each line

for line in fpLines:
    line = list(line.split())
    line = line[:6]
    line[2:6] = [' '.join(line[2:6])]
    dateLine = line[2]
    formattedDate = datetime.strptime(dateLine, "%a %b %d %H:%M:%S")
    
    # calculate time and seconds passed

    deltaTime = formattedDate - referenceDate 
    secondsElapsed = deltaTime.total_seconds()

    # format output file
    
     print (' '.join(line[:2]), secondsElapsed, file=output)
