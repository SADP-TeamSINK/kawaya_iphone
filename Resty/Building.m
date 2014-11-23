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


-(id) initWithSetting:(NSInteger)buildingID name:(NSString *)name floorSize:(NSInteger)floorSize latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude{
    self = [super init];
    
    self.toilets = [NSMutableArray array];

    self.buildingID = buildingID;
    self.name = name;
    self.floorSize = floorSize;
    self.latitude = latitude;
    self.longitude = longitude;

    for (int i = 0; i < self.floorSize * 2; i++) {
        [self.toilets addObject:[NSMutableArray array]];
    }
    
    return self;
}

- (NSInteger) addToilet:(Toilet *)toilet{
    NSInteger floor = toilet.floor;
    [self.toilets[floor + self.floorSize] addObject:toilet];
    return ((NSMutableArray *)self.toilets[floor]).count;
}

+ (NSMutableArray *) parseBuildingFromJson:(NSString *)json{
    NSMutableArray *buildings = [NSMutableArray array];
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    //NSLog(@"%@ %@", dic, error);
    
    // jsonをパースして得た辞書型から，建物オブジェクト，トイレオブジェクト，個室オブジェクトを生成．
    for (NSDictionary *building in dic) {
        NSLog(@"building: %@", building[@"building"]);
        Building *buildingObject
            = [[Building alloc]
               initWithSetting:[building[@"id"] integerValue]
                          name:(NSString *)building[@"building"]
                     floorSize:[building[@"floor_size"] integerValue]
                      latitude:(NSNumber *)building[@"latitude"]
                     longitude:(NSNumber *)building[@"longitude"]];

        // トイレオブジェクトを読み込むためのループ
        for (NSDictionary *toilet in building[@"toilet"]) {
            NSLog(@"toilet: %@", toilet[@"store_name"]);
            
            Toilet *toiletObject
                = [[Toilet alloc]
                   initWithSetting:[toilet[@"id"] integerValue]
                             floor:[toilet[@"floor"] integerValue]
                         storeName:(NSString *)toilet[@"store_name"]
                          latitude:(NSNumber *)toilet[@"latitude"]
                         longitude:(NSNumber *)toilet[@"longitude"]
                               sex:(Sex)[toilet[@"sex"] integerValue]];

            for (NSDictionary *room in toilet[@"room"]) {
                NSLog(@"room: %d", (BOOL)room[@"available"]);
                Room *roomObject
                = [[Room alloc]
                   initWithSetting:[room[@"id"] integerValue]
                   available:(BOOL)[room[@"available"] boolValue]
                   washlet:(BOOL)[room[@"washlet"] boolValue]
                   multipurpose:(BOOL)[room[@"multipurpose"] boolValue]];
                [toiletObject addRoom:roomObject];
            }
            
            [buildingObject addToilet:toiletObject];
        }
        
        [buildings addObject:buildingObject];
    }
    return buildings;
}

- (NSNumber *) getUtillization{
    double sizeAllRoom = 0;
    double sizeUnavailableRoom = 0;
    for (NSMutableArray *toiletsByFloor in self.toilets) {
        for (Toilet *toilet in toiletsByFloor) {
            for (Room *room in toilet.rooms) {
                sizeAllRoom++;
                if(!room.available){
                    sizeUnavailableRoom++;
                }
            }
        }
    }
    return [[NSNumber alloc] initWithDouble:(sizeUnavailableRoom / sizeAllRoom)];
}

@end