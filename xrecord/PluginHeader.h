//
//  PluginHeader.h
//  xrecord
//
//  Created by sfk on 30/03/16.
//  Copyright © 2016 WPO Foundation. All rights reserved.
//

#ifndef PluginHeader_h
#define PluginHeader_h

#include <CoreFoundation/CFPlugInCOM.h>

typedef struct MyInterfaceStruct {
    IUNKNOWN_C_GUTS;
    int (*Initialize)(void *);
    int (*InitializeWithObjectID)(void*,unsigned int);
    int (*TearDown)(void *);
    int (*ObjectShow)(void *,unsigned int);
    int (*ObjectHasProperty)(void *,unsigned int, void *);
    int (*ObjectIsPropertySettable)(void *,unsigned int ,void * ,int *);
    int (*ObjectGetPropertyDataSize)(void *,
                                     unsigned int,
                                     void * ,
                                     unsigned int,
                                     void *,
                                     unsigned int *);
    int (*ObjectGetPropertyData)(void *,
                                 unsigned int,
                                 void *,
                                 unsigned int,
                                 void *,
                                 unsigned int,
                                 unsigned int *,
                                 void *);
    int (*ObjectSetPropertyData)(void *,
                                 unsigned int,
                                 void *,
                                 unsigned int,
                                 void *,
                                 unsigned int,
                                 void *);
    int (*DeviceSuspend)(void *, unsigned int);
    int (*DeviceResume)(void *, unsigned int);
    int (*DeviceStartStream)(void * , unsigned int, unsigned int);
    int (*DeviceStopStream)(void *, unsigned int, unsigned int );
    int (*DeviceProcessAVCCommand)(void *, unsigned int, void *);
    int (*DeviceProcessRS422Command)(void *,unsigned int, void *);
    int (*StreamCopyBufferQueue)(void *, unsigned int, void (*)(unsigned int, void*, void*), void*, void *);
    int (*StreamDeckPlay)(void *, unsigned int);
    int (*StreamDeckStop)(void *, unsigned int);
    int (*StreamDeckJog)(void *, unsigned int, int);
    int (*StreamDeckCueTo)(void *, unsigned int, float, int);
    
} MyInterfaceStruct ;

#endif /* PluginHeader_h */
