//
//  APIController.h
//  Resty
//
//  Created by Imamori Daichi on 2014/11/17.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>


@interface APIController : NSObject
- (id) initWithUrl:(NSURL *)url;
- (NSString *) call:(CLLocationCoordinate2D)topLeftCoordinate BottomRightCoordinate:(CLLocationCoordinate2D)bottomRightCoordinate;
- (NSUInteger) getMeshNumberFromCoordinate:(CLLocationCoordinate2D)coordinate;
@end