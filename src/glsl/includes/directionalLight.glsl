vec3 directionalLight(
	vec3 lightColor,
	float lightIntensity,
	vec3 normal,
	vec3 lightPosition,
	vec3 viewDirection,
	float specularPower
) {
	vec3 lightDirection = normalize(lightPosition);
	vec3 lightReflection = reflect(-lightDirection, normal);
    // reflect is a glsl provided fn
    // reverse it (* -1) since we need a vector pointing toward the surface

	float shading = dot(normal, lightDirection);
	shading = max(shading, 0.0);

    // dot product to compare viewDirection & lightReflection.
    // with dot product, when 2 vectors are going in the opposite direction, we
    // get -1. if they are going in the same direction we get 1.
	float specular = -dot(lightReflection, viewDirection);
	specular = max(0.0, specular);
    // // pow to reduce it
	specular = pow(specular, specularPower);

	lightColor *= lightIntensity * (shading + specular);

	// return lightColor * lightIntensity * (shading + specular);
	return lightColor;
}