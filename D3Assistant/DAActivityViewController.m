	//
//  DAActivityViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 18.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import "DAActivityViewController.h"

@interface DAActivityViewController ()

@end

@implementation DAActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.progress = [[NSProgress alloc] init];
	[self.progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
	self.view.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"fractionCompleted"]) {
		if (self.progress.fractionCompleted >= 1.0)
			self.view.hidden = YES;
		else
			self.view.hidden = NO;
	}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
