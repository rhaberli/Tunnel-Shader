#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define HorizontalAmplitude		0.01
#define VerticleAmplitude		0.1
#define HorizontalSpeed			0.2
#define VerticleSpeed			0.3
#define ParticleMinSize			1.9
#define ParticleMaxSize			1.69
#define ParticleBreathingSpeed		2.34
#define ParticleColorChangeSpeed	3.33
#define ParticleCount			7.0
#define ParticleColor1			vec3(11.0, 9.0, 7.0)
#define ParticleColor2			vec3(1.0, 3.0, 5.0)


vec3 chess( vec2 uv, vec2 pp )
{
    vec2 p = floor( uv * 11. );
    float t = mod( p.x * p.y, 5.);
    vec3 c = vec3(t+pp.y, t+pp.x, t+(pp.x*pp.x*pp.y));

    return c;
}

vec3 tube( vec2 p, float scrollSpeed, float rotateSpeed )
{    
    float a = 2.0 * atan( p.y, p.x  );
    float po = 1.;
    float px = pow( p.x*p.y, po );
    float py = pow( p.y*p.x, po );
    float r = pow( px / py, 1./(po*po));    
    vec2 uvp = vec2( 1.0*r + (time*scrollSpeed), a + (time*rotateSpeed));	
    vec3 finalColor = chess( uvp, p ).xyz;
    finalColor *= r;

    return finalColor;
}

vec3 particles( vec2 uv )
{
	vec2 pos = uv * 2.0 - 1.0;
	pos.x *= (resolution.x / resolution.y);
	
	vec3 c = vec3( 0, 0, 0 );
	
	for( float i = 1.0; i < ParticleCount+1.0; ++i )
	{
		float cs = cos( time * HorizontalSpeed * (i/ParticleCount) ) * HorizontalAmplitude;
		float ss = sin( time * VerticleSpeed   * (i/ParticleCount) ) * VerticleAmplitude;
		vec2 origin = vec2( cs , ss );
		
		float t = sin( time * ParticleBreathingSpeed * i ) * 0.5 + 0.5;
		float particleSize = mix( ParticleMinSize, ParticleMaxSize, t );
		float d = clamp( sin( length( pos - origin )  + particleSize ), 0.0, particleSize);
		
		float t2 = sin( time * ParticleColorChangeSpeed * i ) * 0.5 + 0.5;
		vec3 color = mix( ParticleColor1, ParticleColor2, t2 );
		c += color * pow( d, 70.0 );
	}
	
	return c;
}

void main(void)
{
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    float timeSpeedX = time * 0.3;
    float timeSpeedY = time * 0.2;
    vec2 p = uv + vec2( -0.50+cos(timeSpeedX)*0.5, -0.5-sin(timeSpeedY)*0.5 );

    vec3 finalColor = tube( p , 1.0, 0.0);


    timeSpeedX = time * 0.30001;
    timeSpeedY = time * 0.20001;
    p = uv + vec2( -0.50+cos(timeSpeedX)*0.2, -0.5-sin(timeSpeedY)*0.3 );
    
	
	finalColor += particles( uv );
	
    gl_FragColor = vec4( finalColor, 1.0 );
}
