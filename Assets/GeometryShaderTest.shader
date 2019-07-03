// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/GeometryShaderTest"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _WireColor("WireColor", Color) = (0,0,1,1)
        _Radius("Radius", float) = 10
        _InnerRadius("InnerRadius", Range(0,1)) = 0.5
        _OuterRadius("OuterRadius", Range(0,1)) = 0.5
    }
    SubShader
    {

        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#pragma geometry geom
            #include "UnityCG.cginc"
			#include "UnityStandardBRDF.cginc"

            struct v2g
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
            };

            struct g2f
            {
				float4 vertex : SV_POSITION;
                float distance : TEXCOORD0;
				float2 barycentric : TEXCOORD1;
            };

            v2g vert (appdata_base v)
            {
                v2g o;
				o.vertex = mul(unity_ObjectToWorld, v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

			float4 _MaskPosition;
			float _Radius;

			g2f VertexOutput(float3 oPos, float distance, float2 baryCoord)
			{
				g2f o;
				o.vertex = UnityWorldToClipPos(oPos);
				o.distance = distance;
				o.barycentric = baryCoord;
				return o;
			}

			[maxvertexcount(3)]
			void geom (triangle v2g IN[3], inout TriangleStream<g2f> tristream)
			{
				float3 v0 = IN[0].vertex.xyz;
				float3 v1 = IN[1].vertex.xyz;
				float3 v2 = IN[2].vertex.xyz;

				float3 avgPos = (v0 + v1 + v2) / 3;
				float dist = distance(avgPos, _MaskPosition);

				tristream.Append(VertexOutput(v0, dist, float2(1,0)));
				tristream.Append(VertexOutput(v1, dist, float2(0,1)));
				tristream.Append(VertexOutput(v2, dist, float2(0,0)));
				
			}

			fixed4 _Color;
			fixed4 _WireColor;
			float _InnerRadius;
			float _OuterRadius;

            fixed4 frag (g2f i) : SV_Target
            {
				float3 bary = float3(i.barycentric.x, i.barycentric.y, 1 - i.barycentric.x - i.barycentric.y);
				float3 deltas = fwidth(bary);
				bary = 1 - smoothstep(deltas, deltas * 2, bary);
				float edge = saturate(max(bary.x, max(bary.y, bary.z)));

				float x = 1 - saturate(i.distance / _Radius);
				float c = max(step(0.5, x), edge * step(0.01, 1 - saturate(i.distance / (_Radius / lerp(2, 1, _OuterRadius)))));
				fixed4 col;
				col.rgb = lerp(_Color, _WireColor, min(edge,step(x, lerp(0.5, 1, _InnerRadius))));
				col.a = c;
                return col;
            }
            ENDCG
        }
    }
}