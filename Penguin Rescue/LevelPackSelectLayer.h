//
//  LevelPackSelectLayer.h
//  Penguin Rescue
//
//  Created by Stephen Johnson on 10/15/12.
//  Copyright Conquer LLC 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "LevelHelperLoader.h"
#import "Constants.h"
#import "CCScrollLayer.h"
#import "IAPManager.h"

// IntroLayer
@interface LevelPackSelectLayer : CCLayer
{
	LevelHelperLoader* _levelLoader;
	IAPManager* _iapManager;
	
	CCScrollLayer *_scrollLayer;
	
	NSMutableDictionary* _spriteNameToLevelPackPath;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
