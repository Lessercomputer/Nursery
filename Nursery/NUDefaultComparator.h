//
//  NUDefaultComparator.h
//  Nursery
//
//  Created by P,T,A on 2013/01/26.
//
//

#import <Nursery/NUComparator.h>
#import <Nursery/NUCoding.h>

@class NUBell;

@interface NUDefaultComparator : NSObject <NUComparator>
{
    NUBell *bell;
}

- (NSComparisonResult)compareObject:(id)anObject1 toObject:(id)anObject2;

@end

@interface NUDefaultComparator (Coding) <NUCoding>
@end