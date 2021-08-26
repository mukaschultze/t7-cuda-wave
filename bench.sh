#!/usr/bin/bash

cd wave


echo "wave_seq_1024_100 ---------------------------------------"
./wave 1024 100
echo "END -----------------------------------------------------"

echo "wavecuda1_1024_100 ---------------------------------------"
nvprof ./wavecuda1 1024 100
echo "END -----------------------------------------------------"

echo "wavecuda2_1024_100 ---------------------------------------"
nvprof ./wavecuda2 1024 100
echo "END -----------------------------------------------------"  


echo "wave_seq_1024_200 ---------------------------------------"
./wave 1024 200
echo "END -----------------------------------------------------"

echo "wavecuda1_1024_200 ---------------------------------------"
nvprof ./wavecuda1 1024 200
echo "END -----------------------------------------------------"  

echo "wavecuda2_1024_200 ---------------------------------------"
nvprof ./wavecuda2 1024 200
echo "END -----------------------------------------------------"  


echo "wavecuda1_2048_100 ---------------------------------------"
./wave 2048 100
echo "END -----------------------------------------------------"

echo "wavecuda1_2048_100 ---------------------------------------"
nvprof ./wavecuda1 2048 100
echo "END -----------------------------------------------------"

echo "wavecuda1_2048_100 ---------------------------------------"
nvprof ./wavecuda2 2048 100
echo "END -----------------------------------------------------"


echo "wave_seq_2048_200 ---------------------------------------"
./wave 2048 200
echo "END -----------------------------------------------------"

echo "wavecuda1_2048_200 ---------------------------------------"
nvprof ./wavecuda1 2048 200
echo "END -----------------------------------------------------"

echo "wavecuda2_2048_200 ---------------------------------------"
nvprof ./wavecuda2 2048 200
echo "END -----------------------------------------------------"
