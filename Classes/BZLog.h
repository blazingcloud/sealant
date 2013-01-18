//
//  BZLog.h
//
// http://www.cimgf.com/2009/01/24/dropping-nslog-in-release-builds/
// DLog is almost a drop-in replacement for NSLog
//
// DLog(@"x value: %d", x);
// DLogLine;
// DLogObject(myVar);
// DLogPtr(myPointer);

#ifndef BZLog_h
#define BZLog_h

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog(@"%s [line %d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#define ALog(fmt, ...) NSLog((@"%s line:%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#ifdef DEBUG
#	define DLog(fmt, ...) ALog(fmt, ##__VA_ARGS__);
#   define ELog(err) {if(err) DLogObject(err)}
#   define ULog(fmt, ...)   { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:\
[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] \
message:[NSString stringWithFormat:fmt, ##__VA_ARGS__] \
delegate:nil \
cancelButtonTitle:@"Ok" \
otherButtonTitles:nil]; \
[alert show]; \
}
#else
#   define DLog(...)
#   define ELog(...)
#   define ULog(...)
#endif

#define DLogLine DLog(@".")
#define DLogObject(o) DLog(#o @"=%@", o)

#define DLogPtr(p) DLog(#p @"=%p", p)
#define DLogInt(i) DLog(#i @"=%d", i)
#define DLogFloat(f) DLog(#f @"=%f", f)

// CGRect
#define DLogRect(r) DLog(#r @"={{%f,%f},{%f,%f}}", r.origin.x, r.origin.y, r.size.width, r.size.height)
// CGSize
#define DLogSize(s) DLog(#s @"={%f,%f}", s.width, s.height)
// CGPoint
#define DLogPoint(p) DLog(#p @"={%f,%f}", p.x, p.y)

#define DLogOrientation(o)                  DLog(@"%@", \
o==UIDeviceOrientationUnknown               ? @"UIDeviceOrientationUnknown"             : \
o==UIDeviceOrientationPortrait              ? @"UIDeviceOrientationPortrait"            : \
o==UIDeviceOrientationPortraitUpsideDown    ? @"UIDeviceOrientationPortraitUpsideDown"  : \
o==UIDeviceOrientationLandscapeLeft         ? @"UIDeviceOrientationLandscapeLeft"       : \
o==UIDeviceOrientationLandscapeRight        ? @"UIDeviceOrientationLandscapeRight"      : \
o==UIDeviceOrientationFaceUp                ? @"UIDeviceOrientationFaceUp"              : \
o==UIDeviceOrientationFaceDown              ? @"UIDeviceOrientationFaceDown"            : \
@"Unknown")

#endif
