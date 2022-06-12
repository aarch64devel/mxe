# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := glib
$(PKG)_WEBSITE  := https://gtk.org/
$(PKG)_DESCR    := GLib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.69.3
$(PKG)_CHECKSUM := 47af2c6e06becee44d447ae7d1212dbab255b002b5141d9b62a4357c0ecc058f
$(PKG)_SUBDIR   := glib-$($(PKG)_VERSION)
$(PKG)_FILE     := glib-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/glib/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dbus gettext libffi libiconv pcre zlib $(BUILD)~$(PKG)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

$(PKG)_DEPS_$(BUILD) := autotools gettext libffi libiconv zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/glib/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD_DARWIN
    # native build for glib-tools
    cd '$(SOURCE_DIR)' && NOCONFIGURE=true ./autogen.sh
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --enable-regex \
        --disable-threads \
        --disable-selinux \
        --disable-inotify \
        --disable-fam \
        --disable-xattr \
        --disable-dtrace \
        --disable-libmount \
        --with-pcre=internal \
        PKG_CONFIG='$(PREFIX)/$(TARGET)/bin/pkgconf' \
        CPPFLAGS='-I$(PREFIX)/$(TARGET).gnu/include' \
        LDFLAGS='-L$(PREFIX)/$(TARGET).gnu/lib'
    $(MAKE) -C '$(BUILD_DIR)/glib'    -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/gthread' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/gmodule' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/gobject' -j '$(JOBS)' lib_LTLIBRARIES= install-exec
    $(MAKE) -C '$(BUILD_DIR)/gio/xdgmime'     -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/gio/kqueue'      -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/gio'     -j '$(JOBS)' glib-compile-schemas
    $(MAKE) -C '$(BUILD_DIR)/gio'     -j '$(JOBS)' glib-compile-resources
    $(INSTALL) -m755 '$(BUILD_DIR)/gio/glib-compile-schemas' '$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m755 '$(BUILD_DIR)/gio/glib-compile-resources' '$(PREFIX)/$(TARGET)/bin/'
endef

define $(PKG)_BUILD_NATIVE
    # native build for glib-tools
    cd '$(SOURCE_DIR)' && meson \
    --prefix '$(PREFIX)' \
    build

    cd '$(SOURCE_DIR)/build' && ninja && meson install
endef

define $(PKG)_BUILD_$(BUILD)
    $(if $(findstring darwin, $(BUILD)), \
        $($(PKG)_BUILD_DARWIN), \
        $($(PKG)_BUILD_NATIVE))
endef

define $(PKG)_BUILD
    # other packages expect glib-tools in $(TARGET)/bin
    rm -f  usr/aarch64-w64-mingw32/bin/glib-*

    # cross build
    cp '$(SOURCE_DIR)/../../cross.txt' '$(SOURCE_DIR)'
    cd '$(SOURCE_DIR)' && meson \
    --cross-file=cross.txt \
    --prefix '$(PREFIX)/aarch64-w64-mingw32' \
    build-arm

    cd '$(SOURCE_DIR)/build-arm' && ninja && meson install
    ln -s '$(PREFIX)/bin/glib-compile-schemas'   '$(PREFIX)/$(TARGET)/bin/glib-compile-schemas'
    ln -s '$(PREFIX)/bin/glib-compile-resources' '$(PREFIX)/$(TARGET)/bin/glib-compile-resources'
endef
