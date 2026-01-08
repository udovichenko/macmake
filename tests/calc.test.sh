#!/bin/bash

# Test calc and calc-limit make targets
# This script demonstrates the usage of the new CSS calculation functions

echo "╔════════════════════════════════════════════════════════════╗"
echo "║          Testing calc and calc-limit Make Targets          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo "📋 Test 1: Basic calc (380:10 → 1440:20)"
echo "Command: make calc v=10,20,380,1440"
OUTPUT=$(make calc v=10,20,380,1440 2>&1 | grep -v "^$")
echo "Result: $OUTPUT"
echo "Expected: calc(6px + 0.9vw); /* 380:10 - 1440:20 */"
echo ""

echo "📋 Test 2: Basic calc-limit (380:100 → 1440:150)"
echo "Command: make calc-limit v=100,150,380,1440"
OUTPUT=$(make calc-limit v=100,150,380,1440 2>&1 | grep -v "^$")
echo "Result: $OUTPUT"
echo "Expected: min(calc(82px + 4.7vw), 150px); /* 380:100 - 1440:150 */"
echo ""

echo "📋 Test 3: calc with default breakpoints (393:16 → 1440:24)"
echo "Command: make calc v=16,24"
OUTPUT=$(make calc v=16,24 2>&1 | grep -v "^$")
echo "Result: $OUTPUT"
echo "Expected: calc(13px + 0.8vw); /* 393:16 - 1440:24 */"
echo ""

echo "📋 Test 4: calc-limit with custom breakpoints (768:50 → 1920:80)"
echo "Command: make calc-limit v=50,80,768,1920"
OUTPUT=$(make calc-limit v=50,80,768,1920 2>&1 | grep -v "^$")
echo "Result: $OUTPUT"
echo "Expected: min(calc(30px + 2.6vw), 80px); /* 768:50 - 1920:80 */"
echo ""

echo "✅ All tests completed!"
echo ""
echo "Note: Output is automatically copied to clipboard with each command."

