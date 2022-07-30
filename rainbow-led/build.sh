# variables
DEVICE='GW1N-LV1QN48C6/I5';
BOARD='tangnano';

# synthesis commands
yosys -p \
"read_verilog rainbow_led.v
proc; opt
techmap; opt
synth_gowin
write_json rainbow_led.json";

# place-n-route
nextpnr-gowin \
    --json rainbow_led.json \
    --write rainbow_led.pnr.json \
    --device $DEVICE \
    --cst ../tang-nano.cst;

# pack
gowin_pack -d $DEVICE -o rainbow_led.pack.fs rainbow_led.pnr.json;

# load to board
openFPGALoader -v rainbow_led.pack.fs;
