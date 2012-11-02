//
//  LevelSelectLayer.mm
//  Penguin Rescue
//
//  Created by Stephen Johnson on 10/15/12.
//  Copyright Conquer LLC 2012. All rights reserved.
//


// Import the interfaces
#import "LevelSelectLayer.h"
#import "LevelPackSelectLayer.h"
#import "GameLayer.h"
#import "LevelPackManager.h"
#import "SettingsManager.h"
#import "SimpleAudioEngine.h"
#import "CCScrollLayer.h"
#import "Utilities.h"
#import "Analytics.h"


#pragma mark - LevelSelectLayer

@implementation LevelSelectLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) sceneWithLevelPackPath:(NSString*)levelPackPath 
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelSelectLayer *layer = [LevelSelectLayer node];
	
	[layer loadLevelsWithLevelPackPath:levelPackPath];
	
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

		[LevelHelperLoader dontStretchArt];

		//create a LevelHelperLoader object - we use an empty level
		_levelLoader = [[LevelHelperLoader alloc] initWithContentOfFile:[NSString stringWithFormat:@"Levels/%@/%@", @"Menu", @"LevelSelect"]];
		[_levelLoader addObjectsToWorld:nil cocos2dLayer:self];

		_spriteNameToLevelPath = [[NSMutableDictionary alloc] init];
		
		LHSprite* backButton = [_levelLoader createSpriteWithName:@"Back_inactive" fromSheet:@"Menu" fromSHFile:@"Spritesheet" parent:self];
		[backButton prepareAnimationNamed:@"Menu_Back_Button" fromSHScene:@"Spritesheet"];
		[backButton transformPosition: ccp(20*SCALING_FACTOR_H + backButton.boundingBox.size.width/2,
											20*SCALING_FACTOR_V + backButton.boundingBox.size.height/2)];
		[backButton registerTouchBeganObserver:self selector:@selector(onTouchAnyButton:)];
		[backButton registerTouchEndedObserver:self selector:@selector(onTouchEndedBack:)];

	}
	
	if(DEBUG_MEMORY) DebugLog(@"Initialized LevelSelectLayer");	
	if(DEBUG_MEMORY) report_memory();
	
	return self;
}



-(void) loadLevelsWithLevelPackPath:(NSString*)levelPackPath {

	_levelPackPath = [levelPackPath retain];

	//load all available levels for this pack
	NSDictionary* levelsDictionary = [LevelPackManager allLevelsInPack:_levelPackPath];
	
	//load all levels for this pack that the user has completed
	NSDictionary* completedLevels = [LevelPackManager completedLevelsInPack:_levelPackPath];
	NSArray* availableLevels = [LevelPackManager availableLevelsInPack:_levelPackPath];
	
	NSMutableArray* scrollableLayers = [[NSMutableArray alloc] init];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];

	LHSprite* levelButton = [_levelLoader createSpriteWithName:@"Level_inactive" fromSheet:@"Menu" fromSHFile:@"Spritesheet" parent:self];
	const CGSize levelButtonSize = levelButton.boundingBox.size;
	const int levelButtonMarginX = 50*SCALING_FACTOR_H;
	const int levelButtonMarginY = 30*SCALING_FACTOR_V;
	const int columns = (winSize.width - levelButtonMarginX*2) / (levelButtonMarginX+levelButtonSize.width);
	const int rows = (winSize.height - levelButtonMarginY*2) / (levelButtonMarginY+levelButtonSize.height);
	const int levelButtonXInitial = winSize.width/2 - (columns/2 * (levelButtonSize.width+levelButtonMarginX)) + (levelButtonSize.width+levelButtonMarginX)/2;
	const int levelButtonYInitial = winSize.height + levelButtonSize.height/2;
	[levelButton removeSelf];

	int levelButtonX = levelButtonXInitial;
	int levelButtonY = levelButtonYInitial;
	CCLayer* scrollableLayer = nil;

	for(int i = 0; i < levelsDictionary.count; i++) {

		if(i%(rows*columns) == 0) {
			if(scrollableLayer != nil) {
				[scrollableLayer release];
				scrollableLayer = nil;
			}
			scrollableLayer = [[CCLayerColor alloc]
								initWithColor:ccc4(arc4random()*255,arc4random()*255,arc4random()*255,255)
								width:winSize.width
								height:winSize.height];
			[scrollableLayers addObject:scrollableLayer];
			
			levelButtonX = levelButtonXInitial;
			levelButtonY = levelButtonYInitial;
		}

		if(i%columns == 0) {
			//new row
			levelButtonY-= (levelButtonSize.height + levelButtonMarginY);
			levelButtonX = levelButtonXInitial;
		}
		
		NSDictionary* levelData = [levelsDictionary objectForKey:[NSString stringWithFormat:@"%d", i]];
		NSString* levelName = [levelData objectForKey:LEVELPACKMANAGER_KEY_NAME];
		NSString* levelPath = [levelData objectForKey:LEVELPACKMANAGER_KEY_PATH];
		
		//create the sprite
		LHSprite* levelButton = [_levelLoader createSpriteWithName:@"Level_inactive" fromSheet:@"Menu" fromSHFile:@"Spritesheet" parent:scrollableLayer];
		[levelButton prepareAnimationNamed:@"Menu_Level_Select_Button" fromSHScene:@"Spritesheet"];

		bool isLocked = false;
		
		if([completedLevels valueForKey:levelPath] != nil) {
			//DebugLog(@"Level %@ is completed!", levelPath);

			/*
			//add a checkmark on top
			LHSprite* completedMark = [_levelLoader createSpriteWithName:@"Level_Completed" fromSheet:@"Menu" fromSHFile:@"Spritesheet" parent:levelButton];
			[completedMark transformPosition:ccp(levelButtonSize.width - completedMark.contentSize.width/2 - 15*SCALING_FACTOR_H,completedMark.contentSize.height/2 + 15*SCALING_FACTOR_V)];
			*/

			//display the grade
			double score = [(NSNumber*)[completedLevels valueForKey:levelPath] doubleValue];
			double zScore = [ScoreKeeper zScoreFromScore:score withLevelPackPath:_levelPackPath levelPath:levelPath];
			CCLabelTTF* gradeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", [ScoreKeeper gradeFromZScore:zScore]] fontName:@"Helvetica" fontSize:20*SCALING_FACTOR_FONTS];
			gradeLabel.color = ccBLACK;
			gradeLabel.position = ccp(levelButtonSize.width - 30*SCALING_FACTOR_H, 25*SCALING_FACTOR_V);
			[levelButton addChild:gradeLabel];
			
		}else if([availableLevels containsObject:levelPath]) {
			//DebugLog(@"Level %@ is available!", levelPath);

					
		}else {
			//DebugLog(@"Level %@ is NOT available!", levelPath);

			isLocked = true;

			//add a lock on top
			LHSprite* lockIcon = [_levelLoader createSpriteWithName:@"Level_Locked" fromSheet:@"Menu" fromSHFile:@"Spritesheet" parent:levelButton];
			[lockIcon transformPosition:ccp(levelButtonSize.width - lockIcon.contentSize.width/2 - 15*SCALING_FACTOR_H,
											lockIcon.contentSize.height/2 + 15*SCALING_FACTOR_V)];

		}
		
		//display the level name
		CCLabelTTF* levelNameLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", levelName] fontName:@"Helvetica" fontSize:20*SCALING_FACTOR_FONTS dimensions:CGSizeMake(levelButtonSize.width-20*SCALING_FACTOR_H, levelButtonSize.height - 20*SCALING_FACTOR_V) hAlignment:kCCTextAlignmentCenter vAlignment:kCCVerticalTextAlignmentCenter lineBreakMode:kCCLineBreakModeWordWrap];
		levelNameLabel.color = ccBLACK;
		levelNameLabel.position = ccp(levelButtonSize.width/2,levelButtonSize.height/2);
		[levelButton addChild:levelNameLabel];
		
		
		if(!isLocked) {
			//used when clicking the sprite
			[_spriteNameToLevelPath setObject:levelPath forKey:levelButton.uniqueName];
			[levelButton registerTouchBeganObserver:self selector:@selector(onTouchAnyButton:)];
			[levelButton registerTouchEndedObserver:self selector:@selector(onTouchEndedLevelSelect:)];
		}
		
		
		
		//positioning
		[levelButton transformPosition: ccp(levelButtonX, levelButtonY)];
		levelButtonX+= levelButtonSize.width + levelButtonMarginX;
	}
	if(scrollableLayer != nil) {
		[scrollableLayer release];
		scrollableLayer = nil;
	}

	
	// now create the scroller and pass-in the pages (set widthOffset to 0 for fullscreen pages)
	_scrollLayer = [[CCScrollLayer alloc] initWithLayers:scrollableLayers widthOffset: 0];
	[scrollableLayers release];

	// finally add the scroller to your scene
	[self addChild:_scrollLayer];
	
	
	NSDictionary* flurryParams = [NSDictionary dictionaryWithObjectsAndKeys:
		_levelPackPath, @"Level_Pack",
	nil];
	[Analytics logEvent:@"View_Level_Pack" withParameters:flurryParams];

}



/************* Touch handlers ***************/

-(void)onTouchAnyButton:(LHTouchInfo*)info {
	if(info.sprite == nil) return;
	[info.sprite setFrame:info.sprite.currentFrame+1];	//active state
}

-(void)onTouchEndedLevelSelect:(LHTouchInfo*)info {
	if(info.sprite == nil) return;
	
	if([SettingsManager boolForKey:SETTING_SOUND_ENABLED]) {
		[[SimpleAudioEngine sharedEngine] playEffect:@"sounds/menu/button.wav"];
	}
	
	NSString* levelPath = [_spriteNameToLevelPath objectForKey:info.sprite.uniqueName];
	
	[SettingsManager setString:_levelPackPath forKey:SETTING_LAST_LEVEL_PACK_PATH];
	[SettingsManager setString:levelPath forKey:SETTING_LAST_LEVEL_PATH];
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameLayer sceneWithLevelPackPath:[NSString stringWithFormat:@"%@", _levelPackPath] levelPath:levelPath] ]];
}


-(void)onTouchEndedBack:(LHTouchInfo*)info {
	if(info.sprite == nil) return;
	[info.sprite setFrame:info.sprite.currentFrame+1];	//active state
	
	if([SettingsManager boolForKey:SETTING_SOUND_ENABLED]) {
		[[SimpleAudioEngine sharedEngine] playEffect:@"sounds/menu/button.wav"];
	}
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[LevelPackSelectLayer scene] ]];
}


-(void) onEnter
{
	[super onEnter];

}


-(void) onExit {
	if(DEBUG_MEMORY) DebugLog(@"LevelSelectLayer onExit");

	for(LHSprite* sprite in _levelLoader.allSprites) {
		[sprite stopAnimation];
	}	
	
	[super onExit];
}

-(void) dealloc
{
	if(DEBUG_MEMORY) DebugLog(@"LevelSelectLayer dealloc");
	
	[_levelPackPath release];
	[_spriteNameToLevelPath release];	
	[_scrollLayer release];

	[_levelLoader release];
	_levelLoader = nil;
	
	[super dealloc];
	
	if(DEBUG_MEMORY) report_memory();
}

@end
