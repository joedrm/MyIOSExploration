//
//  VTSSimpleFlipRenderer.m
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/14/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import "VTSSimpleFlipRenderer.h"

NSString *const kPassThroughSimpleFlipFragmentShader = SHADER_STRING
(
    varying highp vec2 texCoordVarying;
    uniform highp float progress;
    uniform sampler2D from;
    uniform sampler2D to;
 
    void main()
    {
        highp vec2 p = texCoordVarying;
        highp vec2 q = p;
        p.x = (p.x - 0.5)/abs(progress - 0.5)*0.5 + 0.5;
        highp vec4 a = texture2D(from, p);
        highp vec4 b = texture2D(to, p);
        gl_FragColor = vec4(mix(a, b, step(0.5, progress)).rgb * step(abs(q.x - 0.5), abs(progress - 0.5)), 1.0);
     
    }
 
 );

@interface VTSSimpleFlipRenderer ()

@end

@implementation VTSSimpleFlipRenderer

- (NSString *)fragmentShaderString {
    return kPassThroughSimpleFlipFragmentShader;
}

@end
