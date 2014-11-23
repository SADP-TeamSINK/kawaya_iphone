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

@implementation MapViewController {
    GMSMapView *mapView_;
    FilteringButtonController *filteringButtonController_;
    NSDictionary *toiletData_;
    NSInteger height_;
    NSInteger width_;
    MapController *mapController_;
}


- (void)loadView {
    
    mapController_ = [[MapController alloc] init];
    
    //画面サイズ取得
    height_ = [[UIScreen mainScreen] bounds].size.height;
    width_ = [[UIScreen mainScreen] bounds].size.width;
    
    // 背景のviewの初期化
    UIView *backView;
    backView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = backView;
    
    filteringButtonController_ = [[FilteringButtonController alloc] initWithState:BOTH empty:FALSE wash:TRUE multipurpose:FALSE parent:self];
    UIButton *btnSex = filteringButtonController_.sexButton;
    UIButton *btnUpdate = filteringButtonController_.updateButton;
    UIButton *btnWash = filteringButtonController_.washButton;
    UIButton *btnMultipurpose = filteringButtonController_.multipurposeButton;
    
    mapView_ = [mapController_ getMapView];
    
    
    [self.view addSubview:mapView_];
    
    // ボタンがタップされた時のメソッド登録
    [btnSex             addTarget:self action:@selector(pushBtnSex:)            forControlEvents:UIControlEventTouchDown];
    [btnUpdate           addTarget:self action:@selector(pushBtnUpdate:)          forControlEvents:UIControlEventTouchDown];
    [btnWash            addTarget:self action:@selector(pushBtnWash:)           forControlEvents:UIControlEventTouchDown];
    [btnMultipurpose    addTarget:self action:@selector(pushBtnMultipurpose:)   forControlEvents:UIControlEventTouchDown];

    [self.view addSubview:btnSex];
    [self.view addSubview:btnUpdate];
    [self.view addSubview:btnWash];
    [self.view addSubview:btnMultipurpose];
}


-(void)pushBtnSex:(UIButton*)button{
    [filteringButtonController_ tappedSexButton:button];
}

-(void)pushBtnUpdate:(UIButton*)button{
    [filteringButtonController_ tappedUpdateButton:button];
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
