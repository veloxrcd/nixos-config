#!/usr/bin/env bash
TREE=$(swaymsg -t get_tree)
WS_ID=$(echo "$TREE" | jq -r ".. | select(.type? == \"workspace\" and (.focus | length > 0)) | .id" | head -n 1)
ALL_IDS=$(echo "$TREE" | jq -r ".. | select(.type? == \"workspace\" and .id == $WS_ID) | .. | select(.type? == \"con\" or .type? == \"floating_con\") | select(.app_id? != null or .window_properties? != null) | .id" | head -n 2)

ID1=$(echo "$ALL_IDS" | head -n 1)
ID2=$(echo "$ALL_IDS" | tail -n 1)

if [ -n "$ID1" ]; then
  swaymsg "[con_id=$ID1] floating enable, resize set width 45ppt height 45ppt, move position 5ppt 5ppt"
fi

if [ -n "$ID2" ] && [ "$ID1" != "$ID2" ]; then
  swaymsg "[con_id=$ID2] floating enable, resize set width 45ppt height 45ppt, move position 50ppt 50ppt"
fi
