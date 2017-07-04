#!/bin/bash
###################################################################################################
## Example workflow script for CLC Server Command Line Tools 2.1
## CLC bio, June 2014
##
## For full documentation please visit: https://www.qiagenbioinformatics.com/support/manuals/
###################################################################################################
### SETTINGS (Edit before use) ####################################################################
# 1. Configure your server connection parameters
SERVER="localhost"
PORT="7777"
USER="root"
PASSWORD="default"
# 2. Configure the path to the CLC Server Command Line tools
SERVERCMDPATH="/home/user/clcservercmdline/clcserver"
PARSECMDPATH="/home/user/clcservercmdline/clcresultparser"
# 3. Configure High-throughput sequencing data import location for import data
#  - Use the server web-interface to setup a data import location
#  - Copy the example files from the data directory to this location
#  - Edit the IMPORTPATH variable below to a CLC URL point to this location
#
# For more info please visit:
# http://resources.qiagenbioinformatics.com/manuals/clcgenomicsserver/current/admin/index.php?manual=Accessing_files_on_writing_to_areas_server_filesystem.html
#
# For information about CLC URLs please visit:
# http://resources.qiagenbioinformatics.com/manuals/clcservercommandlinetools/current/index.php?manual=Data_objects_data_files_CLC_URL.html
IMPORTPATH="clc://serverfile/tmp/cmdline"
# 4. Configure data paths for saving results
#  - Use the server web-interface to configure a file system location for data storage
#  - Edit the DATAPATH variable below to a CLC URL pointing to this location
#
# For more info please visit:
# http://resources.qiagenbioinformatics.com/manuals/clcgenomicsserver/current/admin/index.php?manual=Adding_file_system_location.html
#
# For information about CLC URLs please visit:
# http://resources.qiagenbioinformatics.com/manuals/clcservercommandlinetools/current/index.php?manual=Data_objects_data_files_CLC_URL.html
DATAPATH="clc://server/test"
DIR="clc-example"
SUBDIR="workflow-example"
### FUNCTIONS #####################################################################################
function check_return_code {
	return_code=$?
	cmdname=$1
	#echo Return code: $return_code
	if [ $return_code -ne 0 ]
	then
		echo ""
		echo "### Error during: $cmdname ###"
		echo "Terminating script"
		exit 1
	fi
}
### COMMANDS ######################################################################################
SERVERCMD="$SERVERCMDPATH -S $SERVER -P $PORT -U $USER -W $PASSWORD"
PARSECMD=$PARSECMDPATH
### WORKFLOW SCRIPT ###############################################################################
# Make a directory for DIR
echo ""
echo "Make a directory: $DIR"
$SERVERCMD -A mkdir \
           -t ${DATAPATH} \
           -n ${DIR} \
           -O tmpdir_result.txt
check_return_code "make dir"
tmpdir=`$PARSECMD -f "tmpdir_result.txt" \
                  -c "clc-example"`
check_return_code "make dir result parsing"
rm tmpdir_result.txt
# Make subdirectory in DIR folder for result and data
echo ""
echo "Make subdirectory: $SUBDIR"
$SERVERCMD -A mkdir \
           -t ${tmpdir} \
           -n ${SUBDIR} \
           -O mkdir_result.txt
check_return_code "Make sub dir"
destdir=`$PARSECMD -f mkdir_result.txt \
                   -p "-d" \
                   -c $SUBDIR`
check_return_code "Make sub dir result parsing"
rm mkdir_result.txt
# Import solid data
echo ""
echo "Import solid data"
$SERVERCMD -A ngs_import_solid \
           -f "$IMPORTPATH/solid_matepair_F3.csfasta" \
           -f "$IMPORTPATH/solid_matepair_F3._QV.qual" \
           -f "$IMPORTPATH/solid_matepair_R3.csfasta" \
           -f "$IMPORTPATH/solid_matepair_R3._QV.qual" \
           --paired-reads true \
           --read-orientation FORWARD_FORWARD \
           --min-distance 100 \
           --max-distance 25000 \
           ${destdir} \
           -O ngs_import_solid_result.txt
check_return_code "Import solid data"
soliddata=`$PARSECMD -f ngs_import_solid_result.txt \
                     -p "-i" \
                     -c "solid" \
                     --ignorelog true`
check_return_code "Import solid data result parsing"
rm ngs_import_solid_result.txt
# Import genome
echo ""
echo "Import genome"
$SERVERCMD -A import \
           -f automaticimport \
           -s "$IMPORTPATH/reference.fa" \
           ${destdir} \
           -O import_result.txt
check_return_code "Import genome"
refdata=`$PARSECMD -f import_result.txt \
                   -p "--references" \
                   -c "reference"`
check_return_code "Import genome result parsing"
rm import_result.txt
# Do readmapping
echo ""
echo "Read Mapping"
$SERVERCMD -A read_mapping \
           ${soliddata} \
           ${destdir} \
           ${refdata} \
           -O read_mapping_result.txt
check_return_code "Read Mapping"
echo $PARSECMD -f read_mapping_result.txt -p "-i" -c "mapping"
readmap=`$PARSECMD -f read_mapping_result.txt \
                   -p "-i" \
                   -c "Reads" \
                   --ignorelog true`
check_return_code "Read Mapping result parsing"
rm read_mapping_result.txt
# Basic Variant Detection
echo ""
echo "Basic Variant Detection"
$SERVERCMD -A model_free_variant_detection \
           --create-table true \
           --min-coverage 1 \
           ${readmap} \
           ${destdir} \
           -O variants_result.txt
check_return_code "Basic Variation Detection"
table=`$PARSECMD -f variants_result.txt \
                 -p "-i" \
                 -c "(Reads)"`
check_return_code "Basic Variation Detection result parsing"
rm variants_result.txt
# Export variant table to excel
echo ""
echo "Export variant table to excel"
$SERVERCMD -A export \
           -e excel_2010 \
           -d $IMPORTPATH \
           ${table} \
           -O table_export_result.txt
check_return_code "Export variant table to excel"
file=`$PARSECMD -f table_export_result.txt \
                -O ClcUrl`
check_return_code "Export variant table to excel result parsing"
rm table_export_result.txt
# Workflow completed
echo ""
echo "Workflow completed succesfully"
echo "Variant table: ${file}"