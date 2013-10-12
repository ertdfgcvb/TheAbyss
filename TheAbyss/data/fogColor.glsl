#define PROCESSING_COLOR_SHADER

varying vec4 vertColor;

uniform float fogNear;
uniform float fogFar;
uniform vec3 fogColor;

void main(){
    gl_FragColor = vertColor;
    
    float depth = gl_FragCoord.z / gl_FragCoord.w;
    float fogFactor = smoothstep(fogNear, fogFar, depth);
    gl_FragColor = mix(gl_FragColor, vec4(fogColor, gl_FragColor.w), fogFactor);
}