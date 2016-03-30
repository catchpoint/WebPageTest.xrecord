//
//  PluginHeaderHelper.cpp
//  xrecord
//
//  Created by sfk on 30/03/16.
//  Copyright © 2016 WPO Foundation. All rights reserved.
//

#include "PluginHeaderHelper.h"

MyInterfaceStruct** startScreenCapturePlugin()
{
    CFUUIDRef pluginFactoryRef = CFUUIDCreateFromString(NULL,CFSTR("30010C1C-93BF-11D8-8B5B-000A95AF9C6A"));
    CFUUIDRef interfaceTypeRef = CFUUIDGetConstantUUIDWithBytes(0x0, 0xb8, 0x9d, 0xfa, 0xba, 0x93, 0xbf, 0x11, 0xd8, 0x8e, 0xa6, 0x0, 0xa, 0x95, 0xaf, 0x9c, 0x6a);
    MyInterfaceStruct **interface = NULL;
    
    //create a url that points to plug-in using the hard-coded path
    CFURLRef pluginUrl = CFURLCreateWithFileSystemPath(NULL, CFSTR("/Library/CoreMediaIO/Plug-Ins/DAL/iOSScreenCapture.plugin"), CFURLPathStyle(0), true);
    
    CFPlugInAddInstanceForFactory(pluginFactoryRef);
    
    //create a CFPlugin using the url
    //this step causes the plug-ins types and factories
    //to be registered with the system
    //note that plug-ins code is not loaded unless
    //the plug-in is using dynamic registration
    
    CFPlugInRef plugin = CFPlugInCreate(NULL,pluginUrl);
    
    if(plugin)
    {
        //See if this plug-in implements the "my" type
        
        CFArrayRef factories = CFPlugInFindFactoriesForPlugInType(pluginFactoryRef);
        
        //if there are factories for requested type, attempt to get
        //the iknown interface
        
        if((factories != NULL) && (CFArrayGetCount(factories)>0)){
            
            //get the factory id for the first location in the array
            // of IDs
            CFUUIDRef factoryID = (CFUUIDRef)CFArrayGetValueAtIndex(factories, 0);
            
            //use the factory id to get an IUknown interface
            //Here to code for plugin is loaded
            //IUknownVTbl is a struct containing the IUNKNOWN_C_GUTS
            //CFPlugin::MyFactoryFunction is called here
            
            
            IUnknownVTbl **iunknown =(IUnknownVTbl**) CFPlugInInstanceCreate(NULL, factoryID,pluginFactoryRef);
            
            //if this is a iunknown interface
            //query for the test interface
            
            if(iunknown)
            {
                
                (*iunknown)->QueryInterface(iunknown,CFUUIDGetUUIDBytes(interfaceTypeRef),(LPVOID *)(&interface));
                (*iunknown)->Release(iunknown);
                
                if(interface){
                    (*interface)->Initialize(interface);
                    
                    //wait for plugin load max 15 sec
                    Boolean loaded = false;
                    int count = 0 ;
                    while (loaded != true || count > 15) {
                        loaded = CFPlugInIsLoadOnDemand(plugin);
                        usleep(1000000); // will sleep for 1 s
                        count = count+1;
                    }
                    
                }
                
            }
        }
        
    }
    return interface;
}

void stopScreenCapturePlugin(MyInterfaceStruct** interface)
{
    if(interface != NULL) (*interface)->Release(interface);
}


