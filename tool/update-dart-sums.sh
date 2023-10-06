#!/usr/bin/env bash

# Use this file to update the Dart SHA256 hashes 
# in the Dockerfile. Run after check-dart-sdk.sh

lead='# BEGIN dart-sha$'
tail='# END dart-sha$'
new_file='tool/new-dart-hashes.txt'
existing_file='Dockerfile'

new_hash=$(sed -n -e '/DART_SHA/ p' -e '/DART_SHA/ q' $new_file)
old_hash=$(sed -n -e '/DART_SHA/ p' -e '/DART_SHA/ q' $existing_file)

echo -e "Old $old_hash"
echo -e "New $new_hash"

if [[ -z "$new_hash" ]]; then
    echo "No new hash found."
else [[ -z "$old_hash" ]]
    echo "Comparing hashes"
    if [["$new_hash" = "$old_hash"]]; then
        echo "Hashes match. No changes needed."
    else
        echo "New hashes found. Replacing hashes.\n"
        echo $(sed -i.save -e "/$lead/,/$tail/{ /$lead/{p; r $new_file
                }; /$tail/p;d;}" $existing_file)
        echo "Replaced hashes"
    fi
fi

rm $new_file
echo -e "Removed $new_file. Re-run check-dart-sdk.sh to pull the current SHA hashes.\n"

echo -e "Update completed."
