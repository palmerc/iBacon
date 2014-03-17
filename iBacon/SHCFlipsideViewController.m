//
//  SHCFlipsideViewController.m
//  iBacon
//
//  Created by Cameron Palmer on 23.11.13.
//  Copyright (c) 2013 ShortcutAS. All rights reserved.
//

#import "SHCFlipsideViewController.h"

@interface SHCFlipsideViewController ()

@end

@implementation SHCFlipsideViewController

- (void)awakeFromNib
{
    self.preferredContentSize = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
