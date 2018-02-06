# Zarafa Mail Storage Index

This script scans for any emails (both plaintext and gzipped) in the storage directory.
Scan time depends on the size of directory.

After the scan is done, you'll have a MySQL table with file path, email date and time, from and to fields. 

### How to install

* Import base.sql to MySQL
* Install procmail and mysql-client
* Edit variables in **run.sh**
* ./run.sh

Enjoy! Please put a star if you like!
