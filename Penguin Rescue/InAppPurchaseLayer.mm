//
//  InAppPurchaseLayer.mm
//  Penguin Rescue
//
//  Created by Stephen Johnson on 10/15/12.
//  Copyright Conquer LLC 2012. All rights reserved.
//


// Import the interfaces
#import "InAppPurchaseLayer.h"
#import "MainMenuLayer.h"
#import "GameLayer.h"
#import "AppDelegate.h"
#import "SettingsManager.h"
#import "SimpleAudioEngine.h"
#import "Utilities.h"
#import "Analytics.h"

#pragma mark - InAppPurchaseLayer

@implementation InAppPurchaseLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	InAppPurchaseLayer *layer = [InAppPurchaseLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//
-(id) init
{
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;

		// ask director for the window size
		CGSize winSize = [[CCDirector sharedDirector] winSize];

		[LevelHelperLoader dontStretchArt];

		//create a LevelHelperLoader object - we use an empty level
		_levelLoader = [[LevelHelperLoader alloc] initWithContentOfFile:[NSString stringWithFormat:@"Levels/%@/%@", @"Menu", @"About"]];
		
		
		
		
		//TODO: fill this bad boy out with:
			/*
			Rate App
			Email us
			About the App
			About Conquer
			Version
			*/
		CCLabelTTF* TODOLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"TODO: Add an IAP page"] fontName:@"Helvetica" fontSize:48*SCALING_FACTOR_FONTS];
		TODOLabel.color = ccWHITE;
		TODOLabel.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:TODOLabel];
			
			
		
		
		
		
		
				
		LHSprite* backButton = [_levelLoader createSpriteWithName:@"Back_inactive" fromSheet:@"Menu" fromSHFile:@"Spritesheet" parent:self];
		[backButton prepareAnimationNamed:@"Menu_Back_Button" fromSHScene:@"Spritesheet"];
		[backButton transformPosition: ccp(20*SCALING_FACTOR_H + backButton.boundingBox.size.width/2,
											20*SCALING_FACTOR_V + backButton.boundingBox.size.height/2)];
		[backButton registerTouchBeganObserver:self selector:@selector(onTouchBeganAnyButton:)];
		[backButton registerTouchEndedObserver:self selector:@selector(onBack:)];


		[Analytics logEvent:@"View_IAP"];

	}
	
	if(DEBUG_MEMORY) DebugLog(@"Initialized InAppPurchaseLayer");
	if(DEBUG_MEMORY) report_memory();
	
	return self;
}


-(void)onTouchBeganAnyButton:(LHTouchInfo*)info {
	if(info.sprite == nil) return;
	[info.sprite setFrame:info.sprite.currentFrame+1];	//active state
}


-(void)onBack:(LHTouchInfo*)info {
	if(info.sprite == nil) return;
	[info.sprite setFrame:info.sprite.currentFrame-1];	//active state
	
	if([SettingsManager boolForKey:SETTING_SOUND_ENABLED]) {
		[[SimpleAudioEngine sharedEngine] playEffect:@"sounds/menu/button.wav"];
	}

	NSString* lastLevelPackPath = [SettingsManager stringForKey:SETTING_LAST_LEVEL_PACK_PATH];
	NSString* lastLevelPath = [SettingsManager stringForKey:SETTING_LAST_LEVEL_PATH];
	
	if(lastLevelPackPath != nil) {
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameLayer sceneWithLevelPackPath:lastLevelPackPath levelPath:lastLevelPath] ]];
	}else {
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MainMenuLayer scene] ]];
	}
}






-(void) onEnter
{
	[super onEnter];
}


-(void) onExit {
	if(DEBUG_MEMORY) DebugLog(@"InAppPurchaseLayer onExit");

	for(LHSprite* sprite in _levelLoader.allSprites) {
		[sprite stopAnimation];
	}			
	
	[super onExit];
}

-(void) dealloc
{
	if(DEBUG_MEMORY) DebugLog(@"InAppPurchaseLayer dealloc");

	[_levelLoader release];
	_levelLoader = nil;	
	
	[super dealloc];
	
	if(DEBUG_MEMORY) report_memory();
}	

@end
