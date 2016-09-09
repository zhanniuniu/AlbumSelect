//
//  ZLJPhotosVC.m
//  VistLibrary
//
//  Created by dlt_zhanlijun on 16/8/31.
//  Copyright © 2016年 dlt_zhanlijun. All rights reserved.
//

#import "ZLJPhotosVC.h"
#import "ZLJGroupInfo.h"
#import "ZLJAseetInfo.h"
#import "ZLJPHAssetInfo.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#define kMargin 5
#define kBottonHeight 40
#define kCountButtonHeight 22
#define LIGHT_GREEN_COLOR [UIColor colorWithRed:83.0/255.0f green:181.0/255.0f blue:70.0/255.0f alpha:1.0f]

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

static NSString *cellIdentifier = @"cellIdentifier";
@interface ZLJPhotosVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    ZLJGroupInfo *_groupInfo;
     UICollectionView *_collectionView;
    NSMutableArray *_assetInfoArray;//存储所有读取的照片
    NSMutableArray *_selectedImageArray;//存储所有被选择的照片
    UIButton *_doneButton;//完成按钮
    UIButton *_countButton;//计数按钮
    UIButton *_saveButton;//保存按钮
    dispatch_queue_t _queue;//全局穿行队列
    
    BOOL isyes;

}
@end

@implementation ZLJPhotosVC


-(instancetype)initWithGroupInfo:(ZLJGroupInfo *)groupInfo
{
    self = [super init];
    if (self) {
        _groupInfo =groupInfo;
        self.title = groupInfo.title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //        self.navigationController.navigationBar.translucent = YES;
    }
    
    [self setNavigationbar];
    [self addContentView];
    
   
    if (iOS8Later) {
         [self loadPHAsset];
    }
    else
    {
         [self loadAssets];
    }
    
    [self addBottomView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationbar
{
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addContentView
{
    CGRect frame = self.view.frame;
    frame.size.height -=44+20+kBottonHeight;
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[UICollectionViewFlowLayout new]];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    _collectionView.delegate =self;
    _collectionView.dataSource =self;
    _collectionView.allowsMultipleSelection = YES;
    [self.view addSubview:_collectionView];

}

//添加底部视图
- (void)addBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame), self.view.bounds.size.width, kBottonHeight)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bottomView];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneButton setFrame:CGRectMake(self.view.bounds.size.width-40-10, (kBottonHeight-20)/2, 40, 20)];
    [_doneButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_doneButton setUserInteractionEnabled:NO];
    [bottomView addSubview:_doneButton];
    
    _countButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_countButton setFrame:CGRectMake(CGRectGetMinX(_doneButton.frame)-kCountButtonHeight, (kBottonHeight-kCountButtonHeight)/2, kCountButtonHeight, kCountButtonHeight)];
    [_countButton setImage:[UIImage imageNamed:@"Mypic.bundle/ms_badge"] forState:UIControlStateNormal];
    [_countButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_countButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -kCountButtonHeight, 0, 0)];
    _countButton.hidden = YES;
    [bottomView addSubview:_countButton];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveButton setFrame:CGRectMake(self.view.bounds.size.width-80, 0, 80, kBottonHeight)];
    [_saveButton setBackgroundColor:[UIColor clearColor]];
    [_saveButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [_saveButton setUserInteractionEnabled:NO];
    [bottomView addSubview:_saveButton];
}

//设置按钮的状态
- (void)setButtonStatus:(int)count
{
    if (count>0) {
        [_doneButton setTitleColor:LIGHT_GREEN_COLOR forState:UIControlStateNormal];
        
        _countButton.hidden = NO;
        [_countButton setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
        NSValue *value1 = [NSValue valueWithCGRect:CGRectMake(0, 0, kCountButtonHeight*0.5, kCountButtonHeight*0.5)];
        NSValue *value2 = [NSValue valueWithCGRect:CGRectMake(0, 0, kCountButtonHeight*1.2, kCountButtonHeight*1.2)];
        NSValue *value3 = [NSValue valueWithCGRect:CGRectMake(0, 0, kCountButtonHeight, kCountButtonHeight)];
        animation.values = @[value1, value2, value3];
        animation.duration = 0.6;
        [_countButton.imageView.layer addAnimation:animation forKey:nil];
        
        
        [_saveButton setUserInteractionEnabled:YES];
        
        
        
    } else {
        [_doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        _countButton.hidden = YES;
        
        [_saveButton setUserInteractionEnabled:NO];
    }
    
    
    
}

//完成
- (void)done
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZLJPhotosVCImagePickerSuccess:)]) {
        [self.delegate ZLJPhotosVCImagePickerSuccess:_selectedImageArray];
    }
    
    //返回
    [self back];
}

- (void)loadAssets
{
    _assetInfoArray = [NSMutableArray array];
    ALAssetsGroup *group = _groupInfo.group;
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            ZLJAseetInfo *assetInfo = [[ZLJAseetInfo alloc] initWithAsset:result];
            [_assetInfoArray addObject:assetInfo];
        }
        else
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_assetInfoArray.count-1 inSection:0];
            [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        }
    }];
}


- (void)loadPHAsset
{
    _assetInfoArray = [NSMutableArray array];
    PHFetchResult *result = _groupInfo.result;
    

    for (PHAsset *asset in result) {
        ZLJPHAssetInfo *assetInfo = [[ZLJPHAssetInfo alloc] initWithAsset:asset];
        [_assetInfoArray addObject:assetInfo];
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_assetInfoArray.count-1 inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];

    
}



#pragma mark UICollectionViewDelegate


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    
    
    if (!_queue) {
        _queue = dispatch_queue_create("serial queue", NULL);
    }
    if (!_selectedImageArray) {
        _selectedImageArray = [NSMutableArray array];
    }
    
    if (_selectedImageArray.count>=9) {
        return;
    }
    
    dispatch_async(_queue, ^{
        
        
        
        if (iOS8Later) {
            ZLJPHAssetInfo *assetInfo = _assetInfoArray[indexPath.row];
            PHAsset *asset = assetInfo.asset;
            PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
            
            [imageManager requestImageForAsset:asset
                                    targetSize:PHImageManagerMaximumSize
                                   contentMode:PHImageContentModeAspectFill
                                       options:nil
                                 resultHandler:^(UIImage *result, NSDictionary *info) {
                                         assetInfo.fullScreenImage = result;
                                     [_selectedImageArray addObject:assetInfo.fullScreenImage];
                                     
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         //设置按钮的状态
                                         [self setButtonStatus:(int)_selectedImageArray.count];
                                         isyes =  [self isNumover:(int)_selectedImageArray.count];
                                         
                                     });

                                     // 得到一张 UIImage，展示到界面上
                                     
                                 }];

        }
        else
        {
            ZLJAseetInfo *assetInfo = _assetInfoArray[indexPath.row];
            if (!assetInfo.fullScreenImage) {
                ALAsset *asset = assetInfo.asset;
                ALAssetRepresentation *representation = [asset defaultRepresentation];
                UIImage *fullSreenImage = [UIImage imageWithCGImage:representation.fullScreenImage];
                assetInfo.fullScreenImage = fullSreenImage;
            }
            
            [_selectedImageArray addObject:assetInfo.fullScreenImage];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的状态
                [self setButtonStatus:(int)_selectedImageArray.count];
                isyes =  [self isNumover:(int)_selectedImageArray.count];
                
            });

        }
        
    });
}
- (BOOL)isNumover:(int)conte
{
    if (conte>=9) {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(_queue, ^{
        
        
        if (iOS8Later) {
            ZLJPHAssetInfo *assetInfo = _assetInfoArray[indexPath.row];
            UIImage *fullScreenImage = assetInfo.fullScreenImage;
            [_selectedImageArray removeObject:fullScreenImage];

            
        }else
        {
            ZLJAseetInfo *assetInfo = _assetInfoArray[indexPath.row];
            UIImage *fullScreenImage = assetInfo.fullScreenImage;
            [_selectedImageArray removeObject:fullScreenImage];

        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //设置按钮的状态
            [self setButtonStatus:(int)_selectedImageArray.count];
            isyes =  [self isNumover:(int)_selectedImageArray.count];

        });
    });
}

#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _assetInfoArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    
    if (iOS8Later) {
        ZLJPHAssetInfo *assetInfo = _assetInfoArray[indexPath.row];
        cell.backgroundView = [[UIImageView alloc] initWithImage:assetInfo.thumbNailImage];
        
    }else
    {
     ZLJAseetInfo *assetInfo = _assetInfoArray[indexPath.row];
        cell.backgroundView = [[UIImageView alloc] initWithImage:assetInfo.thumbNailImage];
    }
    
    
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mypic.bundle/ms_overlay.png"]];
    
    return cell;

}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.bounds.size.width-kMargin*5)/4, (self.view.bounds.size.width-kMargin*5)/4);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kMargin;
}

@end
