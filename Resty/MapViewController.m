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
    NSData *dammyJson_;
    NSDictionary *toiletData_;
    int height_;
    int width_;
    MapController *mapController_;
}


- (void)loadView {
    
    mapController_ = [[MapController alloc] init];
    
    //画面サイズ取得
    height_ = [[UIScreen mainScreen] bounds].size.height;
    width_ = [[UIScreen mainScreen] bounds].size.width;
    
    // ダミーデータの読み込み
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dammy" ofType:@"json"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    dammyJson_ = [fileHandle readDataToEndOfFile];
    
    NSError* error;
    toiletData_ = [NSJSONSerialization JSONObjectWithData:dammyJson_ options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"%@ %@", toiletData_, error);
    
    
    filteringButtonController_ = [[FilteringButtonController alloc] initWithState:BOTH empty:FALSE wash:TRUE multipurpose:FALSE parent:self];
    UIButton *btnSex = filteringButtonController_.sexButton;
    UIButton *btnEmpty = filteringButtonController_.emptyButton;
    UIButton *btnWash = filteringButtonController_.washButton;
    UIButton *btnMultipurpose = filteringButtonController_.multipurposeButton;
    
    mapView_ = [mapController_ makeMapView];
    
    
    self.view = mapView_;

    
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
