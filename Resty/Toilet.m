//
//  Toilet.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/22.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import "Toilet.h"
#import <Foundation/Foundation.h>

@implementation Toilet : NSObject


- (id) initWithSetting:(NSInteger)toiletID floor:(NSInteger)floor storeName:(NSString *)storeName latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude sex:(Sex)sex{
    self = [super init];

    self.rooms = [NSMutableArray array];

    self.toiletID   = toiletID;
    self.floor      = floor;
    self.storeName  = storeName;
    self.latitude   = latitude;
    self.longitude  = longitude;
    self.sex        = sex;
    
    return self;
}

- (NSInteger) addRoom:(Room *)room{
    [self.rooms addObject:room];
    return self.rooms.count;
}

@end