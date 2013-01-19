//
//  KWImageMatcher.m
//
//  Created by Blazing Pair on 12/10/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

#import "KWImageMatcher.h"
#import "BZSpecHelper.h"

@interface KWImageMatcher ()
@property (nonatomic, strong) UIImage *object;
@property (nonatomic, strong) NSString *objectName;
@end

@implementation KWImageMatcher

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return @[@"matchImage:"];
}

#pragma mark -
#pragma mark Getting Matcher Compatability

+ (BOOL)canMatchSubject:(id)anObject {
    return [anObject isKindOfClass:[UIImage class]];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
    return [UIImagePNGRepresentation(subject) isEqual:UIImagePNGRepresentation(self.object)];
}

- (void)matchImage:(NSString *)expectedImageName {
    self.objectName = expectedImageName;
    UIImage *anImage = [UIImage imageWithData:[BZSpecHelper testDataFromFile:self.objectName]];
    NSAssert1(anImage, @"could not find expected image: %@", self.objectName);
    self.object = anImage;
}

- (NSString *)failureMessageForShould {
    NSString *actualImagePath = [@"/tmp" stringByAppendingPathComponent:self.objectName];
    [UIImagePNGRepresentation(subject) writeToFile:actualImagePath atomically:NO];
    return [NSString stringWithFormat:@"image should match %@", actualImagePath];
}

- (NSString *)failureMessageForShouldNot {
    return [NSString stringWithFormat:@"image should not match %@", [[BZSpecHelper urlForTestFile:self.objectName] path]];
}


@end
