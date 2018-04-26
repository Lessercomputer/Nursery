//
//  NUComparator.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/20.
//
//

#import <Foundation/NSObject.h>

@protocol NUComparator <NSObject>

- (NSComparisonResult)compareObject:(id)anObject1 toObject:(id)anObject2;

@end
