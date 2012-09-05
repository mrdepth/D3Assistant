//
//  HeroCellView.h
//  D3Assistant
//
//  Created by Artem Shimanski on 05.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeroCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *frameImageView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameLabels;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *paragonLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadLabel;

@end
