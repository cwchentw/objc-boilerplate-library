#import "Algebra.h"

@implementation Algebra
+(BOOL) isEven:(int)n
{
    return !(n & 1) ? YES : NO;
}
@end