//
//  TableViewController.h
//  weatherTask
//
//  Created by Sibin on 14/07/17.
//  Copyright © 2017 Canisrigel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController
@property(nonnull,strong)NSMutableArray *weatherList;



@property(nonatomic,strong)NSMutableArray *cityName;
@property(nonatomic,strong)NSMutableArray *cityTemperature;
@property(nonatomic,strong)NSMutableArray *cityWeatherDescriptions;
@property(nonatomic,strong)NSMutableArray *cityWeatherIcon;

@property(nonatomic,strong)NSMutableArray *cityIds;
@property(nonatomic,strong)NSMutableArray *cityMinTemp;
@property(nonatomic,strong)NSMutableArray *cityMaxTemp;
@property(nonatomic,strong)NSMutableArray *cityDates;
@end
