//
//  NUThreadedChildminder.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/03/16.
//
//

#import <Foundation/NSObject.h>
#import <Foundation/NSDate.h>

@class NSThread;

@class NUGarden;

@interface NUThreadedChildminder : NSObject
{
    BOOL isLoaded;
    NUGarden *garden;
    NSThread *thread;
}

+ (id)threadedChildminderWithGarden:(NUGarden *)aGarden;

- (id)initWithGarden:(NUGarden *)aGarden;

- (NUGarden *)garden;
- (void)setGarden:(NUGarden *)aGarden;

- (NSString *)threadName;
- (double)threadPriority;

- (NSTimeInterval)lowerTimeInterval;
- (double)timeRatio;

- (void)start;
- (void)stop;

- (void)startThread:(id)anArgument;
- (BOOL)processOneUnit;

- (BOOL)isLoaded;
- (void)setIsLoaded:(BOOL)aLoadedFlag;

@end
