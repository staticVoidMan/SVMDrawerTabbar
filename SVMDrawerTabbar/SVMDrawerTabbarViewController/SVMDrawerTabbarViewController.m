//
//  SVMDrawerTabbarViewController.m
//  SVMDrawerTabbar
//
//  Created by staticVoidMan on 29/08/15.
//  Copyright (c) 2015 svmLogics. All rights reserved.
//

#import "SVMDrawerTabbarViewController.h"
#import "SVMCommon.h"

#import "SVMTabController.h"

#import "SVMDrawerCell.h"

@interface SVMDrawerTabbarViewController ()<UITabBarDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
	SVMTabController *svmTabController;
	
	IBOutlet UIView *vwContainer_Right;
	IBOutlet UIView *vwContainer_SVMTabController;
	IBOutlet UIView *vwOverlay;
	IBOutlet UIVisualEffectView *vwBlur;
	IBOutlet UITabBar *tabBar;
	
	IBOutlet UIView *vwStatusBar;
	
	IBOutlet UIView *vwContainer_Drawer;
	IBOutlet UITableView *tvDrawer;
	
	IBOutlet NSLayoutConstraint *constraintLeft_vwContainer_SVMTabController;
	
	IBOutlet UITapGestureRecognizer *gesTap_vwOverlay;
	UIScreenEdgePanGestureRecognizer *gesEdgePan_Left;
	UIScreenEdgePanGestureRecognizer *gesEdgePan_Right;
	
	BOOL isAnimating_Drawer;
	BOOL isDrawerShown;
	
	NSMutableArray *arrDrawer;
}
@end

@implementation SVMDrawerTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(showDrawer:)
												 name:kSVM_NOTIFICATION_DRAWER_SHOW
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(hideDrawer:)
												 name:kSVM_NOTIFICATION_DRAWER_HIDE
											   object:nil];
	
	[self initialSettings];
	[self createDrawerDataSource];
	[self createShowDrawerSwipeGesture];
	[self createHideDrawerSwipeGesture];
}

-(void)initialSettings {
	constraintLeft_vwContainer_SVMTabController.constant = -ceil([[UIScreen mainScreen] bounds].size.width * 0.618);
	
	[vwOverlay setAlpha:0.0f];
	[vwContainer_Right bringSubviewToFront:vwOverlay];
}

-(void)createDrawerDataSource {
	arrDrawer = [[NSMutableArray alloc] init];
	[arrDrawer addObject:[@{@"title"	:@"SVMThirdVC"
							,@"image"	:@""
							,@"badge"	:@(1)
							} mutableCopy]];
}

-(void)createShowDrawerSwipeGesture {
	gesEdgePan_Left = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
																		action:@selector(gesEdgePan_Left_Act:)];
	[gesEdgePan_Left setEdges:UIRectEdgeLeft];
	[gesEdgePan_Left setDelegate:self];
	
	[self.view addGestureRecognizer:gesEdgePan_Left];
}

-(void)createHideDrawerSwipeGesture {
	gesEdgePan_Right = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
																		 action:@selector(gesEdgePan_Right_Act:)];
	[gesEdgePan_Right setEdges:UIRectEdgeRight];
	[gesEdgePan_Right setDelegate:self];
	
	[self.view addGestureRecognizer:gesEdgePan_Right];
}


#pragma mark - Gesture Methods
-(IBAction)gesTap_vwOverlay_Act:(UITapGestureRecognizer *)sender {
	[SVMDrawerTabbarViewController hideDrawerAnimated:YES];
}

-(void)gesEdgePan_Left_Act:(UIScreenEdgePanGestureRecognizer *)sender {
	[SVMDrawerTabbarViewController showDrawerAnimated:YES];
}

-(void)gesEdgePan_Right_Act:(UIScreenEdgePanGestureRecognizer *)sender {
	[SVMDrawerTabbarViewController hideDrawerAnimated:YES];
}

#pragma mark - Drawer Related Methods
#pragma mark Exposed Methods
+(void)showDrawerAnimated:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] postNotificationName:kSVM_NOTIFICATION_DRAWER_SHOW
														object:nil
													  userInfo:@{@"animated":@(animated)}];
}

+(void)hideDrawerAnimated:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] postNotificationName:kSVM_NOTIFICATION_DRAWER_HIDE
														object:nil
													  userInfo:@{@"animated":@(animated)}];
}

#pragma mark Notification Handlers
-(void)showDrawer:(NSNotification *)notification {
	if (isDrawerShown == YES) {
		return;
	}
	
	BOOL animated = notification.userInfo[@"animated"];
	CGFloat speed = 0;
	if (animated) {
		speed = kSVM_Animation_Speed;
	}
	
	if (isAnimating_Drawer == NO) {
		isAnimating_Drawer = YES;
		
		constraintLeft_vwContainer_SVMTabController.constant = 0;
		[UIView animateWithDuration:speed
						 animations:^{
							 [vwContainer_Drawer setAlpha:1.0f];
							 [vwOverlay setAlpha:0.6f];
							 [self.view layoutIfNeeded];
						 }
						 completion:^(BOOL finished) {
							 isAnimating_Drawer = NO;
							 isDrawerShown = YES;
						 }];
	}
}

-(void)hideDrawer:(NSNotification *)notification {
	if (isDrawerShown == NO) {
		return;
	}
	
	BOOL animated = notification.userInfo[@"animated"];
	CGFloat speed = 0;
	if (animated) {
		speed = kSVM_Animation_Speed;
	}
	
	if (isAnimating_Drawer == NO) {
		isAnimating_Drawer = YES;
		
		constraintLeft_vwContainer_SVMTabController.constant = -ceil([[UIScreen mainScreen] bounds].size.width * 0.618);
		[UIView animateWithDuration:speed
						 animations:^{
							 [vwContainer_Drawer setAlpha:0.3f];
							 [vwOverlay setAlpha:0.0f];
							 [self.view layoutIfNeeded];
						 }
						 completion:^(BOOL finished) {
							 isAnimating_Drawer = NO;
							 isDrawerShown = NO;
						 }];
	}
}

#pragma mark - Storyboard Methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embedSVMTabController"]) {
		svmTabController = segue.destinationViewController;
		[tabBar setSelectedItem:tabBar.items[0]];
	}
}

#pragma mark - UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return arrDrawer.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	SVMDrawerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SVMDrawerCell_Title"];
	
	[cell.lblTitle setText:arrDrawer[indexPath.row][@"title"]];
	
	return cell;
}

#pragma mark - UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 0: {
			[svmTabController loadTab:eSVMTabIndex_Third];
			break;
		}
	}
	
	[tabBar setSelectedItem:nil];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITabbar Delegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	switch (item.tag) {
		case 0: {
			[svmTabController loadTab:eSVMTabIndex_First];
			break;
		}
		case 1: {
			[svmTabController loadTab:eSVMTabIndex_Second];
			break;
		}
	}
}
@end
