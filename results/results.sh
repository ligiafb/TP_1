#!/bin/bash
cat *.out | grep sender | awk -F' ' '{print $7}' > data
soma=$(paste -sd+ data | bc)
div=$(cat data | wc -l)
total=`echo "scale=2 ; $soma / $div" | bc`
echo "ft ecmp8 tcp 1flow average : $total" > average.txt
echo "ft ecmp8 tcp 1flow average : $total"
