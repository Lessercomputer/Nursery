//
//  NUCPreprocessingFile.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/11/18.
//

#import "NUCPreprocessingDirective.h"

@class NSMutableDictionary;
@class NUCPreprocessingTokenStream, NUCPreprocessor;
@class NUCGroup;

@interface NUCPreprocessingFile : NUCPreprocessingDirective
{
    NUCGroup *group;
}

+ (BOOL)preprocessingFileFrom:(NUCPreprocessingTokenStream *)aStream with:(NUCPreprocessor *)aPreprocessor into:(NUCPreprocessingFile **)aToken;
+ (instancetype)preprocessingFileWithGroup:(NUCGroup *)aGroup;

- (instancetype)initWithGroup:(NUCGroup *)aGroup;

- (NUCGroup *)group;

@end
