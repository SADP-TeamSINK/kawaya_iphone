//
//  ViewController.m
//  Resty
//
//  Created by Kazuma Nagaya on 2014/10/18.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController{
    GMSMapView *mapView_;
    FilteringButtonController *filteringButtonController_;
}


- (void)loadView {

    filteringButtonController_ = [[FilteringButtonController alloc] initWithState:BOTH empty:FALSE wash:TRUE multipurpose:FALSE parent:self];
    UIButton *btnSex = filteringButtonController_.sexButton;
    UIButton *btnEmpty = filteringButtonController_.emptyButton;
    UIButton *btnWash = filteringButtonController_.washButton;
    UIButton *btnMultipurpose = filteringButtonController_.multipurposeButton;
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.026111
                                                            longitude:135.780833
                                                                 zoom:16];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(35.026111, 135.780833);
    marker.title = @"kyoto University";
    marker.snippet = @"Japan";
    marker.map = mapView_;

    // ボタンがタップされた時のメソッド登録
    [btnSex             addTarget:self action:@selector(pushBtnSex:)            forControlEvents:UIControlEventTouchDown];
    [btnEmpty           addTarget:self action:@selector(pushBtnEmpty:)          forControlEvents:UIControlEventTouchDown];
    [btnWash            addTarget:self action:@selector(pushBtnWash:)           forControlEvents:UIControlEventTouchDown];
    [btnMultipurpose    addTarget:self action:@selector(pushBtnMultipurpose:)   forControlEvents:UIControlEventTouchDown];

    [self.view addSubview:btnSex];
    [self.view addSubview:btnEmpty];
    [self.view addSubview:btnWash];
    [self.view addSubview:btnMultipurpose];
}


-(void)pushBtnSex:(UIButton*)button{
    [filteringButtonController_ tappedSexButton:button];
}

-(void)pushBtnEmpty:(UIButton*)button{
    [filteringButtonController_ tappedEmptyButton:button];
}

-(void)pushBtnWash:(UIButton*)button{
    [filteringButtonController_ tappedWashButton:button];
}

-(void)pushBtnMultipurpose:(UIButton*)button{
    [filteringButtonController_ tappedMultipurposeButton:button];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
