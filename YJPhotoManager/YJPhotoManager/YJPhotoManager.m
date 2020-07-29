//
//  YJPhotoManager.m
//  yuntaizixun
//
//  Created by 冯英杰 on 2020/5/20.
//  Copyright © 2020 FengYingJie. All rights reserved.
//

#import "YJPhotoManager.h"
#import <Photos/Photos.h>
@interface YJPhotoManager()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIViewController *viewController;
@property (strong, nonatomic) UIImagePickerController *picker;


@end
@implementation YJPhotoManager
static YJPhotoManager *instance = nil;

+(instancetype)shareInstance
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[self alloc] init];
	});
	return instance;
}



/// 弹出相册 相机 选择框
/// @param vc 当前界面的UIViewController
/// @param isClip 是否剪切
/// @param style 可选择相册相机 单选或多选
/// @param completion 选择的图片回调
- (void)showAlertWithController:(UIViewController *)vc isClip:(BOOL)isClip style:(YJPhotoStyle)style completion:(void (^) (UIImage *image))completion
{
	self.isClip = isClip;
	self.imageBlcok = completion;
	_viewController = vc;
	switch (style) {
		case YJPhotoStyleDefualt:
	  {
		MJWeakSelf
		UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[weakSelf openLibray];
		}];
		UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[weakSelf openCamera];
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
			weakSelf.imageBlcok = nil;
		}];
		
		[self _alertActionShowWithActionArr:@[cameraAction,photoLibraryAction,cancelAction] style:UIAlertControllerStyleActionSheet title:@"提醒" message:@"请选择" viewController:vc];
	  }
			break;
		case YJPhotoStyleCamera:
	  {
		[self openCamera];
	  }
			break;
		case YJPhotoStyleLibray:
	  {
		[self openLibray];
	  }
			
		default:
			break;
	}
	
}
//打开相册
- (void)openLibray
{
	if (![self explicitlyInvalidAccessAuthForPhoto])
	  {
		self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		if (_isClip)
		{
		  self.picker.allowsEditing = YES;
		}
		else
		  {
			self.picker.allowsEditing = NO;
		  }
		[_viewController presentViewController:self.picker animated:YES completion:nil];
		
	  }
}
//打开相机
- (void)openCamera
{
	if (![self explicitlyInvalidAccessAuthForCapture])
	  {
		self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		if (_isClip)
		  {
			self.picker.allowsEditing = YES;
		  }
		
		else
		  {
			self.picker.allowsEditing = NO;
		  }
		[_viewController presentViewController:self.picker animated:YES completion:nil];
		
	  }
}
#pragma mark - UIImagePickerControllerDelegate 相册
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    获取图片
	if (_isClip)
	{
		UIImage *image = info[UIImagePickerControllerEditedImage];
	  !_imageBlcok?:_imageBlcok(image);

	}
	else
	  {
		UIImage *image = info[UIImagePickerControllerOriginalImage];
		!_imageBlcok?:_imageBlcok(image);
	  }
//    获取图片后返回
    [picker dismissViewControllerAnimated:YES completion:nil];
	self.imageBlcok = nil;
}

//按取消按钮时候的功能
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    返回
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImagePickerController *)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
		_picker.delegate = self;
		_picker.modalPresentationStyle = UIModalPresentationFullScreen;
		
    }
    return _picker;
}
#pragma mark - 一、判断是否有权限访问相册。

/**

 * @desc  判断是否为明确无效的访问权限 for 系统相册。

 */

- (BOOL)explicitlyInvalidAccessAuthForPhoto
{

    /**

     *  PHAuthorizationStatusNotDetermined  （默认）用户还没做出选择。

     *  PHAuthorizationStatusRestricted  此应用程序没有被授权访问的照片数据。

     *  PHAuthorizationStatusDenied  用户已经明确否认了照片数据的应用程序访问。

     *  PHAuthorizationStatusAuthorized  用户已经授权应用访问照片数据。

     */

    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];

    if (PHAuthorizationStatusRestricted == status

        ||PHAuthorizationStatusDenied == status)  {
		[self openAppSysSettingWithMsg:@"请您先允许App访问照片。\n是否现在前往设置？"];

        return YES;//无权限。可以弹出提示：请您先允许App访问照片。\n是否现在前往设置？

    }

    return NO;

}


#pragma mark - 二、判断是否有权限访问相机。

/**

 * @desc  判断是否为明确无效的访问权限 for 系统相机。

 */

- (BOOL)explicitlyInvalidAccessAuthForCapture
{

    /**

     *  AVAuthorizationStatusNotDetermined  （默认）用户还没做出选择。

     *  AVAuthorizationStatusRestricted  此应用程序没有被授权访问。

     *  AVAuthorizationStatusDenied  用户已经明确否认应用程序访问。

     *  AVAuthorizationStatusAuthorized  用户已经授权应用程序访问。

     */

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (AVAuthorizationStatusRestricted == authStatus

        ||AVAuthorizationStatusDenied == authStatus) {

		[self openAppSysSettingWithMsg:@"请您先允许App访问相机。\n是否现在前往设置？"];
        return YES;//无权限。可以弹出提示：请您先允许App访问相机。\n是否现在前往设置？

    }

    return NO;

}



#pragma mark -三、打开App对应的系统设置界面。

/**

 * @desc  打开App对应的系统设置界面。

 *@param  msg 如：@"请您先允许App访问相机。\n是否现在前往设置？"

 */

- (void)openAppSysSettingWithMsg:(NSString*)msg
{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *actionForCancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:NULL];

    [alert addAction:actionForCancel];

    UIAlertAction *actionForOther = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }];

    [alert addAction:actionForOther];

    [_viewController presentViewController:alert animated:YES completion:nil];

}
@end
