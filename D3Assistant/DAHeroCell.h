//
//  DAHeroCell.h
//  D3Assistant
//
//  Created by Artem Shimanski on 29.10.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAHeroCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadLabel;
@property (weak, nonatomic) IBOutlet UIImageView *deadImageView;
@property (strong, nonatomic) id object;
@end