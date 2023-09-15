#!/bin/bash
# https://nwchemgit.github.io/Compiling-NWChem.html
# Set up environment variables
export NWCHEM_TOP=$HOME/calc/nwchem/
export NWCHEM_TARGET=LINUX64
export NWCHEM_MODULES=qm
export USE_MPI=y
export USE_INTERNALBLAS=y

if [[ -f $NWCHEM_TOP/bin/LINUX64/nwchem ]]; then
    rm $NWCHEM_TOP/bin/LINUX64/nwchem
fi


check_binary() {
    if [[ ! -f $NWCHEM_TOP/bin/LINUX64/nwchem ]]; then
        echo "Error: nwchem binary was not created!"
        exit 1
    fi
}

# Function to compile solvation
compile_solvation() {
    echo "solvation"
    cd $NWCHEM_TOP/src/solvation
    gfortran -c -m64 -ffast-math -Wuninitialized -fno-aggressive-loop-optimizations -std=legacy -fdefault-integer-8 -fno-tree-dominator-opts -O2 -Wuninitialized -fno-aggressive-loop-optimizations -O3 -mfpmath=sse -fno-tree-dominator-opts -ffast-math -fprefetch-loop-arrays -ftree-vectorize -mtune=native -I. -I../nwdft/include -I../ddscf -I$NWCHEM_TOP/src/include -I$NWCHEM_TOP/src/tools/install/include -DGFORTRAN -DCHKUNDFLW -DGCC4 -DGCC46 -DEXT_INT -DLINUX -DLINUX64 -DPARALLEL_DIAG -DBLAS_NOTHREADS -DUSE_INTEGER8 hnd_coschg.F
    gfortran -c -m64 -ffast-math -Wuninitialized -fno-aggressive-loop-optimizations -std=legacy -fdefault-integer-8 -fno-tree-dominator-opts -O2 -Wuninitialized -fno-aggressive-loop-optimizations -O3 -mfpmath=sse -fno-tree-dominator-opts -ffast-math -fprefetch-loop-arrays -ftree-vectorize -mtune=native -I. -I../nwdft/include -I../ddscf -I$NWCHEM_TOP/src/include -I$NWCHEM_TOP/src/tools/install/include -DGFORTRAN -DCHKUNDFLW -DGCC4 -DGCC46 -DEXT_INT -DLINUX -DLINUX64 -DPARALLEL_DIAG -DBLAS_NOTHREADS -DUSE_INTEGER8 hnd_cosmo_lib.F
    #make 
    cd ..
    gfortran -m64 -ffast-math -Wuninitialized -fno-aggressive-loop-optimizations -std=legacy -fdefault-integer-8 -fno-tree-dominator-opts -g -fno-aggressive-loop-optimizations -fno-tree-dominator-opts -g -O0 -fno-aggressive-loop-optimizations -I. -I$NWCHEM_TOP/src/include -I$NWCHEM_TOP/src/tools/install/include -DGFORTRAN -DCHKUNDFLW -DGCC4 -DGCC46 -DEXT_INT -DLINUX -DLINUX64 -DPARALLEL_DIAG -DBLAS_NOTHREADS -DCOMPILATION_DATE="'`date +%a_%b_%d_%H:%M:%S_%Y`'" -DCOMPILATION_DIR="'$NWCHEM_TOP'" -DNWCHEM_BRANCH="'7.0.0'" -c -o nwchem.o nwchem.F
    gfortran -m64 -ffast-math -Wuninitialized -fno-aggressive-loop-optimizations -std=legacy -fdefault-integer-8 -fno-tree-dominator-opts -g -fno-aggressive-loop-optimizations -fno-tree-dominator-opts -g -O0 -fno-aggressive-loop-optimizations -I. -I$NWCHEM_TOP/src/include -I$NWCHEM_TOP/src/tools/install/include -DGFORTRAN -DCHKUNDFLW -DGCC4 -DGCC46 -DEXT_INT -DLINUX -DLINUX64 -DPARALLEL_DIAG -DBLAS_NOTHREADS -DCOMPILATION_DATE="'`date +%a_%b_%d_%H:%M:%S_%Y`'" -DCOMPILATION_DIR="'$NWCHEM_TOP'" -DNWCHEM_BRANCH="'7.0.0'" -c -o stubs.o stubs.F
    gfortran -L$NWCHEM_TOP/lib/LINUX64 -L$NWCHEM_TOP/src/tools/install/lib -o $NWCHEM_TOP/bin/LINUX64/nwchem nwchem.o stubs.o -lnwctask -lccsd -lmcscf -lselci -lmp2 -lmoints -lstepper -ldriver -loptim -lnwdft -lgradients -lcphf -lesp -lddscf -ldangchang -lguess -lhessian -lvib -lnwcutil -lrimp2 -lproperty -lsolvation -lnwints -lprepar -lnwmd -lnwpw -lofpw -lpaw -lpspw -lband -lnwpwlib -lcafe -lspace -lanalyze -lqhop -lpfft -ldplot -ldrdy -lvscf -lqmmm -lqmd -letrans -lpspw -ltce -lbq -lmm -lcons -lperfm -ldntmc -lccca -ldimqm -lfcidump -lgwmol -lnwcutil -lga -larmci -lpeigs -lperfm -lcons -lbq -lnwcutil -lnwclapack -lnwcblas -L/usr/lib/x86_64-linux-gnu/openmpi/lib/fortran/gfortran -lmpi_usempif08 -lmpi_usempi_ignore_tkr -lmpi_mpifh -lmpi -lopen-rte -lopen-pal -lhwloc -levent_core -levent_pthreads -lm -lz -lcomex -lmpi_usempif08 -lmpi_usempi_ignore_tkr -lmpi_mpifh -lmpi -lopen-rte -lopen-pal -lhwloc -levent_core -levent_pthreads -lm -lz -lm -lpthread
    check_binary
}

# Function to compile everything
compile_all() {
    echo "all"
    make nwchem_config 
    make USE_MPI=y USE_INTERNALBLAS=y >& make.log
    check_binary
}

# Check command line arguments for switch
if [ "$1" == "solvation" ]; then
    compile_solvation
elif [ "$1" == "all" ]; then
    compile_all
else
    echo "Usage: $0 [solvation|all]"
    exit 1
fi
