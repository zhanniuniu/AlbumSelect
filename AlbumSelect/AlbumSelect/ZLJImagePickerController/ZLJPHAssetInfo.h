//
//  ZLJPHAssetInfo.h
//  VistLibrary
//
//  Created by dlt_zhanlijun on 16/9/5.
//  Copyright © 2016年 dlt_zhanlijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


@interface ZLJPHAssetInfo : NSObject

@property (nonatomic,strong)UIImage *thumbNailImage;
@property (nonatomic,strong)PHAsset *asset;
@property (nonatomic,strong)UIImage *fullScreenImage;

-(id)initWithAsset:(PHAsset *)asset;
@end
