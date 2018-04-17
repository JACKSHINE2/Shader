Shader "test/15_Wave"
{
	Properties
	{
		
		_MainTex ("Texture", 2D) = "gray" {}
		_Arange("Maxhight",float) = 1
		_Color("Color",color) = (0.5,0.5,0.5,0.5)
		_Frequency("Frequency",float) = 1
		_Speed("Speed",float) = 1
	}
	SubShader
	{
		

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			fixed _Arange;
			fixed _Frequency;
			fixed _Speed;
			fixed4 _Color;

			v2f vert (a2v v)
			{

				//波动函数
				//y = A * sin(B * x + C)
				//A:波动峰值；B：周期数；C：与x相关的横向移动距离
				v2f f;

				fixed timer = _Time.y * _Speed;

				fixed waver = _Arange*sin(timer + v.vertex.x * _Frequency);

				v.vertex.y =  waver;

				f.vertex = UnityObjectToClipPos(v.vertex);
				f.uv = v.uv;
				return f;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				//UV滚动
				fixed2 tempUV = i.uv;

				tempUV.x += _Time.y;
				
				fixed4 col = tex2D(_MainTex, tempUV) + _Color;

				return col;
			}
			ENDCG
		}
	}
}
