//
//  HeroCellView.h
//  D3Assistant
//
//  Created by Artem Shimanski on 05.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeroCellView : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *frameImageView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *levelLabels;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *classLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *paragonLevelLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *deadLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *skullImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *hardcoreLabel;
@property (nonatomic, assign) BOOL hardcore;

@end
