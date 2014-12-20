//
//  NSString+GFCValidation.m
//  Spikeball
//
//  Created by Sam Goldstein on 7/8/14.
//

#import "NSString+GFCValidation.h"

@implementation NSString (GFCValidation)

- (BOOL)isValidEmailAddress {
    if ([self length] < 6) { //minimum is a@b.c
        return NO;
    }
    
    BOOL valid = [[self componentsSeparatedByString:@"@"] count] == 2 && [[self componentsSeparatedByString:@"."] count] >= 2 && [[[self componentsSeparatedByString:@"."] lastObject] length] > 1;
    
    if ([self rangeOfString:@" "].location != NSNotFound) {
        return NO;
    }
    
    return valid;
}

- (BOOL)isValidPassword {
    BOOL valid = self.length > 5;
    return valid;
}

- (BOOL)isValidPhoneNumber {
    //TODO: international numbers, etc
    NSString *phoneRegex = @"^\[0-9]{3}\[0-9]{3}[0-9]{4}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:self];
}

@end