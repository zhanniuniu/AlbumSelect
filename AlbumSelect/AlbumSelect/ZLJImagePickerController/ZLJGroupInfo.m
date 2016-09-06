//
//  ZLJGroupInfo.m
//  VistLibrary
//
//  Created by dlt_zhanlijun on 16/9/1.
//  Copyright © 2016年 dlt_zhanlijun. All rights reserved.
//

#import "ZLJGroupInfo.h"

@implementation ZLJGroupInfo
-(instancetype)initWithALGroup:(ALAssetsGroup *)group
{
    if (self = [super init]) {
        self.group = group;
        self.image = [UIImage imageWithCGImage:group.posterImage];
        self.count = [NSString stringWithFormat:@"%ld张照片",(long)group.numberOfAssets];
        self.title = [group valueForProperty:ALAssetsGroupPropertyName];
    }
    return self;
}

-(instancetype)initWithPHResult:(PHFetchResult *)result title:(NSString *)title
{
    if (self = [super init]) {
        self.result = result;
        self.count = [NSString stringWithFormat:@"%ld",result.count];
        self.title = title;
        // 在资源的集合中获取第一个集合，并获取其中的图片
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        PHAsset *asset = result[0];
        [imageManager requestImageForAsset:asset
                                targetSize:CGSizeMake(120, 120)
                               contentMode:PHImageContentModeAspectFill
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 
                                 // 得到一张 UIImage，展示到界面上
                                 self.image = result;
                             }];

        
    }
    
    
    return self;
}

+(instancetype)groupInfoWithALGroup:(ALAssetsGroup *)group
{
    return [[self alloc] initWithALGroup:group];
}

+(instancetype)resultInfoWithPHResult:(PHFetchResult *)result title:(NSString *)title
{
    return [[self alloc] initWithPHResult:result title:title];
}



- (void)aaa
{
//    id asset = [model.result lastObject];
//    if (!self.sortAscendingByModificationDate) {
//        asset = [model.result firstObject];
//    }
//    [[TZImageManager manager] getPhotoWithAsset:asset photoWidth:80 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
//        if (completion) completion(photo);
//    }];

}

//- (PHImageRequestID)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *, NSDictionary *, BOOL isDegraded))completion {
//    if ([asset isKindOfClass:[PHAsset class]]) {
//        CGSize imageSize;
////        if (photoWidth < TZScreenWidth && photoWidth < _photoPreviewMaxWidth) {
////            imageSize = AssetGridThumbnailSize;
////        } else {
//            PHAsset *phAsset = (PHAsset *)asset;
//            CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
////            CGFloat pixelWidth = photoWidth * TZScreenScale;
////            CGFloat pixelHeight = pixelWidth / aspectRatio;
////            imageSize = CGSizeMake(pixelWidth, pixelHeight);
////        }
//        // 修复获取图片时出现的瞬间内存过高问题
//        // 下面两行代码，来自hsjcom，他的github是：https://github.com/hsjcom 表示感谢
//        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
//        option.resizeMode = PHImageRequestOptionsResizeModeFast;
//        PHImageRequestID imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
//            if (downloadFinined && result) {
////                result = [self fixOrientation:result];
//                if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
//            }
//            // Download image from iCloud / 从iCloud下载图片
//            if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
//                PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
//                option.networkAccessAllowed = YES;
//                option.resizeMode = PHImageRequestOptionsResizeModeFast;
//                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//                    UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
//                    resultImage = [self scaleImage:resultImage toSize:imageSize];
//                    if (resultImage) {
//                        resultImage = [self fixOrientation:resultImage];
//                        if (completion) completion(resultImage,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
//                    }
//                }];
//            }
//        }];
//        return imageRequestID;
//        
//    }
//}
@end
