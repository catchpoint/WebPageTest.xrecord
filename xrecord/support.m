//
//  support.m
//  xrecord
//
//  Created by Patrick Meenan on 2/24/15.
//  Copyright (c) 2015 WPO Foundation. All rights reserved.
//

#import "support.h"
#import "QuickTime.h"
#import <CoreMediaIO/CMIOHardware.h>

@implementation XRecord_Bridge
+ (void) startQuickTime
{
    BOOL already_running = NO;
    QuickTimeApplication * qt = [SBApplication applicationWithBundleIdentifier:@"com.apple.QuickTimePlayerX"];
    SBElementArray * documents = [qt documents];
    for (QuickTimeDocument* document in documents) {
        if ([[document name] isEqualToString:@"Audio Recording"])
            already_running = YES;
    }
    if (already_running == NO)
        [qt newAudioRecording];
}

+ (void) enableScreenCaptureDevices
{
    // Enable iOS device to show up as AVCapture devices
    // From WWDC video 2014 #508 at 5:34
    // https://developer.apple.com/videos/wwdc/2014/#508
    CMIOObjectPropertyAddress prop = {
        kCMIOHardwarePropertyAllowScreenCaptureDevices,
        kCMIOObjectPropertyScopeGlobal,
        kCMIOObjectPropertyElementMaster };
    UInt32 allow = 1;
    CMIOObjectSetPropertyData(kCMIOObjectSystemObject, &prop, 0, NULL, sizeof(allow), &allow);
}
@end