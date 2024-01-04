#!/bin/bash
set -e

# Check links are valid 
TOOL_DIR=/tool
tool/check-links.sh

# Deploy to Firebase hosting
firebase deploy --project=flutter-website-staging --only=hosting


