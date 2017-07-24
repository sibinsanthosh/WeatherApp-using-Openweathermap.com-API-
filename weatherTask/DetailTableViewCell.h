//
//  DetailTableViewCell.h
//  weatherTask
//
//  Created by Sibin on 14/07/17.
//  Copyright © 2017 Canisrigel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *tempLabel;
@property (strong, nonatomic) IBOutlet UILabel *minTempLabel;
@property (strong, nonatomic) IBOutlet UIImageView *weatherIconImgView;
@property (strong, nonatomic) IBOutlet UILabel *maxTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *weatherLabel;

@end
