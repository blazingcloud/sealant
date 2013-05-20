#import "JSObjectionBindingEntry.h"


@implementation JSObjectionBindingEntry

- (id)initWithObject:(id)theObject {
    if ((self = [super init])) {
        _instance = theObject;    
    }
    return self;
}

- (id)extractObject:(NSArray *)arguments {
    return _instance;
}

- (JSObjectionScope)lifeCycle {
    return JSObjectionScopeSingleton;
}

- (void)dealloc {
     _instance = nil;
}

@end
