//漫反射
Shader "test/05myDiffuseFragment"
{
	Properties
	{
		_Diffuse("DiffuseColor",Color) = (1,1,1,1)
	}
	SubShader
	{
		Pass
		{
			//1、定义LightMode，从而取得一些unity光照变量
			Tags{"LightMode" = "ForwardBase"}
			CGPROGRAM
			//2、引入Lighting.cginc Unity内置文件(这里类似命名空间)，这两部都需要有
			#include "Lighting.cginc" //取得第一个直射光的颜色 _LightColor0 ;第一个直射光的位置  _WorldSpaceLightPos0
			#pragma vertex vert			
			#pragma fragment frag
			float4 _Diffuse;

			//application to vertex 从应用到顶点
			struct a2v
			{
				//顶点坐标
				float4 vertex:POSITION;//通知Unity把模型空间下的顶点坐标赋值给vertex
				float3 normal:NORMAL;//通知Unity把模型空间下的法线坐标赋值给normal
			};


			struct v2f
			{
				float4 position : SV_POSITION; 

				fixed3 worldNormalDir:COLOR0;
			};
			
			v2f vert(a2v v)
			{		
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex); 

				f.worldNormalDir = mul(v.normal,(float3x3)unity_WorldToObject); 

				return f;
				
			}

			fixed4 frag(v2f f):SV_Target
			{

				//定义环境光（来源：Window\Lighting\Setting中的Environment Lighting Source）
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

				//法线方向           单位化向量   取得方向并将其从模型空间转换成世界空间（其中强制转化unity_WorldToObject成为一个3x3的矩阵）
				fixed3 normalDir = normalize(f.worldNormalDir);

				//光照方向         单位化向量     取得方向	
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);//对于每一个顶点来说，光的位置就是光的方向，因为光是平行光
				
				//漫反射函数 + 自身的颜色
				fixed3 diffuse = _LightColor0.rgb * max(dot(normalDir,lightDir),0) * _Diffuse.rgb;

				//漫反射 叠加 环境光
				fixed3 tempColor = diffuse + ambient;

				
				return fixed4(tempColor,1);
			}

			ENDCG

		}
	}
	Fallback "Diffuse"
}
