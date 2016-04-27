#include "common.cuh"

rtBuffer<float3, 1> posData;
rtBuffer<uint3, 1> indexData;

rtDeclareVariable(float3, normal, attribute normal, );
rtDeclareVariable(Ray, ray, rtCurrentRay, );

RT_PROGRAM void intersect(int primId) {

	uint3 prim = indexData[primId];
	float3 p0 = posData[prim.x];
	float3 p1 = posData[prim.y];
	float3 p2 = posData[prim.z];

	float3 n;
	float t, u, v;

	if (intersect_triangle(ray, p0, p1, p2, n, t, u, v)) {

		if (rtPotentialIntersection(t)) {
			normal = normalize(n);
			rtReportIntersection(0);
		}
	}

}

RT_PROGRAM void bounds(int primId, float result[6]) {

	uint3 prim = indexData[primId];
	float3 p0 = posData[prim.x];
	float3 p1 = posData[prim.y];
	float3 p2 = posData[prim.z];

	optix::Aabb* aabb = (optix::Aabb*)result;
	aabb->m_min = fminf(fminf(p0, p1), p2);
	aabb->m_max = fmaxf(fmaxf(p0, p1), p2);
}