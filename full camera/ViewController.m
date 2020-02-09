//
//  ViewController.m
//  full camera
//
//  Created by van on 2020/2/9.
//  Copyright © 2020 van. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>//这个框架是选择媒体类型时需要用到的

@interface ViewController ()

@end

@implementation ViewController

UISwipeGestureRecognizer * recognizer;
UIImagePickerController * imagePickerVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)openCamera {
    // 实例化UIImagePickerController
    imagePickerVC = [[UIImagePickerController alloc] init];
    // 设置资源来源
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 设置可用的媒体类型、默认只包含kUTTypeImage，如果想选择视频，请添加kUTTypeMovie
    imagePickerVC.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage];
    // 设置代理，遵守UINavigationControllerDelegate, UIImagePickerControllerDelegate 协议
    imagePickerVC.delegate = self;
    // 是否允许编辑
    imagePickerVC.allowsEditing = YES;
    // 如果选择的是视屏，允许的视屏时长为20秒
    imagePickerVC.videoMaximumDuration = 20;
    // 允许的视屏质量（如果质量选取的质量过高，会自动降低质量）
    imagePickerVC.videoQuality = UIImagePickerControllerQualityTypeHigh;
    // 相机获取媒体的类型（照相、录制视屏）
    imagePickerVC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    // 使用前置还是后置摄像头
    imagePickerVC.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    // 是否开起闪光灯
    imagePickerVC.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    imagePickerVC.navigationBarHidden = YES;
    imagePickerVC.toolbarHidden = YES;
           imagePickerVC.showsCameraControls = NO;

    // 此属性可transform自定义界面
    // Device's screen size (ignoring rotation intentionally):
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

    // 调整缩放，铺满屏幕
    float cameraAspectRatio = 12.0 / 11.0;
    float oldHeight = floorf(screenSize.width * cameraAspectRatio);
    float scale = ceilf((screenSize.height / oldHeight) * 10.0) / 10.0;

    imagePickerVC.cameraViewTransform = CGAffineTransformMakeScale(scale, scale);
    // model出控制器
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}


- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer{
     if (!imagePickerVC){
         return;
     }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [UIView transitionWithView:imagePickerVC.view duration:1.0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            imagePickerVC.cameraDevice = UIImagePickerControllerCameraDeviceRear == imagePickerVC.cameraDevice ? UIImagePickerControllerCameraDeviceFront :  UIImagePickerControllerCameraDeviceRear;
        } completion:NULL];
    }
    
}

- (void)addGesture {
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    recognizer.delegate = self;
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [imagePickerVC.view addGestureRecognizer:recognizer];
}

- (void)viewDidAppear:(BOOL)animated{
    [self openCamera];
    [self addGesture];
}


@end

