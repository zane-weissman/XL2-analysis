#######################################
# Create CSV from NTI Audio XL2 Log
#######################################

# Largely adapted from Matthew Costi's soundscape-analyzer (https://github.com/mscosti/soundscape-analyzer)
# relevant code can be found in soundscape-analyzer/src/CreateCSV.py

# This script writes data from the "broadband LOG Results" section of an NTI XL2
# audio analyzer log file. This section contains measurements specified in the 
# logging settings of the XL2. The script will write the first measurement 
# specified for logging into a comma separated value (CSV) file which can be read by
# spreadsheet programs like Excel. The columns will be as follows, in order:
#   - year
#   - month
#   - day
#   - hour
#   - minute
#   - second
#   - data (i.e. the first measurement specificed in the XL2 logging settings)

# USAGE 
#############################
# This script takes command line arguments. Each command line argument specifies a 
# plaintext XL2 log file to be read and converted to a CSV file.
# >python2 CreateCSV.py logFile1 [logFile2 ...]

# FUNCTIONS
#############################

# gets the starting line of a data portion of an XL2 log file
# returns all of the lines of the file and the line at which the data in the section
# specified by the delimeter starts. The skipln parameter allows the function to skip a few lines after the delimeter before the data begins.
def get_starting_line(logFile,delimeter,skipln):
    raw_log = open(logFile) # open file
    raw_lines = raw_log.read().split('\n') # split file by line
    line_cnt = 0
    for line in raw_lines: 
      if delimeter in str(line): # look for delimiter
        line_cnt += skipln # add offset
        break;
      line_cnt += 1
    return raw_lines,line_cnt

# MAIN
#############################

import csv
import datetime
import sys

for logFile in sys.argv[1:]: # iterate through arguments - each of which is a log file

  # read lines from the log file and identify the start of the data that will be
  # copied into the CSV
  log_lines, line_cnt = get_starting_line(logFile,"# Broadband LOG Results",3)

  # prepare CSV writer object
  dest_name = logFile+'.csv' # append '.csv' to create CSV file name
  log_csv = open(dest_name,'wb')
  log_writer = csv.writer(log_csv,dialect='excel')

  for line in log_lines[line_cnt:]: # iterate through lines in the log file
      words = line.split() # split line by whitespace
      if len(words) >= 4: # read until a line is unreadable - the end of the data
          
          # parse the line day/date and data
          year,month,day = words[0].split('-')
          hours,mins,secs = words[1].split(':')
          data = words[3]

          # convert to numbers
          year = int(year)
          month = int(month)
          day = int(day)
          hours = int(hours)
          mins = int(mins)
          secs = int(secs)
          data = float(data)
          
          # write row to CSV
          log_writer.writerow([year,month,day,hours,mins,secs,data])
          
      else:
          break # break when line is unreadable
      

  print "Decibel readings CSV File created with filename '%s'"%dest_name

