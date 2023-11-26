shader_type canvas_item;

uniform float contrast : hint_range(0.0, 2.0) = 1.650;
uniform float alpha : hint_range(0.0, 1.0) = 0.87;


void fragment() {
	vec4 color = texture(TEXTURE, UV);
////	color -= vec4(0.41, 0.41, 0.41, 0);
//	color.rgb = pow(color.rgb, vec3(1.0 / 0.678920));
//	color.rgb = (color.rgb - vec3(0.5)) * vec3(contrast) + vec3(0.5);
	
    // Sample the texture
    vec4 texColor = texture(TEXTURE, UV);
    
    // Define black color (assuming black is vec4(0.0, 0.0, 0.0, 1.0))
    vec4 blackColor = vec4(0.0, 0.0, 0.0, 0.80);
    
    // Multiply black color by 0.2 (80% reduction)
    vec4 blackAdjusted = blackColor * 1.0;
    
    // Add the 80% black to the original texture color
    vec4 resultColor = texColor * blackAdjusted;
    
    // Output final color
    COLOR = resultColor;
}
