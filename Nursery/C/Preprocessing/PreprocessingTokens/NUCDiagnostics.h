//
//  NUCDiagnostics.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/06/30.
//

#import <Foundation/NSObject.h>

@class NSMutableArray;

@interface NUCDiagnostics : NSObject
{
    NSMutableArray *diagnostics;
}

+ (instancetype)diagnostics;

- (void)add:(id)aDiagnostic;

- (NSMutableArray *)diagnostics;

@end

