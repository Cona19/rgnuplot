#!/bin/bash

#if [ \( -z "$1" \) -o \( -z "$2" \) ]
if [ -z "$1" ]
then
    echo "Usage : $0 gnuplot_script_file [output_image_file]"
    exit
fi

SCRIPT_FILE=$1
if [ -z "$2" ]
then
    OUTPUT_FILE="output.png"
else
    OUTPUT_FILE=$2
fi

USER=hyeonseok
HOST=10.211.55.24
HOST_DIR=gnuplot
PORT=22
BASE_SETTING="set terminal png size 800,600 enhanced font 'Helvetica,20';\
    set output '$OUTPUT_FILE'"

echo "Send $SCRIPT_FILE to $USER@$HOST:$HOST_DIR/script.p with $PORT port number..."
scp -P $PORT $SCRIPT_FILE $USER@$HOST:$HOST_DIR/script.p

echo "Execute $SCRIPT_FILE in server..."
ssh $USER@$HOST -p $PORT "cd $HOST_DIR && gnuplot -e \"$BASE_SETTING; load 'script.p'\""

echo "Receive output image to $OUTPUT_FILE..."
scp -P $PORT $USER@$HOST:$HOST_DIR/output.png $OUTPUT_FILE

echo "Open $OUTPUT_FILE..."
open $OUTPUT_FILE
