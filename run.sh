export PROGRAM_NAME="wavecuda2"

cd wave
nvcc $PROGRAM_NAME.cu -o $PROGRAM_NAME
nvprof ./$PROGRAM_NAME 1024 100

echo "GENERATING GIF"
convert -delay 1x10 wave1*.bmp ../wave.gif
rm wave1*.bmp
# rm $PROGRAM_NAME

echo "END"