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


@interface Building : NSObject

@property (nonatomic) NSInteger buildingID;
@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger floorSize;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

- (id) initWithSetting:(NSInteger) buildingID name:(NSString *)name floorSize:(NSInteger) floorSize latitude:(double)latitude longitude:(double)longitude;



@end