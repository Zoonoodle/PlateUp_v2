#!/usr/bin/env python3
import subprocess
import time

# Tap on the first check-in card (Morning)
# iPhone 16 Pro has resolution 1179 × 2556 (logical 393 × 852)
# Check-in cards should be around y=250-350 area
subprocess.run(["xcrun", "simctl", "spawn", "iPhone 16 Pro", "uiopen", "plateup://focus"])
time.sleep(2)

# Since we can't directly tap, let's try to trigger the check-in via deep link
subprocess.run(["xcrun", "simctl", "openurl", "iPhone 16 Pro", "plateup://checkin/morning"])