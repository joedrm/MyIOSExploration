/*
     File: APLOpenGLRenderer.m
 Abstract: OpenGL base class renderer sets up an EAGLContext for rendering, it also loads, compiles and links the vertex and fragment shaders for both the Y and UV planes.
  Version: 1.2
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 
 */

#import "APLOpenGLRenderer.h"

NSString *const kPassThroughVertexShader = SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 texCoord;
    uniform mat4 renderTransform;
    varying vec2 texCoordVarying;
    void main()
    {
        gl_Position = position * renderTransform;
        texCoordVarying = texCoord;
    }

);

NSString *const kPassThroughFragmentShaderRGB = SHADER_STRING
(
 
    varying highp vec2 texCoordVarying;
    uniform highp float progress;
    uniform sampler2D from;
    uniform sampler2D to;
 
    void main()
    {
        highp vec2 p = texCoordVarying;
        gl_FragColor = mix(texture2D(from, p), texture2D(to, p), progress);
    }
 
);

@interface APLOpenGLRenderer ()

- (void)setupOffscreenRenderContext;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type source:(NSString *)source;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;

@end

@implementation APLOpenGLRenderer

- (id)init
{
    self = [super init];
    if(self) {
		_currentContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		[EAGLContext setCurrentContext:_currentContext];
		
        [self setupOffscreenRenderContext];
        [self loadShaders];
        
		[EAGLContext setCurrentContext:nil];
    }
    
    return self;
}

- (void)dealloc
{
    if (_videoTextureCache) {
        CFRelease(_videoTextureCache);
    }
    if (_offscreenBufferHandle) {
        glDeleteFramebuffers(1, &_offscreenBufferHandle);
        _offscreenBufferHandle = 0;
    }
}

- (void)renderPixelBuffer:(CVPixelBufferRef)destinationPixelBuffer usingForegroundSourceBuffer:(CVPixelBufferRef)foregroundPixelBuffer andBackgroundSourceBuffer:(CVPixelBufferRef)backgroundPixelBuffer forTweenFactor:(float)tween
{
    [EAGLContext setCurrentContext:self.currentContext];
    
    if (foregroundPixelBuffer != NULL || backgroundPixelBuffer != NULL) {
        
        CVOpenGLESTextureRef foregroundRGBTexture  = [self rgbTextureForPixelBuffer:foregroundPixelBuffer];
        
        CVOpenGLESTextureRef backgroundRGBTexture = [self rgbTextureForPixelBuffer:backgroundPixelBuffer];
        
        CVOpenGLESTextureRef destRGBTexture = [self rgbTextureForPixelBuffer:destinationPixelBuffer];
        
        glUseProgram(self.programRGB);
        
        // Set the render transform
        GLfloat preferredRenderTransform [] = {
            self.renderTransform.a, self.renderTransform.b, self.renderTransform.tx, 0.0,
            self.renderTransform.c, self.renderTransform.d, self.renderTransform.ty, 0.0,
            0.0,					   0.0,										1.0, 0.0,
            0.0,					   0.0,										0.0, 1.0,
        };
        
        glUniformMatrix4fv(uniforms[UNIFORM_RENDER_TRANSFORM_RGB], 1, GL_FALSE, preferredRenderTransform);
        
        glBindFramebuffer(GL_FRAMEBUFFER, self.offscreenBufferHandle);
        glViewport(0, 0, (int)CVPixelBufferGetWidth(destinationPixelBuffer), (int)CVPixelBufferGetHeight(destinationPixelBuffer));
        
        // Y planes of foreground and background frame are used to render the Y plane of the destination frame
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(CVOpenGLESTextureGetTarget(foregroundRGBTexture), CVOpenGLESTextureGetName(foregroundRGBTexture));
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(CVOpenGLESTextureGetTarget(backgroundRGBTexture), CVOpenGLESTextureGetName(backgroundRGBTexture));
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        // Attach the destination texture as a color attachment to the off screen frame buffer
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, CVOpenGLESTextureGetTarget(destRGBTexture), CVOpenGLESTextureGetName(destRGBTexture), 0);
        
        GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
        
        if (status != GL_FRAMEBUFFER_COMPLETE) {
            NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
            goto bail;
        }
        
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        
        GLfloat quadVertexData1 [] = {
            -1.0, 1.0,
            1.0, 1.0,
            -1.0, -1.0,
            1.0, -1.0,
        };
        
        // texture data varies from 0 -> 1, whereas vertex data varies from -1 -> 1
        GLfloat quadTextureData1 [] = {
            0.5 + quadVertexData1[0]/2, 0.5 + quadVertexData1[1]/2,
            0.5 + quadVertexData1[2]/2, 0.5 + quadVertexData1[3]/2,
            0.5 + quadVertexData1[4]/2, 0.5 + quadVertexData1[5]/2,
            0.5 + quadVertexData1[6]/2, 0.5 + quadVertexData1[7]/2,
        };
        
        glUniform1i(uniforms[UNIFORM_RGB_FROM], 0);
        glUniform1i(uniforms[UNIFORM_RGB_TO], 1);
        glUniform1f(uniforms[UNIFORM_RENDER_PROGRESS_RGB], tween);
        
        glVertexAttribPointer(ATTRIB_VERTEX_RGB, 2, GL_FLOAT, 0, 0, quadVertexData1);
        glEnableVertexAttribArray(ATTRIB_VERTEX_RGB);
        
        glVertexAttribPointer(ATTRIB_TEXCOORD_RGB, 2, GL_FLOAT, 0, 0, quadTextureData1);
        glEnableVertexAttribArray(ATTRIB_TEXCOORD_RGB);
        
        // Blend function to draw the foreground frame
        glEnable(GL_BLEND);
        glBlendFunc(GL_ONE, GL_ZERO);
        
        // Draw the foreground frame
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        
        glFlush();
        
    bail:
        CFRelease(foregroundRGBTexture);
        CFRelease(backgroundRGBTexture);
        CFRelease(destRGBTexture);
        
        // Periodic texture cache flush every frame
        CVOpenGLESTextureCacheFlush(self.videoTextureCache, 0);
        
        [EAGLContext setCurrentContext:nil];
    }
    
}

- (void)setupOffscreenRenderContext
{
	//-- Create CVOpenGLESTextureCacheRef for optimal CVPixelBufferRef to GLES texture conversion.
    if (_videoTextureCache) {
        CFRelease(_videoTextureCache);
        _videoTextureCache = NULL;
    }
    CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, _currentContext, NULL, &_videoTextureCache);
    if (err != noErr) {
        NSLog(@"Error at CVOpenGLESTextureCacheCreate %d", err);
    }
	
	glDisable(GL_DEPTH_TEST);
	
	glGenFramebuffers(1, &_offscreenBufferHandle);
	glBindFramebuffer(GL_FRAMEBUFFER, _offscreenBufferHandle);
}

- (CVOpenGLESTextureRef)rgbTextureForPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    
    CVOpenGLESTextureRef rgbTexture = NULL;
    CVReturn err;
    
    if (!_videoTextureCache) {
        NSLog(@"No video texture cache");
        goto bail;
    }
    
    // Periodic texture cache flush every frame
    CVOpenGLESTextureCacheFlush(_videoTextureCache, 0);
    
    // CVOpenGLTextureCacheCreateTextureFromImage will create GL texture optimally from CVPixelBufferRef.
    // RGB
    err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                       _videoTextureCache,
                                                       pixelBuffer,
                                                       NULL,
                                                       GL_TEXTURE_2D,
                                                       GL_RGBA,
                                                       (int)CVPixelBufferGetWidth(pixelBuffer),
                                                       (int)CVPixelBufferGetHeight(pixelBuffer),
                                                       GL_BGRA,
                                                       GL_UNSIGNED_BYTE,
                                                       0,
                                                       &rgbTexture);
    
    if (!rgbTexture || err) {
        NSLog(@"Error at creating rgb texture using CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
    }
    
bail:
    return rgbTexture;
}

#pragma mark -
#pragma mark Base methods for extension

- (NSString *)fragmentShaderString {
    return kPassThroughFragmentShaderRGB;
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
	GLuint vertShader, fragShaderRGB;
	NSString *vertShaderSource, *fragShaderRGBSource;
	
	// Create the shader program.
    _programRGB = glCreateProgram();
	
	// Create and compile the vertex shader.
	vertShaderSource = kPassThroughVertexShader;
	if (![self compileShader:&vertShader type:GL_VERTEX_SHADER source:vertShaderSource]) {
		NSLog(@"Failed to compile vertex shader");
		return NO;
	}
    
    // Create and compile RGB fragment shader.
    fragShaderRGBSource = [self fragmentShaderString];
    if (![self compileShader:&fragShaderRGB type:GL_FRAGMENT_SHADER source:fragShaderRGBSource]) {
        NSLog(@"Failed to compile RGB fragment shader");
        return NO;
    }
    
    // Attach vertex shader to programY.
    glAttachShader(_programRGB, vertShader);
    
    // Attach fragment shader to programY.
    glAttachShader(_programRGB, fragShaderRGB);
	
	// Bind attribute locations. This needs to be done prior to linking.
	
    glBindAttribLocation(_programRGB, ATTRIB_VERTEX_RGB, "position");
    glBindAttribLocation(_programRGB, ATTRIB_TEXCOORD_RGB, "texCoord");
		   
	// Link the program.
	if (![self linkProgram:_programRGB]) {
		NSLog(@"Failed to link program: %d", _programRGB);
		
		if (vertShader) {
			glDeleteShader(vertShader);
			vertShader = 0;
		}
        if (_programRGB) {
            glDeleteProgram(_programRGB);
            _programRGB = 0;
        }
		
		return NO;
	}
	
	// Get uniform locations.
    uniforms[UNIFORM_RGB_FROM] = glGetUniformLocation(_programRGB, "from");
    uniforms[UNIFORM_RGB_TO] = glGetUniformLocation(_programRGB, "to");
    uniforms[UNIFORM_RENDER_TRANSFORM_RGB] = glGetUniformLocation(_programRGB, "renderTransform");
    uniforms[UNIFORM_RENDER_PROGRESS_RGB] = glGetUniformLocation(_programRGB, "progress");
    
    
	// Release vertex and fragment shaders.
	if (vertShader) {
		glDetachShader(_programRGB, vertShader);
		glDeleteShader(vertShader);
	}
    if (fragShaderRGB) {
        glDetachShader(_programRGB, fragShaderRGB);
        glDeleteShader(fragShaderRGB);
    }
	
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type source:(NSString *)sourceString
{
    if (sourceString == nil) {
		NSLog(@"Failed to load vertex shader: Empty source string");
        return NO;
    }
    
	GLint status;
	const GLchar *source;
	source = (GLchar *)[sourceString UTF8String];
	
	*shader = glCreateShader(type);
	glShaderSource(*shader, 1, &source, NULL);
	glCompileShader(*shader);
	
#if defined(DEBUG)
	GLint logLength;
	glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
	if (logLength > 0) {
		GLchar *log = (GLchar *)malloc(logLength);
		glGetShaderInfoLog(*shader, logLength, &logLength, log);
		NSLog(@"Shader compile log:\n%s", log);
		free(log);
	}
#endif
	
	glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
	if (status == 0) {
		glDeleteShader(*shader);
		return NO;
	}
	
	return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
	GLint status;
	glLinkProgram(prog);
	
#if defined(DEBUG)
	GLint logLength;
	glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
	if (logLength > 0) {
		GLchar *log = (GLchar *)malloc(logLength);
		glGetProgramInfoLog(prog, logLength, &logLength, log);
		NSLog(@"Program link log:\n%s", log);
		free(log);
	}
#endif
	
	glGetProgramiv(prog, GL_LINK_STATUS, &status);
	if (status == 0) {
		return NO;
	}
	
	return YES;
}

#if defined(DEBUG)

- (BOOL)validateProgram:(GLuint)prog
{
	GLint logLength, status;
	
	glValidateProgram(prog);
	glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
	if (logLength > 0) {
		GLchar *log = (GLchar *)malloc(logLength);
		glGetProgramInfoLog(prog, logLength, &logLength, log);
		NSLog(@"Program validate log:\n%s", log);
		free(log);
	}
	
	glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
	if (status == 0) {
		return NO;
	}
	
	return YES;
}

#endif

@end
