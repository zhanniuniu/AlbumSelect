//
//  ZLJPHAssetInfo.m
//  VistLibrary
//
//  Created by dlt_zhanlijun on 16/9/5.
//  Copyright © 2016年 dlt_zhanlijun. All rights reserved.
//

#import "ZLJPHAssetInfo.h"

@implementation ZLJPHAssetInfo
-(id)initWithAsset:(PHAsset *)asset
{
    self= [super init];
    if (self) {
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];

        [imageManager requestImageForAsset:asset
                                targetSize:CGSizeMake(120, 120)
                               contentMode:PHImageContentModeAspectFill
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 self.thumbNailImage = result;
                                 // 得到一张 UIImage，展示到界面上
                                 
                             }];
//        self.thumbNailImage = [UIImage imageWithCGImage:asset.thumbnail];
        self.asset = asset;
    }

    return self;
}
@end
