//
//  ATInteractionRatingDialogController.m
//  ApptentiveConnect
//
//  Created by Peter Kamb on 3/3/14.
//  Copyright (c) 2014 Apptentive, Inc. All rights reserved.
//

#import "ATInteractionRatingDialogController.h"
#import "ATInteraction.h"
#import "ATBackend.h"
#import "ATConnect_Private.h"
#import "ATAppRatingMetrics.h"
#import "ATUtilities.h"
#import "ATEngagementBackend.h"

// TODO: Remove, soon. All info should come from interaction's configuration.
#import "ATAppRatingFlow.h"

NSString *const ATInteractionRatingDialogEventLabelLaunch = @"launch";
NSString *const ATInteractionRatingDialogEventLabelCancel = @"cancel";
NSString *const ATInteractionRatingDialogEventLabelRate = @"rate";
NSString *const ATInteractionRatingDialogEventLabelRemind = @"remind";
NSString *const ATInteractionRatingDialogEventLabelDecline = @"decline";

@implementation ATInteractionRatingDialogController

- (id)initWithInteraction:(ATInteraction *)interaction {
	NSAssert([interaction.type isEqualToString:@"RatingDialog"], @"Attempted to load a Rating Dialog with an interaction of type: %@", interaction.type);
	self = [super init];
	if (self != nil) {
		_interaction = [interaction copy];
	}
	return self;
}

- (void)showRatingDialogFromViewController:(UIViewController *)viewController {
	[self retain];
	
	self.viewController = viewController;
	
	NSDictionary *config = self.interaction.configuration;

	NSString *title = config[@"title"] ?: ATLocalizedString(@"Thank You", @"Rate app title.");
	NSString *message = config[@"body"] ?: [NSString stringWithFormat:ATLocalizedString(@"We're so happy to hear that you love %@! It'd be really helpful if you rated us. Thanks so much for spending some time with us.", @"Rate app message. Parameter is app name."), [[ATBackend sharedBackend] appName]];
	NSString *rateAppTitle = config[@"rate_text"] ?: [NSString stringWithFormat:ATLocalizedString(@"Rate %@", @"Rate app button title"), [[ATBackend sharedBackend] appName]];
	NSString *noThanksTitle = config[@"no_text"] ?: ATLocalizedString(@"No Thanks", @"cancel title for app rating dialog");
	NSString *remindMeTitle = config[@"remind_text"] ?: ATLocalizedString(@"Remind Me Later", @"Remind me later button title");
	
	if (!self.ratingDialog) {
		self.ratingDialog = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:noThanksTitle otherButtonTitles:rateAppTitle, remindMeTitle, nil];
		[self.ratingDialog show];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:ATAppRatingDidPromptForRatingNotification object:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView == self.ratingDialog) {
				
		if (buttonIndex == 1) { // rate
			[self postNotification:ATAppRatingDidClickRatingButtonNotification forButton:ATAppRatingButtonTypeRateApp];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:ATAppRatingFlowUserAgreedToRateAppNotification object:nil];
			
			[self engageEvent:ATInteractionRatingDialogEventLabelRate];
			
		} else if (buttonIndex == 2) { // remind later
			[self postNotification:ATAppRatingDidClickRatingButtonNotification forButton:ATAppRatingButtonTypeRemind];
			
			[self engageEvent:ATInteractionRatingDialogEventLabelRemind];
		} else if (buttonIndex == 0) { // no thanks
			[self postNotification:ATAppRatingDidClickRatingButtonNotification forButton:ATAppRatingButtonTypeNo];
			
			[self engageEvent:ATInteractionRatingDialogEventLabelDecline];
		}
		
		[self release];
	}
}

- (void)postNotification:(NSString *)name forButton:(ATAppRatingButtonType)button {
	NSDictionary *userInfo = @{ATAppRatingButtonTypeKey: @(button)};
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:userInfo];
}

- (BOOL)engageEvent:(NSString *)eventLabel {
	return [[ATEngagementBackend sharedBackend] engageApptentiveEvent:eventLabel fromInteraction:self.interaction.type fromViewController:self.viewController];
}

- (void)dealloc {
	[_interaction release], _interaction = nil;
	[_ratingDialog release], _ratingDialog = nil;
	[_viewController release], _viewController = nil;
	
	[super dealloc];
}

@end