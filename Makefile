# Makefile

RESET=\033[0m
BOLD=\033[1m
GREEN=\033[0;92m
RED=\033[0;91m
MAGENTA=\033[0;95m
CYAN=\033[0;96m

ERROR=$(BOLD)$(RED)
SUCCESS=$(BOLD)$(GREEN)
INFO=$(BOLD)$(CYAN)

CXX := g++
CXXFLAGS := -std=c++17 -Wall -Wextra -Weverything -Wvla -O1 -g3 -pedantic -v -fsanitize=address -fno-omit-frame-pointer -fno-optimize-sibling-calls
DBG = gdb
LDFLAGS := -v -lc

BUILD_DIRECTORY := build

EXECUTABLE := $(BUILD_DIRECTORY)/program

SRCS := $(wildcard *.cpp) #$(wildcard */*.cpp)
HDRS := $(wildcard *.h) $(wildcard */*.h)
OBJS := $(patsubst %.cpp, $(BUILD_DIRECTORY)/%.o, $(SRCS))


.PHONY: all clean help run check debug

all: $(EXECUTABLE)

check:
	@which $(CXX) > /dev/null && echo "$(SUCCESS)✅ SUCCESS:$(RESET) $(CXX) is installed" || echo "$(ERROR)❌ ERROR:$(RESET) $(CXX) not found, please install $(CXX)"
	@which $(DBG) > /dev/null && echo "$(SUCCESS)✅ SUCCESS:$(RESET) $(DBG) is installed" || echo "$(ERROR)❌ ERROR:$(RESET) $(DBG) not found, please install $(DBG)"

$(EXECUTABLE): $(OBJS)
	@echo "🔧 Linking $(INFO)$@$(RESET) ..."
	@mkdir -p $(@D)
	@$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS) && \
		echo "$(SUCCESS)✅ Build successful:$(RESET) $@" || \
		(echo "$(ERROR)❌ Linking failed:$(RESET) $@" && exit 1)

$(BUILD_DIRECTORY)/%.o: %.cpp
	@echo "🔧 Compiling $(INFO)$<$(RESET) ..."
	@mkdir -p $(@D)
	@$(CXX) $(CXXFLAGS) -c $< -o $@ && \
		echo "$(SUCCESS)✅ Compiled:$(RESET) $<" || \
		(echo "$(ERROR)❌ Compile failed:$(RESET) $<" && exit 1)


debug: $(EXECUTABLE)
	@$(DBG) ./$(EXECUTABLE)

clean:
	@echo "$(INFO)make clean$(RESET) $(RM) -r $(EXECUTABLE) $(OBJS) $(BUILD_DIRECTORY) *~ *.bak *.dSYM *.out .*.un~"
	@$(RM) -r $(EXECUTABLE) $(OBJS) $(BUILD_DIRECTORY) *~ *.bak *.dSYM *.out .*.un~


run: $(EXECUTABLE)
	@echo "$(INFO)make run$(RESET)"
	@make clean
	@make all
	@./$(EXECUTABLE)
	@make clean


help:
	@echo "$(INFO)make help$(RESET)"
	@echo "Makefile for Building $(MAGENTA)$(EXECUTABLE)$(RESET)."
	@echo "Usage:"
	@echo "  $(MAGENTA)make$(RESET)             — build"
	@echo "  $(MAGENTA)make all$(RESET)         — build"
	@echo "  $(MAGENTA)make check$(RESET)       — dependency check"
	@echo "  $(MAGENTA)make clean$(RESET)       — remove build files"
	@echo "  $(MAGENTA)make run$(RESET)         — run program"

