Shader "Unlit/SegmentShadow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
			#include "LineIntersect.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				float3 wPos : TEXCOORD1;
                UNITY_FOG_COORDS(2)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 seg0Start = float2(0,10);
				float2 seg0End   = float2(10,0);
				
				float2 center = 13*float2(cos(_Time.y),sin(_Time.y));
				float2 wPosXZ = i.wPos.xz;
				
				float centerPoint = saturate(length(wPosXZ-center));
				
				half segShadow = 1.0-(half)IsSegIntersectSeg( seg0Start,  seg0End,
													          center,   wPosXZ); 
															  
				for(int j=0; j<256;j++)
				{
					segShadow = 1.0-(half)IsSegIntersectSeg( seg0Start,  seg0End,
													          center,   wPosXZ); 
					
				}					
				// sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
				col = centerPoint * fixed4(segShadow,segShadow,segShadow,1);
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
