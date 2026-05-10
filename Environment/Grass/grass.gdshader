shader_type spatial;
render_mode cull_disabled;

uniform vec3 color : source_color;
uniform vec3 color2 : source_color;

uniform sampler2D noise;
uniform float noiseScale = 20.0;

/* Grass sway */
uniform vec2 wind_dir = vec2(1.0, 0.2);   // wind direction (X,Z)
uniform float wind_speed = 1000;           // animation speed
uniform float wind_strength = 0.25;       // sway strength (in meters)
uniform float gust_strength = 1;       // gustiness (0-1)
uniform float bend_power = 1.6;           // bend strength

varying vec3 worldPos;

void vertex() {
	
	// world position of the vertex
	worldPos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

	// Height mask: the bottom barely moves, the top moves more (if UV.y goes bottom → top)
	float height_mask = pow(clamp(UV.y, 0.0, 1.0), bend_power);

	// Noise for variation between grass blades (and within a single blade)
	float n = texture(noise, worldPos.xz / noiseScale).r;

	// Wave + gusts
	float t = TIME * wind_speed;
	float wave = sin(t + n * 6.2831853);
	float gust = sin(t * 0.5 + worldPos.x * 0.2 + worldPos.z * 0.2);
	float sway = mix(wave, gust, clamp(gust_strength, 0.0, 1.0));
	
	// Offset along the wind direction
	vec2 dir = normalize(wind_dir);
	VERTEX.xz += dir * (sway * wind_strength * height_mask);

}

void fragment() {
	vec3 noiseLevel = texture(noise, worldPos.xz / noiseScale).rgb;
	ALBEDO = mix(color, color2, UV.y) * mix(color, color2, noiseLevel.r);

	if (!FRONT_FACING){
		NORMAL = -NORMAL;
	}

}