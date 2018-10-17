# marklogic-meters-export-tools
Tools for reviewing content from exported RAW Meters data 

## Setup

Create app server with the path:
/path/to/marklogic-meters-export-tools/src/main/xquery

Indexes:

http://marklogic.com/manage/meters
host-name
string

http://marklogic.com/manage/meters
start-time
dateTime


## Export

https://help.marklogic.com/knowledgebase/article/View/530/0/exporting-metering-data

## Import

 mlcp-9.0.7/bin/mlcp.sh import -host localhost -port 8000 -database Meters -username username -password password -input_file_path /path/to/your/metersData/ -input_file_type documents -input_compressed true -mode local -thread_count 10 -batch_size 10

