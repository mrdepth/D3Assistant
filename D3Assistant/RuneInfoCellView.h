//
//  RuneInfoCellView.h
//  D3Assistant
//
//  Created by Artem Shimanski on 10.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RuneInfoCellView : UITableViewCell
@property (assign, nonatomic) IBOutlet UIImageView *runeImageView;
@property (assign, nonatomic) IBOutlet UILabel *runeNameLabel;
@property (assign, nonatomic) IBOutlet UILabel *runeDescriptionLabel;
@property (assign, nonatomic) IBOutlet UILabel *levelLabel;

@end
