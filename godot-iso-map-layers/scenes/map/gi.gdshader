shader_type canvas_item; 

uniform float speed = 100;

void fragment() {
	COLOR = texture(TEXTURE, UV);  // This does not seem to be necessary.
	COLOR.b = 1.0;
}

void vertex() {
  	// Animate Sprite2D moving in big circle around its location
  	VERTEX += vec2(cos(TIME) * speed, sin(TIME) * speed);
}