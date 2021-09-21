// Fragment shader: : toon shading
// ================
#version 450 core

in vec3 E;
in vec3 N;
in vec3 L;
in vec3 H;

// Ouput data
out vec4 FragColor;

struct Material {
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    float shininess;
}; 
struct PointLight{
	vec3 position;
	vec3 color;
	float power;
 };

uniform Material material;
uniform PointLight light;
in vec3 Color;


void main()
{
	float intensity;
	vec4 color;
	intensity = dot(L,N);

   	if (intensity > 0.75)
		color = vec4(0.75*Color.r, 0.75*Color.g, 0.75*Color.b, 1.0);
	else if (intensity > 0.5)
		color = vec4(0.5*Color.r, 0.5*Color.g, 0.5*Color.b, 1.0);
	else if (intensity > 0.25)
		color = vec4(0.25*Color.r, 0.25*Color.g, 0.25*Color.b, 1.0);
	else
		color = vec4(0.1*Color.r, 0.1*Color.g, 0.1*Color.b, 1.0);

	float aa = dot(normalize(E), normalize(N));

	if(aa >= 0.0 && aa < 0.30)
		color = vec4(0.0, 0.0, 0.0, 1.0);

	FragColor = color;
}

