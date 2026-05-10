shader_type spatial;
render_mode cull_disabled, depth_draw_opaque, shadows_disabled;

//Global Wind

global uniform vec2 wind_direction;
global uniform float wind_texture_scale;
global uniform float wind_speed;
global uniform float still_sway_speed;
global uniform float still_sway_strength;
global uniform float gust_strength;
global uniform float gust_frequency;
uniform sampler2D wind_noise : hint_default_white;

//Player Interaction Globals
global uniform vec3 player_position;
global uniform float interaction_radius;
global uniform float interaction_push;

uniform sampler2D shader_texture : source_color;
uniform bool use_shader_texture = false;

varying float v_height;

//Vertex
void vertex() {
    v_height = UV.y;

    vec3 world_pos = (MODEL_MATRIX * vec4(0.0,0.0,0.0,1.0)).xyz;
    vec3 pos = VERTEX;

    vec3 right = vec3(1.0,0.0,0.0);
    vec3 forward = vec3(0.0,0.0,1.0);

    //smooth bend
    float bend_factor = pow(1.0 - UV.y, 2.0);
    bend_factor = smoothstep(0.05, 1.0, bend_factor); // bottom barely moves

    // Bend
    pos += forward * 0.5 * bend_factor;

    // Wind
    vec2 uv = world_pos.xz / wind_texture_scale;
    vec2 move_uv = uv + normalize(wind_direction) * TIME * wind_speed;

    float noise = texture(wind_noise, move_uv).r;
    float gust = smoothstep(gust_frequency, 1.0, noise);
    float sway = sin(TIME * still_sway_speed + world_pos.x + world_pos.z) * still_sway_strength;

    vec3 offset = right * (sway + gust * gust_strength) * bend_factor;
    pos += offset;

    //Player Interaction
    vec3 diff = world_pos - player_position;
    float dist = length(diff);
    if(dist < interaction_radius){
        float push_strength = smoothstep(interaction_radius,0.0, dist);
        vec3 dir = normalize(vec3(diff.x,0.0,diff.z));
        vec3 local_dir = mat3(inverse(MODEL_MATRIX)) * dir;
        pos += local_dir * push_strength * interaction_push * bend_factor;
        offset += local_dir * push_strength * interaction_push * bend_factor; // normal adjustment
    }

    VERTEX = pos;


    //normal

    NORMAL = normalize(NORMAL + offset * bend_factor * 0.5);
}
void fragment() {
    if(use_shader_texture){
        ALBEDO = texture(shader_texture, UV).rgb;
    }
}