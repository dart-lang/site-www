#!/bin/bash
set -e

# Deploy to Firebase hosting
firebase deploy --project=flutter-website-staging --only=hosting


