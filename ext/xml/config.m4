PHP_ARG_ENABLE([xml],
  [whether to enable XML support],
  [AS_HELP_STRING([--disable-xml],
    [Disable XML support])],
  [yes])

PHP_ARG_WITH([libexpat-dir],
  [libexpat install dir],
  [AS_HELP_STRING([--with-libexpat-dir=DIR],
    [XML: libexpat install prefix (deprecated)])],
  [no],
  [no])

if test "$PHP_XML" != "no"; then

  dnl
  dnl Default to libxml2 if --with-libexpat-dir is not used.
  dnl
  if test "$PHP_LIBEXPAT_DIR" = "no"; then

    if test "$PHP_LIBXML" = "no"; then
      AC_MSG_ERROR([XML extension requires LIBXML extension, add --with-libxml])
    fi

    PHP_SETUP_LIBXML(XML_SHARED_LIBADD, [
      xml_extra_sources="compat.c"
      PHP_ADD_EXTENSION_DEP(xml, libxml)
    ])
  fi

  dnl
  dnl Check for expat only if --with-libexpat-dir is used.
  dnl
  if test "$PHP_LIBEXPAT_DIR" != "no"; then
    for i in $PHP_XML $PHP_LIBEXPAT_DIR /usr /usr/local; do
      if test -f "$i/$PHP_LIBDIR/libexpat.a" || test -f "$i/$PHP_LIBDIR/libexpat.$SHLIB_SUFFIX_NAME"; then
        EXPAT_DIR=$i
        break
      fi
    done

    if test -z "$EXPAT_DIR"; then
      AC_MSG_ERROR([not found. Please reinstall the expat distribution.])
    fi

    PHP_ADD_INCLUDE($EXPAT_DIR/include)
    PHP_ADD_LIBRARY_WITH_PATH(expat, $EXPAT_DIR/$PHP_LIBDIR, XML_SHARED_LIBADD)
    AC_DEFINE(HAVE_LIBEXPAT, 1, [ ])
  fi

  PHP_NEW_EXTENSION(xml, xml.c $xml_extra_sources, $ext_shared,, -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1)
  PHP_SUBST(XML_SHARED_LIBADD)
  PHP_INSTALL_HEADERS([ext/xml/])
  AC_DEFINE(HAVE_XML, 1, [ ])
fi
