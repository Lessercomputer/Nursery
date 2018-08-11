//
//  NUThreadedChildminder.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/03/16.
//
//

#import <Foundation/NSObject.h>

@class NSThread;

@class NUGarden;

@interface NUThreadedChildminder : NSObject
{
    NUGarden *garden;
    NSThread *thread;
}

+ (id)threadedChildminderWithGarden:(NUGarden *)aGarden;

- (id)initWithGarden:(NUGarden *)aGarden;

- (NUGarden *)garden;
- (void)setGarden:(NUGarden *)aGarden;

- (NSString *)threadName;
- (double)threadPriority;

- (void)start;
- (void)stop;

- (void)startThread:(id)anArgument;
- (void)processOneUnit;

@end
