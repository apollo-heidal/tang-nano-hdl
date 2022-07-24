# variables
DEVICE='GW1N-LV1QN48C6/I5';
BOARD='tangnano';

# synthesis commands
yosys -p \
"read_verilog delayed_pulse.v top.v
proc; opt
techmap; opt
synth_gowin
write_json top.json";

# place-n-route
nextpnr-gowin \
    --json top.json \
    --write top.pnr.json \
    --device $DEVICE \
    --cst ../tang-nano.cst;

# pack
gowin_pack -d $DEVICE -o top.pack.fs top.pnr.json;

# load to board
openFPGALoader -v top.pack.fs;
