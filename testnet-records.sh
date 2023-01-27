set -e

NEARD=/home/marcelo/nearcore/target/debug/neard

in_dir=$(mktemp -d)
out_dir=$(mktemp -d)

echo "input dir: $in_dir"
echo "output dir: $out_dir"

$NEARD --home $in_dir init --chain-id testnet --download-config --download-genesis

jq '.records' "$in_dir/genesis.json" > "$out_dir/records.json"
jq '.records = []' "$in_dir/genesis.json" > "$out_dir/genesis.json"
jq '.genesis_records_file = "records.json"' "$in_dir/config.json" > "$out_dir/config.json"

md5sum "$out_dir/genesis.json" > "$out_dir/genesis_md5sum" | cut -d ' ' -f 1
md5sum "$out_dir/records.json" > "$out_dir/records_md5sum" | cut -d ' ' -f 1

xz --keep "$out_dir/genesis.json"
xz --keep "$out_dir/records.json"
