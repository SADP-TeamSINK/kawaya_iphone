//
//  SexButtonController.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/14.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilteringButtonController.h"

@implementation FilteringButtonController {
    Sex stateOfSex;
    Boolean stateOfWash;
    Boolean stateOfMultipurpose;
    UIViewController *parent;
    NSInteger height;
    NSInteger width;
    NSInteger heightButton;
    NSInteger widthButton;
    NSInteger numberOfButton;
}
- (id) initWithState:(Sex)sex empty:(Boolean)empty wash:(Boolean)wash multipurpose:(Boolean)multipurpose parent:(UIViewController*)p
{
    self = [super init];
    parent = p;

    // ボタンの設定
    heightButton = 30;
    widthButton = 30;
    numberOfButton = 4;
    
    // 画面サイズ取得
    height = [[UIScreen mainScreen] bounds].size.height;
    width = [[UIScreen mainScreen] bounds].size.width;
    
    // 状態の設定
    stateOfSex = sex;
    stateOfWash = wash;
    stateOfMultipurpose = multipurpose;
    
    // ボタンの生成
    self.sexButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.updateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.washButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.multipurposeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // ボタンの配置とサイズ設定
    NSInteger margin = (width - widthButton * numberOfButton) / (numberOfButton + 1);
    NSInteger margin_bottom = 30;
    self.sexButton.frame = CGRectMake(margin * 1 + widthButton * (1 - 1), height - heightButton - margin_bottom, widthButton, heightButton);
    self.washButton.frame = CGRectMake(margin * 2 + widthButton * (2 - 1), height - heightButton - margin_bottom, widthButton, heightButton);
    self.multipurposeButton.frame = CGRectMake(margin * 3 + widthButton * (3 - 1), height - heightButton - margin_bottom, widthButton, heightButton);
    self.updateButton.frame = CGRectMake(margin * 4 + widthButton * (4 - 1), height - heightButton - margin_bottom, widthButton, heightButton);

    
    // ボタンの表示設定
    [self changeSexButton];
    [self changeWashButton];
    [self changeMultipurposeButton];
    [self.updateButton setTitle:@"更新" forState:UIControlStateNormal];
    
    return self;
}

- (void)tappedSexButton:(UIButton*)button{
    if(stateOfSex == MAN){
        stateOfSex = WOMAN;
    }else{
        stateOfSex = MAN;
    }
    NSLog(@"tappedSexButton");
    [self changeSexButton];
}

- (void) tappedUpdateButton:(UIButton*)btn{

}

- (void) tappedWashButton:(UIButton*)btn{
    if(stateOfWash){
        stateOfWash = FALSE;
    }else{
        stateOfWash = TRUE;
    }
    
    [self changeWashButton];
}

- (void) tappedMultipurposeButton:(UIButton*)btn{
    if(stateOfMultipurpose){
        stateOfMultipurpose = FALSE;
    }else{
        stateOfMultipurpose = TRUE;
    }
    
    [self changeMultipurposeButton];
}

- (void) changeSexButton{
    if (stateOfSex == MAN) {
        [self.sexButton setTitle:@"男" forState:UIControlStateNormal];
    }else{
        [self.sexButton setTitle:@"女" forState:UIControlStateNormal];
    }
}

- (void) changeWashButton{
    if(stateOfWash){
        [self.washButton setTitle:@"洗入" forState:UIControlStateNormal];
    }else{
        [self.washButton setTitle:@"洗無" forState:UIControlStateNormal];
    }
}

- (void) changeMultipurposeButton{
    if(stateOfMultipurpose){
        [self.multipurposeButton setTitle:@"多入" forState:UIControlStateNormal];
    }else{
        [self.multipurposeButton setTitle:@"多無" forState:UIControlStateNormal];
    }
}

@end