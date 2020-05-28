#!/bin/bash

env | grep TERRARIA | sed -e 's/TERRARIA_//' - | sed -e 's/\([^=]*\)/\L\1/' > /terraria/config.txt

cat /terraria/config.txt

set -x

$@