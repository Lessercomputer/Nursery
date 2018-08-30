//
//  NUChildminder.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/03/16.
//
//

#import <Foundation/NSLock.h>
#import <Foundation/NSThread.h>
#import <Foundation/NSString.h>

#import "NUChildminder.h"
#import "NUMainBranchNursery.h"

const int NUThreadedChildminderActiveCondition      = 0;
const int NUThreadedChildminderDeactiveCondition    = 1;
const int NUThreadedChildminderTerminateCondition   = 2;

@implementation NUChildminder

+ (id)childminderWithGarden:(NUGarden *)aGarden
{
	return [[[self alloc] initWithGarden:aGarden] autorelease];
}

- (id)initWithGarden:(NUGarden *)aGarden
{
	if (self = [super init])
    {
        garden = aGarden;
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(startThread:) object:nil];
    }
    
	return self;
}

- (void)dealloc
{
    [self setGarden:nil];

	[thread release];
	
	[super dealloc];
}

- (NUGarden *)garden
{
    return garden;
}

- (void)setGarden:(NUGarden *)aGarden
{
    garden = aGarden;
}

- (NSString *)threadName
{
    return [NSString stringWithFormat:@"org.nursery-framework.%@", self];
}

- (double)threadPriority
{
    return 0.0;
}

- (NSTimeInterval)lowerTimeInterval
{
    return 0.1;
}

- (double)timeRatio
{
    return 1;//0.05;
}

- (void)start
{
    [thread setName:[self threadName]];
    [thread setThreadPriority:[self threadPriority]];
    [thread start];
}

- (void)stop
{
    [thread cancel];
    while ([thread isExecuting])
        [NSThread sleepForTimeInterval:0.1];
}

- (void)startThread:(id)anArgument
{
    while (![thread isCancelled])
    {
        @autoreleasepool
        {
            NSDate *aBaseDate = [NSDate date];
            NSDate *aStopDate = [aBaseDate dateByAddingTimeInterval:[self lowerTimeInterval] * [self timeRatio]];
            BOOL aProcessed = YES;

            while ([self isLoaded] && [aStopDate timeIntervalSinceNow] > 0 && aProcessed)
            {
                aProcessed = [self processOneUnit];
                if (!aProcessed)
                    [NSThread sleepUntilDate:aStopDate];
            }
            
            aStopDate = [aBaseDate dateByAddingTimeInterval:[self lowerTimeInterval] * (1 - [self timeRatio])];
            [NSThread sleepUntilDate:aStopDate];
        }
    }
}

- (BOOL)processOneUnit
{
    return NO;
}

- (BOOL)isLoaded
{
    return isLoaded;
}

- (void)setIsLoaded:(BOOL)aLoadedFlag
{
    isLoaded = aLoadedFlag;
}

@end
