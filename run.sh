#!/bin/bash

if [ ! -f /home/openplc/scripts/script.st ]; then
    echo "Structured text file missing!"
    exit 1
fi

if [ ! -f /home/openplc/scripts/mbconfig.cfg ]; then
    echo "Config file missing!"
    exit 1
fi

SQL_SCRIPT="INSERT INTO Programs (Name, Description, File, Date_upload) VALUES ('Hauptprogramm', 'Dies ist das Hauptprogramm fuer diese BUSSEplc-Einheit.', 'script.st', strftime('%s', 'now'));"
SQL_DEVICE="INSERT INTO Slave_dev (dev_name, dev_type, slave_id, com_port, baud_rate, data_bits, stop_bits, di_start, di_size, coil_start, coil_size, ir_start, ir_size, hr_read_start, hr_read_size, hr_write_start, hr_write_size) VALUES ('Arduino Mega', 'Mega', 1, '/dev/ttyAMA0', 115200, 8, 1, 0, 24, 0, 16, 0, 16, 0, 0, 0, 12);"
SQL_AUTOST="UPDATE Settings SET Value = 'true' WHERE Key = 'Start_run_mode';"

cp /home/openplc/scripts/script.st /home/openplc/OpenPLC_v3/webserver/st_files
sqlite3 /home/openplc/OpenPLC_v3/webserver/openplc.db "$SQL_SCRIPT"

cp /home/openplc/scripts/mbconfig.cfg /home/openplc/OpenPLC_v3/webserver
sqlite3 /home/openplc/OpenPLC_v3/webserver/openplc.db "$SQL_DEVICE"

sqlite3 /home/openplc/OpenPLC_v3/webserver/openplc.db "$SQL_AUTOST"

sudo /home/openplc/OpenPLC_v3/start_openplc.sh
