#!/usr/bin/env bash
# Description: override krb5/libssh libraries in Vagrant embedded libraries
set -e

# Get pre-requisites
dnf -y install \
  libxslt-devel libxml2-devel libvirt-devel \
  libguestfs-tools-c ruby-devel \
  gcc byacc make cmake gcc-c++

mkdir -p vagrant-build
cd vagrant-build
dnf download --source krb5-libs libssh
# krb5
rpm2cpio krb5-1.18.2-5.el8.src.rpm | cpio -idmv krb5-1.18.2.tar.gz
tar xzf krb5-1.18.2.tar.gz
pushd krb5-1.18.2/src
./configure
make
cp -a lib/crypto/libk5crypto.so.3* /opt/vagrant/embedded/lib64/
popd

# libssh
rpm2cpio libssh-0.9.4-2.el8.src.rpm | cpio -imdv  libssh-0.9.4.tar.xz
tar xJf libssh-0.9.4.tar.xz
mkdir build
pushd build
cmake ../libssh-0.9.4  -DOPENSSL_ROOT_DIR=/opt/vagrant/embedded
make
cp lib/libssh* /opt/vagrant/embedded/lib64/
popd
