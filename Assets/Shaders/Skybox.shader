Shader "Custom/Skybox" {
	Properties {
		_Skybox ("Skybox", Cube) = "white" {}
	}
	CGINCLUDE
	#include "UnityCG.cginc"
	
	struct v2f {
		float4 pos:	SV_POSITION;
		float3 dir: TEXCOORD0;
	};
	
	samplerCUBE _Skybox;
	
	ENDCG
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		Cull off
		
		Pass // Silhouette
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			float4x4 inverse(float4x4 input)
			{
			    #define minor(a,b,c) determinant(float3x3(input.a, input.b, input.c))
			    //determinant(float3x3(input._22_23_23, input._32_33_34, input._42_43_44))
			 
			    float4x4 cofactors = float4x4(
			        minor(_22_23_24, _32_33_34, _42_43_44), 
			       -minor(_21_23_24, _31_33_34, _41_43_44),
			        minor(_21_22_24, _31_32_34, _41_42_44),
			       -minor(_21_22_23, _31_32_33, _41_42_43),
			 
			       -minor(_12_13_14, _32_33_34, _42_43_44),
			        minor(_11_13_14, _31_33_34, _41_43_44),
			       -minor(_11_12_14, _31_32_34, _41_42_44),
			        minor(_11_12_13, _31_32_33, _41_42_43),
			 
			        minor(_12_13_14, _22_23_24, _42_43_44),
			       -minor(_11_13_14, _21_23_24, _41_43_44),
			        minor(_11_12_14, _21_22_24, _41_42_44),
			       -minor(_11_12_13, _21_22_23, _41_42_43),
			 
			       -minor(_12_13_14, _22_23_24, _32_33_34),
			        minor(_11_13_14, _21_23_24, _31_33_34),
			       -minor(_11_12_14, _21_22_24, _31_32_34),
			        minor(_11_12_13, _21_22_23, _31_32_33)
			    );
			    #undef minor
			    return transpose(cofactors) / determinant(input);
			}	

			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos = float4(v.vertex.xy*2,1,1);
				o.dir = mul(inverse(UNITY_MATRIX_VP), o.pos);
				return o;
			}

			fixed4 frag(v2f i): COLOR
			{
				fixed4 tex = texCUBE(_Skybox, i.dir);
				return tex;
			}
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
