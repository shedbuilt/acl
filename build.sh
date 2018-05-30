#!/bin/bash
# Patch
sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in &&
sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test &&
sed -i 's/{(/\\{(/' test/run &&
sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" libacl/__acl_to_any_text.c &&
# Configure
./configure --prefix=/usr \
            --disable-static \
            --libexecdir=/usr/lib &&
# Build and Install
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install install-dev install-lib &&
# Rearrange
chmod -v 755 "${SHED_FAKE_ROOT}/usr/lib/libacl.so" &&
mkdir -v "${SHED_FAKE_ROOT}/lib" &&
mv -v "${SHED_FAKE_ROOT}"/usr/lib/libacl.so.* "${SHED_FAKE_ROOT}/lib" &&
ln -sfv ../../lib/$(readlink "${SHED_FAKE_ROOT}/usr/lib/libacl.so") "${SHED_FAKE_ROOT}/usr/lib/libacl.so"
