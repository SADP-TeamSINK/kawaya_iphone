//
//  ToiletTableViewCell.m
//  Resty
//
//  Created by Imamori Daichi on 2014/11/24.
//  Copyright (c) 2014年 Kazuma Nagaya. All rights reserved.
//

#import "ToiletTableViewCell.h"

@implementation ToiletTableViewCell {
    NSInteger height_;
    NSInteger width_;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        height_ = [[UIScreen mainScreen] bounds].size.height;
        width_ = [[UIScreen mainScreen] bounds].size.width;
        
        self.contentView.frame = CGRectMake(0, 0, height_ * PANE_HEIGHT_RATIO, width_ * PANE_WIDTH_RATIO);
        self.contentView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
        
        // メインテキスト
        _storeName = [[UILabel alloc] initWithFrame:CGRectMake(PANE_TOP_PADDING, PANE_LEFT_PADDING, width_ * PANE_WIDTH_RATIO, height_ * PANE_HEIGHT_RATIO)];
        _storeName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _storeName.font = [UIFont systemFontOfSize:STORE_NAME_FONT_SIZE];
        _storeName.numberOfLines = 2;
        
        [self.contentView addSubview:_storeName];
        
        // ウォシュレットマークの設定
        _washletImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"washletMark.png"]];
        _washletImageView.frame
            = CGRectMake(
                         self.contentView.frame.size.width - PANE_RIGHT_PADDING - _washletImageView.image.size.width,
                         PANE_TOP_PADDING,
                         _washletImageView.image.size.width,
                         _washletImageView.image.size.height);
        [self.contentView addSubview:_washletImageView];
        
        // 多目的トイレマークの設定
        _washletImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"multipurposeMark.png"]];
        _washletImageView.frame = CGRectMake(100, PANE_TOP_PADDING, _washletImageView.image.size.width, _washletImageView.image.size.height);
        [self.contentView addSubview:_washletImageView];

    }
    
    // レイアウトをアップデート
    [self updateConstraints];
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
