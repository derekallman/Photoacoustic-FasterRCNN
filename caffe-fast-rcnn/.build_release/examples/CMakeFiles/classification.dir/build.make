# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.4

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/bin/cmake

# The command to remove a file.
RM = /usr/local/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build

# Include any dependencies generated for this target.
include examples/CMakeFiles/classification.dir/depend.make

# Include the progress variables for this target.
include examples/CMakeFiles/classification.dir/progress.make

# Include the compile flags for this target's objects.
include examples/CMakeFiles/classification.dir/flags.make

examples/CMakeFiles/classification.dir/cpp_classification/classification.cpp.o: examples/CMakeFiles/classification.dir/flags.make
examples/CMakeFiles/classification.dir/cpp_classification/classification.cpp.o: ../examples/cpp_classification/classification.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object examples/CMakeFiles/classification.dir/cpp_classification/classification.cpp.o"
	cd /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/examples && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/classification.dir/cpp_classification/classification.cpp.o -c /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/examples/cpp_classification/classification.cpp

examples/CMakeFiles/classification.dir/cpp_classification/classification.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/classification.dir/cpp_classification/classification.cpp.i"
	cd /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/examples && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/examples/cpp_classification/classification.cpp > CMakeFiles/classification.dir/cpp_classification/classification.cpp.i

examples/CMakeFiles/classification.dir/cpp_classification/classification.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/classification.dir/cpp_classification/classification.cpp.s"
	cd /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/examples && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/examples/cpp_classification/classification.cpp -o CMakeFiles/classification.dir/cpp_classification/classification.cpp.s

examples/CMakeFiles/classification.dir/cpp_classification/classification.cpp.o.requires:

.PHONY : examples/CMakeFiles/classification.dir/cpp_classification/classification.cpp.o.requires

examples/CMakeFiles/classification.dir/cpp_classification/classification.cpp.o.provides: examples/CMakeFiles/classification.dir/cpp_classification/classification.cpp.o.requires
	$(MAKE) -f examples/CMakeFiles/classification.dir/build.make examples/CMakeFiles/classification.dir/cpp_classification/classification.cpp.o.provides.build
.PHONY : examples/CMakeFiles/classification.dir/cpp_classification/classification.cpp.o.provides

examples/CMakeFiles/classification.dir/cpp_classification/classification.cpp.o.provides.build: examples/CMakeFiles/classification.dir/cpp_classification/classification.cpp.o


# Object files for target classification
classification_OBJECTS = \
"CMakeFiles/classification.dir/cpp_classification/classification.cpp.o"

# External object files for target classification
classification_EXTERNAL_OBJECTS =

examples/cpp_classification/classification: examples/CMakeFiles/classification.dir/cpp_classification/classification.cpp.o
examples/cpp_classification/classification: examples/CMakeFiles/classification.dir/build.make
examples/cpp_classification/classification: lib/libcaffe.so.1.0.0-rc3
examples/cpp_classification/classification: lib/libproto.a
examples/cpp_classification/classification: /usr/lib/x86_64-linux-gnu/libboost_system.so
examples/cpp_classification/classification: /usr/lib/x86_64-linux-gnu/libboost_thread.so
examples/cpp_classification/classification: /usr/lib/x86_64-linux-gnu/libboost_filesystem.so
examples/cpp_classification/classification: /usr/lib/x86_64-linux-gnu/libglog.so
examples/cpp_classification/classification: /usr/lib/x86_64-linux-gnu/libgflags.so
examples/cpp_classification/classification: /home/pulseadmin/anaconda2/lib/libprotobuf.so
examples/cpp_classification/classification: /usr/lib/x86_64-linux-gnu/libglog.so
examples/cpp_classification/classification: /usr/lib/x86_64-linux-gnu/libgflags.so
examples/cpp_classification/classification: /home/pulseadmin/anaconda2/lib/libprotobuf.so
examples/cpp_classification/classification: /home/pulseadmin/anaconda2/lib/libhdf5_hl.so
examples/cpp_classification/classification: /home/pulseadmin/anaconda2/lib/libhdf5.so
examples/cpp_classification/classification: /home/pulseadmin/anaconda2/lib/libhdf5_hl.so
examples/cpp_classification/classification: /home/pulseadmin/anaconda2/lib/libhdf5.so
examples/cpp_classification/classification: /usr/lib/x86_64-linux-gnu/librt.so
examples/cpp_classification/classification: /usr/lib/x86_64-linux-gnu/libpthread.so
examples/cpp_classification/classification: /home/pulseadmin/anaconda2/lib/libz.so
examples/cpp_classification/classification: /usr/lib/x86_64-linux-gnu/libdl.so
examples/cpp_classification/classification: /usr/lib/x86_64-linux-gnu/libm.so
examples/cpp_classification/classification: /usr/lib/x86_64-linux-gnu/liblmdb.so
examples/cpp_classification/classification: /home/pulseadmin/anaconda2/lib/libleveldb.so
examples/cpp_classification/classification: /home/pulseadmin/anaconda2/lib/libsnappy.so
examples/cpp_classification/classification: /usr/local/cuda/lib64/libcudart.so
examples/cpp_classification/classification: /usr/local/cuda/lib64/libcurand.so
examples/cpp_classification/classification: /usr/local/cuda/lib64/libcublas.so
examples/cpp_classification/classification: /usr/lib/x86_64-linux-gnu/libopencv_highgui.so.2.4.8
examples/cpp_classification/classification: /usr/lib/x86_64-linux-gnu/libopencv_imgproc.so.2.4.8
examples/cpp_classification/classification: /usr/lib/x86_64-linux-gnu/libopencv_core.so.2.4.8
examples/cpp_classification/classification: /usr/lib/liblapack_atlas.so
examples/cpp_classification/classification: /usr/lib/libcblas.so
examples/cpp_classification/classification: /usr/lib/libatlas.so
examples/cpp_classification/classification: /home/pulseadmin/anaconda2/lib/libpython2.7.so
examples/cpp_classification/classification: /usr/lib/x86_64-linux-gnu/libboost_python.so
examples/cpp_classification/classification: examples/CMakeFiles/classification.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable cpp_classification/classification"
	cd /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/examples && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/classification.dir/link.txt --verbose=$(VERBOSE)
	cd /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/examples && ln -sf /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/examples/cpp_classification/classification /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/examples/cpp_classification/classification.bin

# Rule to build all files generated by this target.
examples/CMakeFiles/classification.dir/build: examples/cpp_classification/classification

.PHONY : examples/CMakeFiles/classification.dir/build

examples/CMakeFiles/classification.dir/requires: examples/CMakeFiles/classification.dir/cpp_classification/classification.cpp.o.requires

.PHONY : examples/CMakeFiles/classification.dir/requires

examples/CMakeFiles/classification.dir/clean:
	cd /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/examples && $(CMAKE_COMMAND) -P CMakeFiles/classification.dir/cmake_clean.cmake
.PHONY : examples/CMakeFiles/classification.dir/clean

examples/CMakeFiles/classification.dir/depend:
	cd /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/examples /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/examples /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/examples/CMakeFiles/classification.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : examples/CMakeFiles/classification.dir/depend

