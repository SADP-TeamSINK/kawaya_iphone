//
//  ViewController.m
//  Resty
//
//  Created by Kazuma Nagaya on 2014/10/18.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController {
    GMSMapView *mapView_;
    BOOL firstLocationUpdate_;

    FilteringButtonController *filteringButtonController_;
    NSDictionary *toiletData_;
    NSInteger height_;
    NSInteger width_;
    MapController *mapController_;
    UIView *footer_;
    Color *color_;
    
    CLLocationManager *locationAuthorizationManager_;
    UIView *backView_;
    UIView *listHeaderHandle_;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    CLLocationCoordinate2D initLocation;
    initLocation.latitude = 35.868936;
    initLocation.longitude = 137.554047;
    mapView_.camera = [GMSCameraPosition cameraWithTarget:initLocation
                                                     zoom:4.5];
}


- (void)loadView {
    color_ = [[Color alloc] init];
    
    //画面サイズ取得
    height_ = [[UIScreen mainScreen] bounds].size.height;
    width_ = [[UIScreen mainScreen] bounds].size.width;
    
    filteringButtonController_ = [[FilteringButtonController alloc] initWithState:MAN washlet:FALSE multipurpose:FALSE parent:self];
    UIButton *btnSex = filteringButtonController_.sexButton;
    UIButton *btnUpdate = filteringButtonController_.updateButton;
    UIButton *btnWashlet = filteringButtonController_.washletButton;
    UIButton *btnMultipurpose = filteringButtonController_.multipurposeButton;
    
    // 背景Viewの設定
    backView_ = [[UIView alloc] initWithFrame:CGRectMake(
                                                         0,
                                                         0,
                                                         width_,
                                                         height_)];
    self.view = backView_;
    
    // MapControllerの初期化
    mapController_ = [[MapController alloc] initWithFilteringButtonController:filteringButtonController_];
    mapView_ = [mapController_ getMapView];
    mapView_.settings.myLocationButton = YES;
    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
    [self.view addSubview:mapView_];
    // フッターの背景Viewを作成
    footer_ = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                       height_- BUTTON_BOTTOM_MARGIN - BUTTON_TOP_MARGIN - BUTTON_SIZE,
                                                       width_,
                                                       BUTTON_BOTTOM_MARGIN + BUTTON_TOP_MARGIN + BUTTON_SIZE)];
    footer_.backgroundColor = color_.gray;
    // 影の設定
    footer_.layer.shadowOpacity = 0.4; // 濃さを指定
    footer_.layer.shadowRadius = 2.0f;
    footer_.layer.shadowOffset = CGSizeMake(0.0, 0.0); // 影までの距離を指定
    [self.view addSubview:footer_];
    [self.view bringSubviewToFront:footer_];
    
    // ボタンがタップされた時のメソッド登録
    [btnSex             addTarget:self action:@selector(pushBtnSex:)            forControlEvents:UIControlEventTouchDown];
    [btnUpdate           addTarget:self action:@selector(pushBtnUpdate:)          forControlEvents:UIControlEventTouchDown];
    [btnWashlet            addTarget:self action:@selector(pushBtnWashlet:)           forControlEvents:UIControlEventTouchDown];
    [btnMultipurpose    addTarget:self action:@selector(pushBtnMultipurpose:)   forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:btnSex];
    [self.view addSubview:btnUpdate];
    [self.view addSubview:btnWashlet];
    [self.view addSubview:btnMultipurpose];
    
    // リストのヘッダハンドルを準備
    listHeaderHandle_ = [[UIView alloc] initWithFrame:CGRectMake(0, height_, width_, LIST_TOP_BAR_HEIGHT)];
    //listHeaderHandle_.backgroundColor = color_.red;
    [self.view addSubview:listHeaderHandle_];
    // ヘッダハンドルをドラッグ対応させる
    UIPanGestureRecognizer *panGestureRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragHeader:)];
    [listHeaderHandle_ addGestureRecognizer:panGestureRecognizer];
    mapController_.listHeaderHandle = listHeaderHandle_;
    
}


-(void)pushBtnSex:(UIButton*)button{
    [filteringButtonController_ tappedSexButton:button];
    NSLog(@"myLocation: (%@)", mapView_.myLocation);
    
    [self pushAnyButton];
}

-(void)pushBtnUpdate:(UIButton*)button{
    [filteringButtonController_ tappedUpdateButton:button];
    [mapController_ updateBuildings];
    [mapController_ updateListForState];
}

-(void)pushBtnWashlet:(UIButton*)button{
    [filteringButtonController_ tappedWashletButton:button];
    [self pushAnyButton];
}

-(void)pushBtnMultipurpose:(UIButton*)button{
    [filteringButtonController_ tappedMultipurposeButton:button];
    [self pushAnyButton];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Rather than setting -myLocationEnabled to YES directly,
// call this method:

- (void) pushAnyButton{
    [mapController_ updateAllBuildingMarkerForState];
    [mapController_ updateListForState];
}



- (void)dealloc {
    [mapView_ removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}

#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        [mapView_ animateToCameraPosition:[GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:17]];
    }
}

- (void) dragHeader:(UIPanGestureRecognizer *)sender{
    UIView *targetView = sender.view;

    if(sender.state == UIGestureRecognizerStateEnded){
       // NSLog(@"target.y: %f, limit: %ld", targetView.frame.origin.y, LIST_OFF_LIMIT_RATIO * height_);
        if(targetView.frame.origin.y > MAP_RATIO * height_){
            [mapController_ offList];
        }else{
            [mapController_ onList];
        }
    }else{
        UIView *baseView = mapController_.listViewController.baseView;
        CGPoint p = [sender translationInView:targetView];
        CGRect handleRect = CGRectMake(
                                       targetView.frame.origin.x,
                                       MAX(targetView.frame.origin.y + p.y, LIMIT_TOP),
                                       targetView.frame.size.width,
                                       targetView.frame.size.height);
        CGRect listRect = CGRectMake(
                                       baseView.frame.origin.x,
                                       MAX(baseView.frame.origin.y + p.y, LIMIT_TOP),
                                       baseView.frame.size.width,
                                       MAX(baseView.frame.size.height, baseView.frame.size.height - p.y));
        
        targetView.frame = handleRect;
        baseView.frame = listRect;

        [sender setTranslation:CGPointZero inView:targetView];
        [sender setTranslation:CGPointZero inView:mapController_.listViewController.baseView];
    }
}

@end
