//
//  ZLJGroupInfo.h
//  VistLibrary
//
//  Created by dlt_zhanlijun on 16/9/1.
//  Copyright © 2016年 dlt_zhanlijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface ZLJGroupInfo : NSObject

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *count;
@property (nonatomic,strong) ALAssetsGroup *group;
@property (nonatomic,strong) PHFetchResult *result;

-(instancetype)initWithALGroup:(ALAssetsGroup *)group;

+(instancetype)groupInfoWithALGroup:(ALAssetsGroup *)group;

-(instancetype)initWithPHResult:(PHFetchResult *)result title:(NSString *)title;

+(instancetype)resultInfoWithPHResult:(PHFetchResult *)result title:(NSString *)title;


@end
