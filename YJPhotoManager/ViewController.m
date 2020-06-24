//
//  ViewController.m
//  YJPhotoManager
//
//  Created by 冯英杰 on 2020/6/23.
//  Copyright © 2020 洞中风情. All rights reserved.
//

#import "ViewController.h"
#import "YJPhotoManager.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (IBAction)choosePhoto:(id)sender {
	__weak typeof(self) weakSelf = self;

	[[YJPhotoManager shareInstance] showAlertWithController:self isClip:YES completion:^(UIImage * _Nonnull image) {
		weakSelf.mainImageView.image = image;
	}];
}


@end
