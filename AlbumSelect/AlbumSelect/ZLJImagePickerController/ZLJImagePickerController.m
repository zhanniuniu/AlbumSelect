//
//  ZLJImagePickerController.m
//  VistLibrary
//
//  Created by dlt_zhanlijun on 16/8/31.
//  Copyright © 2016年 dlt_zhanlijun. All rights reserved.
//

#import "ZLJImagePickerController.h"
#import "ZLJAlbumVC.h"
#import "ZLJPhotosVC.h"

@interface ZLJImagePickerController ()<ZLJPhotosVCDelegate>

@end

@implementation ZLJImagePickerController

+ (id)imagePicker
{
    ZLJAlbumVC *albumVC = [[ZLJAlbumVC alloc] init];
    return  [[self alloc] initWithRootViewController:albumVC];
}

#pragma mark ZLJPhotosVCDelegate
-(void)ZLJPhotosVCImagePickerSuccess:(NSArray *)array
{
    if (self.ZLJdelegate&&[self.ZLJdelegate respondsToSelector:@selector(ZLJImagePickerControllerDidFinshWithArray:)]) {
        [self.ZLJdelegate ZLJImagePickerControllerDidFinshWithArray:array];
    }
}

@end
