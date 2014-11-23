//
//  Building.h
//  Resty
//
//  Created by Imamori Daichi on 2014/11/22.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Const.m"
#import "Toilet.h"
#import "Building.h"
#import "Room.h"

@interface Building : NSObject

@property (nonatomic) NSInteger buildingID;
@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger floorSize;
@property (nonatomic) NSNumber *latitude;
@property (nonatomic) NSNumber *longitude;
@property (nonatomic) NSMutableArray *toilets;
//@property (nonatomic) NSNumber *utillization;


- (id) initWithSetting:(NSInteger) buildingID name:(NSString *)name floorSize:(NSInteger) floorSize latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;

- (NSInteger) addToilet:(Toilet *)toilet;
- (NSNumber *) getUtillization;
+ (NSMutableArray *) parseBuildingFromJson:(NSString *)json;

@end