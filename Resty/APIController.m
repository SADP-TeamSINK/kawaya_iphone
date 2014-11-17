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

- (id) initWithUrl:(NSURL *) url{
    self = [super self];
    url_ = url;
    return self;
}

- (NSString *) call:(CLLocationCoordinate2D)topLeftCoordinate BottomRightCoordinate:(CLLocationCoordinate2D)bottomRightCoordinate{
    double topLeftLatitude = topLeftCoordinate.latitude;
    double topLeftLongitude = topLeftCoordinate.longitude;
    double bottomRightLatitude = bottomRightCoordinate.latitude;
    double bottomRightLongitude = bottomRightCoordinate.longitude;

    for (double latitude = bottomRightLatitude; latitude < topLeftLatitude; latitude += 0.01f) {
        for (double longitude = topLeftLongitude; longitude < bottomRightLongitude; longitude += 0.01f) {
            NSLog(@"get mesh(%f, %f)", latitude, longitude);
        }
    }
    return @"API Called!";
}

- (NSUInteger) getMeshNumberFromCoordinate:(CLLocationCoordinate2D)coordinate{
    double latitude = coordinate.latitude;
    double longitude = coordinate.longitude;

    NSUInteger meshNumber = ((NSUInteger)(latitude * 100) * 10^5) + ((NSUInteger)(longitude * 100));
    
    return meshNumber;
}
@end