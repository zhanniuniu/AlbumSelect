//
//  ZLJAseetInfo.h
//  VistLibrary
//
//  Created by dlt_zhanlijun on 16/9/1.
//  Copyright © 2016年 dlt_zhanlijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ZLJAseetInfo : NSObject

@property (nonatomic,strong)UIImage *thumbNailImage;
@property (nonatomic,strong)ALAsset *asset;
@property (nonatomic,strong)UIImage *fullScreenImage;

-(id)initWithAsset:(ALAsset *)asset;

@end
