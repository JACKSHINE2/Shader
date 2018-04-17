Shader "test/15_Wave"
{
	Properties
	{
		
		_MainTex ("贴图", 2D) = "black" {}

		//振幅
		_Arange("Maxhight",float) = 1

		_Color("Color",color) = (0.5,0.5,0.5,0.5)

		//频率
		_Frequency("Frequency",float) = 1
		//流动速度
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

			fixed _Arange;
			fixed _Frequency;
			fixed _Speed;
			fixed4 _Color;
			sampler2D _MainTex;

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
			
			

			fixed4 frag (v2f i) : SV_Target
			{

				//定义环境光（来源：Window\Lighting\Setting中的Environment Lighting Source）
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

				fixed3 col = tex2D(_MainTex, i.uv) + _Color + ambient;

				return col;
			}
			ENDCG
		}
	}
}
