//
//  SHCFlipsideViewController.h
//  iBacon
//
//  Created by Cameron Palmer on 23.11.13.
//  Copyright (c) 2013 ShortcutAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHCFlipsideViewController;

@protocol SHCFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(SHCFlipsideViewController *)controller;
@end

@interface SHCFlipsideViewController : UIViewController

@property (weak, nonatomic) id <SHCFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
