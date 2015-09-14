//
//  support.h
//  xrecord
//
//  Created by Patrick Meenan on 2/24/15.
//  Copyright (c) 2015 WPO Foundation. All rights reserved.
//

#ifndef xrecord_support_h
#define xrecord_support_h

#import <Foundation/Foundation.h>

@interface XRecord_Bridge : NSObject
+ (void) startQuickTime;
+ (void) stopQuickTime;
+ (void) enableScreenCaptureDevices;
+ (void) installSignalHandler:(int)child_pid;
+ (BOOL) didSignal;
@end

#endif
