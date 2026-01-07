# project source
TOP = cpu

VSRCS_DIR = ./rtl
VINC_DIR = ./include
CSRCS_DIR = ./sim
BUILD_DIR = ./verilator
OBJ_DIR = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/$(TOP)

VINC = $(shell find $(VINC_DIR) -name "*.vh" -or -name "*.svh")
VSRCS = $(shell find $(VSRCS_DIR) -name "*.v" -or -name "*.sv")
CSRCS = $(shell find $(CSRC_DIR) -name "*.c" -or -name "*.cc" -or -name "*.cpp")

VERILATOR = verilator
VERILATOR_FLAGS =  --trace --build --Mdir $(OBJ_DIR)#--Wall

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(OBJ_DIR)

all:run view
	
sim:$(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)/sim/
	cp $(CSRCS_DIR)/sim_main.cpp $(BUILD_DIR)/sim/
	$(VERILATOR) $(VERILATOR_FLAGS) \
		-I$(VINC_DIR)\
		-cc $(VSRCS) \
		--top-module $(TOP) \
		--exe $(CSRCS_DIR)/sim_main.cpp

run:sim
	cd $(BUILD_DIR) && ./obj_dir/V$(TOP)

view:
	gtkwave $(BUILD_DIR)/dump.vcd &

clean:
	rm -rf $(BUILD_DIR)


