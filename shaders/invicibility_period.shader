shader_type canvas_item;
render_mode unshaded;

uniform bool activated;
uniform vec4 color : hint_color;

void fragment() {
	vec4 sprite_color = texture(TEXTURE, UV);
	if (activated) {
		sprite_color.rgb = color.rgb;
	}
	
	//COLOR = vec4(0.0);
	COLOR = sprite_color;
}