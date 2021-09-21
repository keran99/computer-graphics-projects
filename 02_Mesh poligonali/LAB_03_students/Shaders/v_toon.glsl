// Vertex shader: toon shading
// ================
#version 450 core

// Input vertex data, different for all executions of this shader.
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;

out vec3 Color;
out vec3 E;
out vec3 N;
out vec3 L;
out vec3 H;

struct PointLight{
	vec3 position;
	vec3 color;
	float power;
};
struct Material {
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    float shininess;
}; 


// Values that stay constant for the whole mesh.
uniform mat4 P;
uniform mat4 V;
uniform mat4 M; // position*rotation*scaling

uniform PointLight light;
uniform Material material;



void main()
{
    gl_Position = P * V * M * vec4(aPos, 1.0);

	// Position in VCS
	vec4 eyePosition = V * M * vec4(aPos, 1.0);
	// LightPos in VCS
	vec4 eyeLightPos = V * vec4(light.position, 1.0);
	// Compute vectors H,L,N in VCS
	E = normalize(-eyePosition.xyz);
	L = normalize((eyeLightPos - eyePosition).xyz);
	N = normalize(transpose(inverse(mat3(V * M))) * aNormal);
	H = normalize(L + E);
	vec3 R = reflect(-L, N);  

	// ambient
    vec3 ambient = light.power * material.ambient;
  	
    // diffuse 
    float diff = max(dot(L,N), 0.0);
    vec3 diffuse = light.power * light.color * diff * material.diffuse;

    // specular
    float spec = pow(max(dot(E, R), 0.0), material.shininess);
    vec3 specular =  light.power * light.color * spec * material.specular;  

    Color = ambient + diffuse + specular;
}

