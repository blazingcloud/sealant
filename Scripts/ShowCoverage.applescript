(*
 ShowCoverage.applescript
 
 Show Coverage after running tests in Xcode

 Set up - edit XCode scheme and add Post action in Test step:
    osascript $PROJECT_DIR/<path_to_this_script>/ShowCoverage.applescript
 Select Provide Build Settings from Application Target, not Unit Tests
 Use default /bin/sh shell
 *)
set arch to system attribute "PLATFORM_PREFERRED_ARCH"
if arch is "i386" then
	set obj_dir to system attribute "OBJECT_FILE_DIR"
	set variant to system attribute "BUILD_VARIANTS"
	set coverage_dir to obj_dir & "-" & variant & "/" & arch
	tell application "CoverStory"
		activate
		set coverage to open (coverage_dir)
	end tell
end if