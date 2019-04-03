# marklogic-meters-export-tools

Tools for reviewing content from exported RAW Meters data 

## Setup

Create app server with the path:
/path/to/marklogic-meters-export-tools/src/main/xquery

### Element range indexes

```
scalar type: string
namespace uri: http://marklogic.com/manage/meters
localnames: host-name, database-name
collation: http://marklogic.com/collation/

scalar type: dateTime
namespace uri: http://marklogic.com/manage/meters
localname: start-time

scalar type: unsignedLong
namespace uri: http://marklogic.com/manage/meters
localname: memory-process-size
```

## Export

https://help.marklogic.com/knowledgebase/article/View/530/0/exporting-metering-data

## Importing the data (using MLCP)

```bash
 mlcp-9.0.7/bin/mlcp.sh import -host localhost -port 8000 -database Meters -username username -password password -input_file_path /path/to/your/metersData/ -input_file_type documents -input_compressed true -mode local -thread_count 10 -batch_size 10
```