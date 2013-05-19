// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor
{
    CCSprite *hero, *princess, *enemy, *codeIndicator, *fireball, *selectedSprite, *successSign, *defeatSign, *murdererSign, *finger;
    CGSize size;
    BOOL jumping, won, lost;
    float jumpSpeed, heroSpeed, gravity;
    NSMutableArray *commandsArray, *tempArray, *optionArray, *selectedOptions;
    CCLabelTTF* textLabel, *descriptLabel, *titleLabel;
    int commandsIndex, test, sign;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
