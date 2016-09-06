//
//  ViewController.m
//  AlbumSelect
//
//  Created by dlt_zhanlijun on 16/9/5.
//  Copyright © 2016年 dlt_zhanlijun. All rights reserved.
//

#import "ViewController.h"
#import "ZLJImagePickerController.h"
@interface ViewController ()<ZLJImagePickerControllerVCDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)SlectImage:(id)sender {
    
    ZLJImagePickerController *imagePickerController =[ZLJImagePickerController imagePicker];
    imagePickerController.ZLJdelegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ZLJImagePickerControllerVCDelegate

-(void)ZLJImagePickerControllerDidFinshWithArray:(NSArray *)array
{
    if (array) {
        UIImage *image = array[0];
        _imageView.image = image;
    }
}
@end
