#!/usr/bin/env sh

echo "================ Deploy to Firebase ========================"
firebase deploy --token "${FIREBASE_TOKEN}" --non-interactive

