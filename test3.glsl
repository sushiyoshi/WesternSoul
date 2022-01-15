#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec3 skycolor;

float map(vec3 p){
    
    p.z += time;
    float h = dot(sin(p - cos(p.yzx*1.3)), vec3(.13));
    h += dot(sin(p*2. - cos(p.yzx*1.3*2.)), vec3(.1/2.));
    return p.y + 1. + h;     
}

vec3 getNormal(vec3 p)
{
    vec2 e = vec2(0.0035, -0.0035); 
    return normalize(
        e.xyy * map(p + e.xyy) + 
        e.yyx * map(p + e.yyx) + 
        e.yxy * map(p + e.yxy) + 
        e.xxx * map(p + e.xxx));
}

vec3 col(vec3 ro, vec3 rd, vec3 norm, float md, float t)
{   
    // light direction
    vec3 ld = ro + vec3(-1.0, -1.0, 1.21); 
    
    // basic diffuse / specular 
    float diff = max(dot(norm, ld), 0.0);
    float spec = pow(max( dot( reflect(-ld, norm), -rd ), 0.0 ), 7.0);
    
    vec3 objCol = vec3(0.3, 0.3,0.3);
    vec3 glowCol = vec3(1.0, 0.4, 0.0); 
    vec3 sceneCol;
    
    //main color
    sceneCol = (objCol*(diff - 0.015 * 0.5) + vec3(1.0, 0.6, 0.2)*spec*0.15) ;
    
    //fog
    //sceneCol =  mix( sceneCol, vec3(0.15,0.2,0.9), 1.0 - exp( -0.00026*t*t*t ) );
    sceneCol =  mix( sceneCol, skycolor, 1.0 - exp( -0.00026*t*t*t ) );
    
    // Kinda makes it look like theres alot of dust in the air. kinda 
    float sand = smoothstep(0.12, 1.5, 0.008 / md * t) * 0.3;
    sceneCol += glowCol * sand;
    
    return sceneCol;
    
}

void main()
{
    vec2 uv = 2.0 * vec2(gl_FragCoord.xy - 0.5*resolution.xy)/resolution.y; 
  
    // ray origin and direction
    vec3 ro = vec3(0.0, 0.0, 0.0); 
    vec3 rd = normalize(vec3(uv,2.0));
    
    float t = 0.0; 
   
    float minDist = 999.0;
    
    // raymarch
    for (int i = 0; i < 100; i++) 
    {
        float d = map(ro + rd*t);
        
        minDist = min(minDist, d);
        
        if(abs(d)<0.01)
        {
            minDist = 0.1;
            break;  
        }
        if(t>25.0) 
        {
            minDist = min(minDist, d);
            t = 80.0;
            break;
        }
        
        t += d * 0.7;
    }
    vec3 norm = getNormal(ro + rd * t);
    
    // color the scene
    vec3 sceneColor = col(ro, rd, norm, minDist, t);
    //from: https://glslsandbox.com/e#78448.0
    float tempx = mod(norm.x*3., 0.5) - 0.05;
    if(uv.y > -0.1) tempx = 1.; 
    float c = sign(tempx * (mod(uv.y*3.+time*0.1, 0.5) - 0.05))*0.03;
    
    sceneColor += vec3(c);
    
    gl_FragColor = vec4(sqrt(clamp(sceneColor, 0.0, 1.0)), 1.0);
 
}
