shader_type canvas_item; //Add this onto a ColorRect or texture above object to work
render_mode unshaded;

uniform sampler2D displace : hint_albedo;
uniform float displacementAmount : hint_range(0,0.1);
uniform float abberationAmount: hint_range(0, 0.1);
uniform float abberationAmountX : hint_range(-0.1,0.1);
uniform float abberationAmountY : hint_range(-0.1,0.1);
uniform float dispSize: hint_range(0.1,2.0);
uniform float maxAlpha : hint_range(0.1,1.0);

uniform vec4 effect_color : hint_color = vec4(0, 0, 0, 1.0);
uniform float radius : hint_range(0, 0.7) = 0.4;
uniform float width : hint_range(0.01, 0.2);

void fragment()
{
	float l = length(UV - vec2(0.5));
	//circle
	//float d = distance(1.0 / SCREEN_PIXEL_SIZE*0.5,FRAGCOORD.xy)*(sin(1.0)+1.5)*0.003;
	//DISPLACE Effect
	if (l < radius) {
		vec4 disp = texture(displace, SCREEN_UV * dispSize);
		vec2 newUV = SCREEN_UV + disp.xy * displacementAmount;
		
		
		//abberation
		COLOR.r = texture(SCREEN_TEXTURE, newUV - vec2(abberationAmountX, abberationAmountY)).r;
		COLOR.g = texture(SCREEN_TEXTURE, newUV).g;
		COLOR.b = texture(SCREEN_TEXTURE, newUV + vec2(abberationAmountX, abberationAmountY)).b;
		COLOR.a = texture(SCREEN_TEXTURE, newUV).a * maxAlpha;
	} else if (l > radius + width) {
		COLOR = effect_color;
	} else {
		float k = (l - radius) / width;
		COLOR = mix(texture(TEXTURE, UV),effect_color, k);
	}
    //COLOR = mix(vec4(1.0, 1.0, 1.0, 1.0), vec4(0.0, 0.0, 0.0, 1.0), d);
    //COLOR = mix(disp, vec4(0.0, 0.0, 0.0, 1.0), d);
	
}