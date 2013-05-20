
// To check if a library is compiled with CocoaPods you
// can use the `COCOAPODS` macro definition which is
// defined in the xcconfigs so it is available in
// headers also when they are imported in the client
// project.


// KIF
#define COCOAPODS_POD_AVAILABLE_KIF
#define COCOAPODS_VERSION_MAJOR_KIF 0
#define COCOAPODS_VERSION_MINOR_KIF 0
#define COCOAPODS_VERSION_PATCH_KIF 1

// TestFlightSDK
#define COCOAPODS_POD_AVAILABLE_TestFlightSDK
// This library does not follow semantic-versioning,
// so we were not able to define version macros.
// Please contact the author.
// Version: 1.3.0.beta4.

