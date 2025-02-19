//
//  NUCTypeSpecifier.h
//  Nursery
//
//  Created by akiha on 2025/02/04.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCExternalDefinition.h"

@interface NUCTypeSpecifier : NUCExternalDefinition

+ (BOOL)typeSpecifierFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCTypeSpecifier **)aTypeSpecifier;

@property (nonatomic, retain) id content;

@end

