//
//  support.m
//  xrecord
//
//  Created by Patrick Meenan on 2/24/15.
//  Copyright (c) 2015 WPO Foundation. All rights reserved.
//

#import "support.h"
#import <CoreMediaIO/CMIOHardware.h>

@implementation XRecord_Bridge
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