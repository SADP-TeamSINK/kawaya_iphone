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

@class ListViewController;

@interface MapController : NSObject <GMSMapViewDelegate>
@property UIView *listHeaderHandle;
@property ListViewController *listViewController;

- (id) initWithFilteringButtonController:(FilteringButtonController *)filteringButtonController;
- (GMSMapView *) getMapView;
- (CLLocationCoordinate2D) getTopLeftCoordinate;
- (CLLocationCoordinate2D) getBottomLeftCoordinate;
- (CLLocationCoordinate2D) getBottomRightCoordinate;
- (void) markBuildings:(NSMutableArray *)buildings;
- (void) markToilets:(Building *)building;
- (UIImage *) getUIImageForMarker:(NSNumber *)utillization;
- (void) updateAllBuildingMarkerForState;
- (void) updateListForState;
- (void) updateBuildings;
- (void) callApi:(GMSMapView *)mapView;
- (void) animateTopScreen:(CLLocationCoordinate2D) location zoomLevel:(double)zoomLevel;

- (void) offList;
- (void) onList;

@end