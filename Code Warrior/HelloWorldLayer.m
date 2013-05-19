#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    HelloWorldLayer *layer = [HelloWorldLayer node];
    [scene addChild: layer];
    return scene;
}

// on "init" you need to initialize your instance
-(id) init {
	if( (self=[super initWithColor:ccc4(222, 222, 222, 222)]) ) {
        size = [[CCDirector sharedDirector] winSize];
        
        gravity =-0.22;

        self.isTouchEnabled = YES;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
         @"heroAnims.plist"];
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode
                                          batchNodeWithFile:@"heroAnims.png"];
        [self addChild:spriteSheet];
        
        commandsArray = [[NSMutableArray alloc] init];
        optionArray = [[NSMutableArray alloc] init];
        selectedOptions = [[NSMutableArray alloc] init];
        
        
        CCSprite *mock = [CCSprite spriteWithFile:@"mockup.png"];
        mock.position = ccp(size.width/2,size.height/2);
        //[self addChild:mock];
        
        
        CCSprite *floor = [CCSprite spriteWithFile:@"floor.png"];
        floor.position = ccp(650,60);
        [self addChild:floor];
        
        hero = [CCSprite spriteWithFile:@"hero.png"];
        hero.position = ccp(400,100);
        [self addChild:hero];
        
        princess = [CCSprite spriteWithFile:@"princess.png"];
        princess.position = ccp(950,120);
        [self addChild:princess];
        
        enemy = [CCSprite spriteWithFile:@"goomba.png"];
        enemy.position = ccp(695,90);
        [self addChild:enemy];
        
        CCSprite *codeUI = [CCSprite spriteWithFile:@"codeUI.png"];
        codeUI.position = ccp(152,384);
        [self addChild:codeUI];
        
        codeIndicator = [CCSprite spriteWithFile:@"codeIndicator.png"];
        codeIndicator.position = ccp(160,630);
        [self addChild:codeIndicator];
        
        CCSprite *topUI = [CCSprite spriteWithFile:@"topUI.png"];
        topUI.position = ccp(size.width/2,768-75);
        [self addChild:topUI];
        
        fireball = [CCSprite spriteWithFile:@"fireball.png"];
        fireball.position=ccp(1000,1000);
        [self addChild:fireball];

        [self setupCode];
        [self schedule:@selector(update:)];
        [self schedule:@selector(flasher:) interval:0.3];
        
        successSign = [CCSprite spriteWithFile:@"successSign.png"];
        successSign.position=ccp(660,1400);
        successSign.opacity=0;
        [self addChild:successSign];
        
        defeatSign = [CCSprite spriteWithFile:@"defeatSign.png"];
        defeatSign.position=ccp(660,1400);
        defeatSign.opacity=0;
        [self addChild:defeatSign];
        
        murdererSign = [CCSprite spriteWithFile:@"murdererSign.png"];
        murdererSign.position=ccp(660,1400);
        murdererSign.opacity=0;
        [self addChild:murdererSign];
        
        finger = [CCSprite spriteWithFile:@"finger.png"];
        finger.position=ccp(660,1400);
        finger.opacity=0;
        [self addChild:finger z:10];
        
        hero.scale=1.2;
        enemy.scale=1.2;
        princess.scale=1.2;
	}
	return self;
}

-(void)setupCode {
    CGSize boxSize = CGSizeMake(300, 100);

    //textLabel = [CCLabelTTF labelWithString:@"void main() {\n}" dimensions:boxSize hAlignment:kCCTextAlignmentLeft vAlignment:kCCVerticalTextAlignmentTop lineBreakMode:kCCLineBreakModeWordWrap fontName:@"Courier New" fontSize:18];
    
    //textLabel.color = ccBLACK;
    //textLabel.position = ccp([self boundingBox].size.width/2, [self boundingBox].size.height/2);
    //[self addChild:textLabel];
    
    titleLabel = [CCLabelTTF labelWithString:@"Select An Action" dimensions:boxSize hAlignment:kCCTextAlignmentLeft vAlignment:kCCVerticalTextAlignmentCenter lineBreakMode:kCCLineBreakModeWordWrap fontName:@"Arial" fontSize:20];
    titleLabel.color = ccWHITE;
    titleLabel.position = ccp(910,size.height-70);
    [self addChild:titleLabel];
    
    descriptLabel = [CCLabelTTF labelWithString:@"Code Lines" dimensions:boxSize hAlignment:kCCTextAlignmentLeft vAlignment:kCCVerticalTextAlignmentCenter lineBreakMode:kCCLineBreakModeWordWrap fontName:@"Courier New" fontSize:12];
    descriptLabel.color = ccWHITE;
    descriptLabel.position = ccp(615,size.height-75);
    [self addChild:descriptLabel];
    
    CCSprite *forwardOption = [CCSprite spriteWithFile:@"forwardIcon.png"];
    forwardOption.tag=0;
    forwardOption.position = ccp(60-5,size.height-90);
    [self addChild:forwardOption];
    forwardOption.userData = @"forwardIcon.png";
    [optionArray addObject:forwardOption];

    CCSprite *jumpOption = [CCSprite spriteWithFile:@"jumpIcon.png"];
    jumpOption.tag=0;
    jumpOption.position = ccp(130-5,size.height-90);
    [self addChild:jumpOption];
    jumpOption.userData = @"jumpIcon.png";
    [optionArray addObject:jumpOption];

    CCSprite *pauseOption = [CCSprite spriteWithFile:@"pauseIcon.png"];
    pauseOption.tag=0;
    pauseOption.position = ccp(200-5,size.height-90);
    [self addChild:pauseOption];
    pauseOption.userData = @"pauseIcon.png";
    [optionArray addObject:pauseOption];

    CCSprite *fireballOption = [CCSprite spriteWithFile:@"fireballIcon.png"];
    fireballOption.tag=0;
    fireballOption.position = ccp(270-5,size.height-90);
    [self addChild:fireballOption];
    fireballOption.userData = @"fireballIcon.png";
    [optionArray addObject:fireballOption];

    CCSprite *jumpForwardOption = [CCSprite spriteWithFile:@"jumpForwardIcon.png"];
    jumpForwardOption.tag=0;
    jumpForwardOption.position = ccp(340-5,size.height-90);
    [self addChild:jumpForwardOption];
    jumpForwardOption.userData = @"jumpForwardIcon.png";
    [optionArray addObject:jumpForwardOption];

    
//    CCLabelTTF* aLabel1 = [CCLabelTTF labelWithString:@"hero.jump();" fontName:@"Arial" fontSize:20];
//    aLabel1.color = ccBLACK;
//    CCMenuItem *infoButton = [CCMenuItemLabel itemWithLabel:aLabel1 block:^(id sender) {
//        textLabel.string = [[textLabel.string substringToIndex:[textLabel.string length]-1] stringByAppendingString:@"     hero.jump();\n}"];
//        NSString *command = @"hero.jump();";
//        [commandsArray addObject:command];    }];
//    
//    CCLabelTTF* aLabel2 = [CCLabelTTF labelWithString:@"hero.moveLeft();" fontName:@"Arial" fontSize:20];
//    aLabel2.color = ccBLACK;
//    CCMenuItem *acceptButton = [CCMenuItemLabel itemWithLabel:aLabel2 block:^(id sender) {
//        textLabel.string = [[textLabel.string substringToIndex:[textLabel.string length]-1] stringByAppendingString:@"     hero.moveLeft();\n}"];
//        NSString *command = @"hero.moveLeft();";
//        [commandsArray addObject:command];    }];
//    
//    CCLabelTTF* aLabel3 = [CCLabelTTF labelWithString:@"hero.moveRight();" fontName:@"Arial" fontSize:20];
//    aLabel3.color = ccBLACK;
//    CCMenuItem *thirdButton = [CCMenuItemLabel itemWithLabel:aLabel3 block:^(id sender) {
//        textLabel.string = [[textLabel.string substringToIndex:[textLabel.string length]-1] stringByAppendingString:@"     hero.moveRight();\n}"];
//        NSString *command = @"hero.moveRight();";
//        [commandsArray addObject:command];    }];
//    
//    CCLabelTTF* aLabel4 = [CCLabelTTF labelWithString:@"pauseFor(1);" fontName:@"Arial" fontSize:20];
//    aLabel4.color = ccBLACK;
//    CCMenuItem *fourthButton = [CCMenuItemLabel itemWithLabel:aLabel4 block:^(id sender) {
//        textLabel.string = [[textLabel.string substringToIndex:[textLabel.string length]-1] stringByAppendingString:@"     pauseFor(1);\n}"];
//        NSString *command = @"pauseFor(1);";
//        [commandsArray addObject:command];    }];
//    
//    CCLabelTTF* aLabel7 = [CCLabelTTF labelWithString:@"hero.shootFireball();" fontName:@"Arial" fontSize:20];
//    aLabel7.color = ccBLACK;
//    CCMenuItem *fifthButton = [CCMenuItemLabel itemWithLabel:aLabel7 block:^(id sender) {
//        textLabel.string = [[textLabel.string substringToIndex:[textLabel.string length]-1] stringByAppendingString:@"     hero.shootFireball();\n}"];
//        NSString *command = @"hero.shootFireball();";
//        [commandsArray addObject:command];    }];
//    
//    CCMenu *navMenu = [CCMenu menuWithItems:infoButton, acceptButton, thirdButton, fourthButton, fifthButton, nil];
//    
//    [navMenu alignItemsVerticallyWithPadding:30];
//    [navMenu setPosition:ccp(100 , 230)];
//    
//    // Add the menu to the layer
//    [self addChild:navMenu];
    
    CCLabelTTF* aLabel5 = [CCLabelTTF labelWithString:@"PokeMon" fontName:@"Arial" fontSize:20];
    aLabel5.color = ccBLACK;
    CCMenuItem *runButton = [CCMenuItemLabel itemWithLabel:aLabel5 block:^(id sender) {
        NSString *str = @"P";
        [princess setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%@princess.png",str]]];
        [hero setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%@hero.png",str]]];
        [enemy setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%@goomba.png",str]]];
    }];
    
    CCLabelTTF* aLabel6 = [CCLabelTTF labelWithString:@"Mario" fontName:@"Arial" fontSize:20];
    aLabel6.color = ccBLACK;
    CCMenuItem *clearButton = [CCMenuItemLabel itemWithLabel:aLabel6 block:^(id sender) {
        NSString *str = @"";
        [princess setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%@princess.png",str]]];
        [hero setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%@hero.png",str]]];
        [enemy setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%@goomba.png",str]]];
    }];
    
    CCLabelTTF* aLabel7 = [CCLabelTTF labelWithString:@"Harry Potter" fontName:@"Arial" fontSize:20];
    aLabel7.color = ccBLACK;
    CCMenuItem *clearButton1 = [CCMenuItemLabel itemWithLabel:aLabel7 block:^(id sender) {
        NSString *str = @"HP";
        [princess setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%@princess.png",str]]];
        [hero setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%@hero.png",str]]];
        [enemy setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%@goomba.png",str]]];
    }];
    
    CCLabelTTF* aLabel8 = [CCLabelTTF labelWithString:@"Spongebob" fontName:@"Arial" fontSize:20];
    aLabel8.color = ccBLACK;
    CCMenuItem *clearButton11 = [CCMenuItemLabel itemWithLabel:aLabel8 block:^(id sender) {
        NSString *str = @"S";
        [princess setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%@princess.png",str]]];
        [hero setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%@hero.png",str]]];
        [enemy setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%@goomba.png",str]]];
    }];
    
    CCLabelTTF* aLabel9 = [CCLabelTTF labelWithString:@"Sexy" fontName:@"Arial" fontSize:20];
    aLabel9.color = ccBLACK;
    CCMenuItem *clearButton1111 = [CCMenuItemLabel itemWithLabel:aLabel9 block:^(id sender) {
        NSString *str = @"M";
        [princess setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%@princess.png",str]]];
        [hero setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%@hero.png",str]]];
        [enemy setTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"%@goomba.png",str]]];
    }];
    
    
    CCMenu *runMenu = [CCMenu menuWithItems:clearButton, runButton, clearButton11, clearButton1, clearButton1111, nil];
    
    [runMenu alignItemsHorizontallyWithPadding:30];
    [runMenu setPosition:ccp(650, 600)];
    
    // Add the menu to the layer
    [self addChild:runMenu];
    
//    for (int x = 0; x<6; x++) {
//        CCSprite *commandBox = [CCSprite spriteWithFile:@"emptyCommandBox.png"];
//        commandBox.position = ccp(440,690-(x*100));
//        [self addChild:commandBox];
//    }
}

-(void)runCommands {
    successSign.position=ccp(660,1400);
    defeatSign.position=ccp(660,1400);
    murdererSign.position=ccp(660,1400);
    tempArray = [[NSMutableArray alloc] initWithArray:commandsArray];
    hero.opacity=255;
    hero.position=ccp(400,100);
    jumpSpeed=0;
    hero.rotation=0;
    lost=NO;
    won=NO;
    codeIndicator.position = ccp(160,630);
    princess.rotation=0;
    princess.color=ccWHITE;
    princess.position = ccp(950,120);
    [self unschedule:@selector(executeCommands)];
    [hero stopAllActions];
    [self executeCommands];
}

- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    BOOL removed;
    //CCSprite * newSprite = nil;
    for (CCSprite *sprite in optionArray) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
            NSString *str=sprite.userData;
            CCSprite *newSprite = [CCSprite spriteWithFile:str];
            newSprite.position=touchLocation;
            newSprite.tag = sprite.tag;
            
            if([str isEqualToString:@"forwardIcon.png"]) {
                newSprite.userData = @"hero.moveRight();";
                [descriptLabel setString:@"hero.move() {\n     int heroSpeed = 3\n     hero.position.x+=heroSpeed\n};"];
                [titleLabel setString:newSprite.userData];
            } else if([str isEqualToString:@"jumpIcon.png"]) {
                newSprite.userData = @"hero.jump();";
                [titleLabel setString:newSprite.userData];
                [descriptLabel setString:@"boolean heroJumping;\nhero.jump() {\n     if(heroJumping==true)return;\n     int jumpVelocity = 7\n     hero.position.y+=jumpVelocity\n     heroJumping=true\n};"];
                [titleLabel setString:newSprite.userData];
            } else if([str isEqualToString:@"pauseIcon.png"]) {
                newSprite.userData = @"pauseFor(1);";
                [descriptLabel setString:@"pauseFor(int time) {\n     updates.pause(time)\n};"];
                [titleLabel setString:newSprite.userData];
            } else if([str isEqualToString:@"fireballIcon.png"]) {
                newSprite.userData = @"hero.shootFireball();";
                [descriptLabel setString:@"hero.fireBall() {\n     new fireball=createFireball();\n     fireball.position=hero.position\n     fireball.moveOffscreen();\n};"];
                [titleLabel setString:newSprite.userData];
            } else if([str isEqualToString:@"jumpForwardIcon.png"]) {
                newSprite.userData = @"hero.jumpForward();";
                [descriptLabel setString:@"hero.jumpForward() {\n     hero.jump();\n     hero.move();\n};"];
                [titleLabel setString:newSprite.userData];
            }

            
            [self addChild:newSprite];
            selectedSprite = newSprite;
        }
    }
    for (CCSprite *sprite in selectedOptions) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
            [commandsArray removeObjectAtIndex:sprite.tag];
            removed=YES;
        }
    }
    if(removed==YES) [self resetBoxes];
    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    selectedSprite.position = touchLocation;
    finger.position=touchLocation;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    finger.position=touchLocation;
    finger.opacity=255;
    [self selectSpriteForTouch:touchLocation];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    finger.opacity=0;
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if(selectedSprite!=nil) {
        //textLabel.string = [[textLabel.string substringToIndex:[textLabel.string length]-1] stringByAppendingString:@"     hero.shootFireball();\n}"];
        if (touchLocation.y<540) {
        NSString *command2 = selectedSprite.userData;
            [selectedSprite removeFromParentAndCleanup:YES];
            selectedSprite=nil;
        if(commandsArray.count==5) return;
        [commandsArray addObject:command2];
        [self resetBoxes];
        } else {
            [selectedSprite removeFromParentAndCleanup:YES];
            selectedSprite=nil;
        }
//        CCSprite *optionIcon = [CCSprite spriteWithFile:@"heroWalking4.png"];
//        optionIcon.tag=commandsIndex;
//        optionIcon.position = ccp(440+(commandsIndex*100),690);
//        commandsIndex++;
//        [self addChild:optionIcon];

    }
}

-(void)resetBoxes {
    commandsIndex=0;
    enemy.position = ccp(695,90);
    for (int x = 0; x<selectedOptions.count; x++) {
        [[selectedOptions objectAtIndex:x] removeFromParentAndCleanup:YES];
    }
    [selectedOptions removeAllObjects];
    for (NSString * command in commandsArray) {
        NSString *str;
        if([command isEqualToString:@"hero.moveRight();"]) {
            str = @"forwardIconInfo.png";
        } else if([command isEqualToString:@"hero.jump();"]) {
            str = @"jumpIconInfo.png";
        } else if([command isEqualToString:@"pauseFor(1);"]) {
            str = @"pauseIconInfo.png";
        } else if([command isEqualToString:@"hero.shootFireball();"]) {
            str = @"fireballIconInfo.png";
        } else if([command isEqualToString:@"hero.jumpForward();"]) {
            str = @"jumpForwardIconInfo.png";
        }
        
        CCSprite *optionIcon = [CCSprite spriteWithFile:str];
        optionIcon.tag=commandsIndex;
        optionIcon.position = ccp(150,530-(commandsIndex*100));
        commandsIndex++;
        [self addChild:optionIcon];
        [selectedOptions addObject:optionIcon];

    }
    test++;
    [self runCommands];
}

-(void)executeCommands {
    heroSpeed=0;
    [hero stopAllActions];
    [self unschedule:@selector(executeCommands)];
    if (tempArray.count==0) {
        return;
    } else {
        NSString *command = [tempArray objectAtIndex:0];
        [tempArray removeObjectAtIndex:0];
        if ([command isEqualToString:@"hero.jump();"])
        {
            [self schedule:@selector(heroJump) interval:0.1];
            [self schedule:@selector(executeCommands) interval:1.1];
        }
        else if ([command isEqualToString:@"hero.jumpForward();"])
        {
            [self heroMove:3];
            [self schedule:@selector(heroJump) interval:0.1];
            [self schedule:@selector(executeCommands) interval:1.1];
        }
        else if ([command isEqualToString:@"hero.moveRight();"])
        {
            [self heroMove:3];
            [self schedule:@selector(executeCommands) interval:1.1];
        }
        else if ([command isEqualToString:@"hero.shootFireball();"])
        {
            [self fireball];
            [self schedule:@selector(executeCommands) interval:1.1];
        }
        else if ([command isEqualToString:@"pauseFor(1);"])
        {
            [self schedule:@selector(executeCommands) interval:1.1];
        }
        //codeIndicator.position = ccp(codeIndicator.position.x, codeIndicator.position.y-12);
        codeIndicator.position=ccp(160,codeIndicator.position.y-100);
    }
}

-(void)fireball {
    fireball.position = hero.position;
    [fireball runAction:[CCMoveBy actionWithDuration:1 position:ccp(700,0)]];
}

- (void)update:(ccTime)dt
{
    if(codeIndicator.position.y>600)codeIndicator.opacity=0;
    else codeIndicator.opacity=255;
    int heroBottom = (hero.position.y)-(hero.contentSize.height/2);
    
    if(heroBottom<71)
    {
        jumpSpeed = 0;
        hero.position=ccp(hero.position.x,71+(hero.contentSize.height/2));
        jumping=NO;
    }
    if(heroBottom>70)
    {        
        jumpSpeed += gravity;
        hero.position=ccp(hero.position.x,hero.position.y+jumpSpeed);
    }
    
    hero.position=ccp(hero.position.x+heroSpeed,hero.position.y);
    if(hero.position.x<390) {
        hero.position=ccp(390,hero.position.y);
    }
    
    if(hero.position.x>1020) {
        hero.position=ccp(1020,hero.position.y);
    }
     
    if(CGRectIntersectsRect(hero.boundingBox, princess.boundingBox) && won == NO){
        [self displayWin];
        
    }
    
    if(CGRectIntersectsRect(hero.boundingBox, enemy.boundingBox) && lost == NO){
        [self displayLose];
    }
    
    if(CGRectIntersectsRect(fireball.boundingBox, enemy.boundingBox)){
        [fireball stopAllActions];
        fireball.position=ccp(1000,1000);
        enemy.position=ccp(1000,1000);
    }
    
    if(CGRectIntersectsRect(fireball.boundingBox, princess.boundingBox)){
        [fireball stopAllActions];
        fireball.position=ccp(1000,1000);
        princess.color = ccBLACK;
        [princess runAction:[CCSequence actions:[CCMoveBy actionWithDuration:0.2 position:ccp(10,0)],
                             [CCMoveBy actionWithDuration:0.2 position:ccp(20,0)],
                             [CCMoveBy actionWithDuration:0.2 position:ccp(-30,0)],
                             [CCMoveBy actionWithDuration:0.1 position:ccp(10,0)],
                             [CCMoveBy actionWithDuration:0.2 position:ccp(-40,0)],
                             [CCMoveBy actionWithDuration:0.2 position:ccp(20,0)],
                             [CCMoveBy actionWithDuration:0.02 position:ccp(0,-40)],
                             [CCRotateBy actionWithDuration:0.4 angle:90], nil]];
        [murdererSign runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2],
                         [CCMoveTo actionWithDuration:0 position:ccp(660,400)], nil]];

    }
}

-(void)restart {
    [self runCommands];
}

-(void) displayLose {
    lost = YES;
    CCSprite *rect = [CCSprite spriteWithFile:@"loseScreen.png"];
    rect.position = ccp(500,500);
    //[self addChild:rect];
    [hero runAction:[CCRotateBy actionWithDuration:0.6 angle:1000]];
    [hero runAction:[CCSequence actions:[CCMoveBy actionWithDuration:0.3 position:ccp(0,50)], [CCMoveBy actionWithDuration:0.3 position:ccp(0,-200)], nil]];
    [defeatSign runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1],
                             [CCMoveTo actionWithDuration:0 position:ccp(660,400)], nil]];

    heroSpeed=0;
}

-(void) displayWin {
    won = YES;
    [successSign runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1],
                           [CCMoveTo actionWithDuration:0 position:ccp(660,400)], nil]];

    heroSpeed=0;
}

-(void) heroMove:(int)direction {
    heroSpeed = direction;
    if(heroSpeed<0)hero.scaleX=-1;
    else if(heroSpeed>0)hero.scaleX=1;
    
    NSMutableArray *idleAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 8; ++i) {
        [idleAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"heroWalking%d.png", i]]];
    }
    
    CCAnimation *idleAnim = [CCAnimation
                             animationWithSpriteFrames:idleAnimFrames delay:0.1f];
    CCAction* walkingAction = [CCRepeatForever actionWithAction:
                               [CCAnimate actionWithAnimation:idleAnim]];
    //[hero runAction:walkingAction];
}

-(void) heroJump {
    [self unschedule:@selector(heroJump)];
    if (jumping==YES) return;
    hero.position=ccpAdd(hero.position, ccp(0,1));
    jumpSpeed=7;
    jumping=YES;
}

- (void)flasher:(ccTime)dt {
    if(murdererSign.opacity==0)murdererSign.opacity=255;
    else murdererSign.opacity=0;
    
    if(successSign.opacity==0)successSign.opacity=255;
    else successSign.opacity=0;
    
    if(defeatSign.opacity==0)defeatSign.opacity=255;
    else defeatSign.opacity=0;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}

@end
