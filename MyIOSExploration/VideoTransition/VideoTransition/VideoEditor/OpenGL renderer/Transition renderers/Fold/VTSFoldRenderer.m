//
//  VTSFoldRenderer.m
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/14/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import "VTSFoldRenderer.h"

NSString *const kPassThroughFoldFragmentShader = SHADER_STRING
(
    varying highp vec2 texCoordVarying;
    uniform highp float progress;
    uniform sampler2D from;
    uniform sampler2D to;
 
    void main()
    {
        highp vec2 p = texCoordVarying;
        highp vec4 a = texture2D(from, (p - vec2(progress, 0.0)) / vec2(1.0-progress, 1.0));
        highp vec4 b = texture2D(to, p / vec2(progress, 1.0));
        gl_FragColor = mix(a, b, step(p.x, progress));
    }
 
 );

@interface VTSFoldRenderer ()

@end

@implementation VTSFoldRenderer

- (NSString *)fragmentShaderString {
    return kPassThroughFoldFragmentShader;
}

@end
