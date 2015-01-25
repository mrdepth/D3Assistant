//
//  DABrowserViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 19.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DAProfile;
@interface DABrowserViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) DAProfile* profile;

@end
