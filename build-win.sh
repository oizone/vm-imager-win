#!/bin/bash


ISOFILE=`echo $1 |sed -e 's/.*\/\(.*\)\.iso.*/\1/'`".iso"

OS_ISO="os_iso_path=${ISOFILE}"
OS_VER=`echo $1| cut -d "_" -f 4`
OS_VERSION=`echo $1|cut -d"_" -f 5-7`

TOOLURL="https://packages.vmware.com/tools/releases/latest/windows/x64/"
TOOLFILE=`curl ${TOOLURL}| grep -oP 'HREF="\K[^"]*' |tail -1`


if ! curl -o ${TOOLFILE} ${TOOLURL}${TOOLFILE}; then
   exit 1
fi

if [ ! -f ./packer ] ; then
    if ! curl -o packer.zip https://releases.hashicorp.com/packer/1.7.0/packer_1.7.0_linux_amd64.zip; then
	exit 1
    fi
    if ! unzip packer.zip; then
	exit 1
    fi
fi

if [[ $1 =~ ^http* ]]; then
    echo "DL ISO ${ISOFILE}"
    if ! curl -o ${ISOFILE} "$1"; then
	exit 1
    fi
fi

MD5=`md5sum ${ISOFILE} | cut -d" " -f 1`
OS_CHECKSUM="os_iso_checksum=${MD5}"

ln -sf ${TOOLFILE} setup64.exe
TOOLS_VERSION=`echo $TOOLFILE|cut -d "-" -f 3`

#mkdir -p ova
for OS in autounattend/${OS_VER}/*; do
    OSNAME="`echo $OS | cut -d "/" -f 3`"
    OSVAR="vm-name=${OSNAME}"
    EXPORT_NAME="vsphere-export-name=`echo $OSNAME| sed 's/ /_/g'`-${OS_VERSION}-VMtools-${TOOLS_VERSION}"
    EXPORT_FOLDER="vsphere-export-folder=./ovf-export/${OS_VER}"
    echo $EXPORT_NAME
    if ! ./packer build -var-file=credentials.json -var "${OS_ISO}" -var "${OS_CHECKSUM}" -var "${OSVAR}" -var "${EXPORT_FOLDER}" -var "${EXPORT_NAME}" -force windows${OS_VER}.json; then
	exit 1
    fi
    #cd ovf-export
    #TARNAME="`echo $OSNAME|sed 's/ /_/g'`"
    #if ! tar -cf "../ova/${TARNAME}-${OS_VERSION}-${TOOLS-VERSION}.ova" "$OSNAME"; then
	#exit 1
    #fi
    #cd ..
done

mkdir -p windows
mv ovf-export/${OS_VER}/* windows/

#if ! python3 ../make_vcsp_2018.py -n windows -t local -p windows/${OS_VER}; then
#    exit 1
#fi

#../azcopy_linux_amd64_10.9.0/azcopy cp windows/${OS_VER} "https://${STORAGE_ACCOUNT}.blob.core.windows.net/${STORAGE_CONTAINER}/windows/?${SAS}" --recursive=true

if ! python uploads3.py windows; then
    exit 1
fi

if ! python3 make_vcsp_2018.py -n hiaas-vmimage-dev -t s3 -p hiaas-vmimage-dev; then
    exit 1
fi
