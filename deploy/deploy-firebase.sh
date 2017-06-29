#!/usr/bin/env bash

: ${FIREBASE_PROJECT:=default}

echo "================ Deploy to Firebase ($FIREBASE_PROJECT) ========================"
firebase --non-interactive deploy --token "$FIREBASE_TOKEN" --project $FIREBASE_PROJECT
