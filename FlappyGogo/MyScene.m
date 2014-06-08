//
//  MyScene.m
//  FlappyGogo
//
//  Created by Yusuke on 6/8/14.
//  Copyright (c) 2014 7gogoApps. All rights reserved.
//

#import "Constants.h"
#import "MyScene.h"

@interface MyScene() {
    SKSpriteNode* _tacochu;
}

@end

@implementation MyScene


#pragma mark - player controles
-(void)actionJump {
    //self.player.physicsBody.velocity = CGVectorMake(0, kPlayerJumpPower); // Originally written by Mr. Rento Usui
    // Jump前にpowerを初期化し、連続タップ時のpowerの倍増を防ぐ
    _tacochu.physicsBody.velocity = CGVectorMake(0, 0);
    [_tacochu.physicsBody applyImpulse:CGVectorMake(0, kPlayerJumpPowerVertical)];
    [self jumpSound];
}


#pragma mark - pole controles

-(void)createPole {
    
    // 現在textureは一種類のみを使い回し。
    SKTexture* poleTex = [SKTexture textureWithImageNamed:@"SpriteKitTest01_obstacle"];
    
    // 位置関係の設定 Originally written by Mr. Rento Usui
    CGFloat effectiveHeight = kPoleHeight;
    //CGFloat centreY = arc4random() % 150;
    CGFloat centreY = arc4random() % (NSInteger)(self.frame.size.width + poleTex.size.width * 2, 0);
    //CGFloat groundHight = CGRectGetHeight([self childNodeWithName:<#(NSString *)#>]);
    CGFloat bottomPadding = 100;
    
    SKSpriteNode* upperPole = [SKSpriteNode spriteNodeWithTexture:poleTex];
    upperPole.position = CGPointMake(0, centreY);
    upperPole.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:upperPole.size];
    upperPole.physicsBody.dynamic = NO;
    
    SKSpriteNode* lowerPole = [SKSpriteNode spriteNodeWithTexture:poleTex];
    lowerPole.position = CGPointMake(0, centreY + upperPole.size.height + kPoleHeight);
    lowerPole.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:lowerPole.size];
    lowerPole.physicsBody.dynamic = NO;
    
    //TODO: Create a new class (SKNode) for poles
    SKNode* poleSet = [SKNode node];
    poleSet.position = CGPointMake(self.frame.size.width + poleTex.size.width * 2, 0);
    poleSet.zPosition = -10;
    
    [poleSet addChild:upperPole];
    [poleSet addChild:lowerPole];
    [self addChild:poleSet];
    
}

//TODO: Make pole images random


#pragma mark - sound effect
-(void)jumpSound {
    [self runAction:[SKAction playSoundFileNamed:@"se_maoudamashii_magical05.mp3" waitForCompletion:NO]];
}

#pragma mark - scene initialisation
-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        /* --- 各種初期化フェーズ --- */
        // Don't forget to add SKContactDelegate protocol on .h file
        self.physicsWorld.contactDelegate = self;
        // タコちゃんの落下速度に関係するparam
        self.physicsWorld.gravity = CGVectorMake(0.0, kWorldGravityVertical);
        
        
        // 先ずtextureを生成してSKSpriteNodeに貼る
        // You can omit the .png, and @2x notation if you only support Retina display.
        
        /* --- 背景を描画 --- */
        SKTexture* bgTex = [SKTexture textureWithImageNamed:@"SpriteKitTest01_background"];
        bgTex.filteringMode = SKTextureFilteringNearest;
        
        SKSpriteNode* bgSprite = [SKSpriteNode spriteNodeWithTexture:bgTex];
        bgSprite.position = CGPointMake(bgSprite.size.width / 2, bgSprite.size.height / 2);
        
        [self addChild:bgSprite];
        
        /* --- タコちゃん出現 --- */
        SKTexture* tacoTex = [SKTexture textureWithImageNamed:@"SpriteKitTest01_tacochu"];
        tacoTex.filteringMode = SKTextureFilteringNearest;
        
        _tacochu = [SKSpriteNode spriteNodeWithTexture:tacoTex];
        [_tacochu setScale:0.15]; // タコ画像が大きすぎたので縮小
        _tacochu.position = CGPointMake(self.frame.size.width / 4, CGRectGetMidY(self.frame));
        
        // タコにphysicsを与える
        // 物理挙動（回転や重力）に関して、今回はれんと氏のものと逆のparamを設定してみる。
        // [注意]: physicsBodyはSKSpriteNodeをinstantiateしてから設定しないと反映されない
        _tacochu.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_tacochu.size.height / 2];
        _tacochu.physicsBody.dynamic = YES;
        _tacochu.physicsBody.allowsRotation = NO;
        _tacochu.physicsBody.mass = 0.001;
        
        [self addChild:_tacochu];
        
        /* --- 地面のグラフィック --- */
        // まだ未作成なので、transparentで
        SKNode* groundArea = [SKNode node];
        groundArea.position = CGPointMake(0, 0);
        groundArea.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, 50)];
        groundArea.physicsBody.dynamic = NO;
        
        [self addChild:groundArea];
        
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    //TEST
    [self actionJump];

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
