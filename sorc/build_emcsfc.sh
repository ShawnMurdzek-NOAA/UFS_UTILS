#! /usr/bin/env bash
set -eux

source ./machine-setup.sh > /dev/null 2>&1
cwd=`pwd`

# Check final exec folder exists
if [ ! -d "../exec" ]; then
  mkdir ../exec
fi

for prog in emcsfc_ice_blend emcsfc_snow2mdl
do
  USE_PREINST_LIBS=${USE_PREINST_LIBS:-"true"}
  if [ $USE_PREINST_LIBS = true ]; then
    module use ../modulefiles
    module load modulefile.global_${prog}.${target}             > /dev/null 2>&1
  else
    export MOD_PATH=${cwd}/lib/modulefiles
    source ../modulefiles/modulefile.global_${prog}.${target}           > /dev/null 2>&1
  fi
  module list
  cd ${cwd}/${prog}.fd
  ./make.sh
  cd $cwd
  module unload modulefile.global_${prog}.${target} > /dev/null 2>&1
done

set +x
echo; echo DONE BUILDING EMCSFC PROGRAMS
