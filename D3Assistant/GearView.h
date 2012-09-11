//
//  GearView.h
//  D3Assistant
//
//  Created by mr_depth on 06.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GearView;
@protocol GearViewDelegate <NSObject>

- (void) didSelectGearView:(GearView*) gearView;

@end

@interface GearView : UIView
@property (nonatomic, assign) IBOutlet id<GearViewDelegate> delegate;
@property (nonatomic, strong) NSDictionary* gear;
@property (nonatomic, strong) NSString* slot;

@end
