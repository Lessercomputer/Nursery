//
//  NUThreadedChildminder.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/03/16.
//
//

#import <Foundation/NSObject.h>

@class NSConditionLock;
@class NUGarden;

@interface NUThreadedChildminder : NSObject
{
    NUGarden *garden;
	NSConditionLock *conditionLock;
	BOOL shouldStop;
	BOOL shouldTerminate;
    BOOL isTerminated;
}

+ (id)threadedChildminderWithGarden:(NUGarden *)aGarden;

- (id)initWithGarden:(NUGarden *)aGarden;

- (NUGarden *)garden;
- (void)setGarden:(NUGarden *)aGarden;

- (NSString *)threadName;
- (double)threadPriority;

- (void)prepare;
- (void)start;
- (void)stop;
- (void)terminate;
- (void)startThread:(id)anArgument;
- (void)process;

- (BOOL)shouldStop;
- (void)setShouldStop:(BOOL)aShouldStop;

- (BOOL)shouldTerminate;
- (void)setShouldTerminate:(BOOL)aShouldTerminate;

- (BOOL)isTerminated;
- (void)setIsTerminated:(BOOL)aTerminated;

@end
