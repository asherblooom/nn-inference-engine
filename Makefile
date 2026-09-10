TARGET_EXEC := read_onnx.out
CXX := g++
CXXFLAGS := -std=c++17 -O2 -Wall -Wextra $(shell pkg-config --cflags protobuf)
LINKERFLAGS := -pthread $(shell pkg-config --libs protobuf)
OBJ_DIR := ./obj
SRC_DIR := ./src

# Find all .cpp and .cc files in the src directory
SRCS := $(shell find $(SRC_DIR) -name '*.cpp' -o -name '*.cc')
# Extract just the filenames, then replace .cpp and .cc with .o
_OBJS := $(notdir $(SRCS))
_OBJS_CPP := $(_OBJS:.cpp=.o)
_OBJS_FINAL := $(_OBJS_CPP:.cc=.o)
# Prepend the obj directory path
OBJS := $(_OBJS_FINAL:%=$(OBJ_DIR)/%)

.PHONY: all clean

all: obj $(TARGET_EXEC)

# Link object files into the final executable
$(TARGET_EXEC): $(OBJS)
	$(CXX) -o $@ $^ $(LINKERFLAGS)

# Compile .cpp files from the base src directory
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@
# Compile .cc files from the base src directory
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cc
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Find sources in 1-level deep subdirs
$(OBJ_DIR)/%.o: $(SRC_DIR)/*/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@
$(OBJ_DIR)/%.o: $(SRC_DIR)/*/%.cc
	$(CXX) $(CXXFLAGS) -c $< -o $@

obj: 
	mkdir -p $(OBJ_DIR)

# Remove object directory and target executable
clean:
	rm -rf $(OBJ_DIR) $(TARGET_EXEC)
