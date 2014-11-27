//
//  Building.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/22.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import "Building.h"
#import <Foundation/Foundation.h>

@implementation Building {
}

-(id) initWithSetting:(NSInteger)buildingID name:(NSString *)name floorSize:(NSInteger)floorSize latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude{
    self = [super init];
    
    _toilets = [NSMutableArray array];

    _buildingID = buildingID;
    _name = name;
    _floorSize = floorSize;
    _latitude = latitude;
    _longitude = longitude;

    
    for (int i = 0; i < self.floorSize * 2 + 1; i++) {
        [self.toilets addObject:[NSMutableArray array]];
    }
    
    return self;
}

- (NSInteger) addToilet:(Toilet *)toilet{
    NSInteger floor = toilet.floor;
    [self.toilets[floor + self.floorSize] addObject:toilet];
    return ((NSMutableArray *)self.toilets[floor + self.floorSize]).count;
}


// 建物の持っているトイレの利用率の平均を，その建物のトイレ利用率とする
// すでにutilizationを計算している場合は使い回し．
- (NSNumber *) getUtillizationWithState:(Sex)sex washlet:(BOOL)washlet multipurpose:(BOOL)multipurpose{
    double sum = 0;
    double numberOfToilet = 0;
    for (NSMutableArray *toiletsByFloor in self.toilets) {
        for (Toilet *toilet in toiletsByFloor) {
            if(sex == BOTH || sex == toilet.sex){
                double util = [toilet getUtillizationWithState:washlet multipurpose:multipurpose].doubleValue;
                if(!isnan(util)){
                    numberOfToilet++;
                    sum += util;
                }
            }
        }
    }
    return [[NSNumber alloc] initWithDouble:sum / numberOfToilet];
}

+ (NSMutableArray *) parseBuildingFromJson:(NSString *)json{
    NSMutableArray *buildings = [NSMutableArray array];
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"%@ %@", dic, error);
    
    // jsonをパースして得た辞書型から，建物オブジェクト，トイレオブジェクト，個室オブジェクトを生成．
    for (NSDictionary *building in dic) {
        NSLog(@"building: %@", building[@"name"]);
        Building *buildingObject
        = [[Building alloc]
           initWithSetting:[building[@"id"] integerValue]
           name:(NSString *)building[@"name"]
           floorSize:[building[@"floor_size"] integerValue]
           latitude:(NSNumber *)building[@"latitude"]
           longitude:(NSNumber *)building[@"longitude"]];
        
        // トイレオブジェクトを読み込むためのループ
        for (NSDictionary *toilet in building[@"toilets"]) {
            NSLog(@"toilet: %@", toilet[@"store_name"]);
            
            Toilet *toiletObject
            = [[Toilet alloc]
               initWithSetting:[toilet[@"id"] integerValue]
               floor:[toilet[@"floor"] integerValue]
               storeName:(NSString *)toilet[@"store_name"]
               latitude:(NSNumber *)toilet[@"latitude"]
               longitude:(NSNumber *)toilet[@"longitude"]
               sex:(Sex)[toilet[@"sex"] integerValue]];
            
            // 所有している建物を登録
            [toiletObject setOwner:buildingObject];
            
            for (NSDictionary *room in toilet[@"rooms"]) {
                NSLog(@"room: %d", (BOOL)room[@"available"]);
                Room *roomObject
                = [[Room alloc]
                   initWithSetting:[room[@"id"] integerValue]
                   available:(BOOL)[room[@"available"] boolValue]
                   washlet:(BOOL)[room[@"washlet"] boolValue]
                   multipurpose:(BOOL)[room[@"multipurpose"] boolValue]];
                
                // washletを持っているかの判定
                if(roomObject.washlet){toiletObject.hasWashlet = true;}

                // multipurposeを持っているかの判定
                if(roomObject.multipurpose){toiletObject.hasMultipurpose = true;}

                [toiletObject addRoom:roomObject];
            }
            
            [buildingObject addToilet:toiletObject];
        }
        
        [buildings addObject:buildingObject];
    }
    return buildings;
}

- (void) removeMarker{
    if(!_marker){
        _marker.map = nil;
        _marker = nil;
    }
}

- (void) putMarker:(GMSMapView *)mapView{
    if(!_marker){
        _marker.map = mapView;
    }
}

- (BOOL) hasFilteringToilet:(Sex)sex washlet:(BOOL)washlet multipurpose:(BOOL)multipurpose{
    for (NSMutableArray *toiletByFloor in _toilets) {
        for (Toilet *toilet in toiletByFloor) {
            if(!(sex == BOTH || sex == toilet.sex)){ continue; }
            if((!washlet || toilet.hasWashlet) && (!multipurpose || toilet.hasMultipurpose)){
                return true;
            }
        }
    }
    return false;
}


@end