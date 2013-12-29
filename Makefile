.SUFFIXES: .f .F .F90 .f90 .o .mod
.SHELL: /bin/sh

.PHONY : usage
usage:
	@echo ""
	@echo "    * USAGE * "
	@echo ""
	@echo " make test       : compiles the test program test_ncio.x"
	@echo " make clean      : cleans object and executable files"
	@echo ""

objdir = .obj

ifort ?= 0
debug ?= 0 
f2py  ?= 0 

ifeq ($(ifort),1)
    FC = ifort 
else
    FC = gfortran
endif 

ifeq ($(f2py),1)
    FC = f2py
endif 

ifeq ($(ifort),1)
	## IFORT OPTIONS ##
	FLAGS        = -module $(objdir) -L$(objdir) -I/home/robinson/apps/netcdf/netcdf/include
	LFLAGS		 = -L/home/robinson/apps/netcdf/netcdf/lib -lnetcdf

	ifeq ($(debug), 1)
	    DFLAGS   = -C -traceback -ftrapuv -fpe0 -check all -vec-report0
	    # -w 
	else
	    DFLAGS   = -vec-report0 -O3
	endif
else
	## GFORTRAN OPTIONS ##
	FLAGS        = -I$(objdir) -J$(objdir) -I/opt/local/include
	LFLAGS		 = -L/opt/local/lib -lnetcdff -lnetcdf

	ifeq ($(debug), 1)
	    DFLAGS   = -w -p -ggdb -ffpe-trap=invalid,zero,overflow,underflow -fbacktrace -fcheck=all
	else
	    DFLAGS   = -O3
	endif
endif

## Individual libraries or modules ##
$(objdir)/ncio.o: ../ncio/ncio3.f90
	$(FC) $(DFLAGS) $(FLAGS) -c -o $@ $<

## Complete programs

test: $(objdir)/ncio.o
	$(FC) $(DFLAGS) $(FLAGS) -o test_ncio.x $^ test_ncio.f90 $(LFLAGS)
	@echo " "
	@echo "    test_ncio.x is ready."
	@echo " "

clean:
	rm -f test_ncio.x $(objdir)/*.o $(objdir)/*.mod
