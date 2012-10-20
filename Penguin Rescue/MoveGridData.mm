//
//  MoveGridData.mm
//  Penguin Rescue
//
//  Created by Stephen Johnson on 10/18/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#import "cocos2d.h"
#import "MoveGridData.h"

@implementation MoveGridData


- (id)initWithGrid:(int**)grid height:(int)height width:(int)width moveHistorySize:(int)moveHistorySize tag:(NSString*)tag {
	if(self = [super init]) {
		_baseGrid = grid;
		_gridWidth = width;
		_gridHeight = height;
		_tag = tag;
	
		if(_gridWidth > 0 && _gridHeight > 0 && _baseGrid != nil) {
			_latestGrid = new int*[_gridWidth];
			for(int x = 0; x < _gridWidth; x++) {
				_latestGrid[x] = new int[_gridHeight];
				for(int y = 0; y < _gridHeight; y++) {
					_latestGrid[x][y] = _baseGrid[x][y];
				}
			}
		}
		
		_forceLatestGridUpdate = false;
		
		_moveHistorySize = moveHistorySize;
		_moveHistory = new CGPoint[_moveHistorySize];
		_moveHistoryIndex = 0;
		_moveHistoryIsFull = false;
	}
	
	//create a grouping of the objects by tags so we can share grids between them
	NSMutableSet* moveGridDatas = [tagToMoveGridData objectForKey:_tag];
	if(moveGridDatas == nil) {
		moveGridDatas = [[NSMutableSet alloc] init];
		[tagToMoveGridData setObject:moveGridDatas forKey:_tag];
	}
	[moveGridDatas addObject:self];
	
	return self;
}

- (void)copyBaseGridToLatestGrid {
	if(_gridWidth > 0 && _gridHeight > 0 && _baseGrid != nil && _latestGrid != nil) {
		for(int x = 0; x < _gridWidth; x++) {
			for(int y = 0; y < _gridHeight; y++) {
				_latestGrid[x][y] = _baseGrid[x][y];
			}
		}
	}
}

- (void)logMove:(CGPoint)pos {
	_moveHistory[_moveHistoryIndex] = pos;
	_moveHistoryIndex = (++_moveHistoryIndex%_moveHistorySize);
	if(_moveHistoryIndex == 0) {
		_moveHistoryIsFull = true;
	}
}


- (int**)gridToTile:(CGPoint)pos withPropagationCallback:(void(^)(int**,CGPoint))propagationMethod {

	if(_forceLatestGridUpdate || pos.x != _lastTileExamined.x || pos.y != _lastTileExamined.y) {
	
		_lastTileExamined = pos;
		_forceLatestGridUpdate = false;
		
		//propagate!
		if(propagationMethod) {
			
			[self copyBaseGridToLatestGrid];
			
			propagationMethod(_latestGrid, pos);
		}
	}else {
	}
	
	//TODO: update all the others sharing our tag (think through this carefully!!)
		
	return _latestGrid;
}

- (void)forceLatestGridUpdate {
	_forceLatestGridUpdate = true;
}

- (int**)baseGrid {
	return _baseGrid;
}

- (int**)latestGrid {
	return _latestGrid;
}

- (void)updateBaseGrid:(int**)baseGrid {
	if(_baseGrid != nil) {
		free(_baseGrid);
	}
	_baseGrid = baseGrid;
	[self copyBaseGridToLatestGrid];
	[self forceLatestGridUpdate];
}

- (double)distanceTraveledStraightline {
	CGPoint start = _moveHistory[_moveHistoryIndex];
	CGPoint end = _moveHistory[(_moveHistoryIndex+_moveHistorySize-1)%_moveHistorySize];
	return ccpDistance(start, end);
}

- (double)distanceTraveled {
	double sum = 0;
	if(_moveHistoryIsFull) {
		for(int i = 1; i < _moveHistorySize; i++) {
			sum+= ccpDistance(_moveHistory[i], _moveHistory[i-1]);
		}
	}else {
		sum = 10000;
	}
	return sum;
}


-(void)dealloc {
	if(_baseGrid != nil) {
		free(_baseGrid);
	}
	if(_latestGrid != nil) {
		free(_latestGrid);
	}
	free(_moveHistory);
	_baseGrid = nil;
	_latestGrid = nil;
	
	[super dealloc];
}

@end
