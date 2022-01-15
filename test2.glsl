#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
float sphereSize=2.0;
float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

#define OCTAVES 6
float fbm (in vec2 st) {
    // Initial values
    float value = 0.0;
    float amplitude = .5;
    float frequency = 0.;
    //
    // Loop of octaves
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(st);
        st *= 2.;
        amplitude *= .5;
    }
    return value;
}

float sphereDistanceFunction(vec3 position, float size) {
    return length(position) - size;
}

// vec3 normal(vec3 pos, float size) {
//     float v = 0.001;
//     return normalize(vec3(sphereDistanceFunction(pos, size) - sphereDistanceFunction(vec3(pos.x - v, pos.y, pos.z), size), sphereDistanceFunction(pos, size) - sphereDistanceFunction(vec3(pos.x, pos.y - v, pos.z), size), sphereDistanceFunction(pos, size) - sphereDistanceFunction(vec3(pos.x, pos.y, pos.z - v), size)));
// }
//from:https://www.iquilezles.org/www/articles/terrainmarching/terrainmarching.htm
// float terrain(in vec2 p) {
//     p *= 0.2;
//     float height = 0.0;
//     float amp = 1.0;
//     for (int i = 0; i < 10; i++) {
//         height += amp * cos(p.x) * sin(p.y);
//         amp *= 0.5;
//         p *= 2.07;
//     }
//     return height * 5.0; // 適当な値で高さをスケール
// }
// vec3 normal(in vec2 p) {
//     float epsilon = 0.02;
//     return normalize(vec3(
//         terrain(p + vec2(epsilon, 0.0)) - terrain(p - vec2(epsilon,0.0)),
//         terrain(p +vec2(0.0, epsilon)) - terrain(p - vec2(0.0, epsilon)),
//         2.0 * epsilon
//     ));
// }


vec3 normal(in vec2 p) {
    float epsilon = 0.02+sin(time)*0.001;
    // return normalize(vec3(
    //     1.0 * epsilon,
    //     fbm(p + vec2(epsilon, 0.0)) - fbm(p - vec2(epsilon,0.0)),
    //     fbm(p +vec2(0.0, epsilon)) - fbm(p - vec2(0.0, epsilon))
    // ));
    return normalize(vec3(
        5.0 * epsilon,
        fbm(p +vec2(0.1, epsilon)) - fbm(p + vec2(0.0, epsilon)) * (sin(time)*0.05+0.85),
        fbm(p +vec2(0.1, epsilon)) - cos(fbm(p - vec2(epsilon,0.0)))*1.0
    ));
}

const float dmax = 50.0;
void main( void ) {
    
    //vec2 pos = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5,0.5);   
    vec2 pos = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);
    float horizon =0.0; 
    float fov = 1.5; 
    float scaling = 0.1;
    
    vec3 p = vec3(pos.x, fov, pos.y - horizon);      
    vec2 s = vec2(p.x/p.z, p.y/p.z) * scaling;
    
    float run=time*0.2;
    if (pos.y>0.0)  
      run=-run;
    /*          
    float color = 1.-sign((mod(s.x*3., 0.1) - 0.05) * (mod(s.y*3.+run, 0.1) - 0.05))*0.5+pos.y;     
    color *= p.z*p.z*10.0;
    */
  /*
    vec3 cameraPosition = vec3(0.0, time, 45.0);
    float screenZ = 4.0;
*/
    vec3 origin = vec3(0.0, 10.0, 0.0 - time);
    vec3 target = vec3(0.0, 8.0, -5.0 - time);
    vec3 cz = normalize(target - origin);
    vec3 cx = cross(cz, vec3(0.0, 1.0, 0.0));
    vec3 cy = cross(cx, cz);
    vec3 rayDirection = vec3(cx * pos.x + cy * pos.y + cz * 1.0);

    vec3 lightDirection = normalize(vec3(0.0, 0.0, 1.0));
    //vec3 rayDirection = normalize(vec3(pos, screenZ) - cameraPosition);
    float color = 1.0;
    float depth = 0.0;
    float dist;
    for (int i = 0; i < 15; i++) {
        vec3 rayPosition = origin + rayDirection * depth;   
        //float dist = sphereDistanceFunction(rayPosition, sphereSize);
        //float height = terrain(rayPosition.xz);
        float height = fbm(rayPosition.xz);
        float dist = rayPosition.y-height;
        /*if (dist < 0.0001) {
            //vec3 normal = normal(cameraPosition, sphereSize);
            //float diffalent = dot(normal, lightDirection);
            //color = vec3(diffalent) + vec3(1.0, 0.7, 0.2);
            color = 1.-sign((mod(cameraPosition.x*3., 0.1) - 0.05) * (mod(y*3.+run, 0.1) - 0.05))*0.5+y;
            break;
        }*/
        if(dist<0.0001 || depth > dmax) {
            break;
        }
        //cameraPosition += rayDirection * dist;
        depth += 0.2 * dist;
    }
    vec3 c = vec3(0.0);
    //float c = 0.0;
    /*
    if (depth < dmax) {
        vec3 p = cameraPosition + depth * rayDirection;
        vec3 n = normal(p.xz);
        c = n * 0.5;
        //c = 0.4-sign((mod(p.x*3., 0.1) - 0.05) * (mod(p.y*3.+run, 0.1) - 0.05))*0.5+p.y;

    }*/
    if (depth < dmax) {
        vec3 p = origin + depth * rayDirection;
        vec3 n = normal(p.xz);
        c = n * 0.5+0.1;
    }
    gl_FragColor = vec4(c, 1.0);

    //float color = fbm(s +time*0.4);
    //fading
    /*
    if(pos.y<-0.05){
        gl_FragColor = vec4( vec3(color) * vec3(0.8,0.6,0.1), 1.0 );
    }else{
        gl_FragColor = vec4( 1.0,0.6,sqrt(1.-pos.y)*.8, 1.0 );
    }*/
}
