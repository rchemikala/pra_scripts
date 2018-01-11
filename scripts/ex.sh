#!/bin/bash

## regexp example to replace numbers using awk

fileName="32142343system.tbl01"

#val=$(echo $fileName | gawk '{ print gensub(/[0-9]/, "",8, $fileName) }') 
val=$(echo $fileName | cut -c9-) 



echo "Value = $val "; 




