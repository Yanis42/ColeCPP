ifeq ($(shell command -v clang++ >/dev/null 2>&1; echo $$?),0)
  CXX := clang++
else
  CXX := g++
endif

QT_INC := -I/usr/include/x86_64-linux-gnu/qt6 -I/usr/include/x86_64-linux-gnu/qt6/QtWidgets -I/usr/include/x86_64-linux-gnu/qt6/QtGui -I/usr/include/x86_64-linux-gnu/qt6/QtCore -I/usr/lib/x86_64-linux-gnu/qt6/mkspecs/linux-g++
QT_LIBS := /usr/lib/x86_64-linux-gnu/libQt6Widgets.so /usr/lib/x86_64-linux-gnu/libQt6Gui.so /usr/lib/x86_64-linux-gnu/libQt6Core.so

DEFINES = -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB
CXXFLAGS := -std=c++17 -Wall -Wextra -D_REENTRANT -fPIC $(DEFINES)
INC := -Iinclude $(QT_INC)

DEBUG := 0

ifneq ($(DEBUG),0)
	OPTFLAGS := -O0
	CXXFLAGS += -g3 -D_DEBUG
else
	OPTFLAGS := -O3
	DEFINES += -DQT_NO_DEBUG
endif

SRC_DIRS := src
CPP_FILES := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.cpp))
H_FILES := $(foreach dir,include,$(wildcard $(dir)/*.h))
MOC_FILES := $(subst include,src,$(H_FILES:.h=.moc.cpp))
O_FILES := $(foreach f,$(CPP_FILES:.cpp=.o),build/$f) $(foreach f,$(MOC_FILES:.moc.cpp=.moc.o),build/$f)
LIBS = $(SUBLIBS) $(QT_LIBS) /usr/lib/x86_64-linux-gnu/libGLX.so /usr/lib/x86_64-linux-gnu/libOpenGL.so -lpthread -lGLX -lOpenGL

OUTPUT := cole.out
UIC := /usr/lib/qt6/libexec/uic
MOC := /usr/lib/qt6/libexec/moc

# create build directory
$(shell mkdir -p $(foreach dir,$(SRC_DIRS),build/$(dir)))

# main targets
all: ui_to_h genmoc $(OUTPUT)

clean:
	rm -rf build $(OUTPUT)

format:
	clang-format-14 -i $(H_FILES) $(CPP_FILES)

ui_to_h:
	$(UIC) -o include/UiMainWindow.h res/UiMainWindow.ui

genmoc:
	$(MAKE) $(foreach f,$(MOC_FILES),$f)

.PHONY: all clean format ui_to_h genmoc

src/%.moc.cpp: include/%.h
	$(MOC) $(INC) $< -o $@

build/src/%.o: src/%.cpp
	$(CXX) $(CXXFLAGS) $(OPTFLAGS) $(INC) -c $(OUTPUT_OPTION) $<

$(OUTPUT): $(O_FILES)
	$(CXX) $(CXXFLAGS) $(O_FILES) $(OUTPUT_OPTION) $(LIBS)
