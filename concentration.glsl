precision mediump float
	;
uniform float time;
uniform vec2  mouse;
uniform vec2  resolution;


//円
float ring(vec3 p){

	float t = 0.02 / abs(0.5 - length(p));
	return t;	
}

//Wave ring
float wave_ring(vec2 p){
	float size = (sin(time) + 1.0) * 0.5;
	
	float u = sin((atan(p.y, p.x) + time * 0.5) * 20.0) * 0.01;
	float t = 0.01 / abs(size + u - length(p));
	
	return t;
}

// Fan
float fan(vec2 p){
	
	float u = abs(sin((atan(p.y, p.x) - length(p) + time) * 10.0) * 0.5) + 0.2;
	float t = 0.01 / abs(u - length(p));
	return t;
}

//タイル状
vec2 to_tile(vec2 p){
	p = p * 2.0; //分割の数
	p = fract(p); //fractは小数点部分を返す
	p = p * 2.0 - 1.0; //中心にずらす( [-1.0～1.0]を
	return p;
}

//Main
void main(void){
    	vec2 m = vec2(mouse.x * 2.0 - 1.0, -mouse.y * 2.0 + 1.0);
    	vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x, resolution.y);
	
	//タイル状に表示
	p = to_tile(p);
    	
	
	//↑に定義している関数
	float ret = wave_ring(p) + wave_ring( vec2(p.x, 0.2)) + wave_ring(vec2(0.2 ,p.y))  ;
	
	//各ピクセルの色を出力
	gl_FragColor = vec4(vec3(ret), 1.0);
}