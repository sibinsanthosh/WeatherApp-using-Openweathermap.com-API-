//
//  CustomTableViewCell.h
//  weatherTask
//
//  Created by Sibin on 14/07/17.
//  Copyright © 2017 Canisrigel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cityNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *cityTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityWeatherLabel;
@property (strong, nonatomic) IBOutlet UIImageView *weatherImgView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;


@end
