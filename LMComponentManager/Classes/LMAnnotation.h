//
//  LMAnnotation.h
//  LMComponentManager
//
//  Created by Arclin on 2020/3/15.
//

#import <Foundation/Foundation.h>

#ifndef LMModSectName

#define LMModSectName "LMMods"

#endif

#ifndef LMServiceSectName

#define LMServiceSectName "LMServices"

#endif


#define LMDATA(sectname) __attribute((used, section("__DATA, "#sectname" ")))


#define LMMod(name) \
class LMComponentManager; char * k##name##_mod LMDATA(LMMods) = ""#name"";

#define LMService(servicename,impl) \
class LMComponentManager; char * k##servicename##_service LMDATA(LMServices) = "{ \""#servicename"\" : \""#impl"\"}";


@interface LMAnnotation : NSObject

@end
