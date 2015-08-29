//
//  SVMTabController.m
//  SVMDrawerTabbar
//
//  Created by staticVoidMan on 29/08/15.
//  Copyright (c) 2015 svmLogics. All rights reserved.
//

#import "SVMTabController.h"
#import "SVMDrawerTabbarViewController.h"

@interface SVMTabController ()
{
	SVMTabIndex svmTabIndex_Current;
	SVMTabIndex svmTabIndex_Previous;
}
@end

@implementation SVMTabController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	[self loadTab:eSVMTabIndex_First];
}

-(void)loadTab:(SVMTabIndex)svmTabIndex {
	if (svmTabIndex != svmTabIndex_Current) {
		svmTabIndex_Previous = svmTabIndex_Current;
		svmTabIndex_Current = svmTabIndex;
	}	
	
	switch (svmTabIndex) {
		case eSVMTabIndex_First: {
			[self performSegueWithIdentifier:@"tabSVMFirstViewController"
									  sender:nil];
			break;
		}
		case eSVMTabIndex_Second: {
			[self performSegueWithIdentifier:@"tabSVMSecondViewController"
									  sender:nil];
			break;
		}
		case eSVMTabIndex_Third: {
			[self performSegueWithIdentifier:@"tabSVMThirdViewController"
									  sender:nil];
			break;
		}
	}
	
	[SVMDrawerTabbarViewController hideDrawerAnimated:YES];
}

#pragma mark - Storyboard Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	UIViewController *existingVC;
	for (UIViewController *currentVC in self.childViewControllers) {
		if ([currentVC.restorationIdentifier isEqualToString:((UIViewController *)segue.destinationViewController).restorationIdentifier]) {
			existingVC = currentVC;
		}
		
		if([currentVC.view isDescendantOfView:self.view]) {
			NSLog(@"Removing Existing: %@",currentVC.restorationIdentifier);
			[currentVC.view removeFromSuperview];
		}
	}
	
	if (existingVC) {
		NSLog(@"Loading Existing: %@", existingVC.restorationIdentifier);
		[self.view addSubview:existingVC.view];
		[existingVC didMoveToParentViewController:self];
	}
	else {
		NSLog(@"Creating New: %@",((UIViewController *)segue.destinationViewController).restorationIdentifier);
		[self addChildViewController:segue.destinationViewController];
		[self.view addSubview:((UIViewController *)segue.destinationViewController).view];
		[segue.destinationViewController didMoveToParentViewController:self];
		[((UIViewController *)segue.destinationViewController).view setFrame:self.view.bounds];
	}
}

@end
