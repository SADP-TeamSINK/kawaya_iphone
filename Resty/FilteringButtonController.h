//
//  NSObject_SexButtonController.h
//  Resty
//
//  Created by Imamori Daichi on 2014/11/14.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Const.m"

@interface FilteringButtonController: NSObject
@property UIButton *sexButton;
@property UIButton *updateButton;
@property UIButton *washButton;
@property UIButton *multipurposeButton;
- (id) initWithState:(Sex)sex empty:(Boolean)empty wash:(Boolean)wash multipurpose:(Boolean)multipurpose parent:(UIViewController*)parent;
- (void) changeSexButton;
- (void) changeWashButton;
- (void) changeMultipurposeButton;
- (void) tappedSexButton:(UIButton*)button;
- (void) tappedUpdateButton:(UIButton*)button;
- (void) tappedWashButton:(UIButton*)button;
- (void) tappedMultipurposeButton:(UIButton*)button;
@end




