//
//  ZLJPhotosVC.h
//  VistLibrary
//
//  Created by dlt_zhanlijun on 16/8/31.
//  Copyright © 2016年 dlt_zhanlijun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLJGroupInfo;
@protocol ZLJPhotosVCDelegate <NSObject>

@required

- (void)ZLJPhotosVCImagePickerSuccess:(NSArray *)array;

@end

@interface ZLJPhotosVC : UIViewController


@property(nonatomic,assign)id delegate;

-(instancetype)initWithGroupInfo:(ZLJGroupInfo *)groupInfo;

@end
