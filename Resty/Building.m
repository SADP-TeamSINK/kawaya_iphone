//
//  Building.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/22.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import "Building.h"
#import <Foundation/Foundation.h>

@implementation Building : NSObject

NSArray *rooms;

-(id) initWithSetting:(NSInteger)buildingID name:(NSString *)name floorSize:(NSInteger)floorSize latitude:(double)latitude longitude:(double)longitude{
    self = [super self];

    self.buildingID = buildingID;
    self.name = name;
    self.floorSize = floorSize;
    self.latitude = latitude;
    self.longitude = longitude;
    
    return self;
}



@end