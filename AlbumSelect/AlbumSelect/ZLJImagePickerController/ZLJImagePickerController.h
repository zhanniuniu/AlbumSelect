//
//  ZLJImagePickerController.h
//  VistLibrary
//
//  Created by dlt_zhanlijun on 16/8/31.
//  Copyright © 2016年 dlt_zhanlijun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZLJImagePickerControllerVCDelegate<NSObject>

- (void)ZLJImagePickerControllerDidFinshWithArray:(NSArray *)array;
@end


@interface ZLJImagePickerController : UINavigationController

@property (nonatomic, assign) id ZLJdelegate;

+ (id)imagePicker;

@end
