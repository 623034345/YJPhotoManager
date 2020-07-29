# YJPhotoManager
一行代码实现系统相册功能
			
	#import "YJPhotoManager.h"
	
	[[YJPhotoManager shareInstance] showAlertWithController:self isClip:NO style:YJPhotoStyleDefualt completion:^(UIImage * _Nonnull image) {
	}];
