//
//  SHCMainViewController.m
//  iBacon
//
//  Created by Cameron Palmer on 23.11.13.
//  Copyright (c) 2013 ShortcutAS. All rights reserved.
//

#import "SHCMainViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <EstimoteSDK/ESTBeacon.h>
#import <EstimoteSDK/ESTBeaconManager.h>
#import "SHCBeaconTableViewCell.h"

static NSString *const kEstimoteUUIDString = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
static NSString *const kBeaconTableViewCellReuseIdentifier = @"BeaconTableViewCellReuseIdentifier";


@interface SHCMainViewController () <ESTBeaconManagerDelegate>
@property (strong, nonatomic) ESTBeaconManager *beaconManager;
@property (assign, nonatomic, getter = isInsideRegion) BOOL insideRegion;
@property (strong, nonatomic) NSArray *beacons;

@end



@implementation SHCMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create a location manager
    ESTBeaconManager *beaconManager = [[ESTBeaconManager alloc] init];
    beaconManager.delegate = self;
    
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initRegionWithIdentifier:@"Shortcut"];
    [self.beaconManager startRangingBeaconsInRegion:region];
}

- (NSDictionary *)estimotes
{
    return @{@"40529:23004" : @"Icy Marshmellow",
             @"25515:57657" : @"Mint Cocktail",
             @"23037:18575" : @"Blueberry Pie"};
}

- (NSString *)stringFromBeacon:(CLBeacon *)beacon
{
    return [NSString stringWithFormat:@"%@:%@", [beacon major], [beacon minor]];
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.beacons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLBeacon *beacon = [self.beacons objectAtIndex:indexPath.row];
    SHCBeaconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBeaconTableViewCellReuseIdentifier];
    cell.titleLabel.text = [[self estimotes] objectForKey:[self stringFromBeacon:beacon]];
    NSString *proximityString = nil;
    CLProximity proximity = [beacon proximity];
    CLLocationAccuracy accuracy = [beacon accuracy];
    NSInteger rssi = [beacon rssi];
    
    switch (proximity) {
        case CLProximityUnknown:
            proximityString = @"Unknown";
            break;
        case CLProximityImmediate:
            proximityString = @"Immediate";
            break;
        case CLProximityNear:
            proximityString = @"Near";
            break;
        case CLProximityFar:
            proximityString = @"Far";
            break;
        default:
            break;
    }
    
    cell.rssiLabel.text = [NSString stringWithFormat:@"Proximity: %@,\nAccuracy: %f,\nRSSI: %ld", proximityString, accuracy, (long)rssi];

    return cell;
}



#pragma mark -

- (void)sendEnterLocalNotification
{
    if (!self.isInsideRegion) {
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        NSString *time = [dateFormatter stringFromDate:date];
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [NSString stringWithFormat:@"Enter: %@", time];
        localNotification.alertAction = nil;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    self.insideRegion = YES;
}

- (void)sendExitLocalNotification
{
    if (self.isInsideRegion) {
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        NSString *time = [dateFormatter stringFromDate:date];
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [NSString stringWithFormat:@"Exit: %@", time];
        localNotification.alertAction = nil;
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    self.insideRegion = NO;
}

- (void)updateUIForState:(CLRegionState)state
{
    if (state == CLRegionStateInside) {
        NSLog(@"Inside");
    } else if (state == CLRegionStateOutside) {
        NSLog(@"Outside");
    } else {
        NSLog(@"Unknown");
    }
}



#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // always update UI
    [self updateUIForState:state];
    
    switch (state) {
        case CLRegionStateInside:
            [self sendEnterLocalNotification];
            
            break;
        case CLRegionStateOutside:
            [self sendExitLocalNotification];

            break;
        case CLRegionStateUnknown:
            
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
   
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    self.beacons = [beacons sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CLBeacon *beacon1 = obj1;
        CLBeacon *beacon2 = obj2;
        
        NSComparisonResult majorComparison = [beacon1.major compare:beacon2.major];
        if (majorComparison != NSOrderedSame) {
            return majorComparison;
        } else {
            return [beacon1.minor compare:beacon2.minor];
        }
    }];
    
    [self.tableView reloadData];
}

@end
