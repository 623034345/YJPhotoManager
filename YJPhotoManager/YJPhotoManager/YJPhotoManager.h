//
//  YJPhotoManager.h
//  yuntaizixun
//
//  Created by 冯英杰 on 2020/5/20.
//  Copyright © 2020 FengYingJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface YJPhotoManager : NSObject

@property (nonatomic, assign) BOOL isClip;//是否剪切
@property (nonatomic, strong) void (^ _Nullable imageBlcok)(UIImage *image);

+(instancetype)shareInstance;

/// 弹出相册 相机 选择框
/// @param vc 当前界面的UIViewController
/// @param isClip 是否剪切
/// @param completion 选择的图片回调
- (void)showAlertWithController:(UIViewController *)vc isClip:(BOOL)isClip completion:(void (^) (UIImage *image))completion;

@end

NS_ASSUME_NONNULL_END
