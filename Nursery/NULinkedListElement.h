//
//  NULinkedListElement.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/06/01.
//

#import <Foundation/NSObject.h>

@interface NULinkedListElement : NSObject

+ (instancetype)listElementWithObject:(id)anObject;

- (instancetype)initWithObject:(id)anObject;

@property (nonatomic, retain) id object;

@property (nonatomic, assign) NULinkedListElement *next;
@property (nonatomic, assign) NULinkedListElement *previous;

@end
