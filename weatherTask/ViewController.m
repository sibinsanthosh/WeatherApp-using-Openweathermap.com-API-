//
//  ViewController.m
//  weatherTask
//
//  Created by Sibin on 14/07/17.
//  Copyright © 2017 Canisrigel. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#import <SDWebImage/UIImageView+WebCache.h>
#import "ViewController.h"
#import "DetailTableViewCell.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.cityTemperature=[[NSMutableArray alloc]init];
    self.cityWeatherDescriptions=[[NSMutableArray alloc]init];
    self.cityMinTemp=[[NSMutableArray alloc]init];
    self.cityMaxTemp=[[NSMutableArray alloc]init];
    self.cityDate=[[NSMutableArray alloc]init];
    
    self.tableView.delegate=self;
    
    
    UIImageView *bgImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    bgImage.image=[UIImage imageNamed:(@"bg_weather.jpg")];
    
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    
    self.tableView.backgroundView=bgImage;
    
    NSString * LongText=[NSString stringWithFormat: @"Min:%@°C Max:%@°C",self.firstMin,self.firstMax ];
    
    self.minMaxLabel.text=LongText;
    
    
    
    self.cityNameLabel.text=self.cityName;
    self.firstTemLabel.text=[self.firstTemp stringByAppendingString:@"°C"];
    
    NSString *currentUrl=[NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/forecast/daily?id=%@&APPID=ecda1a8c8d299768835071e59189ed27", self.cityId];
    
    NSURL *weatherUrl=[NSURL URLWithString:currentUrl];
    
    NSLog(@"id:%@",self.cityId);
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        weatherUrl];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
    
    
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* weatherData = [json objectForKey:@"list"]; //2
    
    NSLog(@"weather: %@", weatherData); //3
    
    self.weatherList=weatherData;
    
    for (int i=1; i<=6; i++) {
        
        NSDictionary* weather = [weatherData objectAtIndex:i];
        NSString *epochDate=[weather valueForKey:@"dt"];
        NSTimeInterval seconds = [epochDate doubleValue];
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:seconds];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [formatter setDateFormat:@"EEE"];
        
        
        NSString *stringFromDate = [formatter stringFromDate:date];
        NSDictionary *tempValues= [weather valueForKey:@"temp"];
        NSNumber *tempratuenum=[tempValues valueForKey:@"day"];
        NSNumber *tempraturec=[NSNumber numberWithFloat:([tempratuenum floatValue]-273.15)];
        
        NSString *temprature = [[tempraturec stringValue]  substringToIndex:2] ;
        NSNumber *minnTemp=[tempValues valueForKey:@"min"];
        
        NSNumber *minTemp=[NSNumber numberWithFloat:([minnTemp floatValue]-273.15)];
        
        NSString *minimumTemp=[[minTemp stringValue]  substringToIndex:2];
        
        NSNumber *maxxTemp=[tempValues valueForKey:@"max"];
        NSNumber *maxTemp=[NSNumber numberWithFloat:([maxxTemp floatValue]-273.15)];
        NSString *maximumTemp=[[maxTemp stringValue]  substringToIndex:2];
        
        NSDictionary *weatherdetail=[weather valueForKey:@"weather"];
        NSArray *weatherDescription=[weatherdetail valueForKey:@"icon"];
        NSString *weatherDescriptions=weatherDescription[0];
        
        
        
        
        
        [self.cityTemperature addObject:temprature];
        [self.cityWeatherDescriptions addObject:weatherDescriptions];
        [self.cityMinTemp addObject:minimumTemp];
        [self.cityMaxTemp addObject:maximumTemp];
        [self.cityDate addObject:stringFromDate];
        
        
    }
    
    [self.tableView reloadData];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cityTemperature.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellB" forIndexPath:indexPath];
    
    cell.dateLabel.text=[self.cityDate objectAtIndex:indexPath.row];
    
    NSString * LongText=[NSString stringWithFormat: @"Min:%@°C Max:%@°C",[self.cityMinTemp objectAtIndex:indexPath.row],[self.cityMaxTemp objectAtIndex:indexPath.row] ];
    
    
    NSString *imgUrl=[NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",[self.cityWeatherDescriptions objectAtIndex:indexPath.row]];
    NSURL *img=[NSURL URLWithString:imgUrl];
    [cell.weatherIconImgView sd_setImageWithURL:img];
    
    
    
    
    cell.minTempLabel.text=LongText;
    cell.maxTempLabel.text=[[self.cityMaxTemp objectAtIndex:indexPath.row] stringByAppendingString:@"°C"];;
    cell.tempLabel.text=[[self.cityTemperature objectAtIndex:indexPath.row] stringByAppendingString:@"°C"];
    cell.weatherLabel.text=[self.cityWeatherDescriptions objectAtIndex:indexPath.row];
    return cell;
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
