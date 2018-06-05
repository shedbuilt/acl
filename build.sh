#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
# Patch
sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in &&
sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test &&
sed -i 's/{(/\\{(/' test/run &&
sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" libacl/__acl_to_any_text.c &&
# Configure
./configure --prefix=/usr \
            --docdir="$SHED_PKG_DOCS_INSTALL_DIR" \
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
# Prune Documentation
if [ -z "${SHED_PKG_LOCAL_OPTIONS[docs]}" ]; then
    rm -rf "${SHED_FAKE_ROOT}/usr/share/doc"
fi
