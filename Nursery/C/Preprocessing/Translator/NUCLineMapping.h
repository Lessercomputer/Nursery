//
//  NUCLineMapping.h
//  Nursery
//
//  Created by aki on 2023/08/29.
//

#import <Foundation/NSObject.h>
#import <Foundation/NSRange.h>


@interface NUCLineMapping : NSObject

@property (nonatomic) NSRange lineRange;
@property (nonatomic, retain) id otherLineRange;

+ (instancetype)lineMapping;
+ (instancetype)lineMappingWithLineRange:(NSRange)aRange;

- (instancetype)initWithLineRange:(NSRange)aRange;

- (void)addOtherLineRange:(NSValue *)aLineRange;

@end

