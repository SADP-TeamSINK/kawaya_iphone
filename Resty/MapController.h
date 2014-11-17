//
//  MapController.h
//  Resty
//
//  Created by Imamori Daichi on 2014/11/17.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MapViewController.h"


@interface MapController : NSObject <GMSMapViewDelegate>

- (id) init;
- (GMSMapView *) makeMapView;
- (CLLocationCoordinate2D) getTopLeftCoordinate;
- (CLLocationCoordinate2D) getBottomRightCoordinate;

@end