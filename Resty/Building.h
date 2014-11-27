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
#import "Room.h"

@interface Building : NSObject

@property (nonatomic) NSInteger buildingID;
@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger floorSize;
@property (nonatomic) NSNumber *latitude;
@property (nonatomic) NSNumber *longitude;
@property (nonatomic) NSMutableArray *toilets;
@property (nonatomic) GMSMarker *marker;

- (id) initWithSetting:(NSInteger) buildingID name:(NSString *)name floorSize:(NSInteger) floorSize latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;

- (NSInteger) addToilet:(Toilet *)toilet;
- (NSNumber *) getUtillizationWithState:(Sex)sex washlet:(BOOL)washlet multipurpose:(BOOL)multipurpose;
+ (NSMutableArray *) parseBuildingFromJson:(NSString *)json;
- (void) removeMarker;
- (void) putMarker:(GMSMapView *)mapView;
- (BOOL) hasFilteringToilet:(Sex)sex washlet:(BOOL)washlet multipurpose:(BOOL)multipurpose;
@end