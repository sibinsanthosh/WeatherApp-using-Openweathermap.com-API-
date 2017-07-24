//
//  ViewController.h
//  weatherTask
//
//  Created by Sibin on 14/07/17.
//  Copyright © 2017 Canisrigel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *cityNameLabel;

@property(nonatomic,strong)NSString *cityId;
@property(nonatomic,strong)NSString *cityName;


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *today;
@property (strong, nonatomic) IBOutlet UILabel *minMaxLabel;



@property(nonnull,strong)NSMutableArray *weatherList;

@property (strong, nonatomic) IBOutlet UILabel *firstTemLabel;


@property(nonatomic,strong)NSString *firstMin;
@property(nonatomic,strong)NSString *firstMax;




@property(nonatomic,strong)NSString *firstTemp;
@property(nonnull,strong)NSMutableArray *cityTemperature;
@property(nonnull,strong)NSMutableArray *cityWeatherDescriptions;
@property(nonnull,strong)NSMutableArray *cityIds;
@property(nonnull,strong)NSMutableArray *cityMinTemp;
@property(nonnull,strong)NSMutableArray *cityMaxTemp;
@property(nonnull,strong)NSMutableArray *cityDate;



@end

