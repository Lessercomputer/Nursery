//
//  NUMainBranchSandbox.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/10/23.
//
//

#import "NUMainBranchSandbox.h"
#import "NUGradeSeeker.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchAliaser.h"
#import "NUNurseryRoot.h"
#import "NUBell.h"

@implementation NUMainBranchSandbox

- (id)initWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGradeSeeker:(BOOL)aUsesGradeSeeker retainNursery:(BOOL)aRetainFlag
{
    if (self = [super initWithNursery:aNursery grade:aGrade usesGradeSeeker:aUsesGradeSeeker retainNursery:aRetainFlag])
    {
        farmOutLock = [NSLock new];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc:%@", self);
    [farmOutLock release];
    farmOutLock = nil;
    
    [super dealloc];
}

@end

@implementation NUMainBranchSandbox (SaveAndLoad)

- (NUFarmOutStatus)farmOut
{
    NUFarmOutStatus aFarmOutStatus = NUFarmOutStatusFailed;
    
    @try
    {
        @autoreleasepool
        {
            [farmOutLock lock];
            [[self gradeSeeker] stop];
            [self lock];
            
            if (![[self nursery] open])
            {
                aFarmOutStatus = NUFarmOutStatusFailed;
            }
            else if (![self gradeIsEqualToNurseryGrade])
            {
                aFarmOutStatus = NUFarmOutStatusNurseryGradeUnmatched;
            }
            else
            {
                [[self mainBranchNursery] lockForFarmOut];
                
                if ([self gradeIsEqualToNurseryGrade])
                {
                    NUUInt64 aNewGrade = [[self mainBranchNursery] newGrade];
                    
                    [[self mainBranchAliaser] setGradeForSave:aNewGrade];
                    
                    if (![self contains:[self nurseryRoot]])
                        [[self aliaser] setRoots:[NSMutableArray arrayWithObject:[self nurseryRoot]]];
                    
                    [[self aliaser] encodeObjects];
                    [self setNurseryRootOOP];
                    aFarmOutStatus = [[self mainBranchNursery] save] ? NUFarmOutStatusSucceeded : NUFarmOutStatusFailed;
                    
                    if (aFarmOutStatus == NUFarmOutStatusSucceeded)
                    {
                        [[self mainBranchNursery] retainGrade:aNewGrade bySandbox:self];
                        [self setGrade:aNewGrade];
                        [[self gradeSeeker] pushRootBell:[[self nurseryRoot] bell]];
                    }
                }
                else
                {
                    aFarmOutStatus = NUFarmOutStatusNurseryGradeUnmatched;
                }
                
                [[self mainBranchNursery] unlockForFarmOut];
            }
        }
    }
    @finally
    {
        [self unlock];
        [[self gradeSeeker] startWithoutWait];
        [farmOutLock unlock];
    }
    
    return aFarmOutStatus;
}

@end

@implementation NUMainBranchSandbox (Private)

- (NUMainBranchNursery *)mainBranchNursery
{
    return (NUMainBranchNursery *)[self nursery];
}

- (NUMainBranchAliaser *)mainBranchAliaser
{
    return (NUMainBranchAliaser *)[self aliaser];
}

- (void)setNurseryRootOOP
{
	[[self mainBranchNursery] saveRootOOP:[[self bellForObject:[self nurseryRoot]] OOP]];
}

@end
