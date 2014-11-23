//
//  APIController.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/17.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import "APIController.h"


@implementation APIController : NSObject
NSURL * url_;
NSMutableSet *obtainedMeshMutableSet_;

- (id) initWithUrl:(NSURL *) url{
    obtainedMeshMutableSet_ = [NSMutableSet set];
    self = [super init];
    url_ = url;
    return self;
}

- (NSString *) callFromCoordinate:(CLLocationCoordinate2D)topLeftCoordinate BottomRightCoordinate:(CLLocationCoordinate2D)bottomRightCoordinate{
    NSString *json = @"{}";
    double topLeftLatitude = topLeftCoordinate.latitude;
    double topLeftLongitude = topLeftCoordinate.longitude;
    double bottomRightLatitude = bottomRightCoordinate.latitude;
    double bottomRightLongitude = bottomRightCoordinate.longitude;

    NSMutableArray *meshArrayToSend = [NSMutableArray array];
    for (double latitude = bottomRightLatitude; latitude < topLeftLatitude; latitude += 0.01f) {
        for (double longitude = topLeftLongitude; longitude < bottomRightLongitude; longitude += 0.01f) {
            // CLLocationCoordinate2Dに変換
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = latitude;
            coordinate.longitude = longitude;

            // メッシュ番号を取得
            NSNumber *meshNumber = [NSNumber numberWithUnsignedInteger:[self getMeshNumberFromCoordinate:coordinate]];
            if (![obtainedMeshMutableSet_ containsObject:(id)meshNumber]) {
                [obtainedMeshMutableSet_ addObject:meshNumber];
                [meshArrayToSend addObject:meshNumber];
                NSLog(@"get mesh(%f, %f), m: %@", latitude, longitude, meshNumber);
            }
            
            for (meshNumber in obtainedMeshMutableSet_) {
                NSLog(@"%@", meshNumber);
            }
        }
    }
    
    // 送るべきメッシュの配列が空でなければAPIを叩く
    if([meshArrayToSend count] > 0){
        json = [self call:meshArrayToSend];
    }
    
    return json;
}

- (NSUInteger) getMeshNumberFromCoordinate:(CLLocationCoordinate2D)coordinate{
    double latitude = coordinate.latitude + 180.0f;
    double longitude = coordinate.longitude + 180.0f;

    NSUInteger meshNumber = ((NSUInteger)(latitude * 100) * 100000) + ((NSUInteger)(longitude * 100));
    
    return meshNumber;
}

- (NSString *) call:(NSMutableArray *)meshArray{
    NSString *returnedJson = @"{}";
    NSLog(@"Called call in APIController: %@", meshArray);

    //送信するパラメータの組み立て
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    [mutableDic setValue:meshArray forKey:@"meshNuber"];
    
    NSError *error;
    if([NSJSONSerialization isValidJSONObject:mutableDic]){
        NSData *json = [NSJSONSerialization dataWithJSONObject:mutableDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
        NSLog(@"json %@", [[NSString alloc] initWithData:json
                                                encoding:NSUTF8StringEncoding]);
    
        NSMutableURLRequest *request;
        request =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:API_URL]
                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                timeoutInterval:60.0];

        //HTTPメソッドは"POST"
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%ld", [json length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: json];

        //レスポンス
        NSURLResponse *resp;  
        NSError *err;  

        //HTTPリクエスト送信  
        NSData *result = [NSURLConnection sendSynchronousRequest:request   
                                               returningResponse:&resp error:&err];
        returnedJson = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"Result: %@, err: %@", returnedJson, err);
        
    }else{
        NSLog(@"!!!The Array can not convert json!!!");
    }
    return returnedJson;
}



@end