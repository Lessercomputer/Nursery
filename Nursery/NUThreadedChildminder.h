//
//  NUThreadedChildminder.h
//  Nursery
//
//  Created by P,T,A on 2013/03/16.
//
//

@class NUPlayLot;

@interface NUThreadedChildminder : NSObject
{
    NUPlayLot *playLot;
	NSConditionLock *conditionLock;
	BOOL shouldStop;
	BOOL shouldTerminate;
    BOOL isTerminated;
}

+ (id)threadedChildminderWithPlayLot:(NUPlayLot *)aPlayLot;

- (id)initWithPlayLot:(NUPlayLot *)aPlayLot;

- (NUPlayLot *)playLot;
- (void)setPlayLot:(NUPlayLot *)aPlayLot;

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
