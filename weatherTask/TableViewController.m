//
//  TableViewController.m
//  weatherTask
//
//  Created by Sibin on 14/07/17.
//  Copyright © 2017 Canisrigel. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define weatherUrl [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/group?id=1277333,4321929,1264527,1269843,1275339,1275004&units=metric&appid=ecda1a8c8d299768835071e59189ed27"]

#import <SDWebImage/UIImageView+WebCache.h>
#import "Reachability.h"
#import "TableViewController.h"
#import "CustomTableViewCell.h"
#import "ViewController.h"
@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    BOOL hasInternetConnection = [[Reachability reachabilityForInternetConnection] isReachable];
    if (hasInternetConnection) {
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL:
                            weatherUrl];
            [self performSelectorOnMainThread:@selector(fetchedData:)
                                   withObject:data waitUntilDone:YES];
        });
    }
    else{
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"No Internet Access"
                                     message:@"Please check your internet connection"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        exit(0);
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];    }
    
    
    
    self.cityName=[[NSMutableArray alloc]init];
    self.cityTemperature=[[NSMutableArray alloc]init];
    self.cityWeatherDescriptions=[[NSMutableArray alloc]init];
    self.cityIds=[[NSMutableArray alloc]init];
    self.cityMinTemp=[[NSMutableArray alloc]init];
    self.cityMaxTemp=[[NSMutableArray alloc]init];
    self.cityWeatherIcon=[[NSMutableArray alloc]init];
    self.cityDates=[[NSMutableArray alloc]init];
    
    
    UIImageView *bgImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    bgImage.image=[UIImage imageNamed:(@"bg_weather.jpg")];
    
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    
    
    self.tableView.backgroundView=bgImage;

    
    
}


- (void)fetchedData:(NSData *)responseData {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* weatherData = [json objectForKey:@"list"]; //2
    
    
    self.weatherList=weatherData;
    
    for (int i=0; i<self.weatherList.count; i++) {
        
        NSDictionary* weather = [weatherData objectAtIndex:i];
        
        
        NSString *epochDate=[weather valueForKey:@"dt"];
        NSTimeInterval seconds = [epochDate doubleValue];
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:seconds];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        
        
        NSString *stringFromDate = [formatter stringFromDate:date];
        
        NSArray *cityIdss=[weatherData valueForKey:@"id"];
        NSString *cityId=cityIdss[i];
        NSString *cityNmae=[weather valueForKey:@"name"];
        NSDictionary *temp=[weather valueForKey:@"main"];
        NSNumber *tempratuenum=[temp valueForKey:@"temp"];
        
        
        
        
        NSString *temprature = [[tempratuenum stringValue] substringToIndex:2] ;
        NSNumber *minTemp=[temp valueForKey:@"temp_min"];
        NSString *minimumTemp=[[minTemp stringValue] substringToIndex:2];
        NSNumber *maxTemp=[temp valueForKey:@"temp_max"];
        NSString *maximumTemp=[[maxTemp stringValue]  substringToIndex:2];
        
        NSDictionary *weatherdetail=[weather valueForKey:@"weather"];
        NSArray *weatherDescription=[weatherdetail valueForKey:@"main"];
        NSArray *weatherimgs=[weatherdetail valueForKey:@"icon"];
        
        NSString *weatherDescriptions=weatherDescription[0];
        NSString *weatherIcon=weatherimgs[0];
        
        
        
        
        
        
        [self.cityIds addObject:cityId];
        [self.cityName addObject:cityNmae];
        [self.cityTemperature addObject:temprature];
        [self.cityWeatherDescriptions addObject:weatherDescriptions];
        [self.cityMinTemp addObject:minimumTemp];
        [self.cityMaxTemp addObject:maximumTemp];
        [self.cityWeatherIcon addObject:weatherIcon];
        [self.cityDates addObject:stringFromDate];
    }
    
    
    [self.tableView reloadData];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.weatherList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    
    NSString *imgUrl=[NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",[self.cityWeatherIcon objectAtIndex:indexPath.row]];
    NSURL *img=[NSURL URLWithString:imgUrl];
    [cell.weatherImgView sd_setImageWithURL:img];
    cell.dateLabel.text=[self.cityDates objectAtIndex:indexPath.row];
    cell.cityNameLabel.text=[self.cityName objectAtIndex:indexPath.row];
    cell.cityTempLabel.text=[[self.cityTemperature objectAtIndex:indexPath.row] stringByAppendingString:@"°C"];;
    cell.cityWeatherLabel.text=[self.cityWeatherDescriptions objectAtIndex:indexPath.row];
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"segue"]) {
        
        ViewController *dvc=[segue destinationViewController];
        NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
        
        dvc.cityId=[self.cityIds objectAtIndex:indexPath.row];
        NSLog(@"new ids %@",[self.cityIds objectAtIndex:indexPath.row]);
        dvc.cityName=[self.cityName objectAtIndex:indexPath.row];
        dvc.firstTemp=[self.cityTemperature objectAtIndex:indexPath.row];
        
        dvc.firstMin=[self.cityMinTemp objectAtIndex:indexPath.row];
        dvc.firstMax=[self.cityMaxTemp objectAtIndex:indexPath.row];
        
        NSLog(@"new names %@",[self.cityName objectAtIndex:indexPath.row]);
        
        
    }
}

@end
