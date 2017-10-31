//
//  NUThreadedChildminder.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/03/16.
//
//

@class NUSandbox;

@interface NUThreadedChildminder : NSObject
{
    NUSandbox *sandbox;
	NSConditionLock *conditionLock;
	BOOL shouldStop;
	BOOL shouldTerminate;
    BOOL isTerminated;
}

+ (id)threadedChildminderWithSandbox:(NUSandbox *)aSandbox;

- (id)initWithSandbox:(NUSandbox *)aSandbox;

- (NUSandbox *)sandbox;
- (void)setSandbox:(NUSandbox *)aSandbox;

- (void)prepare;
- (void)start;
- (void)startWithoutWait;
- (void)stop;
- (void)terminate;
- (void)startThread:(id)anArgument;
- (void)process;

- (BOOL)shouldStop;
- (void)setShouldStop:(BOOL)aShouldStop;

@end
