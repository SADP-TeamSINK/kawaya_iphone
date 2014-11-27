//
//  MapController.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/14.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilteringButtonController.h"

@implementation FilteringButtonController {
    UIViewController *parent;
    NSInteger height;
    NSInteger width;
    UIImage *manButtonImage;
    UIImage *womanButtonImage;
    UIImage *manWomanButtonImage;
    UIImage *washletButtonImage;
    UIImage *washletButtonOffImage;
    UIImage *washletButtonHighlightedImage;
    UIImage *multipurposeButtonImage;
    UIImage *multipurposeButtonOffImage;
    UIImage *multipurposeButtonHighlightedImage;
    UIImage *updateButtonImage;
    UIImage *updateButtonHighlightedImage;
}
- (id) initWithState:(Sex)sex empty:(Boolean)empty washlet:(Boolean)washlet multipurpose:(Boolean)multipurpose parent:(UIViewController*)p
{
    self = [super init];
    parent = p;

    // 画面サイズ取得
    height = [[UIScreen mainScreen] bounds].size.height;
    width = [[UIScreen mainScreen] bounds].size.width;
    
    // 状態の設定
    _stateOfSex = sex;
    _stateOfWashlet = washlet;
    _stateOfMultipurpose = multipurpose;
    
    // ボタンの生成
    self.sexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.washletButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.multipurposeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sexButton.adjustsImageWhenHighlighted = NO;
    
    // ボタンの配置とサイズ設定
    NSInteger margin = (width - BUTTON_SIZE * (BUTTON_NUMBER - 1 + SEX_BUTTON_WIDTH_HEIGHT_RATIO)) / (BUTTON_NUMBER + 1);
    NSInteger margin_bottom = BUTTON_BOTTOM_MARGIN;
    self.sexButton.frame = CGRectMake(margin * BUTTON_LEFT_MARGIN_RATIO + BUTTON_SIZE * (1 - 1), height - BUTTON_SIZE - margin_bottom, BUTTON_SIZE * SEX_BUTTON_WIDTH_HEIGHT_RATIO, BUTTON_SIZE);
    self.washletButton.frame = CGRectMake(margin * BUTTON_LEFT_MARGIN_RATIO + margin + BUTTON_SIZE * SEX_BUTTON_WIDTH_HEIGHT_RATIO * (2 - 1), height - BUTTON_SIZE - margin_bottom, BUTTON_SIZE, BUTTON_SIZE);
    self.multipurposeButton.frame = CGRectMake(margin * BUTTON_LEFT_MARGIN_RATIO + margin * 2 + BUTTON_SIZE * (3 - 2) + BUTTON_SIZE * SEX_BUTTON_WIDTH_HEIGHT_RATIO, height - BUTTON_SIZE - margin_bottom, BUTTON_SIZE, BUTTON_SIZE);
    self.updateButton.frame = CGRectMake(margin * BUTTON_LEFT_MARGIN_RATIO + margin * 3 + BUTTON_SIZE * (4 - 2) +  BUTTON_SIZE * SEX_BUTTON_WIDTH_HEIGHT_RATIO, height - UPDATE_BUTTON_SIZE - margin_bottom, UPDATE_BUTTON_SIZE, UPDATE_BUTTON_SIZE);

    // ボタンの画像設定
    manButtonImage = [UIImage imageNamed:@"manButton.png"];
    womanButtonImage = [UIImage imageNamed:@"womanButton.png"];
    manWomanButtonImage = [UIImage imageNamed:@"manWomanButton.png"];
    washletButtonImage = [UIImage imageNamed:@"washletButton.png"];
    washletButtonOffImage = [UIImage imageNamed:@"washletButtonOff.png"];
    washletButtonHighlightedImage = [UIImage imageNamed:@"washletButtonHighlighted.png"];
    multipurposeButtonImage = [UIImage imageNamed:@"multipurposeButton.png"];
    multipurposeButtonOffImage = [UIImage imageNamed:@"multipurposeButtonOff.png"];
    multipurposeButtonHighlightedImage = [UIImage imageNamed:@"multipurposeHighlightedButton.png"];
    updateButtonImage = [UIImage imageNamed:@"updateButton.png"];
    updateButtonHighlightedImage = [UIImage imageNamed:@"updateButtonHighlighted.png"];
    
    // フィルタリングボタンの表示設定
    [self changeSexButton];
    [self changeWashletButton];
    [self changeMultipurposeButton];
    
    // 更新ボタン
    [self.updateButton setBackgroundImage:updateButtonImage forState:UIControlStateNormal];
    [self.updateButton setBackgroundImage:updateButtonHighlightedImage forState:UIControlStateHighlighted];
    
    return self;
}

- (void)tappedSexButton:(UIButton*)button{
    if(_stateOfSex == MAN){
        _stateOfSex = WOMAN;
    }else{
        _stateOfSex = MAN;
    }
    NSLog(@"tappedSexButton");
    [self changeSexButton];
}

- (void) tappedUpdateButton:(UIButton*)btn{

}

- (void) tappedWashletButton:(UIButton*)btn{
    if(_stateOfWashlet){
        _stateOfWashlet = FALSE;
    }else{
        _stateOfWashlet = TRUE;
    }
    
    [self changeWashletButton];
}

- (void) tappedMultipurposeButton:(UIButton*)btn{
    if(_stateOfMultipurpose){
        _stateOfMultipurpose = FALSE;
    }else{
        _stateOfMultipurpose = TRUE;
    }
    
    [self changeMultipurposeButton];
}

- (void) changeSexButton{
    if(_stateOfSex == MAN){
        [_sexButton setBackgroundImage:manButtonImage forState:UIControlStateNormal];
        [_sexButton setBackgroundImage:manWomanButtonImage forState:UIControlStateHighlighted];
    }else{
        [_sexButton setBackgroundImage:womanButtonImage forState:UIControlStateNormal];
        [_sexButton setBackgroundImage:manWomanButtonImage forState:UIControlStateHighlighted];
    }
}

- (void) changeWashletButton{
    if(_stateOfWashlet){
        [_washletButton setBackgroundImage:washletButtonImage forState:UIControlStateNormal];
        //[_washletButton setBackgroundImage:washletButtonHighlightedImage forState:UIControlStateHighlighted];
    }else{
        [_washletButton setBackgroundImage:washletButtonOffImage forState:UIControlStateNormal];
        //[_washletButton setBackgroundImage:washletButtonHighlightedImage forState:UIControlStateHighlighted];
    }
}

- (void) changeMultipurposeButton{
    if(_stateOfMultipurpose){
        [_multipurposeButton setBackgroundImage:multipurposeButtonImage forState:UIControlStateNormal];
    }else{
        [_multipurposeButton setBackgroundImage:multipurposeButtonOffImage forState:UIControlStateNormal];
    }
}

//フィルタリングメソッド
- (NSMutableArray *) filtering:(NSMutableArray *)buildings stateOfSex:(Sex)sex stateOfWashlet:(BOOL)washlet stateOfMultipurpose:(BOOL)multipurpose{
    
    //初期状態のチェック
    NSLog(@"stateOfSex初期値:%@", sex==0 ? @"男(0)" : @"女(1)"); //>>男
    NSLog(@"stateOfWash初期値:%@", washlet ? @"true" : @"false"); //>>false
    NSLog(@"stateOfMultipurpose初期値:%@", multipurpose ? @"true" : @"false"); //>>false
    
    //デバッグ用パラメータ
    sex = 0;
    washlet = true;
    multipurpose = false;
    
    //フィルタリング結果の配列を定義
    NSMutableArray *filteringResultBuildings = [NSMutableArray array];
    
    //各々の要素が存在する場合のフラグを定義
    BOOL sexFrag;
    BOOL washletFrag;
    BOOL multipurposeFrag;
    BOOL buildingFrag;
    
    //ボタン状態に分けてフィルタリング
    if(sex==0 && washlet==false && multipurpose==false){//男 ∧ ウ× ∧多×
        for(Building *building in buildings){
            sexFrag=false; //建物ごとに初期化
            buildingFrag=false;
            for (NSMutableArray *toiletByFloor in building.toilets) {
                for (Toilet *toilet in toiletByFloor) {
                    if(toilet.sex==0){ //条件は性別のみ
                        //[filteringResultBuildings addObject:toilet]; //トイレ位置を追加 > Thread1:signal SIGABRT
                        sexFrag=true; //フラグを立てる
                        buildingFrag=true;
                    }
                }
            }
            if(sexFrag==true && buildingFrag==true){ //男性トイレがある場合その建物を追加
                [filteringResultBuildings addObject:building]; //建物位置を追加
            }
        }
    }
    if(sex==1 && washlet==false && multipurpose==false){//女 ∧ ウ× ∧ 多×
        for(Building *building in buildings){
            sexFrag=false;
            buildingFrag=false;
            for (NSMutableArray *toiletByFloor in building.toilets) {
                for (Toilet *toilet in toiletByFloor) {
                    if(toilet.sex==1){
                        //[filteringResultBuildings addObject:toilet];
                        sexFrag=true;
                        buildingFrag=true;
                    }
                }
            }
            if(sexFrag==true && buildingFrag==true){ //女性トイレがある場合その建物を追加
                [filteringResultBuildings addObject:building];
            }
        }
    }
    if(sex==0 && washlet==true){  //男 ∧ ウ◯ ∧ (多◯ or ×)
        for(Building *building in buildings){
            washletFrag=false;
            buildingFrag=false;
            for (NSMutableArray *toiletByFloor in building.toilets) {
                for (Toilet *toilet in toiletByFloor) {
                    if(toilet.sex==0 && toilet.hasWashlet==true){
                        //[filteringResultBuildings addObject:toilet];
                        washletFrag=true; //ウォシュレットフラグを立てる
                        buildingFrag=true;
                    }
                }
            }
            if(washletFrag==true && buildingFrag==true){ //男性トイレかつウォシュレットがある場合その建物を追加
                [filteringResultBuildings addObject:building];
            }
        }
    }
    if(sex==1 && washlet==true){  //女 ∧ ウ◯ ∧ (多◯ or ×)
        for(Building *building in buildings){
            washletFrag=false;
            buildingFrag=false;
            for (NSMutableArray *toiletByFloor in building.toilets) {
                for (Toilet *toilet in toiletByFloor) {
                    if(toilet.sex==1 && toilet.hasWashlet==true){
                        //[filteringResultBuildings addObject:toilet];
                        washletFrag=true;
                        buildingFrag=true;
                    }
                }
            }
            if(washletFrag==true && buildingFrag==true){ //女性トイレかつウォシュレットがある場合その建物を追加
                [filteringResultBuildings addObject:building];
            }
        }
    }
    
    if(sex==0 && washlet==false && multipurpose==true){//男 ∧ ウ× ∧ 多◯)
        for(Building *building in buildings){
            multipurposeFrag=false;
            buildingFrag=false;
            for (NSMutableArray *toiletByFloor in building.toilets) {
                for (Toilet *toilet in toiletByFloor) {
                    if(toilet.sex==0 && toilet.hasMultipurpose==true){
                        //[filteringResultBuildings addObject:toilet];
                        multipurposeFrag=true; //多目的トイレフラグを立てる
                        buildingFrag=true;
                    }
                }
            }
            if(multipurposeFrag==true && buildingFrag==true){ //男性トイレかつ多目的トイレがある場合その建物を追加
                [filteringResultBuildings addObject:building];
            }
        }
    }
    if(sex==1 && washlet==false && multipurpose==true){//女 ∧ ウ× ∧ 多◯)
        for(Building *building in buildings){
            multipurposeFrag=false;
            buildingFrag=false;
            for (NSMutableArray *toiletByFloor in building.toilets) {
                for (Toilet *toilet in toiletByFloor) {
                    if(toilet.sex==1 && toilet.hasMultipurpose==true){
                        //[filteringResultBuildings addObject:toilet];
                        multipurposeFrag=true;
                        buildingFrag=true;
                    }
                }
            }
            if(multipurposeFrag==true && buildingFrag==true){ //女性トイレかつ多目的トイレがある場合その建物を追加
                [filteringResultBuildings addObject:building];
            }
        }
    }
    NSLog(@"フィルタ結果の配列を出力:%@",filteringResultBuildings);
    return filteringResultBuildings; //フィルタリングした配列を返す
}

@end