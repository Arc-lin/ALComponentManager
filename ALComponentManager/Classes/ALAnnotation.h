//
//  ALAnnotation.h
//  ALComponentManager
//
//  Created by Arclin on 2020/3/15.
//

#import <Foundation/Foundation.h>

#ifndef ALModSectName

#define ALModSectName "ALMods"

#endif

#ifndef ALServiceSectName

#define ALServiceSectName "ALServices"

#endif


#define ALDATA(sectname) __attribute((used, section("__DATA, "#sectname" ")))


#define ALMod(name) \
class ALComponentManager; char * k##name##_mod ALDATA(ALMods) = ""#name"";

#define ALService(servicename,impl) \
class ALComponentManager; char * k##servicename##_service ALDATA(ALServices) = "{ \""#servicename"\" : \""#impl"\"}";


@interface ALAnnotation : NSObject

@end
