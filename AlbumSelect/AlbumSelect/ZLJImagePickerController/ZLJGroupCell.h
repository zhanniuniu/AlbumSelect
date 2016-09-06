//
//  ZLJGroupCell.h
//  VistLibrary
//
//  Created by dlt_zhanlijun on 16/9/1.
//  Copyright © 2016年 dlt_zhanlijun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLJGroupInfo;
@interface ZLJGroupCell : UITableViewCell

- (void)setContentView:(ZLJGroupInfo *)groupInfo;
+ (CGFloat)getCellHeight;

@end
