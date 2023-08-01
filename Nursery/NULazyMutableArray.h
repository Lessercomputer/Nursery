//
//  NULazyMutableArray.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/05/22.
//

#import <Foundation/NSArray.h>
#import <Nursery/NUTypes.h>
#import <Nursery/NUCoding.h>
#import <Nursery/NUMovingUp.h>

@interface NULazyMutableArray : NSMutableArray <NUIndexedCoding, NUMovingUp>
{
    NUUInt64 *oops;
    id *objects;
    NSUInteger capacity;
    NSUInteger count;
}

@property (nonatomic, assign) NUBell *bell;

- (void)grow;
- (NULazyMutableArray *)subLazyMutableArrayWithRange:(NSRange)aRange;

- (BOOL)hasOOPs;
- (NUUInt64)oopAt:(NSUInteger)anIndex;

- (void)initIvarsWithAliaser:(NUAliaser *)anAliaser;
- (void)releaseIvars;
- (void)releaseObjects;

@end
