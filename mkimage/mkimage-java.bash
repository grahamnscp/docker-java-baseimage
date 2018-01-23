#!/usr/bin/env bash
#
set -e
#set -x

# set default image name if not passed in
name=$1
name=${name:=bareimg}

# default image tag
tag=$2
tag=${tag:="1.0"}


# temp build directory (yum install route)
target=$(mktemp -d --tmpdir $(basename $0).XXXXX)

echo using temp package root: $target


# set up yum
yum_config=/etc/yum.conf
if [ -f /etc/dnf/dnf.conf ] && command -v dnf &> /dev/null; then
    yum_config=/etc/dnf/dnf.conf
    alias yum=dnf
fi
if [ -d /etc/yum/vars ]; then
    mkdir -p -m 755 "$target"/etc/yum
    cp -a /etc/yum/vars "$target"/etc/yum/
fi

mkdir -m 755 "$target"/dev
mknod -m 600 "$target"/dev/console c 5 1
mknod -m 600 "$target"/dev/initctl p
mknod -m 666 "$target"/dev/full c 1 7
mknod -m 666 "$target"/dev/null c 1 3
mknod -m 666 "$target"/dev/ptmx c 5 2
mknod -m 666 "$target"/dev/random c 1 8
mknod -m 666 "$target"/dev/tty c 5 0
mknod -m 666 "$target"/dev/tty0 c 4 0
mknod -m 666 "$target"/dev/urandom c 1 9
mknod -m 666 "$target"/dev/zero c 1 5



#######################################################################################
#
echo Install desired packages..
yum -c "$yum_config" --installroot="$target" --releasever=/ --setopt=tsflags=nodocs \
        --setopt=group_package_types=mandatory -y install tree > /dev/null 2>&1
yum -c "$yum_config" --installroot="$target" --releasever=/ --setopt=tsflags=nodocs \
        --setopt=group_package_types=mandatory -y install java-1.8.0-openjdk > /dev/null 2>&1
#
#######################################################################################


# clear out yum
yum -c "$yum_config" --installroot="$target" -y clean all 2>&1 > /dev/null


# dummy networking
cat > "$target"/etc/sysconfig/network <<EOF
NETWORKING=yes
HOSTNAME=localhost.localdomain
EOF

echo purging unecessary files..
# effectively: febootstrap-minimize --keep-zoneinfo --keep-rpmdb --keep-services "$target".
rm -rf "$target"/usr/{{lib,share}/locale,{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive}
rm -rf "$target"/usr/share/{man,doc,info,gnome/help}
rm -rf "$target"/usr/share/cracklib
rm -rf "$target"/usr/share/i18n
rm -rf "$target"/var/cache/yum
#mkdir -p --mode=0755 "$target"/var/cache/yum
rm -rf "$target"/sbin/sln
rm -rf "$target"/etc/ld.so.cache "$target"/var/cache/ldconfig
#mkdir -p --mode=0755 "$target"/var/cache/ldconfig

#version=
#for file in "$target"/etc/{redhat,system}-release
#do
#    if [ -r "$file" ]; then
#        version="$(sed 's/^[^0-9\]*\([0-9.]\+\).*$/\1/' "$file")"
#        break
#    fi
#done


# Copy Java test
echo Installing a sample java app as a test into: /HelloJavaImage
cp -R HelloJavaImage "$target"/

#######################################################################################
# cut a tar file from temp install root
#
echo creating docker image tar: img-$name-$tag.tar..
tar --numeric-owner -c -C "$target" -f img-$name-$tag.tar .
#######################################################################################

#######################################################################################
# load into docker
#
echo loading image tar into docker..
docker import img-$name-$tag.tar $name:$tag
#######################################################################################

#######################################################################################
# test
#
echo docker run tests..
#docker run -it --rm $name:$tag /bin/bash -c 'tree'
docker run -it --rm $name:$tag /bin/bash -c 'java -version'
docker run -it --rm $name:$tag java -classpath HelloJavaImage HelloJavaImage
#
######################################################################################



# clean up working dir as in tar now
rm -rf "$target"

