//
//  MapController.h
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
@property UIButton *washletButton;
@property UIButton *multipurposeButton;
@property Boolean stateOfWashlet;
@property Boolean stateOfMultipurpose;
@property Sex stateOfSex;

- (id) initWithState:(Sex)sex empty:(Boolean)empty washlet:(Boolean)wash multipurpose:(Boolean)multipurpose parent:(UIViewController*)parent;
- (void) changeSexButton;
- (void) changeWashletButton;
- (void) changeMultipurposeButton;
- (void) tappedSexButton:(UIButton*)button;
- (void) tappedUpdateButton:(UIButton*)button;
- (void) tappedWashletButton:(UIButton*)button;
- (void) tappedMultipurposeButton:(UIButton*)button;
- (NSMutableArray *) filtering:(NSMutableArray *)buildings stateOfSex:(Sex)sex stateOfWashlet:(BOOL)washlet stateOfMultipurpose:(BOOL)multipurpose;

@end




