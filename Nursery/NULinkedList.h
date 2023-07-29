//
//  NULinkedList.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/06/01.
//

#import <Foundation/NSObject.h>

#import "NUTypes.h"

@class NSMutableSet;

@class NULinkedListElement;

@interface NULinkedList : NSObject
{
    NSMutableSet *elements;
    NULinkedListElement *first;
    NULinkedListElement *last;
}

- (NULinkedListElement *)first;
- (NULinkedListElement *)last;

- (NUUInt64)count;
- (BOOL)contains:(NULinkedListElement *)anElement;

- (void)addElementAtFirst:(NULinkedListElement *)anElement;
- (void)moveToFirst:(NULinkedListElement *)anElement;
- (void)remove:(NULinkedListElement *)anElement;
- (void)removeLast;
- (void)removeAll;

@end
