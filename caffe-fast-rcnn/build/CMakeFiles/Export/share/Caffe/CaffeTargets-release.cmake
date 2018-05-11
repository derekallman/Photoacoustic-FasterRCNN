#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "caffe" for configuration "Release"
set_property(TARGET caffe APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(caffe PROPERTIES
  IMPORTED_LINK_INTERFACE_LIBRARIES_RELEASE "proto;proto;/usr/lib/x86_64-linux-gnu/libboost_system.so;/usr/lib/x86_64-linux-gnu/libboost_thread.so;/usr/lib/x86_64-linux-gnu/libboost_filesystem.so;-lpthread;/usr/lib/x86_64-linux-gnu/libglog.so;/usr/lib/x86_64-linux-gnu/libgflags.so;/home/pulseadmin/anaconda2/lib/libprotobuf.so;-lpthread;/home/pulseadmin/anaconda2/lib/libhdf5_hl.so;/home/pulseadmin/anaconda2/lib/libhdf5.so;/home/pulseadmin/anaconda2/lib/libhdf5_hl.so;/home/pulseadmin/anaconda2/lib/libhdf5.so;/usr/lib/x86_64-linux-gnu/librt.so;/usr/lib/x86_64-linux-gnu/libpthread.so;/home/pulseadmin/anaconda2/lib/libz.so;/usr/lib/x86_64-linux-gnu/libdl.so;/usr/lib/x86_64-linux-gnu/libm.so;/usr/lib/x86_64-linux-gnu/liblmdb.so;/home/pulseadmin/anaconda2/lib/libleveldb.so;/home/pulseadmin/anaconda2/lib/libsnappy.so;/usr/local/cuda/lib64/libcudart.so;/usr/local/cuda/lib64/libcurand.so;/usr/local/cuda/lib64/libcublas.so;/usr/local/cuda/lib64/libcudnn.so;opencv_core;opencv_highgui;opencv_imgproc;/usr/lib/liblapack_atlas.so;/usr/lib/libcblas.so;/usr/lib/libatlas.so;/home/pulseadmin/anaconda2/lib/libpython2.7.so;/usr/lib/x86_64-linux-gnu/libboost_python.so"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libcaffe.so.1.0.0-rc3"
  IMPORTED_SONAME_RELEASE "libcaffe.so.1.0.0-rc3"
  )

list(APPEND _IMPORT_CHECK_TARGETS caffe )
list(APPEND _IMPORT_CHECK_FILES_FOR_caffe "${_IMPORT_PREFIX}/lib/libcaffe.so.1.0.0-rc3" )

# Import target "proto" for configuration "Release"
set_property(TARGET proto APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(proto PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libproto.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS proto )
list(APPEND _IMPORT_CHECK_FILES_FOR_proto "${_IMPORT_PREFIX}/lib/libproto.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
