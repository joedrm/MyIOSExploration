//
//  VTSWindRenderer.m
//  VideoTransitionsSample
//
//  Created by Ruslan Shevtsov on 4/14/15.
//  Copyright (c) 2015 iQueSoft. All rights reserved.
//

#import "VTSWindRenderer.h"

NSString *const kPassThroughWindFragmentShader = SHADER_STRING
(
    varying highp vec2 texCoordVarying;
    uniform highp float progress;
    uniform sampler2D from;
    uniform sampler2D to;
 
    highp float rand (highp vec2 co) {
        return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
    }

    void main()
    {
        highp float size = 0.2;

        highp vec2 p = texCoordVarying;
        highp float r = rand(vec2(0, p.y));
        highp float m = smoothstep(0.0, -size, p.x*(1.0-size) + size*r - (progress * (1.0 + size)));
        gl_FragColor = mix(texture2D(from, p), texture2D(to, p), m);

    }
 
 );

@interface VTSWindRenderer ()

@end

@implementation VTSWindRenderer

- (NSString *)fragmentShaderString {
    return kPassThroughWindFragmentShader;
}

@end
