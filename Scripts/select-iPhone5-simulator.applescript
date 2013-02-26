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
							click menu item "iPhone (Retina 4-inch)"
						end tell
					end tell
				end tell
			end tell
		end tell
	end tell
end tell
