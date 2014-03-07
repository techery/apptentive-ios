//
//  ATInteractionUpgradeMessageViewController.h
//  ApptentiveConnect
//
//  Created by Peter Kamb on 10/16/13.
//  Copyright (c) 2013 Apptentive, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATInteraction;

NSString *const ATInteractionUpgradeMessageLaunch;
NSString *const ATInteractionUpgradeMessageClose;

@interface ATInteractionUpgradeMessageViewController : UIViewController {
	UIViewController *presentingViewController;
	@private
	UIWindow *originalPresentingWindow;
	
	// Used when handling view rotation.
	CGRect lastSeenPresentingViewControllerFrame;
	CGAffineTransform lastSeenPresentingViewControllerTransform;
}

@property (nonatomic, strong) ATInteraction *upgradeMessageInteraction;

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet UIView *alertView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *appIconContainer;
@property (nonatomic, strong) IBOutlet UIImageView *appIconView;
@property (nonatomic, strong) IBOutlet UIImageView *appIconBackgroundView;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIView *okButtonBackgroundView;
@property (nonatomic, strong) IBOutlet UIView *poweredByBackground;
@property (strong, nonatomic) IBOutlet UILabel *poweredByApptentiveLogo;
@property (nonatomic, strong) IBOutlet UIImageView *poweredByApptentiveIconView;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;

- (id)initWithInteraction:(ATInteraction *)interaction;

- (IBAction)okButtonPressed:(id)sender;
- (void)applyRoundedCorners;
- (UIImage *)blurredBackgroundScreenshot;

- (void)presentFromViewController:(UIViewController *)newPresentingViewController animated:(BOOL)animated;

@end
