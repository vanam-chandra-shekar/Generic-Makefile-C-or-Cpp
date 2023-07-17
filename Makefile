INCLUDEDIR = include
SOURCEDIR = src
LIBDIR = lib
BINDIR = bin
LANGUAGE = cpp
PREPROCESSER = GLEW_STATIC
LIBRARIES = glew32 glfw3 opengl32 gdi32

TARGET = main

CXX = g++

INCLUDEDIR := $(foreach D,$(INCLUDEDIR),$(patsubst %,-I%,$(D)))
LIBDIR := $(foreach D,$(LIBDIR),$(patsubst %,-L%,$(D)))
PREPROCESSER := $(foreach D,$(PREPROCESSER),$(patsubst %,-D%,$(D)))
LIBRARIES := $(foreach D,$(LIBRARIES),$(patsubst %,-l%,$(D)))
SOURCEFILES := $(foreach D,$(SOURCEDIR),$(wildcard $(D)/*.$(LANGUAGE)))
OBJFILES := $(patsubst %.$(LANGUAGE),%.o,$(foreach D,$(SOURCEFILES),$(patsubst $(dir $(D))%,$(BINDIR)/%,$(D))))
DEPFILES := $(patsubst %.o,%.d,$(OBJFILES))

ifndef (CONFIG)
	CONFIG = DEBUG
endif

ifndef (VERBOS)
	SILENT = @
endif

ifeq ($(CONFIG),DEBUG)
	DEPFLAGS = -MP -MD
	CXXFLAGS = $(INCLUDEDIR) $(LIBDIR) $(LIBRARIES)  $(DEPFLAGS) -g $(PREPROCESSER)
endif

ifeq ($(CONFIG),RELEASE)
	DEPFLAGS = -MP -MD
	OPT = O2
	CXXFLAGS = $(INCLUDEDIR) $(LIBDIR) $(LIBRARIES)  $(DEPFLAGS) $(OPT) $(PREPROCESSER)
endif

VPATH = $(SOURCEDIR)

.PHONY: all clean

all:$(TARGET)

$(TARGET):$(OBJFILES)
	$(SILENT)echo ===== Linking =====
	$(SILENT)$(CXX) $^ -o $@ $(CXXFLAGS)
	$(SILENT)echo ===== RUNING =====
	$(SILENT).\$(TARGET)

$(BINDIR)/%.o:%.$(LANGUAGE) | $(BINDIR)
	$(SILENT) echo [Compiling $<]
	$(SILENT)$(CXX)  -c $< -o $@ $(CXXFLAGS)

$(BINDIR):
	$(SILENT)echo Creating $@ Dir
	$(SILENT)mkdir $@

clean:
	$(echo)echo ===== CLEANING =====
	$(SILENT)del /Q $(TARGET).exe
	$(SILENT)del /Q $(BINDIR)


-include $(DEPFILES)