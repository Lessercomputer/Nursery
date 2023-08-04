//
//  NUCDecomposer.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/05/15.
//

#import <Foundation/NSObject.h>

@class NUCSourceFile;
@class NSArray;

@interface NUCDecomposer : NSObject
{
    BOOL hashExistsOnCurrentLine;
    BOOL includeExistsOnCurrentLine;
}

- (NSArray *)decomposePreprocessingFile:(NUCSourceFile *)aSourceFile;
- (NSArray *)decomposePreprocessingTokensIn:(NSString *)aString;

@end

