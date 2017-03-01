//
//  iAPBundleIDs.m
//  Serpentine!
//
//  Created by Dylan Chong on 11/10/13.
//  Copyright (c) 2013 Dylan Chong. All rights reserved.
//

#import "iAPBundleIDs.h"

@implementation iAPBundleIDs
+ (NSString *)buy20ID{return @"com.piguygames.serpentine.buy20up";}
+ (NSString *)buy45ID{return @"com.piguygames.serpentine.buy45up";}
+ (NSString *)buy100ID{return @"com.piguygames.serpentine.buy100up";}
+ (NSString *)buyDoubleID{return @"com.piguygames.serpentine.doubleup";}
+ (NSString *)buyiAdsID{return @"com.piguygames.serpentine.removeAdsAndBuy20";}

+ (NSSet *)returnAllIDs {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (!([[self buy20ID] isEqualToString:@""])) [array addObject:[self buy20ID]];
    if (!([[self buy45ID] isEqualToString:@""])) [array addObject:[self buy45ID]];
    if (!([[self buy100ID] isEqualToString:@""])) [array addObject:[self buy100ID]];
    if (!([[self buyDoubleID] isEqualToString:@""])) [array addObject:[self buyDoubleID]];
    if (!([[self buyiAdsID] isEqualToString:@""])) [array addObject:[self buyiAdsID]];
    
    return [NSSet setWithArray:array];
}
@end
