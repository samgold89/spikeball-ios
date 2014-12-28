//
//  SBNumberViewFlowLayout.m
//  Spikeball
//
//  Created by Sam Goldstein on 12/26/14.
//  Copyright (c) 2014 Sam Goldstein. All rights reserved.
//

#import "SBNumberViewFlowLayout.h"

@implementation SBNumberViewFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* arr = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* atts in arr) {
        if (nil == atts.representedElementKind) {
            NSIndexPath* attsPath = atts.indexPath;
            atts.frame = [self layoutAttributesForItemAtIndexPath:attsPath].frame;
        }
    }
    return arr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes* atts = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGRect adjustedFrame = atts.frame;
    adjustedFrame.origin.x = indexPath.row*kCellItemWidth;
    adjustedFrame.size.width = kCellItemWidth;
    atts.frame = adjustedFrame;
    return atts;
}

@end
