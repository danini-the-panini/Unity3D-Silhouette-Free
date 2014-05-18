Shader "Custom/GroundShader" {
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Main Colour (RGB)", Color) = (1,1,1,1)
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"
	
	struct v2f {
		float4 pos:	SV_POSITION;
		half2 uv:	TEXCOORD0;
	};
	
	sampler2D _MainTex;
	fixed4 _Color;
	
	ENDCG
	
	SubShader
	{
		Tags 
		{ 
			"RenderType"="Opaque" 
			"Queue"="Geometry-5"
		}
		
		LOD 200
		
		Blend OneMinusDstColor Zero, One Zero
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma multi_compile_fwdbase

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb * _Color;
		}
		ENDCG
	}
	FallBack "Diffuse"
}