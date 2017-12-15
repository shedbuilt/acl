#!/bin/bash
sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
sed -i 's/{(/\\{(/' test/run
sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" libacl/__acl_to_any_text.c
./configure --prefix=/usr \
            --bindir=/bin \
            --disable-static \
            --libexecdir=/usr/lib
make -j $SHED_NUMJOBS
make DESTDIR=${SHED_FAKEROOT} install install-dev install-lib
chmod -v 755 ${SHED_FAKEROOT}/usr/lib/libacl.so
mkdir -v ${SHED_FAKEROOT}/lib
mv -v ${SHED_FAKEROOT}/usr/lib/libacl.so.* ${SHED_FAKEROOT}/lib
ln -sfv ../../lib/$(readlink ${SHED_FAKEROOT}/usr/lib/libacl.so) ${SHED_FAKEROOT}/usr/lib/libacl.so
