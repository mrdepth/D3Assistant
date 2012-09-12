//
//  RuneInfoCellView.h
//  D3Assistant
//
//  Created by Artem Shimanski on 10.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RuneInfoCellView : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *runeImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *runeNameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *runeDescriptionLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *levelLabel;

@end
