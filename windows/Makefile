
CXX          := g++
DEBUG_FLAGS  = -g
CXXFLAGS     += -c -Wall
LINK         := g++
LDFLAGS      =  


ifdef COMSPEC
# Windows
EXT   = .exe
LIBS  = 
#LIBS  = -lws2_32 -lhidapi -lncurses 
endif


SOURCES = \
	  loaddrv.cpp \
	  loaddrv.h

OBJECTS = loaddrv.o


all: loaddrv$(EXT)


clean:
	rm -rf  loaddrv$(EXT) *.o



#compile
${OBJS}: %.o: %.cpp
	$(CXX) -o $@ $(CXXFLAGS) $<

#link
loaddrv$(EXT): $(OBJECTS)
	$(LINK) $(LDFLAGS) -o loaddrv$(EXT) $^ $(LIBS)

