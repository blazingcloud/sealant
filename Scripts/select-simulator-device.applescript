set simulatedDevice to (item 1 of argv)

tell application "iPhone Simulator"
	activate
end tell

tell application "System Events"
	tell process "iPhone Simulator"
		tell menu bar 1
			tell menu bar item "Hardware"
				tell menu "Hardware"
					tell menu item "Device"
						tell menu "Device"
							click menu item simulatedDevice
						end tell
					end tell
				end tell
			end tell
		end tell
	end tell
end tell
