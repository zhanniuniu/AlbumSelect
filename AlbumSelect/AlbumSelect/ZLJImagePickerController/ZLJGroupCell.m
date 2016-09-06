//
//  ZLJGroupCell.m
//  VistLibrary
//
//  Created by dlt_zhanlijun on 16/9/1.
//  Copyright © 2016年 dlt_zhanlijun. All rights reserved.
//

#import "ZLJGroupCell.h"
#import "ZLJGroupInfo.h"

#define kCellHeight 80
#define kMargin 5

@interface ZLJGroupCell ()
{
    UIImageView *_image;
    UILabel *_title;
    UILabel *_count;
}
@end

@implementation ZLJGroupCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addContentView];
    }
    return self;
}

- (void)addContentView
{
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, kMargin, kCellHeight - kMargin*2, kCellHeight - kMargin*2)];
    [self addSubview:_image];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame)+kMargin*2, kMargin, self.bounds.size.width-(CGRectGetMaxX(_image.frame)+kMargin*2), 40)];
    [_title setTextColor:[UIColor darkGrayColor]];
    [self addSubview:_title];
    
    _count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame)+kMargin*2, CGRectGetMaxY(_title.frame), self.bounds.size.width-(CGRectGetMaxX(_image.frame)+kMargin*2), 20)];
    [_count setFont:[UIFont systemFontOfSize:15]];
    [_count setTextColor:[UIColor lightGrayColor]];
    [self addSubview:_count];
}

- (void)setContentView:(ZLJGroupInfo *)groupInfo
{
    [_image setImage:groupInfo.image];
    
    [_title setText:groupInfo.title];
    
    [_count setText:groupInfo.count];
}

+(CGFloat)getCellHeight
{
    return kCellHeight;
}


@end
