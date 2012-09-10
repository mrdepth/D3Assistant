//
//  RuneInfoCellView.h
//  D3Assistant
//
//  Created by Artem Shimanski on 10.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RuneInfoCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *runeImageView;
@property (weak, nonatomic) IBOutlet UILabel *runeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *runeDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@end
