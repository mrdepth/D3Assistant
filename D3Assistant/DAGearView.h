//
//  DAGearView.h
//  D3Assistant
//
//  Created by Artem Shimanski on 18.12.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DAGear;
@interface DAGearView : UIButton
@property (weak, nonatomic) IBOutlet UIImageView *itemColorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIImageView *socketBackgroundImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *socketBackgroundImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *socketBackgroundImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *socketImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *socketImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *socketImageView3;
@property (nonatomic, strong, readonly) NSString* slot;
@property (nonatomic, strong) DAGear* gear;

@end
