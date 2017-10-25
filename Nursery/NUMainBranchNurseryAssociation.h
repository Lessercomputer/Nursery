//
//  NUMainBranchNurseryAssociation.h
//  Nursery
//
//  Created by P,T,A on 2013/06/29.
//
//

#import <Nursery/NUNurseryAssociation.h>
#import <Nursery/NUPlayLot.h>
#import <Nursery/NUMainBranchNurseryAssociationProtocol.h>

@class NUMainBranchNursery;

extern NSString *NUDefaultMainBranchAssociation;

@interface NUMainBranchNurseryAssociation : NUNurseryAssociation <NUMainBranchNurseryAssociation, NSConnectionDelegate>
{
    NSString *name;
    NSConnection *connection;
    NSMutableDictionary *nurseries;
}

+ (id)defaultAssociation;

+ (id)associationWithName:(NSString *)aName;

- (id)initWithName:(NSString *)aName;

- (NSString *)name;

- (void)open;
- (void)close;

- (void)setNursery:(NUMainBranchNursery *)aNursery forName:(NSString *)aName;
- (void)removeNurseryForName:(NSString *)aName;

@end

