#!/bin/bash



NETCDF=/share/kkraid/zhaos/apps/netcdf4-intel2016
rm -f main

ifort -I${NETCDF}/include ncio.F90 test_ncio.F90 -L${NETCDF}/lib -lnetcdf -lnetcdff -o main

./main

rm -f *.o *.mod
