shader_type canvas_item;


uniform float speed : hint_range(0.0, 1.0) = 0.1;
uniform float rainbow_width : hint_range(0.1, 1.0) = 0.1;


vec4 rainbow(sampler2D texture_in, vec2 uv_in){
	vec4 color = texture(texture_in, uv_in);
    if (color.a == 0.0) {
        return color;
    }
	
    vec2 uv = uv_in;
    float time = TIME * speed;

    float rainbow_offset = mod(uv.x - time + uv.y, 1.0);
    vec3 rainbow_color = vec3(1.0, 0.0, 0.0);  // Start with red

    // Create a gradient with red, orange, yellow, green, blue, and violet
    vec3 colors[6] = {
        vec3(1.0, 0.0, 0.0),  // Red
        vec3(1.0, 0.5, 0.0),  // Orange
        vec3(1.0, 1.0, 0.0),  // Yellow
        vec3(0.0, 1.0, 0.0),  // Green
        vec3(0.0, 0.0, 1.0),  // Blue
        vec3(0.5, 0.0, 1.0)   // Violet
	};

    // Iterate over colors and set rainbow_color based on the current position
    for (int i = 0; i < 6; i++) {
        float color_start = float(i) / 5.0;
        float color_end = float(i+1) /5.0;

        if (rainbow_offset >= color_start && rainbow_offset < color_end) {
            float t = (rainbow_offset - color_start) / rainbow_width;
			
            rainbow_color = mix(colors[i], colors[i + 1], t);
        }
		
    }

    return vec4(rainbow_color, 1.0);
}

// Shader to round corners of a canvas. The 'radius_scale' is multiplied by
// minimum(width, height)/2.0 to calculate the radius of the corners.
//
// Instructions:
// 1) The node that uses this shader must have signals 'tree_entered' and
// 'item_rect_changed' connected to a callable with the next code:
// material.set_shader_parameter("width", size.x)
// material.set_shader_parameter("height", size.y)
//
// Known issues:
// 1) If used on 'TextureRect', take care of 'expand_mode' and 'stretch_mode',
// because image corners might be outside node rectangle and therefore clipped.
// Corners are rounded, but they are outside node's rectangle.


uniform float radius_scale: hint_range(0.0, 1.0, 0.1) = 0.1;
uniform bool rounded_corner_top_left = true;
uniform bool rounded_corner_top_right = true;
uniform bool rounded_corner_bottom_left = true;
uniform bool rounded_corner_bottom_right = true;
uniform float width = 0.25;
uniform float height = 0.25;

vec4 round_corner(sampler2D texture_in, vec2 uv_in){
	vec4 image = texture(texture_in, uv_in);
	vec2 pos = vec2(uv_in.x*width, uv_in.y*height);
	float radius = min(width, height)*radius_scale/2.0;
	float dist;
	// Top left corner
	if (rounded_corner_top_left) {
		dist = length(pos - vec2(radius));
		if (dist > radius && pos.x < radius && pos.y < radius) {
			image.a = 0.0;
		}
		// debugging only
//		if (dist < radius){image.r = 1.0;}
	}
	// Top right corner
	if (rounded_corner_top_right) {
		dist = length(pos - vec2(width-radius, radius));
		if (dist > radius && pos.x > width-radius && pos.y < radius) {
			image.a = 0.0;
		}
		// debugging only
//		if (dist < radius){image.r = 1.0;}
	}
	// Bottom left corner
	if (rounded_corner_bottom_left) {
		dist = length(pos - vec2(radius, height-radius));
		if (dist > radius && pos.x < radius && pos.y > height-radius) {
			image.a = 0.0;
		}
		// debugging only
//		if (dist < radius){image.r = 1.0;}
	}
	// Bottom right corner
	if (rounded_corner_bottom_right) {
		dist = length(pos - vec2(width-radius, height-radius));
		if (dist > radius && pos.x > width-radius && pos.y > height-radius) {
			image.a = 0.0;
		}
		// debugging only
//		if (dist < radius){image.r = 1.0;}
	}
	return image;
}

void fragment() {
	
	COLOR = round_corner(TEXTURE, UV) * rainbow(TEXTURE, SCREEN_UV);
}