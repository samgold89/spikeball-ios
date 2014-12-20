//
//  NSString+GFCValidation.h
//  Spikeball
//
//  Created by Sam Goldstein on 7/8/14.
//

#import <Foundation/Foundation.h>

@interface NSString (GFCValidation)

- (BOOL)isValidPassword;
- (BOOL)isValidEmailAddress;
- (BOOL)isValidPhoneNumber;

@end
