//
//  DAHeroGearViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 18.12.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAGearView.h"

@class DAHero;
@interface DAHeroGearViewController : UIViewController
@property (strong, nonatomic) IBOutletCollection(DAGearView) NSArray *gearViews;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) DAHero* hero;

- (IBAction)onItemInfo:(id)sender;
@end
