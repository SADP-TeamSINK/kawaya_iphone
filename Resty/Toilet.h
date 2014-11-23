//
//  Toilet.h
//  Resty
//
//  Created by Imamori Daichi on 2014/11/22.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Const.m"
#import "Room.h"


@interface Toilet : NSObject

@property (nonatomic) NSInteger toiletID;
@property (nonatomic) NSInteger floor;
@property (nonatomic) NSString *storeName;
@property (nonatomic) NSNumber * latitude;
@property (nonatomic) NSNumber * longitude;
@property (nonatomic) NSMutableArray *rooms;
@property (nonatomic) Sex sex;


- (id) initWithSetting:(NSInteger)toiletID floor:(NSInteger)floor storeName:(NSString*)storeName latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude sex:(Sex)sex;

- (NSInteger) addRoom:(Room*)room;

@end