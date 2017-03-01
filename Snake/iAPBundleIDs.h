//
//  iAPBundleIDs.h
//  Serpentine!
//
//  Created by Dylan Chong on 11/10/13.
//  Copyright (c) 2013 Dylan Chong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iAPBundleIDs : NSObject
+ (NSString *)buy20ID;
+ (NSString *)buy45ID;
+ (NSString *)buy100ID;
+ (NSString *)buyDoubleID;
+ (NSString *)buyiAdsID;

+ (NSSet *)returnAllIDs;
@end
