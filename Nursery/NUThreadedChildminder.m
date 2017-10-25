//
//  NUThreadedChildminder.m
//  Nursery
//
//  Created by P,T,A on 2013/03/16.
//
//

#import "NUThreadedChildminder.h"
#import <Nursery/NUMainBranchNursery.h>

const int NUThreadedChildminderActiveCondition      = 0;
const int NUThreadedChildminderDeactiveCondition    = 1;
const int NUThreadedChildminderTerminateCondition   = 2;

@implementation NUThreadedChildminder

+ (id)threadedChildminderWithPlayLot:(NUPlayLot *)aPlayLot
{
	return [[[self alloc] initWithPlayLot:aPlayLot] autorelease];
}

- (id)initWithPlayLot:(NUPlayLot *)aPlayLot
{
	if (self = [super init])
    {
        [self setPlayLot:aPlayLot];
        shouldTerminate = NO;
        shouldStop = NO;
        conditionLock = [[NSConditionLock alloc] initWithCondition:NUThreadedChildminderDeactiveCondition];
    }
    
	return self;
}

- (void)dealloc
{
	[conditionLock release];
	
	[super dealloc];
}

- (NUPlayLot *)playLot
{
    return playLot;
}

- (void)setPlayLot:(NUPlayLot *)aPlayLot
{
    [playLot autorelease];
    playLot = [aPlayLot retain];
}

- (void)prepare
{
	[NSThread detachNewThreadSelector:@selector(startThread:) toTarget:self withObject:nil];
}

- (void)start
{
	shouldStop = NO;
	[conditionLock lockWhenCondition:NUThreadedChildminderDeactiveCondition];
	[conditionLock unlockWithCondition:NUThreadedChildminderActiveCondition];
}

- (void)startWithoutWait
{
    shouldStop = NO;
}

- (void)stop
{
	shouldStop = YES;
	[conditionLock lockWhenCondition:NUThreadedChildminderDeactiveCondition];
	[conditionLock unlockWithCondition:NUThreadedChildminderDeactiveCondition];
}

- (void)terminate
{
#ifdef DEBUG
    NSLog(@"%@: begin #terminate", self);
#endif
    
    shouldStop = YES;
    shouldTerminate = YES;
    
    [conditionLock lockWhenCondition:NUThreadedChildminderDeactiveCondition];
    
    if (!isTerminated)
    {
        [conditionLock unlockWithCondition:NUThreadedChildminderActiveCondition];
        [conditionLock lockWhenCondition:NUThreadedChildminderDeactiveCondition];
    }
    
    [conditionLock unlockWithCondition:NUThreadedChildminderDeactiveCondition];
    
    [self setPlayLot:nil];
    
#ifdef DEBUG
    NSLog(@"%@: end #terminate", self);
#endif
}

- (void)startThread:(id)anArgument
{
#ifdef DEBUG
    NSLog(@"%@: begin #startThread:", self);
#endif
    
    while (YES)
    {
        [conditionLock lockWhenCondition:NUThreadedChildminderActiveCondition];
        
        if (!shouldTerminate)
        {
            @autoreleasepool
            {
                [self process];
            }
        }
        else
            isTerminated = YES;
        
        [conditionLock unlockWithCondition:NUThreadedChildminderDeactiveCondition];
        
        
        if (isTerminated) break;
    }
    
#ifdef DEBUG
    NSLog(@"%@: end #startThread:", self);
#endif
}

- (void)process
{
    
}

- (BOOL)shouldStop
{
    return shouldStop;
}

- (void)setShouldStop:(BOOL)aShouldStop
{
    shouldStop = aShouldStop;
}

@end
