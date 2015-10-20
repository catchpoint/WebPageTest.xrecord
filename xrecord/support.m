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
@import Foundation;

BOOL signaled = NO;
BOOL started_quicktime = NO;
int child_process = 0;

static void signalHandler(int sig)
{
    signaled = YES;
    if (child_process != 0) {
        kill(child_process, sig);
    }
}

void onUncaughtException(NSException* exception)
{
    NSLog(@"uncaught exception: %@", exception.description);
}



@implementation XRecord_Bridge
+ (void) startQuickTime
{
  @autoreleasepool
  {
    // Start quicktime and a dummy audio recording (needed to trigger the exposing of iOS devices)
    QuickTimeApplication * qt = [SBApplication applicationWithBundleIdentifier:@"com.apple.QuickTimePlayerX"];
    started_quicktime = YES;
    sleep(1);
    [qt newAudioRecording];
    sleep(1);
  }
}

+ (void) stopQuickTime:(BOOL)force
{
  @autoreleasepool
  {
    if (force || started_quicktime == YES) {
      QuickTimeApplication * qt = [SBApplication applicationWithBundleIdentifier:@"com.apple.QuickTimePlayerX"];
      [qt quitSaving:QuickTimeSaveOptionsNo];
      started_quicktime = NO;
      sleep(2);

      // Kill all instances of PTPCamera which can sometimes get wedged and prevent iOS devices from showing up
      NSTask *task = [NSTask new];
      NSPipe *std_out = [NSPipe new];
      NSPipe *std_err = [NSPipe new];
      task.launchPath = @"/usr/bin/killall";
      task.arguments = @[@"PTPCamera"];
      [task setStandardOutput:std_out];
      [task setStandardError:std_err];
      [task launch];
      [task waitUntilExit];
      
      sleep(1);
    }
  }
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

+ (void) installSignalHandler:(int)child_pid
{
    child_process = child_pid;
    NSSetUncaughtExceptionHandler(&onUncaughtException);
    signal(SIGINT, signalHandler);
    signal(SIGTERM, signalHandler);
    signal(SIGQUIT, signalHandler);
    signal(SIGABRT, signalHandler);
}

+ (BOOL) didSignal
{
    return signaled;
}

@end