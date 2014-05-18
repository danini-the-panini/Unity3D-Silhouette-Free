Shader "Custom/SharkShader" {
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Main Colour (RGB)", Color) = (1,1,1,1)
		_Color2 ("Silhouette Colour (RGB)", Color) = (0,0,0,1)
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"
	#include "Lighting.cginc"
	#include "AutoLight.cginc"
	
	struct v2f_simple {
		float4 pos:			SV_POSITION;
		half2 uv:			TEXCOORD0;
	};
	
	struct v2f {
		float4 pos:			SV_POSITION;
		half2 uv:			TEXCOORD0;
		fixed3 light:		TEXCOORD1;
		LIGHTING_COORDS(2,3)
	};
	
	sampler2D _MainTex;
	fixed4 _Color;
	fixed4 _Color2;
	
	ENDCG
	
	SubShader
	{
		Tags 
		{ 
			"RenderType"="Transparent" 
			"Queue"="Geometry-10"
		}
		
		LOD 200
		
		Pass // Silhouette
		{
			//ZWrite Off
			//ZTest Greater
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase

			v2f_simple vert(appdata_full v)
			{
				v2f_simple o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord.xy;
				return o;
			}

			fixed4 frag(v2f_simple i): COLOR
			{
				fixed4 tex = tex2D(_MainTex, i.uv);
				return tex * _Color2;
			}
			ENDCG
		}
		
//		Pass // Above ground
//		{
//			Tags {
//				"LightMode" = "Vertex"
//			}
//			
//			CGPROGRAM
//			#pragma vertex vert
//			#pragma fragment frag
//			#pragma multi_compile_fwdbase
//
//			v2f vert(appdata_full v)
//			{
//				v2f o;
//				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
//				o.uv = v.texcoord.xy;
//
//				o.light = ShadeVertexLights(v.vertex, v.normal);
//
//				TRANSFER_VERTEX_TO_FRAGMENT(o);
//				
//				return o;
//			}
//
//			fixed4 frag(v2f i): COLOR
//			{
//				fixed4 tex = tex2D(_MainTex, i.uv);
//				
//				return tex * _Color * fixed4(i.light*2,1);
//			}
//			ENDCG
//		}
	}
	FallBack "VertexLit"
}