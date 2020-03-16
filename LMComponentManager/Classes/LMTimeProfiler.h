//
//  LMTimeProfiler.h
//  LMComponentManager
//
//  Created by Arclin on 2020/3/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMTimeProfiler : NSObject

#pragma mark - Open API

#define kTimeProfilerResultNotificationName @"LMTimeProfilerResult"
#define kNotificationUserInfoKey            @"logArray"

+ (LMTimeProfiler *)sharedTimeProfiler;

- (instancetype)initTimeProfilerWithMainKey:(NSString *)mainKey;
- (void)recordEventTime:(NSString *)eventName;

- (void)printOutTimeProfileResult;
- (void)saveTimeProfileDataIntoFile:(NSString *)filePath;
- (void)postTimeProfileResultNotification;


@end

NS_ASSUME_NONNULL_END
