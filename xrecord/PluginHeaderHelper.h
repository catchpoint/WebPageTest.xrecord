//
//  PluginHeaderHelper.hpp
//  xrecord
//
//  Created by sfk on 30/03/16.
//  Copyright © 2016 WPO Foundation. All rights reserved.
//

#ifndef PluginHeaderHelper_hpp
#define PluginHeaderHelper_hpp

#include "PluginHeader.h"
#include <unistd.h>

void stopScreenCapturePlugin(MyInterfaceStruct **);

MyInterfaceStruct** startScreenCapturePlugin();


#endif /* PluginHeaderHelper_hpp */
