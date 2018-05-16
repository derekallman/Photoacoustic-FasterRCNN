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
include tools/CMakeFiles/extract_features.dir/depend.make

# Include the progress variables for this target.
include tools/CMakeFiles/extract_features.dir/progress.make

# Include the compile flags for this target's objects.
include tools/CMakeFiles/extract_features.dir/flags.make

tools/CMakeFiles/extract_features.dir/extract_features.cpp.o: tools/CMakeFiles/extract_features.dir/flags.make
tools/CMakeFiles/extract_features.dir/extract_features.cpp.o: ../tools/extract_features.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tools/CMakeFiles/extract_features.dir/extract_features.cpp.o"
	cd /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/tools && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/extract_features.dir/extract_features.cpp.o -c /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/tools/extract_features.cpp

tools/CMakeFiles/extract_features.dir/extract_features.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/extract_features.dir/extract_features.cpp.i"
	cd /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/tools && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/tools/extract_features.cpp > CMakeFiles/extract_features.dir/extract_features.cpp.i

tools/CMakeFiles/extract_features.dir/extract_features.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/extract_features.dir/extract_features.cpp.s"
	cd /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/tools && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/tools/extract_features.cpp -o CMakeFiles/extract_features.dir/extract_features.cpp.s

tools/CMakeFiles/extract_features.dir/extract_features.cpp.o.requires:

.PHONY : tools/CMakeFiles/extract_features.dir/extract_features.cpp.o.requires

tools/CMakeFiles/extract_features.dir/extract_features.cpp.o.provides: tools/CMakeFiles/extract_features.dir/extract_features.cpp.o.requires
	$(MAKE) -f tools/CMakeFiles/extract_features.dir/build.make tools/CMakeFiles/extract_features.dir/extract_features.cpp.o.provides.build
.PHONY : tools/CMakeFiles/extract_features.dir/extract_features.cpp.o.provides

tools/CMakeFiles/extract_features.dir/extract_features.cpp.o.provides.build: tools/CMakeFiles/extract_features.dir/extract_features.cpp.o


# Object files for target extract_features
extract_features_OBJECTS = \
"CMakeFiles/extract_features.dir/extract_features.cpp.o"

# External object files for target extract_features
extract_features_EXTERNAL_OBJECTS =

tools/extract_features: tools/CMakeFiles/extract_features.dir/extract_features.cpp.o
tools/extract_features: tools/CMakeFiles/extract_features.dir/build.make
tools/extract_features: lib/libcaffe.so.1.0.0-rc3
tools/extract_features: lib/libproto.a
tools/extract_features: /usr/lib/x86_64-linux-gnu/libboost_system.so
tools/extract_features: /usr/lib/x86_64-linux-gnu/libboost_thread.so
tools/extract_features: /usr/lib/x86_64-linux-gnu/libboost_filesystem.so
tools/extract_features: /usr/lib/x86_64-linux-gnu/libglog.so
tools/extract_features: /usr/lib/x86_64-linux-gnu/libgflags.so
tools/extract_features: /home/pulseadmin/anaconda2/lib/libprotobuf.so
tools/extract_features: /usr/lib/x86_64-linux-gnu/libglog.so
tools/extract_features: /usr/lib/x86_64-linux-gnu/libgflags.so
tools/extract_features: /home/pulseadmin/anaconda2/lib/libprotobuf.so
tools/extract_features: /home/pulseadmin/anaconda2/lib/libhdf5_hl.so
tools/extract_features: /home/pulseadmin/anaconda2/lib/libhdf5.so
tools/extract_features: /home/pulseadmin/anaconda2/lib/libhdf5_hl.so
tools/extract_features: /home/pulseadmin/anaconda2/lib/libhdf5.so
tools/extract_features: /usr/lib/x86_64-linux-gnu/librt.so
tools/extract_features: /usr/lib/x86_64-linux-gnu/libpthread.so
tools/extract_features: /home/pulseadmin/anaconda2/lib/libz.so
tools/extract_features: /usr/lib/x86_64-linux-gnu/libdl.so
tools/extract_features: /usr/lib/x86_64-linux-gnu/libm.so
tools/extract_features: /usr/lib/x86_64-linux-gnu/liblmdb.so
tools/extract_features: /home/pulseadmin/anaconda2/lib/libleveldb.so
tools/extract_features: /home/pulseadmin/anaconda2/lib/libsnappy.so
tools/extract_features: /usr/local/cuda/lib64/libcudart.so
tools/extract_features: /usr/local/cuda/lib64/libcurand.so
tools/extract_features: /usr/local/cuda/lib64/libcublas.so
tools/extract_features: /usr/lib/x86_64-linux-gnu/libopencv_highgui.so.2.4.8
tools/extract_features: /usr/lib/x86_64-linux-gnu/libopencv_imgproc.so.2.4.8
tools/extract_features: /usr/lib/x86_64-linux-gnu/libopencv_core.so.2.4.8
tools/extract_features: /usr/lib/liblapack_atlas.so
tools/extract_features: /usr/lib/libcblas.so
tools/extract_features: /usr/lib/libatlas.so
tools/extract_features: /home/pulseadmin/anaconda2/lib/libpython2.7.so
tools/extract_features: /usr/lib/x86_64-linux-gnu/libboost_python.so
tools/extract_features: tools/CMakeFiles/extract_features.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable extract_features"
	cd /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/tools && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/extract_features.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tools/CMakeFiles/extract_features.dir/build: tools/extract_features

.PHONY : tools/CMakeFiles/extract_features.dir/build

tools/CMakeFiles/extract_features.dir/requires: tools/CMakeFiles/extract_features.dir/extract_features.cpp.o.requires

.PHONY : tools/CMakeFiles/extract_features.dir/requires

tools/CMakeFiles/extract_features.dir/clean:
	cd /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/tools && $(CMAKE_COMMAND) -P CMakeFiles/extract_features.dir/cmake_clean.cmake
.PHONY : tools/CMakeFiles/extract_features.dir/clean

tools/CMakeFiles/extract_features.dir/depend:
	cd /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/tools /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/tools /home/pulseadmin/Photoacoustic-FasterRCNN/caffe-fast-rcnn/build/tools/CMakeFiles/extract_features.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tools/CMakeFiles/extract_features.dir/depend

