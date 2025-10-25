//
//  NUCTranslator.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/16.
//

#import "NUCTranslator.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSURL.h>

#import "NUCPreprocessor.h"
#import "NUCSourceFile.h"
#import "NUCPreprocessingFile.h"
#import "NUCPreprocessingTokenToTokenStream.h"
#import "NUCToken.h"
#import "NUCIntegerConstant.h"
#import "NUCTranslationUnit.h"
#import "NUMachO.h"
#import "NUMachOSegmentCommand64.h"
#import "NUMachOPageZeroSegmentCommand.h"
#import "NUMachOTextSegmentCommand.h"
#import "NUMachODataSegmentCommand.h"
#import "NUMachOLinkeditCommand.h"
#import "NUMachOSection.h"
#import "NUMachOTextSection.h"
#import "NUMachODataSection.h"
#import "NUMachOSymtabCommand.h"
#import "NUMachODySymtabCommand.h"
#import "NUMachODylinkerCommand.h"
#import "NUMachODyldInfoOnly.h"
#import "NUMachODylibCommand.h"
#import "NUMachOEntryPointCommand.h"
#import "NUAArch64Placeholder.h"
#import "NUMachOPostProcess.h"


@class NUCSourceFile;

@interface NUCTranslator (Private)

- (NSMutableDictionary *)externalSourceFiles;
- (NSMutableDictionary *)allSourceFiles;

- (void)preprocess;

@end

@implementation NUCTranslator

- (instancetype)initWithSourceFileURLs:(NSArray *)aURLs
{
    NSMutableArray *aSourceFiles = [NSMutableArray array];
    
    [aURLs enumerateObjectsUsingBlock:^(NSURL * _Nonnull aURL, NSUInteger idx, BOOL * _Nonnull stop) {
        [aSourceFiles addObject:[[[NUCSourceFile alloc] initWithSourceURL:aURL] autorelease]];
    }];
    
    return [self initWithSourceFiles:aSourceFiles];
}

- (instancetype)initWithSourceFiles:(NSArray *)aSourceFiles
{
    if (self = [super init])
    {
        sourceFiles = [aSourceFiles mutableCopy];
        externalSourceFiles = [NSMutableArray new];
        allSourceFiles = [NSMutableDictionary new];
        preprocessedSourceFiles = [NSMutableArray new];
        _translationUnits = [NSMutableArray new];
        
        NUMachO *aMachO = [NUMachO new];
        
        [aMachO add:[NUMachOPageZeroSegmentCommand loadCommand]];
        
        NUMachOSegmentCommand64 *aLoadCommand = [NUMachOTextSegmentCommand loadCommand];
        [aMachO add:aLoadCommand];
        NUMachOSection *aSection = [NUMachOTextSection section];
        [aLoadCommand add:aSection];
//        [[aSection sectionData] addInstruction:[NUAArch64MovzInstruction instruction]];
//        [[aSection sectionData] addInstruction:[NUAArch64RetInstruction instruction]];
        
        NUMachOSegmentCommand64 *aDataSegmentCommand = [NUMachODataSegmentCommand loadCommand];
        [aMachO add:aDataSegmentCommand];
        NUMachODataSection *aDataSection = [NUMachODataSection section];
        [aDataSegmentCommand add:aDataSection];
        [aMachO add:[NUMachOSymtabCommand loadCommand]];
        [aMachO add:[NUMachODySymtabCommand loadCommand]];
        [aMachO add:[NUMachODylinkerCommand loadCommand]];
        [aMachO add:[NUMachODyldInfoOnly loadCommand]];
        [aMachO add:[NUMachODylibCommand loadCommand]];
        [aMachO add:[NUMachOEntryPointCommand loadCommand]];
        [aMachO add:[NUMachOLinkeditCommand loadCommand]];
        _machO = aMachO;
        
        _instructionIndexesAndValueIndexesToReplace = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc
{
    [sourceFiles release];
    sourceFiles = nil;
    [externalSourceFiles release];
    externalSourceFiles = nil;
    [allSourceFiles release];
    allSourceFiles = nil;
    [preprocessedSourceFiles  release];
    preprocessedSourceFiles = nil;
    [_instructionIndexesAndValueIndexesToReplace release];
    
    [super dealloc];
}

- (NSMutableArray *)sourceFiles
{
    return sourceFiles;
}

- (NUCSourceFile *)sourceFileFor:(NSString *)aFilename
{
    __block NUCSourceFile *aSouceFile = nil;
    
    [[self searchPathURLs] enumerateObjectsUsingBlock:^(NSURL * _Nonnull aSearchPathURL, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *aSourceFileURL = [aSearchPathURL URLByAppendingPathComponent:aFilename];
        aSouceFile = [[NUCSourceFile alloc] initWithSourceURL:aSourceFileURL];
        if (aSouceFile)
            *stop = YES;
    }];
    
    return [aSouceFile autorelease];
}

- (NSMutableArray *)preprocessedSourceFiles
{
    return preprocessedSourceFiles;
}

- (void)translate
{
    [self preprocess];
    
    [[self preprocessedSourceFiles] enumerateObjectsUsingBlock:^(NUCSourceFile * _Nonnull aPreprocessedSourceFile, NSUInteger idx, BOOL * _Nonnull aStop) {
        
        NSArray *aPpTokens = [[aPreprocessedSourceFile preprocessingFile] macroReplacedPpTokens];
        NUCPreprocessingTokenToTokenStream *aPpTokenToTokenStream = [[[NUCPreprocessingTokenToTokenStream alloc] initWithPreprocessingTokens:aPpTokens] autorelease];
        
        NUCToken *aToken = nil;
        
        while ((aToken = [aPpTokenToTokenStream next]))
        {
            NSLog(@"%@", aToken);
        }
        
        [aPpTokenToTokenStream setPosition:0];
        
        NUCTranslationUnit *aTranslationUnit = nil;
        if ([NUCTranslationUnit translationUnitFrom:aPpTokenToTokenStream into:&aTranslationUnit])
            [[self translationUnits] addObject:aTranslationUnit];
        else
            *aStop = YES;
    }];
    
    [[self translationUnits] enumerateObjectsUsingBlock:^(NUCTranslationUnit * _Nonnull aTranslationUnit, NSUInteger idx, BOOL * _Nonnull stop) {
        [aTranslationUnit translateWith:self];
    }];
}

- (void)preprocess
{
    NUCSourceFile *aSourceFile = nil;
    
    while ((aSourceFile = [[self sourceFiles] firstObject]))
    {
        NUCPreprocessor *aPreprocessor = [[NUCPreprocessor alloc] initWithTranslator:self];

        [aPreprocessor preprocessSourceFile:aSourceFile];
        [preprocessedSourceFiles addObject:aSourceFile];
        
        NSLog(@"%@", [[aSourceFile preprocessingFile] preprocessedStringWithPreprocessor:aPreprocessor]);
        
        [[self sourceFiles] removeObjectAtIndex:0];
        [aPreprocessor release];
    };
}

- (void)translate:(id <NUCToken>)aToken
{
    if ([aToken isIntegerConstant])
    {
        NUMachOPostProcess *aPostProcess = [[NUMachOPostProcess new] autorelease];
        
        uint64_t anInstructionOffsetInSection = [[self machO] instructionOffsetInSection];
        [[self machO] addInstruction:[NUAArch64Placeholder instruction]];
        [[self machO] addInstruction:[NUAArch64Placeholder instruction]];
        [[self machO] addInstruction:[NUAArch64Placeholder instruction]];
        
        [aPostProcess setInstructionOffset:anInstructionOffsetInSection];
        [aPostProcess setTextSection:[[self machO] textSection]];
        
        NUMachODataSection *aDataSection = [[self machO] dataSection];
        uint64_t aDataOffsetInSection = [aDataSection dataOffsetInSection];
        [aPostProcess setDataOffset:aDataOffsetInSection];
        [aPostProcess setDataSection:aDataSection];
        [aDataSection addInt64:[(NUCIntegerConstant *)aToken value]];
        
        [[self machO] addPostProcess:aPostProcess];
    }
}

@end

