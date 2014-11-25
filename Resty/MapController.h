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
#import "APIController.h"
#import "Const.m"
#import "ListViewController.h"

@interface MapController : NSObject <GMSMapViewDelegate>

- (id) init;
- (GMSMapView *) getMapView;
- (CLLocationCoordinate2D) getTopLeftCoordinate;
- (CLLocationCoordinate2D) getBottomLeftCoordinate;
- (CLLocationCoordinate2D) getBottomRightCoordinate;
- (void) markBuildings:(NSMutableArray *)buildings;
- (NSMutableArray *) washFiltering:(NSMutableArray *)buildings; //+
@end