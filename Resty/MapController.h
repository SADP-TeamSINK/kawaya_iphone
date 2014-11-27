//
//  MapController.h
//  Resty
//
//  Created by Imamori Daichi on 2014/11/17.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MapViewController.h"
#import "APIController.h"
#import "Const.m"
#import "ListViewController.h"
#import "Building.h"
#import "FilteringButtonController.h"
#import "Color.h"

@interface MapController : NSObject <GMSMapViewDelegate>

- (id) initWithFilteringButtonController:(FilteringButtonController *)filteringButtonController;
- (GMSMapView *) getMapView;
- (CLLocationCoordinate2D) getTopLeftCoordinate;
- (CLLocationCoordinate2D) getBottomLeftCoordinate;
- (CLLocationCoordinate2D) getBottomRightCoordinate;
- (void) markBuildings:(NSMutableArray *)buildings;
- (NSMutableArray *) filtering:(NSMutableArray *)buildings stateOfSex:(Sex)stateOfSex stateOfWashlet:(BOOL)stateOfWashlet stateOfMultipurpose:(BOOL)stateOfmultipurpose; //+
- (void) markToilets:(Building *)building;
- (UIImage *) getUIColorForMarker:(NSNumber *)utillization;

@end