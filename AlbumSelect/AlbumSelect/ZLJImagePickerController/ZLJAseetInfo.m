//
//  ZLJAseetInfo.m
//  VistLibrary
//
//  Created by dlt_zhanlijun on 16/9/1.
//  Copyright © 2016年 dlt_zhanlijun. All rights reserved.
//

#import "ZLJAseetInfo.h"

@implementation ZLJAseetInfo

-(id)initWithAsset:(ALAsset *)asset
{
    self= [super init];
    if (self) {
        self.thumbNailImage = [UIImage imageWithCGImage:asset.thumbnail];
        self.asset = asset;
    }
    return self;
}

@end
