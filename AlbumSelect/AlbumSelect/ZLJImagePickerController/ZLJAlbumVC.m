//
//  ZLJAlbumVC.m
//  VistLibrary
//
//  Created by dlt_zhanlijun on 16/8/31.
//  Copyright © 2016年 dlt_zhanlijun. All rights reserved.
//

#import "ZLJAlbumVC.h"
#import "ZLJGroupCell.h"
#import "ZLJGroupInfo.h"
#import "ZLJPhotosVC.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

@interface ZLJAlbumVC ()<UITableViewDelegate,UITableViewDataSource,ZLJPhotosVCDelegate>
{
    UITableView *_tableView;//相册列表
    NSMutableArray *_groupArray;//相册数组
    ALAssetsLibrary *_assetsLibrary;//资源库
    PHPhotoLibrary *_assetsLibraryph;
    
}
@end

@implementation ZLJAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //        self.navigationController.navigationBar.translucent = YES;
    }
     self.title = @"照片";
    
    [self setNavigationBar];
    [self addTableView];
    

    
    if (iOS8Later) {
        [self loadPHssetsGroup];
    }
    else
    {
        [self loadAssetsGroup];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationBar
{
    //设置标题的颜色和大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    
    //设置导航条的背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Mypic.bundle/uitabr.png"] forBarMetrics:UIBarMetricsDefault];
    
    //设置导航条按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //设置导航条按钮颜色为白色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

}
/**
 *  返回
 */
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  添加视图
 */
- (void)addTableView
{
    CGRect frame = self.view.frame;
    frame.size.height -= 44+20;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}

/**
 *  加载ALsset库
 */
- (void)loadAssetsGroup
{
     /********** 硬件权限 ***********/
    ALAuthorizationStatus authorStatus = [ALAssetsLibrary authorizationStatus];
    
    if (authorStatus == ALAuthorizationStatusDenied || authorStatus == ALAuthorizationStatusRestricted) {
        //程序的名字
        NSDictionary*info =[[NSBundle mainBundle] infoDictionary];
        NSString*projectName =[info objectForKey:@"CFBundleName"];
        NSString *title = [NSString stringWithFormat:@"请在%@的“设置－隐私－照片”选项中，允许%@访问您的手机。",[UIDevice currentDevice].model,projectName];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alertView show];
    }
    else
    {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        _groupArray = [NSMutableArray array];
        
        [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if (group) {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                if (group.numberOfAssets>0) {
                    ZLJGroupInfo *groupInfo = [ZLJGroupInfo groupInfoWithALGroup:group];
                    [_groupArray addObject:groupInfo];
                }
            }
            else
            {
                _groupArray = (NSMutableArray *)[[_groupArray reverseObjectEnumerator] allObjects];
                ZLJPhotosVC *firstPhotosVC  = [[ZLJPhotosVC alloc] initWithGroupInfo:_groupArray[0]];
                firstPhotosVC.delegate =self.navigationController;
                [self.navigationController pushViewController:firstPhotosVC animated:NO];
                
                [_tableView reloadData];
            }
            
        } failureBlock:^(NSError *error) {
            NSLog(@"获取照片组失败");
        }];
    }
}



- (void)loadPHssetsGroup
{
      /********** 硬件权限 ***********/


    PHAuthorizationStatus authorSatus = [PHPhotoLibrary authorizationStatus];
    //  PHAuthorizationStatusDenied 用户拒绝当前应用访问相册
    //  PHAuthorizationStatusRestricted 家长控制,不允许访问
    //  PHAuthorizationStatusNotDetermined 用户还没有做出选择
    
    if (authorSatus == PHAuthorizationStatusDenied||authorSatus==PHAuthorizationStatusRestricted||authorSatus ==PHAuthorizationStatusNotDetermined) {
        //程序的名字
        NSDictionary*info =[[NSBundle mainBundle] infoDictionary];
        NSString*projectName =[info objectForKey:@"CFBundleName"];
        NSString *title = [NSString stringWithFormat:@"请在%@的“设置－隐私－照片”选项中，允许%@访问您的手机。",[UIDevice currentDevice].model,projectName];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        [alertView show];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //按钮触发的方法
            
//         NSArray *_array = @[
//                       @{@"系统设置":@"prefs:root=INTERNET_TETHERING"},
//                       @{@"WIFI设置":@"prefs:root=WIFI"},
//                       @{@"蓝牙设置":@"prefs:root=Bluetooth"},
//                       @{@"系统通知":@"prefs:root=NOTIFICATIONS_ID"},
//                       @{@"通用设置":@"prefs:root=General"},
//                       @{@"显示设置":@"prefs:root=DISPLAY&BRIGHTNESS"},
//                       @{@"壁纸设置":@"prefs:root=Wallpaper"},
//                       @{@"声音设置":@"prefs:root=Sounds"},
//                       @{@"隐私设置":@"prefs:root=privacy"},
//                       @{@"APP Store":@"prefs:root=STORE"},
//                       @{@"Notes":@"prefs:root=NOTES"},
//                       @{@"Safari":@"prefs:root=Safari"},
//                       @{@"Music":@"prefs:root=MUSIC"},
//                       @{@"photo":@"prefs:root=Photos"}
//                       ];
//            NSURL * url = [NSURL URLWithString:[_array[9] allValues].firstObject];
//            [[UIApplication sharedApplication]openURL:url];
            
            
            
            NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
            
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
            

            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //按钮触发的方法
            [self back];
        }]];
        
       [self presentViewController:alertController animated:YES completion:nil];
        
        


    }
    else
    {
         /********** 便利资源库 ***********/
        
        _groupArray = [NSMutableArray array];
        

        PHFetchOptions *option = [[PHFetchOptions alloc] init];
//          if (!NO)
         option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:YES]];
        
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        
        for (PHAssetCollection *collection in smartAlbums) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            if ([collection.localizedTitle containsString:@"Deleted"] || [collection.localizedTitle isEqualToString:@"最近删除"]) continue;
            if ([self isCameraRollAlbum:collection.localizedTitle]) {

                [_groupArray insertObject:[ZLJGroupInfo resultInfoWithPHResult:fetchResult title:collection.localizedTitle] atIndex:0];
            } else {

                [_groupArray addObject:[ZLJGroupInfo resultInfoWithPHResult:fetchResult title:collection.localizedTitle]];
            }
        }
        for (PHAssetCollection *collection in topLevelUserCollections) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            [_groupArray addObject:[ZLJGroupInfo resultInfoWithPHResult:fetchResult title:collection.localizedTitle]];
        }

        
        ZLJPhotosVC *firstPhotosVC  = [[ZLJPhotosVC alloc] initWithGroupInfo:_groupArray[0]];
        firstPhotosVC.delegate =self.navigationController;
        [self.navigationController pushViewController:firstPhotosVC animated:NO];
        
        [_tableView reloadData];
    }
    
    
}


- (BOOL)isCameraRollAlbum:(NSString *)albumName {
    NSString *versionStr = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (versionStr.length <= 1) {
        versionStr = [versionStr stringByAppendingString:@"00"];
    } else if (versionStr.length <= 2) {
        versionStr = [versionStr stringByAppendingString:@"0"];
    }
    CGFloat version = versionStr.floatValue;
    // 目前已知8.0.0 - 8.0.2系统，拍照后的图片会保存在最近添加中
    if (version >= 800 && version <= 802) {
        return [albumName isEqualToString:@"最近添加"] || [albumName isEqualToString:@"Recently Added"];
    } else {
        return [albumName isEqualToString:@"Camera Roll"] || [albumName isEqualToString:@"相机胶卷"] || [albumName isEqualToString:@"所有照片"] || [albumName isEqualToString:@"All Photos"];
    }
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZLJGroupInfo *grouInfo =_groupArray[indexPath.row];
    ZLJPhotosVC *firstPhotosVC  = [[ZLJPhotosVC alloc] initWithGroupInfo:grouInfo];
    firstPhotosVC.delegate =self.navigationController;
    [self.navigationController pushViewController:firstPhotosVC animated:YES];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdetify = @"mycell";
    ZLJGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetify];
    if (!cell) {
        cell = [[ZLJGroupCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdetify];
    }
    
    ZLJGroupInfo *groupInfo = _groupArray[indexPath.row];
    [cell setContentView:groupInfo];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ZLJGroupCell getCellHeight];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupArray.count;
}
@end
