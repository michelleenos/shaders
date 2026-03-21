#include "../lygia/animation/easing.glsl"

float easeFromMap(float easeId, float val) {
	float result = val;

	if (easeId == 1.0) {
		result = quadraticIn(val);
	} else if (easeId == 1.1) {
		result = quadraticOut(val);
	} else if (easeId == 1.2) {
		result = quadraticInOut(val);
	} else if (easeId == 2.0) {
		result = cubicIn(val);
	} else if (easeId == 2.1) {
		result = cubicOut(val);
	} else if (easeId == 2.2) {
		result = cubicInOut(val);
	} else if (easeId == 3.0) {
		result = quarticIn(val);
	} else if (easeId == 3.1) {
		result = quarticOut(val);
	} else if (easeId == 3.2) {
		result = quarticInOut(val);
	} else if (easeId == 4.0) {
		result = circularIn(val);
	} else if (easeId == 4.1) {
		result = circularOut(val);
	} else if (easeId == 4.2) {
		result = circularInOut(val);
	} else if (easeId == 5.0) {
		result = exponentialIn(val);
	} else if (easeId == 5.1) {
		result = exponentialOut(val);
	} else if (easeId == 5.2) {
		result = exponentialInOut(val);
	} else if (easeId == 6.0) {
		result = sineIn(val);
	} else if (easeId == 6.1) {
		result = sineOut(val);
	} else if (easeId == 6.2) {
		result = sineInOut(val);
	}

	return result;
}