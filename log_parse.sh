#!/bin/bash
#
# Bash script used to convert log files into JSON array.  
#
# Usage:
# ./log_parse.sh <input file>
#
# Log format is space delimited with key=value pairs.
# Example:
# item1=1 item2=2 item3=3 ...
# item4=4 item5=5 item6=6 ...
# ...
#


awk -v totallines=$(awk 'END{print NR}' $1) '
BEGIN{
    # Initialize some variables:

    # Uncomment to supply custom input field separator.
    # FS = ""

    # Uncomment to supply custom record separator.
    # RS = ""

    # Set output field separator.
    OFS = "\": \""

    # Set output record separator.
    ORS = ""

    # Set delimiter of key value pairs nested in the log.
    SPLIT = "="

    # Start JSON array
    print "[" 
}
{
    print "{"
    # Iterate through every field in the current record.
    for(i=1; i<=NF; i++) 
        {
        # Split the current VALUE ($i) at the current field/column NUMBER (i).
        split( $i, a, SPLIT)

        # Check to see if the current field/column NUMBER (i) is the last (NF) in the currecnt record.  This handles the placement of commas.
        if (i<NF){
            print "\"" a[1], a[2]"\","
            }
        # Hit the last field; no comma needed.
        else{
            print "\"" a[1], a[2]"\""
            }
        }
    # Place comma between records.
    if(FNR!=totallines){
        print "},\n"
    }
    # Do not place comma on the last record.
    else{
        print "}"
    }
}
END{
    print "]"
}' $1