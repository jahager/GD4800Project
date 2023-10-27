//shader_type spatial;
shader_type canvas_item;

uniform float speed : hint_range(0.0, 1.0) = 0.1;
uniform float rainbow_width : hint_range(0.1, 1.0) = 0.1;

void fragment() {
    vec2 uv = SCREEN_UV;
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

    COLOR = vec4(rainbow_color, 1.0);
}
