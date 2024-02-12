//
//  NUCPragmaOperator.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/11/02.
//

#import <Foundation/NSObject.h>

@class NSMutableArray, NUCPreprocessor;

@interface NUCPragmaOperator : NSObject

+ (NSMutableArray *)executePragmaOperatorsIn:(NSMutableArray *)aPpTokens preprocessor:(NUCPreprocessor *)aPreprocessor;

@end

