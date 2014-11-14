//
//  SexButtonController.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/14.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilteringButtonController.h"

@implementation FilteringButtonController : NSObject
Sex stateOfSex;
Boolean stateOfEmpty;
Boolean stateOfWash;
Boolean stateOfMultipurpose;
UIViewController *parent;
int height;
int width;
int heightButton = 30;
int widthButton = 30;
int numberOfButton = 4;

- (id) initWithState:(Sex)sex empty:(Boolean)empty wash:(Boolean)wash multipurpose:(Boolean)multipurpose parent:(UIViewController*)p
{
    self = [super init];
    parent = p;
    
    //画面サイズ取得
    height = [[UIScreen mainScreen] bounds].size.height;
    width = [[UIScreen mainScreen] bounds].size.width;
    
    //状態の設定
    stateOfSex = sex;
    stateOfEmpty = empty;
    stateOfWash = wash;
    stateOfMultipurpose = multipurpose;
    
    //ボタンの生成
    self.sexButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.emptyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.washButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.multipurposeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //ボタンの配置とサイズ設定
    int margin = (width - widthButton * numberOfButton) / (numberOfButton + 1);
    int margin_bottom = 30;
    self.sexButton.frame = CGRectMake(margin * 1 + widthButton * (1 - 1), height - heightButton - margin_bottom, widthButton, heightButton);
    self.emptyButton.frame = CGRectMake(margin * 2 + widthButton * (2 - 1), height - heightButton - margin_bottom, widthButton, heightButton);
    self.washButton.frame = CGRectMake(margin * 3 + widthButton * (3 - 1), height - heightButton - margin_bottom, widthButton, heightButton);
    self.multipurposeButton.frame = CGRectMake(margin * 4 + widthButton * (4 - 1), height - heightButton - margin_bottom, widthButton, heightButton);

    //ボタンの表示設定
    [self changeSexButton];
    [self changeEmptyButton];
    [self changeWashButton];
    [self changeMultipurposeButton];
    
    return self;
}

- (void)tappedSexButton:(UIButton*)button{
    if(stateOfSex == MAN){
        stateOfSex = WOMAN;
    }else if(stateOfSex == WOMAN){
        stateOfSex = BOTH;
    }else{
        stateOfSex = MAN;
    }
    NSLog(@"tappedSexButton");
    [self changeSexButton];
}

- (void) tappedEmptyButton:(UIButton*)btn{
    if(stateOfEmpty){
        stateOfEmpty = FALSE;
    }else{
        stateOfEmpty = TRUE;
    }
    
    [self changeEmptyButton];
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
    }else if(stateOfSex == WOMAN){
        [self.sexButton setTitle:@"女" forState:UIControlStateNormal];
    }else{
        [self.sexButton setTitle:@"共用" forState:UIControlStateNormal];
    }
}

- (void) changeEmptyButton{
    if(stateOfEmpty){
        [self.emptyButton setTitle:@"空入" forState:UIControlStateNormal];
    }else{
        [self.emptyButton setTitle:@"空無" forState:UIControlStateNormal];
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

