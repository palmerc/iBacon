//
//  SHCBeaconTableViewCell.h
//  iBacon
//
//  Created by Cameron Palmer on 23.11.13.
//  Copyright (c) 2013 ShortcutAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHCBeaconTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;

@end
