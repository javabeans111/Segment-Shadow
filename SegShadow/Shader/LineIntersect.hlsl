#ifndef SEGMENT_SHADOWS_INCLUDED
#define SEGMENT_SHADOWS_INCLUDED
    
	#define Delta 0.001
	#define MAXSEGMENTS 128
	
    //计算两个数字是否接近相等,阈值是dvalue
/*     bool IsApproximately(float a, float b, float dvalue)
    {
        float delta = a - b;
        return delta >= -dvalue && delta <= dvalue;
    }	 */

	
	bool IsSegIntersectSeg( float2 segment0Start,  float2 segment0End,
							float2 segment1Start,  float2 segment1End)
    {
        float2 p = segment0Start;
        float2 r = segment0End - segment0Start;
        float2 q = segment1Start;
        float2 s = segment1End - segment1Start;
        float2 pq = q - p;
        float rxs = r.x * s.y - r.y * s.x;
        float pqxr = pq.x * r.y - pq.y * r.x;
/*         if (IsApproximately(rxs, 0, Delta))
        {
            if (IsApproximately(pqxr, 0, Delta))
            {
                return true;
            }
            return false;
        } */
        float pqxs = pq.x * s.y - pq.y * s.x;
        float t = pqxs / rxs;
        float u = pqxr / rxs;
        return (t >= 0 && t <= 1 && u >= 0 && u <= 1);
    }
	
	int SEG_COUNT;
	float4 SHADOWSEGSA[MAXSEGMENTS];
	
	float4 CENTER;
	half SEGSHADOW_DENSITY;
	half3 SegShadowLoop(float3 fragWorldPos)
	{
		
		half shadowWeight = 0;
				
		for(int j=0; j<MAXSEGMENTS;j++)
		{
			
			float2 segStart = float2(SHADOWSEGSA[j].x,SHADOWSEGSA[j].y);
			float2 segEnd   = float2(SHADOWSEGSA[j].z,SHADOWSEGSA[j].w);
			bool isShadow = IsSegIntersectSeg( fragWorldPos.xz,  CENTER.xz,
											   segStart,segEnd);
				
			shadowWeight += ((half)isShadow);
			if (isShadow) break;
		}
		shadowWeight = 	saturate(1 - saturate(shadowWeight) + 1 - SEGSHADOW_DENSITY);
		return (shadowWeight.xxx);
	}
	
#endif	