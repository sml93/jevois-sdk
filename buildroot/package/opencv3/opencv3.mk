################################################################################
#
# opencv3
#
################################################################################

OPENCV3_VERSION = 4.0.0-beta
OPENCV3_SITE = $(call github,opencv,opencv,$(OPENCV3_VERSION))
OPENCV3_INSTALL_STAGING = YES
OPENCV3_LICENSE = BSD-3-Clause
OPENCV3_LICENSE_FILES = LICENSE
OPENCV3_SUPPORTS_IN_SOURCE_BUILD = NO

OPENCV3_DEPENDENCIES = opencv_contrib # download the contribs before we configure and build here
OPENCV3_DEPENDENCIES += tesseract-ocr
OPENCV3_DEPENDENCIES += protobuf-c
OPENCV3_DEPENDENCIES += openblas
OPENCV3_DEPENDENCIES += jpeg-turbo
OPENCV3_DEPENDENCIES += lapack

# Uses __atomic_fetch_add_4
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
OPENCV3_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -latomic -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -ftree-vectorize -Ofast -funsafe-math-optimizations -mfp16-format=ieee"
else
OPENCV3_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -ftree-vectorize -Ofast -funsafe-math-optimizations -mfp16-format=ieee"
endif

# OpenCV component options
OPENCV3_CONF_OPTS += \
    -DOPENCV_ENABLE_PKG_CONFIG=ON \
	-DBUILD_DOCS=OFF \
	-DBUILD_PERF_TESTS=$(if $(BR2_PACKAGE_OPENCV3_BUILD_PERF_TESTS),ON,OFF) \
	-DBUILD_TESTS=$(if $(BR2_PACKAGE_OPENCV3_BUILD_TESTS),ON,OFF) \
	-DBUILD_WITH_DEBUG_INFO=OFF \
	-DDOWNLOAD_EXTERNAL_TEST_DATA=OFF

ifeq ($(BR2_PACKAGE_OPENCV3_BUILD_TESTS)$(BR2_PACKAGE_OPENCV3_BUILD_PERF_TESTS),)
OPENCV3_CONF_OPTS += -DINSTALL_TEST=OFF
else
OPENCV3_CONF_OPTS += -DINSTALL_TEST=ON
endif

# OpenCV build options
OPENCV3_CONF_OPTS += \
	-DBUILD_WITH_STATIC_CRT=OFF \
	-DENABLE_COVERAGE=OFF \
	-DENABLE_FAST_MATH=ON \
	-DENABLE_IMPL_COLLECTION=OFF \
	-DENABLE_NOISY_WARNINGS=OFF \
	-DENABLE_OMIT_FRAME_POINTER=ON \
	-DENABLE_PRECOMPILED_HEADERS=OFF \
	-DENABLE_PROFILING=OFF \
	-DOPENCV3_WARNINGS_ARE_ERRORS=OFF \
    -DOPENCV_ENABLE_NONFREE=ON

# OpenCV link options
OPENCV3_CONF_OPTS += \
	-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=OFF \
	-DCMAKE_SKIP_RPATH=OFF \
	-DCMAKE_USE_RELATIVE_PATHS=OFF

# OpenCV packaging options:
OPENCV3_CONF_OPTS += \
	-DBUILD_PACKAGE=OFF \
	-DENABLE_SOLUTION_FOLDERS=OFF \
	-DINSTALL_CREATE_DISTRIB=ON

# OpenCV module selection
# * Modules on:
#   - core: if not set, opencv does not build anything
#   - hal: core's dependency
# * Modules off:
#   - android*: android stuff
#   - apps: programs for training classifiers
#   - java: java bindings
#   - viz: missing VTK dependency
#   - world: all-in-one module
#
# * Contrib modules: JEVOIS addition, in opencv_contrib
OPENCV3_CONF_OPTS += \
	-DBUILD_opencv_androidcamera=OFF \
	-DBUILD_opencv_apps=OFF \
	-DBUILD_opencv_calib3d=$(if $(BR2_PACKAGE_OPENCV3_LIB_CALIB3D),ON,OFF) \
	-DBUILD_opencv_core=ON \
	-DBUILD_opencv_features2d=$(if $(BR2_PACKAGE_OPENCV3_LIB_FEATURES2D),ON,OFF) \
	-DBUILD_opencv_flann=$(if $(BR2_PACKAGE_OPENCV3_LIB_FLANN),ON,OFF) \
	-DBUILD_opencv_highgui=ON \
	-DBUILD_opencv_imgcodecs=$(if $(BR2_PACKAGE_OPENCV3_LIB_IMGCODECS),ON,OFF) \
	-DBUILD_opencv_imgproc=$(if $(BR2_PACKAGE_OPENCV3_LIB_IMGPROC),ON,OFF) \
	-DBUILD_opencv_java=OFF \
	-DBUILD_opencv_ml=$(if $(BR2_PACKAGE_OPENCV3_LIB_ML),ON,OFF) \
	-DBUILD_opencv_objdetect=$(if $(BR2_PACKAGE_OPENCV3_LIB_OBJDETECT),ON,OFF) \
	-DBUILD_opencv_photo=$(if $(BR2_PACKAGE_OPENCV3_LIB_PHOTO),ON,OFF) \
	-DBUILD_opencv_shape=$(if $(BR2_PACKAGE_OPENCV3_LIB_SHAPE),ON,OFF) \
	-DBUILD_opencv_stitching=$(if $(BR2_PACKAGE_OPENCV3_LIB_STITCHING),ON,OFF) \
	-DBUILD_opencv_superres=$(if $(BR2_PACKAGE_OPENCV3_LIB_SUPERRES),ON,OFF) \
	-DBUILD_opencv_ts=$(if $(BR2_PACKAGE_OPENCV3_LIB_TS),ON,OFF) \
	-DBUILD_opencv_video=$(if $(BR2_PACKAGE_OPENCV3_LIB_VIDEO),ON,OFF) \
	-DBUILD_opencv_videoio=$(if $(BR2_PACKAGE_OPENCV3_LIB_VIDEOIO),ON,OFF) \
	-DBUILD_opencv_videostab=$(if $(BR2_PACKAGE_OPENCV3_LIB_VIDEOSTAB),ON,OFF) \
	-DBUILD_opencv_viz=OFF \
	-DBUILD_opencv_world=OFF \
    -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-$(OPENCV3_VERSION)/modules \



# JEVOIS: the line below used to be above but then highgui is not built, yet is needed by many contribs, so forced to ON
# above:
#-DBUILD_opencv_highgui=$(if $(BR2_PACKAGE_OPENCV3_LIB_HIGHGUI),ON,OFF) \

# Hardware support options.
#
# * PowerPC support is turned off since its only effect is altering CFLAGS,
#   adding '-mcpu=G3 -mtune=G5' to them, which is already handled by Buildroot.
OPENCV3_CONF_OPTS += \
	-DENABLE_POWERPC=OFF

# Cuda stuff
OPENCV3_CONF_OPTS += \
	-DBUILD_CUDA_STUBS=OFF \
	-DBUILD_opencv_cudaarithm=OFF \
	-DBUILD_opencv_cudabgsegm=OFF \
	-DBUILD_opencv_cudacodec=OFF \
	-DBUILD_opencv_cudafeatures2d=OFF \
	-DBUILD_opencv_cudafilters=OFF \
	-DBUILD_opencv_cudaimgproc=OFF \
	-DBUILD_opencv_cudalegacy=OFF \
	-DBUILD_opencv_cudaobjdetect=OFF \
	-DBUILD_opencv_cudaoptflow=OFF \
	-DBUILD_opencv_cudastereo=OFF \
	-DBUILD_opencv_cudawarping=OFF \
	-DBUILD_opencv_cudev=OFF \
	-DWITH_CUBLAS=OFF \
	-DWITH_CUDA=OFF \
	-DWITH_CUFFT=OFF

# NVidia stuff
OPENCV3_CONF_OPTS += -DWITH_NVCUVID=OFF

# AMD stuff
OPENCV3_CONF_OPTS += \
	-DWITH_OPENCLAMDBLAS=OFF \
	-DWITH_OPENCLAMDFFT=OFF

# Intel stuff
OPENCV3_CONF_OPTS += \
	-DBUILD_WITH_DYNAMIC_IPP=OFF \
	-DWITH_INTELPERC=OFF \
	-DWITH_IPP=OFF \
	-DWITH_IPP_A=OFF \
	-DWITH_TBB=ON \
    -DBUILD_TBB=ON \
    -DENABLE_VFPV4=ON \
    -DENABLE_NEON=ON

# JEVOIS UNCOMMENT THE ABOVE TO ENABLE TBB and VFP and NEON

# Smartek stuff
OPENCV3_CONF_OPTS += -DWITH_GIGEAPI=OFF

# Prosilica stuff
OPENCV3_CONF_OPTS += -DWITH_PVAPI=OFF

# Ximea stuff
OPENCV3_CONF_OPTS += -DWITH_XIMEA=OFF

# Non-Linux support (Android options) must remain OFF:
OPENCV3_CONF_OPTS += \
	-DANDROID=OFF \
	-DBUILD_ANDROID_CAMERA_WRAPPER=OFF \
	-DBUILD_ANDROID_EXAMPLES=OFF \
	-DBUILD_ANDROID_SERVICE=OFF \
	-DBUILD_FAT_JAVA_LIB=OFF \
    -DBUILD_JAVA=OFF \
	-DINSTALL_ANDROID_EXAMPLES=OFF \
	-DWITH_ANDROID_CAMERA=OFF

# Non-Linux support (Mac OSX options) must remain OFF:
OPENCV3_CONF_OPTS += \
	-DWITH_AVFOUNDATION=OFF \
	-DWITH_CARBON=OFF \
	-DWITH_QUICKTIME=OFF

# Non-Linux support (Windows options) must remain OFF:
OPENCV3_CONF_OPTS += \
	-DWITH_CSTRIPES=OFF \
	-DWITH_DSHOW=OFF \
	-DWITH_MSMF=OFF \
	-DWITH_PTHREADS_PF=OFF \
	-DWITH_VFW=OFF \
	-DWITH_VIDEOINPUT=OFF \
	-DWITH_WIN32UI=OFF

# Software/3rd-party support options:
# - disable all examples
OPENCV3_CONF_OPTS += \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_JASPER=OFF \
	-DBUILD_JPEG=OFF \
	-DBUILD_OPENEXR=OFF \
	-DBUILD_PNG=OFF \
	-DBUILD_TIFF=OFF \
	-DBUILD_ZLIB=OFF \
	-DINSTALL_C_EXAMPLES=OFF \
	-DINSTALL_PYTHON_EXAMPLES=OFF \
	-DINSTALL_TO_MANGLED_PATHS=OFF

# Disabled features (mostly because they are not available in Buildroot), but
# - eigen: OpenCV does not use it, not take any benefit from it.
OPENCV3_CONF_OPTS += \
	-DWITH_1394=OFF \
	-DWITH_CLP=OFF \
	-DWITH_EIGEN=OFF \
	-DWITH_GDAL=OFF \
	-DWITH_GPHOTO2=OFF \
	-DWITH_MATLAB=OFF \
	-DWITH_OPENCL=OFF \
	-DWITH_OPENCL_SVM=OFF \
	-DWITH_OPENEXR=OFF \
	-DWITH_OPENNI2=OFF \
	-DWITH_OPENNI=OFF \
	-DWITH_UNICAP=OFF \
	-DWITH_VA=OFF \
	-DWITH_VA_INTEL=OFF \
	-DWITH_VTK=OFF \
	-DWITH_WEBP=OFF \
	-DWITH_XINE=OFF


# JeVois extra options:
OPENCV3_CONF_OPTS += \
    -DWITH_EIGEN=ON \
    -DBUILD_opencv_python2=OFF \
    -DBUILD_NEW_PYTHON_SUPPORT=ON \
    -DENABLE_FAST_MATH=1 \
    -DWITH_OPENMP=ON \
    -DENABLE_CXX11=ON \
	-DWITH_LAPACK=ON \


OPENCV3_DEPENDENCIES += zlib

ifeq ($(BR2_PACKAGE_OPENCV3_WITH_FFMPEG),y)
OPENCV3_CONF_OPTS += -DWITH_FFMPEG=ON
OPENCV3_DEPENDENCIES += ffmpeg bzip2
else
OPENCV3_CONF_OPTS += -DWITH_FFMPEG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV3_WITH_GSTREAMER),y)
OPENCV3_CONF_OPTS += -DWITH_GSTREAMER_0_10=ON
OPENCV3_DEPENDENCIES += gstreamer gst-plugins-base
else
OPENCV3_CONF_OPTS += -DWITH_GSTREAMER_0_10=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV3_WITH_GSTREAMER1),y)
OPENCV3_CONF_OPTS += -DWITH_GSTREAMER=ON
OPENCV3_DEPENDENCIES += gstreamer1 gst1-plugins-base
else
OPENCV3_CONF_OPTS += -DWITH_GSTREAMER=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV3_WITH_GTK)$(BR2_PACKAGE_OPENCV3_WITH_GTK3),)
OPENCV3_CONF_OPTS += -DWITH_GTK=OFF -DWITH_GTK_2_X=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV3_WITH_GTK),y)
OPENCV3_CONF_OPTS += -DWITH_GTK=ON -DWITH_GTK_2_X=ON
OPENCV3_DEPENDENCIES += libgtk2
endif

ifeq ($(BR2_PACKAGE_OPENCV3_WITH_GTK3),y)
OPENCV3_CONF_OPTS += -DWITH_GTK=ON -DWITH_GTK_2_X=OFF
OPENCV3_DEPENDENCIES += libgtk3
endif

ifeq ($(BR2_PACKAGE_OPENCV3_WITH_JASPER),y)
OPENCV3_CONF_OPTS += -DWITH_JASPER=ON
OPENCV3_DEPENDENCIES += jasper
else
OPENCV3_CONF_OPTS += -DWITH_JASPER=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV3_WITH_JPEG),y)
OPENCV3_CONF_OPTS += -DWITH_JPEG=ON
OPENCV3_DEPENDENCIES += jpeg
else
OPENCV3_CONF_OPTS += -DWITH_JPEG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV3_WITH_OPENGL),y)
OPENCV3_CONF_OPTS += -DWITH_OPENGL=ON
OPENCV3_DEPENDENCIES += libgl
else
OPENCV3_CONF_OPTS += -DWITH_OPENGL=OFF
endif

OPENCV3_CONF_OPTS += -DWITH_OPENMP=$(if $(BR2_GCC_ENABLE_OPENMP),ON,OFF)

ifeq ($(BR2_PACKAGE_OPENCV3_WITH_PNG),y)
OPENCV3_CONF_OPTS += -DWITH_PNG=ON
OPENCV3_DEPENDENCIES += libpng
else
OPENCV3_CONF_OPTS += -DWITH_PNG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV3_WITH_QT)$(BR2_PACKAGE_OPENCV3_WITH_QT5),)
OPENCV3_CONF_OPTS += -DWITH_QT=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV3_WITH_QT),y)
OPENCV3_CONF_OPTS += -DWITH_QT=4
OPENCV3_DEPENDENCIES += qt
endif

ifeq ($(BR2_PACKAGE_OPENCV3_WITH_QT5),y)
OPENCV3_CONF_OPTS += -DWITH_QT=5
OPENCV3_DEPENDENCIES += qt5base
endif

ifeq ($(BR2_PACKAGE_OPENCV3_WITH_TIFF),y)
OPENCV3_CONF_OPTS += -DWITH_TIFF=ON
OPENCV3_DEPENDENCIES += tiff
else
OPENCV3_CONF_OPTS += -DWITH_TIFF=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV3_WITH_V4L),y)
OPENCV3_CONF_OPTS += \
	-DWITH_LIBV4L=$(if $(BR2_PACKAGE_LIBV4L),ON,OFF) \
	-DWITH_V4L=ON
OPENCV3_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBV4L),libv4l)
else
OPENCV3_CONF_OPTS += -DWITH_V4L=OFF -DWITH_LIBV4L=OFF
endif

# JEVOIS: force detection of tesseract
OPENCV3_CONF_OPTS += -DOPENCV_FIND_TESSERACT=ON


ifeq ($(BR2_PACKAGE_OPENCV3_LIB_PYTHON),y)
ifeq ($(BR2_PACKAGE_PYTHON),y)
OPENCV3_CONF_OPTS += \
	-DBUILD_opencv_python2=ON \
	-DBUILD_opencv_python3=OFF \
	-DPYTHON2_EXECUTABLE=$(HOST_DIR)/bin/python2 \
	-DPYTHON2_INCLUDE_PATH=$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR) \
	-DPYTHON2_LIBRARIES=$(STAGING_DIR)/usr/lib/libpython$(PYTHON_VERSION_MAJOR).so \
	-DPYTHON2_NUMPY_INCLUDE_DIRS=$(STAGING_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages/numpy/core/include \
	-DPYTHON2_PACKAGES_PATH=/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages \
	-DPYTHON2_NUMPY_VERSION=$(PYTHON_NUMPY_VERSION)
OPENCV3_DEPENDENCIES += python
else
OPENCV3_CONF_OPTS += \
	-DBUILD_opencv_python2=OFF \
	-DBUILD_opencv_python3=ON \
	-DPYTHON3_EXECUTABLE=$(HOST_DIR)/bin/python3 \
	-DPYTHON3_INCLUDE_PATH=$(STAGING_DIR)/usr/include/python$(PYTHON3_VERSION_MAJOR)m \
	-DPYTHON3_LIBRARIES=$(STAGING_DIR)/usr/lib/libpython$(PYTHON3_VERSION_MAJOR)m.so \
	-DPYTHON3_NUMPY_INCLUDE_DIRS=$(STAGING_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/numpy/core/include \
	-DPYTHON3_PACKAGES_PATH=/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages \
	-DPYTHON3_NUMPY_VERSION=$(PYTHON_NUMPY_VERSION)
OPENCV3_DEPENDENCIES += python3
endif
OPENCV3_DEPENDENCIES += python-numpy
else
OPENCV3_CONF_OPTS += \
	-DBUILD_opencv_python2=OFF \
	-DBUILD_opencv_python3=OFF
endif

# Installation hooks:
define OPENCV3_CLEAN_INSTALL_DOC
	$(RM) -fr $(TARGET_DIR)/usr/share/OpenCV/doc
endef
OPENCV3_POST_INSTALL_TARGET_HOOKS += OPENCV3_CLEAN_INSTALL_DOC

define OPENCV3_CLEAN_INSTALL_CMAKE
	$(RM) -f $(TARGET_DIR)/usr/share/OpenCV/OpenCVConfig*.cmake
endef
OPENCV3_POST_INSTALL_TARGET_HOOKS += OPENCV3_CLEAN_INSTALL_CMAKE

ifneq ($(BR2_PACKAGE_OPENCV3_INSTALL_DATA),y)
define OPENCV3_CLEAN_INSTALL_DATA
	$(RM) -fr $(TARGET_DIR)/usr/share/OpenCV/haarcascades \
		$(TARGET_DIR)/usr/share/OpenCV/lbpcascades
endef
OPENCV3_POST_INSTALL_TARGET_HOOKS += OPENCV3_CLEAN_INSTALL_DATA
endif

$(eval $(cmake-package))
