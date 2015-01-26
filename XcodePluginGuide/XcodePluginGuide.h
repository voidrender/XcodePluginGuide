//
//  XcodePluginGuide.h
//  XcodePluginGuide
//
//  Created by Isaac Overacker on 1/25/15.
//
//

#import <AppKit/AppKit.h>

@interface XcodePluginGuide : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end