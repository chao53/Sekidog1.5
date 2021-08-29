Shader "Mr.Yellow/parAlpha Shader GraphV1"
    {
        Properties
        {
            [ToggleUI]Boolean_30e886e85c17475385b1785a2f2b7751("CustomData", Float) = 0
            _MainIntensity("MainIntensity", Float) = 1
            [HDR]_MainCollor("MainCollor", Color) = (1, 1, 1, 1)
            [NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
            Vector4_999f7726b91342a6888d2ed54673d9ff("Main Tiling add Offect", Vector) = (1, 1, 0, 0)
            [NoScaleOffset]_DisTex("DisTex", 2D) = "white" {}
            Vector4_557daace24cb4636a4af16509914c72f("DisTilingAddOffect", Vector) = (1, 1, 0, 0)
            _DisTexSpeed("DisTexSpeed", Vector) = (0, 0, 0, 0)
            _DisTexStep("DisTexStep", Float) = 0.1
            _DisTexStepSmooth("DisTexStepSmooth", Float) = 0.01
            [NoScaleOffset]_SwirlTex("SwirlTex", 2D) = "white" {}
            Vector4_fa3fd3eed3404b58ba226241379c2120("SwirlTillingAddOffect", Vector) = (1, 1, 0, 0)
            _SwirlIntensity("SwirlIntensity", Float) = 0.1
            _SwirlSpeed("SwirlSpeed", Vector) = (1, 0, 0, 0)
            [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
            [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
            [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
        }
        SubShader
        {
            Tags
            {
                "RenderPipeline"="UniversalPipeline"
                "RenderType"="Transparent"
                "UniversalMaterialType" = "Unlit"
                "Queue"="Transparent"
            }
            Pass
            {
                Name "Pass"
                Tags
                {
                    // LightMode: <None>
                }
    
                // Render State
                Cull Off
                Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                ZTest LEqual
                ZWrite Off
    
                // Debug
                // <None>
    
                // --------------------------------------------------
                // Pass
    
                HLSLPROGRAM
    
                // Pragmas
                #pragma target 2.0
                #pragma only_renderers gles gles3 glcore
                #pragma multi_compile_instancing
                #pragma multi_compile_fog
                #pragma vertex vert
                #pragma fragment frag
    
                // DotsInstancingOptions: <None>
                // HybridV1InjectedBuiltinProperties: <None>
    
                // Keywords
                #pragma multi_compile _ LIGHTMAP_ON
                #pragma multi_compile _ DIRLIGHTMAP_COMBINED
                #pragma shader_feature _ _SAMPLE_GI
                // GraphKeywords: <None>
    
                // Defines
                #define _SURFACE_TYPE_TRANSPARENT 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define ATTRIBUTES_NEED_COLOR
                #define VARYINGS_NEED_TEXCOORD0
                #define VARYINGS_NEED_COLOR
                #define FEATURES_GRAPH_VERTEX
                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                #define SHADERPASS SHADERPASS_UNLIT
                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
    
                // Includes
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    
                // --------------------------------------------------
                // Structs and Packing
    
                struct Attributes
                {
                    float3 positionOS : POSITION;
                    float3 normalOS : NORMAL;
                    float4 tangentOS : TANGENT;
                    float4 uv0 : TEXCOORD0;
                    float4 color : COLOR;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                    float4 positionCS : SV_POSITION;
                    float4 texCoord0;
                    float4 color;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                    float4 uv0;
                    float4 VertexColor;
                    float3 TimeParameters;
                };
                struct VertexDescriptionInputs
                {
                    float3 ObjectSpaceNormal;
                    float3 ObjectSpaceTangent;
                    float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                    float4 positionCS : SV_POSITION;
                    float4 interp0 : TEXCOORD0;
                    float4 interp1 : TEXCOORD1;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
    
                PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    output.positionCS = input.positionCS;
                    output.interp0.xyzw =  input.texCoord0;
                    output.interp1.xyzw =  input.color;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.interp0.xyzw;
                    output.color = input.interp1.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
    
                // --------------------------------------------------
                // Graph
    
                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                float Boolean_30e886e85c17475385b1785a2f2b7751;
                float _MainIntensity;
                float4 _MainCollor;
                float4 _MainTex_TexelSize;
                float4 Vector4_999f7726b91342a6888d2ed54673d9ff;
                float4 _DisTex_TexelSize;
                float4 Vector4_557daace24cb4636a4af16509914c72f;
                float4 _DisTexSpeed;
                float _DisTexStep;
                float _DisTexStepSmooth;
                float4 _SwirlTex_TexelSize;
                float4 Vector4_fa3fd3eed3404b58ba226241379c2120;
                float _SwirlIntensity;
                float4 _SwirlSpeed;
                CBUFFER_END
                
                // Object and Global properties
                TEXTURE2D(_MainTex);
                SAMPLER(sampler_MainTex);
                TEXTURE2D(_DisTex);
                SAMPLER(sampler_DisTex);
                TEXTURE2D(_SwirlTex);
                SAMPLER(sampler_SwirlTex);
                SAMPLER(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_Sampler_3_Linear_Repeat);
                SAMPLER(_SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_Sampler_3_Linear_Repeat);
                SAMPLER(_SampleTexture2D_87ad03c8523043feb564e133e3472445_Sampler_3_Linear_Repeat);
    
                // Graph Functions
                
                void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                {
                    RGBA = float4(R, G, B, A);
                    RGB = float3(R, G, B);
                    RG = float2(R, G);
                }
                
                void Unity_Add_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A + B;
                }
                
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_InverseLerp_float(float A, float B, float T, out float Out)
                {
                    Out = (T - A)/(B - A);
                }
                
                void Unity_Step_float(float Edge, float In, out float Out)
                {
                    Out = step(Edge, In);
                }
                
                void Unity_OneMinus_float(float In, out float Out)
                {
                    Out = 1 - In;
                }
                
                void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                {
                    Out = clamp(In, Min, Max);
                }
    
                // Graph Vertex
                struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
    
                // Graph Pixel
                struct SurfaceDescription
                {
                    float3 BaseColor;
                    float Alpha;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float4 _Property_88dbfc584015420a91ab078ecb181d3e_Out_0 = IsGammaSpace() ? LinearToSRGB(_MainCollor) : _MainCollor;
                    float4 _Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2;
                    Unity_Multiply_float(IN.VertexColor, _Property_88dbfc584015420a91ab078ecb181d3e_Out_0, _Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2);
                    float4 _Property_22ca7a64481949828913445ec861165e_Out_0 = Vector4_fa3fd3eed3404b58ba226241379c2120;
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_R_1 = _Property_22ca7a64481949828913445ec861165e_Out_0[0];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_G_2 = _Property_22ca7a64481949828913445ec861165e_Out_0[1];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_B_3 = _Property_22ca7a64481949828913445ec861165e_Out_0[2];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_A_4 = _Property_22ca7a64481949828913445ec861165e_Out_0[3];
                    float4 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGBA_4;
                    float3 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGB_5;
                    float2 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6;
                    Unity_Combine_float(_Split_05f0711b20a7491d9617ab9e43ba41b2_R_1, _Split_05f0711b20a7491d9617ab9e43ba41b2_G_2, 0, 0, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGBA_4, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGB_5, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6);
                    float4 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGBA_4;
                    float3 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGB_5;
                    float2 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6;
                    Unity_Combine_float(_Split_05f0711b20a7491d9617ab9e43ba41b2_B_3, _Split_05f0711b20a7491d9617ab9e43ba41b2_A_4, 0, 0, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGBA_4, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGB_5, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6);
                    float4 _Property_f00725938eb045f5ba39edd01bc23705_Out_0 = _SwirlSpeed;
                    float4 _Multiply_fac423eabd3946ba86caf163f2d73945_Out_2;
                    Unity_Multiply_float(_Property_f00725938eb045f5ba39edd01bc23705_Out_0, (IN.TimeParameters.x.xxxx), _Multiply_fac423eabd3946ba86caf163f2d73945_Out_2);
                    float2 _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2;
                    Unity_Add_float2(_Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6, (_Multiply_fac423eabd3946ba86caf163f2d73945_Out_2.xy), _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2);
                    float2 _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6, _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2, _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3);
                    float4 _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0 = SAMPLE_TEXTURE2D(_SwirlTex, sampler_SwirlTex, _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3);
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_R_4 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.r;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_G_5 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.g;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_B_6 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.b;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_A_7 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.a;
                    float _Add_dd29f5fda32448acb74552905c3d6d03_Out_2;
                    Unity_Add_float(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_R_4, _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_G_5, _Add_dd29f5fda32448acb74552905c3d6d03_Out_2);
                    float _Add_19b5251886274c22919c08b6bccb38e8_Out_2;
                    Unity_Add_float(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_B_6, _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_A_7, _Add_19b5251886274c22919c08b6bccb38e8_Out_2);
                    float _Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2;
                    Unity_Add_float(_Add_dd29f5fda32448acb74552905c3d6d03_Out_2, _Add_19b5251886274c22919c08b6bccb38e8_Out_2, _Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2);
                    float _Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2;
                    Unity_Divide_float(_Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2, 4, _Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2);
                    float _Property_0a2a70c33cb546dd9bdac20429a65b8c_Out_0 = _SwirlIntensity;
                    float _Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2;
                    Unity_Multiply_float(_Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2, _Property_0a2a70c33cb546dd9bdac20429a65b8c_Out_0, _Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2);
                    float4 _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0 = Vector4_999f7726b91342a6888d2ed54673d9ff;
                    float _Split_d851a2a2325a41f0b553937e4925c29a_R_1 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[0];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_G_2 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[1];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_B_3 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[2];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_A_4 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[3];
                    float4 _Combine_3596f49c4a334ab4a5040b2bea265bab_RGBA_4;
                    float3 _Combine_3596f49c4a334ab4a5040b2bea265bab_RGB_5;
                    float2 _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6;
                    Unity_Combine_float(_Split_d851a2a2325a41f0b553937e4925c29a_R_1, _Split_d851a2a2325a41f0b553937e4925c29a_G_2, 0, 0, _Combine_3596f49c4a334ab4a5040b2bea265bab_RGBA_4, _Combine_3596f49c4a334ab4a5040b2bea265bab_RGB_5, _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6);
                    float2 _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2;
                    Unity_Add_float2((_Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2.xx), _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6, _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2);
                    float4 _Combine_d1605ba853a949c9a31366a54ca24223_RGBA_4;
                    float3 _Combine_d1605ba853a949c9a31366a54ca24223_RGB_5;
                    float2 _Combine_d1605ba853a949c9a31366a54ca24223_RG_6;
                    Unity_Combine_float(_Split_d851a2a2325a41f0b553937e4925c29a_B_3, _Split_d851a2a2325a41f0b553937e4925c29a_A_4, 0, 0, _Combine_d1605ba853a949c9a31366a54ca24223_RGBA_4, _Combine_d1605ba853a949c9a31366a54ca24223_RGB_5, _Combine_d1605ba853a949c9a31366a54ca24223_RG_6);
                    float2 _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2, _Combine_d1605ba853a949c9a31366a54ca24223_RG_6, _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3);
                    float4 _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3);
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_R_4 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.r;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_G_5 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.g;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_B_6 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.b;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_A_7 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.a;
                    float4 _Multiply_4eba5955b09345558e792fe0232a0551_Out_2;
                    Unity_Multiply_float(_Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2, _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0, _Multiply_4eba5955b09345558e792fe0232a0551_Out_2);
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_R_1 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[0];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_G_2 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[1];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_B_3 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[2];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_A_4 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[3];
                    float _Property_7d3bdf602b99497eac7c62cb0a1de3b9_Out_0 = _DisTexStepSmooth;
                    float4 _Property_65268079add34c4e804825ec7a71efec_Out_0 = Vector4_557daace24cb4636a4af16509914c72f;
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_R_1 = _Property_65268079add34c4e804825ec7a71efec_Out_0[0];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_G_2 = _Property_65268079add34c4e804825ec7a71efec_Out_0[1];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_B_3 = _Property_65268079add34c4e804825ec7a71efec_Out_0[2];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_A_4 = _Property_65268079add34c4e804825ec7a71efec_Out_0[3];
                    float4 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGBA_4;
                    float3 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGB_5;
                    float2 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6;
                    Unity_Combine_float(_Split_2d06a5d7f5c849b89af1d9f0e06c48aa_R_1, _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_G_2, 0, 0, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGBA_4, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGB_5, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6);
                    float2 _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2;
                    Unity_Add_float2((_Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2.xx), _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6, _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2);
                    float4 _Combine_64df2bdcd9244910ba63c82359f35d21_RGBA_4;
                    float3 _Combine_64df2bdcd9244910ba63c82359f35d21_RGB_5;
                    float2 _Combine_64df2bdcd9244910ba63c82359f35d21_RG_6;
                    Unity_Combine_float(_Split_2d06a5d7f5c849b89af1d9f0e06c48aa_B_3, _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_A_4, 0, 0, _Combine_64df2bdcd9244910ba63c82359f35d21_RGBA_4, _Combine_64df2bdcd9244910ba63c82359f35d21_RGB_5, _Combine_64df2bdcd9244910ba63c82359f35d21_RG_6);
                    float4 _Property_2002f4ad45de4f3788ada633c47883ac_Out_0 = _DisTexSpeed;
                    float4 _Multiply_0b54c1894cce468ea71310c555797e69_Out_2;
                    Unity_Multiply_float(_Property_2002f4ad45de4f3788ada633c47883ac_Out_0, (IN.TimeParameters.x.xxxx), _Multiply_0b54c1894cce468ea71310c555797e69_Out_2);
                    float2 _Add_385457bd7bcf4d69a7735f97024bab24_Out_2;
                    Unity_Add_float2(_Combine_64df2bdcd9244910ba63c82359f35d21_RG_6, (_Multiply_0b54c1894cce468ea71310c555797e69_Out_2.xy), _Add_385457bd7bcf4d69a7735f97024bab24_Out_2);
                    float2 _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2, _Add_385457bd7bcf4d69a7735f97024bab24_Out_2, _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3);
                    float4 _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0 = SAMPLE_TEXTURE2D(_DisTex, sampler_DisTex, _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3);
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_R_4 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.r;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_G_5 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.g;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_B_6 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.b;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_A_7 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.a;
                    float _Add_bbd2209640b14872ae2f0c64037f56c5_Out_2;
                    Unity_Add_float(_SampleTexture2D_87ad03c8523043feb564e133e3472445_R_4, _SampleTexture2D_87ad03c8523043feb564e133e3472445_G_5, _Add_bbd2209640b14872ae2f0c64037f56c5_Out_2);
                    float _Add_5deebdc0a5f04cffab6096fd15406136_Out_2;
                    Unity_Add_float(_SampleTexture2D_87ad03c8523043feb564e133e3472445_B_6, _SampleTexture2D_87ad03c8523043feb564e133e3472445_A_7, _Add_5deebdc0a5f04cffab6096fd15406136_Out_2);
                    float _Add_8c567749c0f34604bf3146789ac90c01_Out_2;
                    Unity_Add_float(_Add_bbd2209640b14872ae2f0c64037f56c5_Out_2, _Add_5deebdc0a5f04cffab6096fd15406136_Out_2, _Add_8c567749c0f34604bf3146789ac90c01_Out_2);
                    float _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2;
                    Unity_Divide_float(_Add_8c567749c0f34604bf3146789ac90c01_Out_2, 4, _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2);
                    float _InverseLerp_ed66297faaa94174809a4c827835fead_Out_3;
                    Unity_InverseLerp_float(_Property_7d3bdf602b99497eac7c62cb0a1de3b9_Out_0, 1.1, _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2, _InverseLerp_ed66297faaa94174809a4c827835fead_Out_3);
                    float _Property_11fb25c356ce4fde9c81bd1c907e3cc0_Out_0 = _DisTexStep;
                    float _Step_b808e6940eb14a9dbd1374f8f9528664_Out_2;
                    Unity_Step_float(_Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2, _Property_11fb25c356ce4fde9c81bd1c907e3cc0_Out_0, _Step_b808e6940eb14a9dbd1374f8f9528664_Out_2);
                    float _OneMinus_a0c152641255443596271035468f6786_Out_1;
                    Unity_OneMinus_float(_Step_b808e6940eb14a9dbd1374f8f9528664_Out_2, _OneMinus_a0c152641255443596271035468f6786_Out_1);
                    float _Multiply_472de54326b84979813b985add57417b_Out_2;
                    Unity_Multiply_float(_InverseLerp_ed66297faaa94174809a4c827835fead_Out_3, _OneMinus_a0c152641255443596271035468f6786_Out_1, _Multiply_472de54326b84979813b985add57417b_Out_2);
                    float _Multiply_e6931bda90fe4fd09db32135618f544f_Out_2;
                    Unity_Multiply_float(_Split_6d41ccf4305240b7ba29e0d66c8d0a2b_A_4, _Multiply_472de54326b84979813b985add57417b_Out_2, _Multiply_e6931bda90fe4fd09db32135618f544f_Out_2);
                    float _Clamp_777ce98db01a49169ebede34e361ea37_Out_3;
                    Unity_Clamp_float(_Multiply_e6931bda90fe4fd09db32135618f544f_Out_2, 0, 1, _Clamp_777ce98db01a49169ebede34e361ea37_Out_3);
                    surface.BaseColor = (_Multiply_4eba5955b09345558e792fe0232a0551_Out_2.xyz);
                    surface.Alpha = _Clamp_777ce98db01a49169ebede34e361ea37_Out_3;
                    return surface;
                }
    
                // --------------------------------------------------
                // Build Graph Inputs
    
                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =           input.normalOS;
                    output.ObjectSpaceTangent =          input.tangentOS;
                    output.ObjectSpacePosition =         input.positionOS;
                
                    return output;
                }
                
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                
                
                
                
                    output.uv0 =                         input.texCoord0;
                    output.VertexColor =                 input.color;
                    output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                    return output;
                }
                
    
                // --------------------------------------------------
                // Main
    
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
    
                ENDHLSL
            }
            Pass
            {
                Name "ShadowCaster"
                Tags
                {
                    "LightMode" = "ShadowCaster"
                }
    
                // Render State
                Cull Off
                Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                ZTest LEqual
                ZWrite On
                ColorMask 0
    
                // Debug
                // <None>
    
                // --------------------------------------------------
                // Pass
    
                HLSLPROGRAM
    
                // Pragmas
                #pragma target 2.0
                #pragma only_renderers gles gles3 glcore
                #pragma multi_compile_instancing
                #pragma vertex vert
                #pragma fragment frag
    
                // DotsInstancingOptions: <None>
                // HybridV1InjectedBuiltinProperties: <None>
    
                // Keywords
                // PassKeywords: <None>
                // GraphKeywords: <None>
    
                // Defines
                #define _SURFACE_TYPE_TRANSPARENT 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define ATTRIBUTES_NEED_COLOR
                #define VARYINGS_NEED_TEXCOORD0
                #define VARYINGS_NEED_COLOR
                #define FEATURES_GRAPH_VERTEX
                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                #define SHADERPASS SHADERPASS_SHADOWCASTER
                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
    
                // Includes
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    
                // --------------------------------------------------
                // Structs and Packing
    
                struct Attributes
                {
                    float3 positionOS : POSITION;
                    float3 normalOS : NORMAL;
                    float4 tangentOS : TANGENT;
                    float4 uv0 : TEXCOORD0;
                    float4 color : COLOR;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                    float4 positionCS : SV_POSITION;
                    float4 texCoord0;
                    float4 color;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                    float4 uv0;
                    float4 VertexColor;
                    float3 TimeParameters;
                };
                struct VertexDescriptionInputs
                {
                    float3 ObjectSpaceNormal;
                    float3 ObjectSpaceTangent;
                    float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                    float4 positionCS : SV_POSITION;
                    float4 interp0 : TEXCOORD0;
                    float4 interp1 : TEXCOORD1;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
    
                PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    output.positionCS = input.positionCS;
                    output.interp0.xyzw =  input.texCoord0;
                    output.interp1.xyzw =  input.color;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.interp0.xyzw;
                    output.color = input.interp1.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
    
                // --------------------------------------------------
                // Graph
    
                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                float Boolean_30e886e85c17475385b1785a2f2b7751;
                float _MainIntensity;
                float4 _MainCollor;
                float4 _MainTex_TexelSize;
                float4 Vector4_999f7726b91342a6888d2ed54673d9ff;
                float4 _DisTex_TexelSize;
                float4 Vector4_557daace24cb4636a4af16509914c72f;
                float4 _DisTexSpeed;
                float _DisTexStep;
                float _DisTexStepSmooth;
                float4 _SwirlTex_TexelSize;
                float4 Vector4_fa3fd3eed3404b58ba226241379c2120;
                float _SwirlIntensity;
                float4 _SwirlSpeed;
                CBUFFER_END
                
                // Object and Global properties
                TEXTURE2D(_MainTex);
                SAMPLER(sampler_MainTex);
                TEXTURE2D(_DisTex);
                SAMPLER(sampler_DisTex);
                TEXTURE2D(_SwirlTex);
                SAMPLER(sampler_SwirlTex);
                SAMPLER(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_Sampler_3_Linear_Repeat);
                SAMPLER(_SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_Sampler_3_Linear_Repeat);
                SAMPLER(_SampleTexture2D_87ad03c8523043feb564e133e3472445_Sampler_3_Linear_Repeat);
    
                // Graph Functions
                
                void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                {
                    RGBA = float4(R, G, B, A);
                    RGB = float3(R, G, B);
                    RG = float2(R, G);
                }
                
                void Unity_Add_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A + B;
                }
                
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_InverseLerp_float(float A, float B, float T, out float Out)
                {
                    Out = (T - A)/(B - A);
                }
                
                void Unity_Step_float(float Edge, float In, out float Out)
                {
                    Out = step(Edge, In);
                }
                
                void Unity_OneMinus_float(float In, out float Out)
                {
                    Out = 1 - In;
                }
                
                void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                {
                    Out = clamp(In, Min, Max);
                }
    
                // Graph Vertex
                struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
    
                // Graph Pixel
                struct SurfaceDescription
                {
                    float Alpha;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float4 _Property_88dbfc584015420a91ab078ecb181d3e_Out_0 = IsGammaSpace() ? LinearToSRGB(_MainCollor) : _MainCollor;
                    float4 _Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2;
                    Unity_Multiply_float(IN.VertexColor, _Property_88dbfc584015420a91ab078ecb181d3e_Out_0, _Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2);
                    float4 _Property_22ca7a64481949828913445ec861165e_Out_0 = Vector4_fa3fd3eed3404b58ba226241379c2120;
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_R_1 = _Property_22ca7a64481949828913445ec861165e_Out_0[0];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_G_2 = _Property_22ca7a64481949828913445ec861165e_Out_0[1];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_B_3 = _Property_22ca7a64481949828913445ec861165e_Out_0[2];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_A_4 = _Property_22ca7a64481949828913445ec861165e_Out_0[3];
                    float4 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGBA_4;
                    float3 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGB_5;
                    float2 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6;
                    Unity_Combine_float(_Split_05f0711b20a7491d9617ab9e43ba41b2_R_1, _Split_05f0711b20a7491d9617ab9e43ba41b2_G_2, 0, 0, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGBA_4, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGB_5, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6);
                    float4 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGBA_4;
                    float3 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGB_5;
                    float2 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6;
                    Unity_Combine_float(_Split_05f0711b20a7491d9617ab9e43ba41b2_B_3, _Split_05f0711b20a7491d9617ab9e43ba41b2_A_4, 0, 0, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGBA_4, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGB_5, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6);
                    float4 _Property_f00725938eb045f5ba39edd01bc23705_Out_0 = _SwirlSpeed;
                    float4 _Multiply_fac423eabd3946ba86caf163f2d73945_Out_2;
                    Unity_Multiply_float(_Property_f00725938eb045f5ba39edd01bc23705_Out_0, (IN.TimeParameters.x.xxxx), _Multiply_fac423eabd3946ba86caf163f2d73945_Out_2);
                    float2 _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2;
                    Unity_Add_float2(_Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6, (_Multiply_fac423eabd3946ba86caf163f2d73945_Out_2.xy), _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2);
                    float2 _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6, _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2, _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3);
                    float4 _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0 = SAMPLE_TEXTURE2D(_SwirlTex, sampler_SwirlTex, _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3);
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_R_4 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.r;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_G_5 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.g;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_B_6 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.b;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_A_7 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.a;
                    float _Add_dd29f5fda32448acb74552905c3d6d03_Out_2;
                    Unity_Add_float(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_R_4, _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_G_5, _Add_dd29f5fda32448acb74552905c3d6d03_Out_2);
                    float _Add_19b5251886274c22919c08b6bccb38e8_Out_2;
                    Unity_Add_float(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_B_6, _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_A_7, _Add_19b5251886274c22919c08b6bccb38e8_Out_2);
                    float _Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2;
                    Unity_Add_float(_Add_dd29f5fda32448acb74552905c3d6d03_Out_2, _Add_19b5251886274c22919c08b6bccb38e8_Out_2, _Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2);
                    float _Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2;
                    Unity_Divide_float(_Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2, 4, _Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2);
                    float _Property_0a2a70c33cb546dd9bdac20429a65b8c_Out_0 = _SwirlIntensity;
                    float _Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2;
                    Unity_Multiply_float(_Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2, _Property_0a2a70c33cb546dd9bdac20429a65b8c_Out_0, _Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2);
                    float4 _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0 = Vector4_999f7726b91342a6888d2ed54673d9ff;
                    float _Split_d851a2a2325a41f0b553937e4925c29a_R_1 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[0];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_G_2 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[1];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_B_3 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[2];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_A_4 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[3];
                    float4 _Combine_3596f49c4a334ab4a5040b2bea265bab_RGBA_4;
                    float3 _Combine_3596f49c4a334ab4a5040b2bea265bab_RGB_5;
                    float2 _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6;
                    Unity_Combine_float(_Split_d851a2a2325a41f0b553937e4925c29a_R_1, _Split_d851a2a2325a41f0b553937e4925c29a_G_2, 0, 0, _Combine_3596f49c4a334ab4a5040b2bea265bab_RGBA_4, _Combine_3596f49c4a334ab4a5040b2bea265bab_RGB_5, _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6);
                    float2 _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2;
                    Unity_Add_float2((_Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2.xx), _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6, _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2);
                    float4 _Combine_d1605ba853a949c9a31366a54ca24223_RGBA_4;
                    float3 _Combine_d1605ba853a949c9a31366a54ca24223_RGB_5;
                    float2 _Combine_d1605ba853a949c9a31366a54ca24223_RG_6;
                    Unity_Combine_float(_Split_d851a2a2325a41f0b553937e4925c29a_B_3, _Split_d851a2a2325a41f0b553937e4925c29a_A_4, 0, 0, _Combine_d1605ba853a949c9a31366a54ca24223_RGBA_4, _Combine_d1605ba853a949c9a31366a54ca24223_RGB_5, _Combine_d1605ba853a949c9a31366a54ca24223_RG_6);
                    float2 _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2, _Combine_d1605ba853a949c9a31366a54ca24223_RG_6, _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3);
                    float4 _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3);
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_R_4 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.r;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_G_5 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.g;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_B_6 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.b;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_A_7 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.a;
                    float4 _Multiply_4eba5955b09345558e792fe0232a0551_Out_2;
                    Unity_Multiply_float(_Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2, _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0, _Multiply_4eba5955b09345558e792fe0232a0551_Out_2);
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_R_1 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[0];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_G_2 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[1];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_B_3 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[2];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_A_4 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[3];
                    float _Property_7d3bdf602b99497eac7c62cb0a1de3b9_Out_0 = _DisTexStepSmooth;
                    float4 _Property_65268079add34c4e804825ec7a71efec_Out_0 = Vector4_557daace24cb4636a4af16509914c72f;
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_R_1 = _Property_65268079add34c4e804825ec7a71efec_Out_0[0];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_G_2 = _Property_65268079add34c4e804825ec7a71efec_Out_0[1];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_B_3 = _Property_65268079add34c4e804825ec7a71efec_Out_0[2];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_A_4 = _Property_65268079add34c4e804825ec7a71efec_Out_0[3];
                    float4 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGBA_4;
                    float3 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGB_5;
                    float2 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6;
                    Unity_Combine_float(_Split_2d06a5d7f5c849b89af1d9f0e06c48aa_R_1, _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_G_2, 0, 0, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGBA_4, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGB_5, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6);
                    float2 _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2;
                    Unity_Add_float2((_Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2.xx), _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6, _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2);
                    float4 _Combine_64df2bdcd9244910ba63c82359f35d21_RGBA_4;
                    float3 _Combine_64df2bdcd9244910ba63c82359f35d21_RGB_5;
                    float2 _Combine_64df2bdcd9244910ba63c82359f35d21_RG_6;
                    Unity_Combine_float(_Split_2d06a5d7f5c849b89af1d9f0e06c48aa_B_3, _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_A_4, 0, 0, _Combine_64df2bdcd9244910ba63c82359f35d21_RGBA_4, _Combine_64df2bdcd9244910ba63c82359f35d21_RGB_5, _Combine_64df2bdcd9244910ba63c82359f35d21_RG_6);
                    float4 _Property_2002f4ad45de4f3788ada633c47883ac_Out_0 = _DisTexSpeed;
                    float4 _Multiply_0b54c1894cce468ea71310c555797e69_Out_2;
                    Unity_Multiply_float(_Property_2002f4ad45de4f3788ada633c47883ac_Out_0, (IN.TimeParameters.x.xxxx), _Multiply_0b54c1894cce468ea71310c555797e69_Out_2);
                    float2 _Add_385457bd7bcf4d69a7735f97024bab24_Out_2;
                    Unity_Add_float2(_Combine_64df2bdcd9244910ba63c82359f35d21_RG_6, (_Multiply_0b54c1894cce468ea71310c555797e69_Out_2.xy), _Add_385457bd7bcf4d69a7735f97024bab24_Out_2);
                    float2 _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2, _Add_385457bd7bcf4d69a7735f97024bab24_Out_2, _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3);
                    float4 _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0 = SAMPLE_TEXTURE2D(_DisTex, sampler_DisTex, _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3);
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_R_4 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.r;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_G_5 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.g;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_B_6 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.b;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_A_7 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.a;
                    float _Add_bbd2209640b14872ae2f0c64037f56c5_Out_2;
                    Unity_Add_float(_SampleTexture2D_87ad03c8523043feb564e133e3472445_R_4, _SampleTexture2D_87ad03c8523043feb564e133e3472445_G_5, _Add_bbd2209640b14872ae2f0c64037f56c5_Out_2);
                    float _Add_5deebdc0a5f04cffab6096fd15406136_Out_2;
                    Unity_Add_float(_SampleTexture2D_87ad03c8523043feb564e133e3472445_B_6, _SampleTexture2D_87ad03c8523043feb564e133e3472445_A_7, _Add_5deebdc0a5f04cffab6096fd15406136_Out_2);
                    float _Add_8c567749c0f34604bf3146789ac90c01_Out_2;
                    Unity_Add_float(_Add_bbd2209640b14872ae2f0c64037f56c5_Out_2, _Add_5deebdc0a5f04cffab6096fd15406136_Out_2, _Add_8c567749c0f34604bf3146789ac90c01_Out_2);
                    float _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2;
                    Unity_Divide_float(_Add_8c567749c0f34604bf3146789ac90c01_Out_2, 4, _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2);
                    float _InverseLerp_ed66297faaa94174809a4c827835fead_Out_3;
                    Unity_InverseLerp_float(_Property_7d3bdf602b99497eac7c62cb0a1de3b9_Out_0, 1.1, _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2, _InverseLerp_ed66297faaa94174809a4c827835fead_Out_3);
                    float _Property_11fb25c356ce4fde9c81bd1c907e3cc0_Out_0 = _DisTexStep;
                    float _Step_b808e6940eb14a9dbd1374f8f9528664_Out_2;
                    Unity_Step_float(_Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2, _Property_11fb25c356ce4fde9c81bd1c907e3cc0_Out_0, _Step_b808e6940eb14a9dbd1374f8f9528664_Out_2);
                    float _OneMinus_a0c152641255443596271035468f6786_Out_1;
                    Unity_OneMinus_float(_Step_b808e6940eb14a9dbd1374f8f9528664_Out_2, _OneMinus_a0c152641255443596271035468f6786_Out_1);
                    float _Multiply_472de54326b84979813b985add57417b_Out_2;
                    Unity_Multiply_float(_InverseLerp_ed66297faaa94174809a4c827835fead_Out_3, _OneMinus_a0c152641255443596271035468f6786_Out_1, _Multiply_472de54326b84979813b985add57417b_Out_2);
                    float _Multiply_e6931bda90fe4fd09db32135618f544f_Out_2;
                    Unity_Multiply_float(_Split_6d41ccf4305240b7ba29e0d66c8d0a2b_A_4, _Multiply_472de54326b84979813b985add57417b_Out_2, _Multiply_e6931bda90fe4fd09db32135618f544f_Out_2);
                    float _Clamp_777ce98db01a49169ebede34e361ea37_Out_3;
                    Unity_Clamp_float(_Multiply_e6931bda90fe4fd09db32135618f544f_Out_2, 0, 1, _Clamp_777ce98db01a49169ebede34e361ea37_Out_3);
                    surface.Alpha = _Clamp_777ce98db01a49169ebede34e361ea37_Out_3;
                    return surface;
                }
    
                // --------------------------------------------------
                // Build Graph Inputs
    
                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =           input.normalOS;
                    output.ObjectSpaceTangent =          input.tangentOS;
                    output.ObjectSpacePosition =         input.positionOS;
                
                    return output;
                }
                
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                
                
                
                
                    output.uv0 =                         input.texCoord0;
                    output.VertexColor =                 input.color;
                    output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                    return output;
                }
                
    
                // --------------------------------------------------
                // Main
    
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
    
                ENDHLSL
            }
            Pass
            {
                Name "DepthOnly"
                Tags
                {
                    "LightMode" = "DepthOnly"
                }
    
                // Render State
                Cull Off
                Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                ZTest LEqual
                ZWrite On
                ColorMask 0
    
                // Debug
                // <None>
    
                // --------------------------------------------------
                // Pass
    
                HLSLPROGRAM
    
                // Pragmas
                #pragma target 2.0
                #pragma only_renderers gles gles3 glcore
                #pragma multi_compile_instancing
                #pragma vertex vert
                #pragma fragment frag
    
                // DotsInstancingOptions: <None>
                // HybridV1InjectedBuiltinProperties: <None>
    
                // Keywords
                // PassKeywords: <None>
                // GraphKeywords: <None>
    
                // Defines
                #define _SURFACE_TYPE_TRANSPARENT 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define ATTRIBUTES_NEED_COLOR
                #define VARYINGS_NEED_TEXCOORD0
                #define VARYINGS_NEED_COLOR
                #define FEATURES_GRAPH_VERTEX
                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                #define SHADERPASS SHADERPASS_DEPTHONLY
                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
    
                // Includes
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    
                // --------------------------------------------------
                // Structs and Packing
    
                struct Attributes
                {
                    float3 positionOS : POSITION;
                    float3 normalOS : NORMAL;
                    float4 tangentOS : TANGENT;
                    float4 uv0 : TEXCOORD0;
                    float4 color : COLOR;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                    float4 positionCS : SV_POSITION;
                    float4 texCoord0;
                    float4 color;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                    float4 uv0;
                    float4 VertexColor;
                    float3 TimeParameters;
                };
                struct VertexDescriptionInputs
                {
                    float3 ObjectSpaceNormal;
                    float3 ObjectSpaceTangent;
                    float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                    float4 positionCS : SV_POSITION;
                    float4 interp0 : TEXCOORD0;
                    float4 interp1 : TEXCOORD1;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
    
                PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    output.positionCS = input.positionCS;
                    output.interp0.xyzw =  input.texCoord0;
                    output.interp1.xyzw =  input.color;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.interp0.xyzw;
                    output.color = input.interp1.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
    
                // --------------------------------------------------
                // Graph
    
                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                float Boolean_30e886e85c17475385b1785a2f2b7751;
                float _MainIntensity;
                float4 _MainCollor;
                float4 _MainTex_TexelSize;
                float4 Vector4_999f7726b91342a6888d2ed54673d9ff;
                float4 _DisTex_TexelSize;
                float4 Vector4_557daace24cb4636a4af16509914c72f;
                float4 _DisTexSpeed;
                float _DisTexStep;
                float _DisTexStepSmooth;
                float4 _SwirlTex_TexelSize;
                float4 Vector4_fa3fd3eed3404b58ba226241379c2120;
                float _SwirlIntensity;
                float4 _SwirlSpeed;
                CBUFFER_END
                
                // Object and Global properties
                TEXTURE2D(_MainTex);
                SAMPLER(sampler_MainTex);
                TEXTURE2D(_DisTex);
                SAMPLER(sampler_DisTex);
                TEXTURE2D(_SwirlTex);
                SAMPLER(sampler_SwirlTex);
                SAMPLER(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_Sampler_3_Linear_Repeat);
                SAMPLER(_SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_Sampler_3_Linear_Repeat);
                SAMPLER(_SampleTexture2D_87ad03c8523043feb564e133e3472445_Sampler_3_Linear_Repeat);
    
                // Graph Functions
                
                void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                {
                    RGBA = float4(R, G, B, A);
                    RGB = float3(R, G, B);
                    RG = float2(R, G);
                }
                
                void Unity_Add_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A + B;
                }
                
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_InverseLerp_float(float A, float B, float T, out float Out)
                {
                    Out = (T - A)/(B - A);
                }
                
                void Unity_Step_float(float Edge, float In, out float Out)
                {
                    Out = step(Edge, In);
                }
                
                void Unity_OneMinus_float(float In, out float Out)
                {
                    Out = 1 - In;
                }
                
                void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                {
                    Out = clamp(In, Min, Max);
                }
    
                // Graph Vertex
                struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
    
                // Graph Pixel
                struct SurfaceDescription
                {
                    float Alpha;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float4 _Property_88dbfc584015420a91ab078ecb181d3e_Out_0 = IsGammaSpace() ? LinearToSRGB(_MainCollor) : _MainCollor;
                    float4 _Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2;
                    Unity_Multiply_float(IN.VertexColor, _Property_88dbfc584015420a91ab078ecb181d3e_Out_0, _Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2);
                    float4 _Property_22ca7a64481949828913445ec861165e_Out_0 = Vector4_fa3fd3eed3404b58ba226241379c2120;
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_R_1 = _Property_22ca7a64481949828913445ec861165e_Out_0[0];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_G_2 = _Property_22ca7a64481949828913445ec861165e_Out_0[1];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_B_3 = _Property_22ca7a64481949828913445ec861165e_Out_0[2];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_A_4 = _Property_22ca7a64481949828913445ec861165e_Out_0[3];
                    float4 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGBA_4;
                    float3 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGB_5;
                    float2 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6;
                    Unity_Combine_float(_Split_05f0711b20a7491d9617ab9e43ba41b2_R_1, _Split_05f0711b20a7491d9617ab9e43ba41b2_G_2, 0, 0, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGBA_4, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGB_5, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6);
                    float4 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGBA_4;
                    float3 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGB_5;
                    float2 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6;
                    Unity_Combine_float(_Split_05f0711b20a7491d9617ab9e43ba41b2_B_3, _Split_05f0711b20a7491d9617ab9e43ba41b2_A_4, 0, 0, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGBA_4, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGB_5, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6);
                    float4 _Property_f00725938eb045f5ba39edd01bc23705_Out_0 = _SwirlSpeed;
                    float4 _Multiply_fac423eabd3946ba86caf163f2d73945_Out_2;
                    Unity_Multiply_float(_Property_f00725938eb045f5ba39edd01bc23705_Out_0, (IN.TimeParameters.x.xxxx), _Multiply_fac423eabd3946ba86caf163f2d73945_Out_2);
                    float2 _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2;
                    Unity_Add_float2(_Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6, (_Multiply_fac423eabd3946ba86caf163f2d73945_Out_2.xy), _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2);
                    float2 _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6, _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2, _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3);
                    float4 _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0 = SAMPLE_TEXTURE2D(_SwirlTex, sampler_SwirlTex, _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3);
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_R_4 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.r;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_G_5 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.g;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_B_6 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.b;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_A_7 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.a;
                    float _Add_dd29f5fda32448acb74552905c3d6d03_Out_2;
                    Unity_Add_float(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_R_4, _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_G_5, _Add_dd29f5fda32448acb74552905c3d6d03_Out_2);
                    float _Add_19b5251886274c22919c08b6bccb38e8_Out_2;
                    Unity_Add_float(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_B_6, _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_A_7, _Add_19b5251886274c22919c08b6bccb38e8_Out_2);
                    float _Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2;
                    Unity_Add_float(_Add_dd29f5fda32448acb74552905c3d6d03_Out_2, _Add_19b5251886274c22919c08b6bccb38e8_Out_2, _Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2);
                    float _Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2;
                    Unity_Divide_float(_Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2, 4, _Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2);
                    float _Property_0a2a70c33cb546dd9bdac20429a65b8c_Out_0 = _SwirlIntensity;
                    float _Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2;
                    Unity_Multiply_float(_Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2, _Property_0a2a70c33cb546dd9bdac20429a65b8c_Out_0, _Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2);
                    float4 _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0 = Vector4_999f7726b91342a6888d2ed54673d9ff;
                    float _Split_d851a2a2325a41f0b553937e4925c29a_R_1 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[0];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_G_2 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[1];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_B_3 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[2];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_A_4 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[3];
                    float4 _Combine_3596f49c4a334ab4a5040b2bea265bab_RGBA_4;
                    float3 _Combine_3596f49c4a334ab4a5040b2bea265bab_RGB_5;
                    float2 _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6;
                    Unity_Combine_float(_Split_d851a2a2325a41f0b553937e4925c29a_R_1, _Split_d851a2a2325a41f0b553937e4925c29a_G_2, 0, 0, _Combine_3596f49c4a334ab4a5040b2bea265bab_RGBA_4, _Combine_3596f49c4a334ab4a5040b2bea265bab_RGB_5, _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6);
                    float2 _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2;
                    Unity_Add_float2((_Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2.xx), _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6, _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2);
                    float4 _Combine_d1605ba853a949c9a31366a54ca24223_RGBA_4;
                    float3 _Combine_d1605ba853a949c9a31366a54ca24223_RGB_5;
                    float2 _Combine_d1605ba853a949c9a31366a54ca24223_RG_6;
                    Unity_Combine_float(_Split_d851a2a2325a41f0b553937e4925c29a_B_3, _Split_d851a2a2325a41f0b553937e4925c29a_A_4, 0, 0, _Combine_d1605ba853a949c9a31366a54ca24223_RGBA_4, _Combine_d1605ba853a949c9a31366a54ca24223_RGB_5, _Combine_d1605ba853a949c9a31366a54ca24223_RG_6);
                    float2 _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2, _Combine_d1605ba853a949c9a31366a54ca24223_RG_6, _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3);
                    float4 _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3);
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_R_4 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.r;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_G_5 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.g;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_B_6 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.b;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_A_7 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.a;
                    float4 _Multiply_4eba5955b09345558e792fe0232a0551_Out_2;
                    Unity_Multiply_float(_Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2, _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0, _Multiply_4eba5955b09345558e792fe0232a0551_Out_2);
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_R_1 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[0];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_G_2 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[1];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_B_3 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[2];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_A_4 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[3];
                    float _Property_7d3bdf602b99497eac7c62cb0a1de3b9_Out_0 = _DisTexStepSmooth;
                    float4 _Property_65268079add34c4e804825ec7a71efec_Out_0 = Vector4_557daace24cb4636a4af16509914c72f;
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_R_1 = _Property_65268079add34c4e804825ec7a71efec_Out_0[0];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_G_2 = _Property_65268079add34c4e804825ec7a71efec_Out_0[1];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_B_3 = _Property_65268079add34c4e804825ec7a71efec_Out_0[2];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_A_4 = _Property_65268079add34c4e804825ec7a71efec_Out_0[3];
                    float4 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGBA_4;
                    float3 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGB_5;
                    float2 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6;
                    Unity_Combine_float(_Split_2d06a5d7f5c849b89af1d9f0e06c48aa_R_1, _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_G_2, 0, 0, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGBA_4, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGB_5, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6);
                    float2 _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2;
                    Unity_Add_float2((_Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2.xx), _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6, _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2);
                    float4 _Combine_64df2bdcd9244910ba63c82359f35d21_RGBA_4;
                    float3 _Combine_64df2bdcd9244910ba63c82359f35d21_RGB_5;
                    float2 _Combine_64df2bdcd9244910ba63c82359f35d21_RG_6;
                    Unity_Combine_float(_Split_2d06a5d7f5c849b89af1d9f0e06c48aa_B_3, _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_A_4, 0, 0, _Combine_64df2bdcd9244910ba63c82359f35d21_RGBA_4, _Combine_64df2bdcd9244910ba63c82359f35d21_RGB_5, _Combine_64df2bdcd9244910ba63c82359f35d21_RG_6);
                    float4 _Property_2002f4ad45de4f3788ada633c47883ac_Out_0 = _DisTexSpeed;
                    float4 _Multiply_0b54c1894cce468ea71310c555797e69_Out_2;
                    Unity_Multiply_float(_Property_2002f4ad45de4f3788ada633c47883ac_Out_0, (IN.TimeParameters.x.xxxx), _Multiply_0b54c1894cce468ea71310c555797e69_Out_2);
                    float2 _Add_385457bd7bcf4d69a7735f97024bab24_Out_2;
                    Unity_Add_float2(_Combine_64df2bdcd9244910ba63c82359f35d21_RG_6, (_Multiply_0b54c1894cce468ea71310c555797e69_Out_2.xy), _Add_385457bd7bcf4d69a7735f97024bab24_Out_2);
                    float2 _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2, _Add_385457bd7bcf4d69a7735f97024bab24_Out_2, _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3);
                    float4 _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0 = SAMPLE_TEXTURE2D(_DisTex, sampler_DisTex, _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3);
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_R_4 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.r;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_G_5 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.g;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_B_6 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.b;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_A_7 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.a;
                    float _Add_bbd2209640b14872ae2f0c64037f56c5_Out_2;
                    Unity_Add_float(_SampleTexture2D_87ad03c8523043feb564e133e3472445_R_4, _SampleTexture2D_87ad03c8523043feb564e133e3472445_G_5, _Add_bbd2209640b14872ae2f0c64037f56c5_Out_2);
                    float _Add_5deebdc0a5f04cffab6096fd15406136_Out_2;
                    Unity_Add_float(_SampleTexture2D_87ad03c8523043feb564e133e3472445_B_6, _SampleTexture2D_87ad03c8523043feb564e133e3472445_A_7, _Add_5deebdc0a5f04cffab6096fd15406136_Out_2);
                    float _Add_8c567749c0f34604bf3146789ac90c01_Out_2;
                    Unity_Add_float(_Add_bbd2209640b14872ae2f0c64037f56c5_Out_2, _Add_5deebdc0a5f04cffab6096fd15406136_Out_2, _Add_8c567749c0f34604bf3146789ac90c01_Out_2);
                    float _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2;
                    Unity_Divide_float(_Add_8c567749c0f34604bf3146789ac90c01_Out_2, 4, _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2);
                    float _InverseLerp_ed66297faaa94174809a4c827835fead_Out_3;
                    Unity_InverseLerp_float(_Property_7d3bdf602b99497eac7c62cb0a1de3b9_Out_0, 1.1, _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2, _InverseLerp_ed66297faaa94174809a4c827835fead_Out_3);
                    float _Property_11fb25c356ce4fde9c81bd1c907e3cc0_Out_0 = _DisTexStep;
                    float _Step_b808e6940eb14a9dbd1374f8f9528664_Out_2;
                    Unity_Step_float(_Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2, _Property_11fb25c356ce4fde9c81bd1c907e3cc0_Out_0, _Step_b808e6940eb14a9dbd1374f8f9528664_Out_2);
                    float _OneMinus_a0c152641255443596271035468f6786_Out_1;
                    Unity_OneMinus_float(_Step_b808e6940eb14a9dbd1374f8f9528664_Out_2, _OneMinus_a0c152641255443596271035468f6786_Out_1);
                    float _Multiply_472de54326b84979813b985add57417b_Out_2;
                    Unity_Multiply_float(_InverseLerp_ed66297faaa94174809a4c827835fead_Out_3, _OneMinus_a0c152641255443596271035468f6786_Out_1, _Multiply_472de54326b84979813b985add57417b_Out_2);
                    float _Multiply_e6931bda90fe4fd09db32135618f544f_Out_2;
                    Unity_Multiply_float(_Split_6d41ccf4305240b7ba29e0d66c8d0a2b_A_4, _Multiply_472de54326b84979813b985add57417b_Out_2, _Multiply_e6931bda90fe4fd09db32135618f544f_Out_2);
                    float _Clamp_777ce98db01a49169ebede34e361ea37_Out_3;
                    Unity_Clamp_float(_Multiply_e6931bda90fe4fd09db32135618f544f_Out_2, 0, 1, _Clamp_777ce98db01a49169ebede34e361ea37_Out_3);
                    surface.Alpha = _Clamp_777ce98db01a49169ebede34e361ea37_Out_3;
                    return surface;
                }
    
                // --------------------------------------------------
                // Build Graph Inputs
    
                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =           input.normalOS;
                    output.ObjectSpaceTangent =          input.tangentOS;
                    output.ObjectSpacePosition =         input.positionOS;
                
                    return output;
                }
                
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                
                
                
                
                    output.uv0 =                         input.texCoord0;
                    output.VertexColor =                 input.color;
                    output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                    return output;
                }
                
    
                // --------------------------------------------------
                // Main
    
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
    
                ENDHLSL
            }
        }
        SubShader
        {
            Tags
            {
                "RenderPipeline"="UniversalPipeline"
                "RenderType"="Transparent"
                "UniversalMaterialType" = "Unlit"
                "Queue"="Transparent"
            }
            Pass
            {
                Name "Pass"
                Tags
                {
                    // LightMode: <None>
                }
    
                // Render State
                Cull Off
                Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                ZTest LEqual
                ZWrite Off
    
                // Debug
                // <None>
    
                // --------------------------------------------------
                // Pass
    
                HLSLPROGRAM
    
                // Pragmas
                #pragma target 4.5
                #pragma exclude_renderers gles gles3 glcore
                #pragma multi_compile_instancing
                #pragma multi_compile_fog
                #pragma multi_compile _ DOTS_INSTANCING_ON
                #pragma vertex vert
                #pragma fragment frag
    
                // DotsInstancingOptions: <None>
                // HybridV1InjectedBuiltinProperties: <None>
    
                // Keywords
                #pragma multi_compile _ LIGHTMAP_ON
                #pragma multi_compile _ DIRLIGHTMAP_COMBINED
                #pragma shader_feature _ _SAMPLE_GI
                // GraphKeywords: <None>
    
                // Defines
                #define _SURFACE_TYPE_TRANSPARENT 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define ATTRIBUTES_NEED_COLOR
                #define VARYINGS_NEED_TEXCOORD0
                #define VARYINGS_NEED_COLOR
                #define FEATURES_GRAPH_VERTEX
                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                #define SHADERPASS SHADERPASS_UNLIT
                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
    
                // Includes
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    
                // --------------------------------------------------
                // Structs and Packing
    
                struct Attributes
                {
                    float3 positionOS : POSITION;
                    float3 normalOS : NORMAL;
                    float4 tangentOS : TANGENT;
                    float4 uv0 : TEXCOORD0;
                    float4 color : COLOR;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                    float4 positionCS : SV_POSITION;
                    float4 texCoord0;
                    float4 color;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                    float4 uv0;
                    float4 VertexColor;
                    float3 TimeParameters;
                };
                struct VertexDescriptionInputs
                {
                    float3 ObjectSpaceNormal;
                    float3 ObjectSpaceTangent;
                    float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                    float4 positionCS : SV_POSITION;
                    float4 interp0 : TEXCOORD0;
                    float4 interp1 : TEXCOORD1;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
    
                PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    output.positionCS = input.positionCS;
                    output.interp0.xyzw =  input.texCoord0;
                    output.interp1.xyzw =  input.color;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.interp0.xyzw;
                    output.color = input.interp1.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
    
                // --------------------------------------------------
                // Graph
    
                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                float Boolean_30e886e85c17475385b1785a2f2b7751;
                float _MainIntensity;
                float4 _MainCollor;
                float4 _MainTex_TexelSize;
                float4 Vector4_999f7726b91342a6888d2ed54673d9ff;
                float4 _DisTex_TexelSize;
                float4 Vector4_557daace24cb4636a4af16509914c72f;
                float4 _DisTexSpeed;
                float _DisTexStep;
                float _DisTexStepSmooth;
                float4 _SwirlTex_TexelSize;
                float4 Vector4_fa3fd3eed3404b58ba226241379c2120;
                float _SwirlIntensity;
                float4 _SwirlSpeed;
                CBUFFER_END
                
                // Object and Global properties
                TEXTURE2D(_MainTex);
                SAMPLER(sampler_MainTex);
                TEXTURE2D(_DisTex);
                SAMPLER(sampler_DisTex);
                TEXTURE2D(_SwirlTex);
                SAMPLER(sampler_SwirlTex);
                SAMPLER(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_Sampler_3_Linear_Repeat);
                SAMPLER(_SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_Sampler_3_Linear_Repeat);
                SAMPLER(_SampleTexture2D_87ad03c8523043feb564e133e3472445_Sampler_3_Linear_Repeat);
    
                // Graph Functions
                
                void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                {
                    RGBA = float4(R, G, B, A);
                    RGB = float3(R, G, B);
                    RG = float2(R, G);
                }
                
                void Unity_Add_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A + B;
                }
                
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_InverseLerp_float(float A, float B, float T, out float Out)
                {
                    Out = (T - A)/(B - A);
                }
                
                void Unity_Step_float(float Edge, float In, out float Out)
                {
                    Out = step(Edge, In);
                }
                
                void Unity_OneMinus_float(float In, out float Out)
                {
                    Out = 1 - In;
                }
                
                void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                {
                    Out = clamp(In, Min, Max);
                }
    
                // Graph Vertex
                struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
    
                // Graph Pixel
                struct SurfaceDescription
                {
                    float3 BaseColor;
                    float Alpha;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float4 _Property_88dbfc584015420a91ab078ecb181d3e_Out_0 = IsGammaSpace() ? LinearToSRGB(_MainCollor) : _MainCollor;
                    float4 _Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2;
                    Unity_Multiply_float(IN.VertexColor, _Property_88dbfc584015420a91ab078ecb181d3e_Out_0, _Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2);
                    float4 _Property_22ca7a64481949828913445ec861165e_Out_0 = Vector4_fa3fd3eed3404b58ba226241379c2120;
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_R_1 = _Property_22ca7a64481949828913445ec861165e_Out_0[0];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_G_2 = _Property_22ca7a64481949828913445ec861165e_Out_0[1];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_B_3 = _Property_22ca7a64481949828913445ec861165e_Out_0[2];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_A_4 = _Property_22ca7a64481949828913445ec861165e_Out_0[3];
                    float4 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGBA_4;
                    float3 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGB_5;
                    float2 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6;
                    Unity_Combine_float(_Split_05f0711b20a7491d9617ab9e43ba41b2_R_1, _Split_05f0711b20a7491d9617ab9e43ba41b2_G_2, 0, 0, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGBA_4, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGB_5, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6);
                    float4 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGBA_4;
                    float3 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGB_5;
                    float2 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6;
                    Unity_Combine_float(_Split_05f0711b20a7491d9617ab9e43ba41b2_B_3, _Split_05f0711b20a7491d9617ab9e43ba41b2_A_4, 0, 0, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGBA_4, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGB_5, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6);
                    float4 _Property_f00725938eb045f5ba39edd01bc23705_Out_0 = _SwirlSpeed;
                    float4 _Multiply_fac423eabd3946ba86caf163f2d73945_Out_2;
                    Unity_Multiply_float(_Property_f00725938eb045f5ba39edd01bc23705_Out_0, (IN.TimeParameters.x.xxxx), _Multiply_fac423eabd3946ba86caf163f2d73945_Out_2);
                    float2 _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2;
                    Unity_Add_float2(_Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6, (_Multiply_fac423eabd3946ba86caf163f2d73945_Out_2.xy), _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2);
                    float2 _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6, _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2, _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3);
                    float4 _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0 = SAMPLE_TEXTURE2D(_SwirlTex, sampler_SwirlTex, _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3);
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_R_4 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.r;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_G_5 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.g;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_B_6 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.b;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_A_7 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.a;
                    float _Add_dd29f5fda32448acb74552905c3d6d03_Out_2;
                    Unity_Add_float(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_R_4, _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_G_5, _Add_dd29f5fda32448acb74552905c3d6d03_Out_2);
                    float _Add_19b5251886274c22919c08b6bccb38e8_Out_2;
                    Unity_Add_float(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_B_6, _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_A_7, _Add_19b5251886274c22919c08b6bccb38e8_Out_2);
                    float _Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2;
                    Unity_Add_float(_Add_dd29f5fda32448acb74552905c3d6d03_Out_2, _Add_19b5251886274c22919c08b6bccb38e8_Out_2, _Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2);
                    float _Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2;
                    Unity_Divide_float(_Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2, 4, _Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2);
                    float _Property_0a2a70c33cb546dd9bdac20429a65b8c_Out_0 = _SwirlIntensity;
                    float _Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2;
                    Unity_Multiply_float(_Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2, _Property_0a2a70c33cb546dd9bdac20429a65b8c_Out_0, _Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2);
                    float4 _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0 = Vector4_999f7726b91342a6888d2ed54673d9ff;
                    float _Split_d851a2a2325a41f0b553937e4925c29a_R_1 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[0];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_G_2 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[1];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_B_3 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[2];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_A_4 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[3];
                    float4 _Combine_3596f49c4a334ab4a5040b2bea265bab_RGBA_4;
                    float3 _Combine_3596f49c4a334ab4a5040b2bea265bab_RGB_5;
                    float2 _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6;
                    Unity_Combine_float(_Split_d851a2a2325a41f0b553937e4925c29a_R_1, _Split_d851a2a2325a41f0b553937e4925c29a_G_2, 0, 0, _Combine_3596f49c4a334ab4a5040b2bea265bab_RGBA_4, _Combine_3596f49c4a334ab4a5040b2bea265bab_RGB_5, _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6);
                    float2 _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2;
                    Unity_Add_float2((_Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2.xx), _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6, _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2);
                    float4 _Combine_d1605ba853a949c9a31366a54ca24223_RGBA_4;
                    float3 _Combine_d1605ba853a949c9a31366a54ca24223_RGB_5;
                    float2 _Combine_d1605ba853a949c9a31366a54ca24223_RG_6;
                    Unity_Combine_float(_Split_d851a2a2325a41f0b553937e4925c29a_B_3, _Split_d851a2a2325a41f0b553937e4925c29a_A_4, 0, 0, _Combine_d1605ba853a949c9a31366a54ca24223_RGBA_4, _Combine_d1605ba853a949c9a31366a54ca24223_RGB_5, _Combine_d1605ba853a949c9a31366a54ca24223_RG_6);
                    float2 _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2, _Combine_d1605ba853a949c9a31366a54ca24223_RG_6, _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3);
                    float4 _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3);
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_R_4 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.r;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_G_5 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.g;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_B_6 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.b;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_A_7 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.a;
                    float4 _Multiply_4eba5955b09345558e792fe0232a0551_Out_2;
                    Unity_Multiply_float(_Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2, _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0, _Multiply_4eba5955b09345558e792fe0232a0551_Out_2);
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_R_1 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[0];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_G_2 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[1];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_B_3 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[2];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_A_4 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[3];
                    float _Property_7d3bdf602b99497eac7c62cb0a1de3b9_Out_0 = _DisTexStepSmooth;
                    float4 _Property_65268079add34c4e804825ec7a71efec_Out_0 = Vector4_557daace24cb4636a4af16509914c72f;
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_R_1 = _Property_65268079add34c4e804825ec7a71efec_Out_0[0];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_G_2 = _Property_65268079add34c4e804825ec7a71efec_Out_0[1];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_B_3 = _Property_65268079add34c4e804825ec7a71efec_Out_0[2];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_A_4 = _Property_65268079add34c4e804825ec7a71efec_Out_0[3];
                    float4 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGBA_4;
                    float3 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGB_5;
                    float2 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6;
                    Unity_Combine_float(_Split_2d06a5d7f5c849b89af1d9f0e06c48aa_R_1, _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_G_2, 0, 0, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGBA_4, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGB_5, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6);
                    float2 _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2;
                    Unity_Add_float2((_Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2.xx), _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6, _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2);
                    float4 _Combine_64df2bdcd9244910ba63c82359f35d21_RGBA_4;
                    float3 _Combine_64df2bdcd9244910ba63c82359f35d21_RGB_5;
                    float2 _Combine_64df2bdcd9244910ba63c82359f35d21_RG_6;
                    Unity_Combine_float(_Split_2d06a5d7f5c849b89af1d9f0e06c48aa_B_3, _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_A_4, 0, 0, _Combine_64df2bdcd9244910ba63c82359f35d21_RGBA_4, _Combine_64df2bdcd9244910ba63c82359f35d21_RGB_5, _Combine_64df2bdcd9244910ba63c82359f35d21_RG_6);
                    float4 _Property_2002f4ad45de4f3788ada633c47883ac_Out_0 = _DisTexSpeed;
                    float4 _Multiply_0b54c1894cce468ea71310c555797e69_Out_2;
                    Unity_Multiply_float(_Property_2002f4ad45de4f3788ada633c47883ac_Out_0, (IN.TimeParameters.x.xxxx), _Multiply_0b54c1894cce468ea71310c555797e69_Out_2);
                    float2 _Add_385457bd7bcf4d69a7735f97024bab24_Out_2;
                    Unity_Add_float2(_Combine_64df2bdcd9244910ba63c82359f35d21_RG_6, (_Multiply_0b54c1894cce468ea71310c555797e69_Out_2.xy), _Add_385457bd7bcf4d69a7735f97024bab24_Out_2);
                    float2 _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2, _Add_385457bd7bcf4d69a7735f97024bab24_Out_2, _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3);
                    float4 _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0 = SAMPLE_TEXTURE2D(_DisTex, sampler_DisTex, _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3);
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_R_4 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.r;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_G_5 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.g;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_B_6 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.b;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_A_7 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.a;
                    float _Add_bbd2209640b14872ae2f0c64037f56c5_Out_2;
                    Unity_Add_float(_SampleTexture2D_87ad03c8523043feb564e133e3472445_R_4, _SampleTexture2D_87ad03c8523043feb564e133e3472445_G_5, _Add_bbd2209640b14872ae2f0c64037f56c5_Out_2);
                    float _Add_5deebdc0a5f04cffab6096fd15406136_Out_2;
                    Unity_Add_float(_SampleTexture2D_87ad03c8523043feb564e133e3472445_B_6, _SampleTexture2D_87ad03c8523043feb564e133e3472445_A_7, _Add_5deebdc0a5f04cffab6096fd15406136_Out_2);
                    float _Add_8c567749c0f34604bf3146789ac90c01_Out_2;
                    Unity_Add_float(_Add_bbd2209640b14872ae2f0c64037f56c5_Out_2, _Add_5deebdc0a5f04cffab6096fd15406136_Out_2, _Add_8c567749c0f34604bf3146789ac90c01_Out_2);
                    float _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2;
                    Unity_Divide_float(_Add_8c567749c0f34604bf3146789ac90c01_Out_2, 4, _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2);
                    float _InverseLerp_ed66297faaa94174809a4c827835fead_Out_3;
                    Unity_InverseLerp_float(_Property_7d3bdf602b99497eac7c62cb0a1de3b9_Out_0, 1.1, _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2, _InverseLerp_ed66297faaa94174809a4c827835fead_Out_3);
                    float _Property_11fb25c356ce4fde9c81bd1c907e3cc0_Out_0 = _DisTexStep;
                    float _Step_b808e6940eb14a9dbd1374f8f9528664_Out_2;
                    Unity_Step_float(_Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2, _Property_11fb25c356ce4fde9c81bd1c907e3cc0_Out_0, _Step_b808e6940eb14a9dbd1374f8f9528664_Out_2);
                    float _OneMinus_a0c152641255443596271035468f6786_Out_1;
                    Unity_OneMinus_float(_Step_b808e6940eb14a9dbd1374f8f9528664_Out_2, _OneMinus_a0c152641255443596271035468f6786_Out_1);
                    float _Multiply_472de54326b84979813b985add57417b_Out_2;
                    Unity_Multiply_float(_InverseLerp_ed66297faaa94174809a4c827835fead_Out_3, _OneMinus_a0c152641255443596271035468f6786_Out_1, _Multiply_472de54326b84979813b985add57417b_Out_2);
                    float _Multiply_e6931bda90fe4fd09db32135618f544f_Out_2;
                    Unity_Multiply_float(_Split_6d41ccf4305240b7ba29e0d66c8d0a2b_A_4, _Multiply_472de54326b84979813b985add57417b_Out_2, _Multiply_e6931bda90fe4fd09db32135618f544f_Out_2);
                    float _Clamp_777ce98db01a49169ebede34e361ea37_Out_3;
                    Unity_Clamp_float(_Multiply_e6931bda90fe4fd09db32135618f544f_Out_2, 0, 1, _Clamp_777ce98db01a49169ebede34e361ea37_Out_3);
                    surface.BaseColor = (_Multiply_4eba5955b09345558e792fe0232a0551_Out_2.xyz);
                    surface.Alpha = _Clamp_777ce98db01a49169ebede34e361ea37_Out_3;
                    return surface;
                }
    
                // --------------------------------------------------
                // Build Graph Inputs
    
                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =           input.normalOS;
                    output.ObjectSpaceTangent =          input.tangentOS;
                    output.ObjectSpacePosition =         input.positionOS;
                
                    return output;
                }
                
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                
                
                
                
                    output.uv0 =                         input.texCoord0;
                    output.VertexColor =                 input.color;
                    output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                    return output;
                }
                
    
                // --------------------------------------------------
                // Main
    
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
    
                ENDHLSL
            }
            Pass
            {
                Name "ShadowCaster"
                Tags
                {
                    "LightMode" = "ShadowCaster"
                }
    
                // Render State
                Cull Off
                Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                ZTest LEqual
                ZWrite On
                ColorMask 0
    
                // Debug
                // <None>
    
                // --------------------------------------------------
                // Pass
    
                HLSLPROGRAM
    
                // Pragmas
                #pragma target 4.5
                #pragma exclude_renderers gles gles3 glcore
                #pragma multi_compile_instancing
                #pragma multi_compile _ DOTS_INSTANCING_ON
                #pragma vertex vert
                #pragma fragment frag
    
                // DotsInstancingOptions: <None>
                // HybridV1InjectedBuiltinProperties: <None>
    
                // Keywords
                // PassKeywords: <None>
                // GraphKeywords: <None>
    
                // Defines
                #define _SURFACE_TYPE_TRANSPARENT 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define ATTRIBUTES_NEED_COLOR
                #define VARYINGS_NEED_TEXCOORD0
                #define VARYINGS_NEED_COLOR
                #define FEATURES_GRAPH_VERTEX
                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                #define SHADERPASS SHADERPASS_SHADOWCASTER
                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
    
                // Includes
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    
                // --------------------------------------------------
                // Structs and Packing
    
                struct Attributes
                {
                    float3 positionOS : POSITION;
                    float3 normalOS : NORMAL;
                    float4 tangentOS : TANGENT;
                    float4 uv0 : TEXCOORD0;
                    float4 color : COLOR;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                    float4 positionCS : SV_POSITION;
                    float4 texCoord0;
                    float4 color;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                    float4 uv0;
                    float4 VertexColor;
                    float3 TimeParameters;
                };
                struct VertexDescriptionInputs
                {
                    float3 ObjectSpaceNormal;
                    float3 ObjectSpaceTangent;
                    float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                    float4 positionCS : SV_POSITION;
                    float4 interp0 : TEXCOORD0;
                    float4 interp1 : TEXCOORD1;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
    
                PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    output.positionCS = input.positionCS;
                    output.interp0.xyzw =  input.texCoord0;
                    output.interp1.xyzw =  input.color;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.interp0.xyzw;
                    output.color = input.interp1.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
    
                // --------------------------------------------------
                // Graph
    
                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                float Boolean_30e886e85c17475385b1785a2f2b7751;
                float _MainIntensity;
                float4 _MainCollor;
                float4 _MainTex_TexelSize;
                float4 Vector4_999f7726b91342a6888d2ed54673d9ff;
                float4 _DisTex_TexelSize;
                float4 Vector4_557daace24cb4636a4af16509914c72f;
                float4 _DisTexSpeed;
                float _DisTexStep;
                float _DisTexStepSmooth;
                float4 _SwirlTex_TexelSize;
                float4 Vector4_fa3fd3eed3404b58ba226241379c2120;
                float _SwirlIntensity;
                float4 _SwirlSpeed;
                CBUFFER_END
                
                // Object and Global properties
                TEXTURE2D(_MainTex);
                SAMPLER(sampler_MainTex);
                TEXTURE2D(_DisTex);
                SAMPLER(sampler_DisTex);
                TEXTURE2D(_SwirlTex);
                SAMPLER(sampler_SwirlTex);
                SAMPLER(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_Sampler_3_Linear_Repeat);
                SAMPLER(_SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_Sampler_3_Linear_Repeat);
                SAMPLER(_SampleTexture2D_87ad03c8523043feb564e133e3472445_Sampler_3_Linear_Repeat);
    
                // Graph Functions
                
                void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                {
                    RGBA = float4(R, G, B, A);
                    RGB = float3(R, G, B);
                    RG = float2(R, G);
                }
                
                void Unity_Add_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A + B;
                }
                
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_InverseLerp_float(float A, float B, float T, out float Out)
                {
                    Out = (T - A)/(B - A);
                }
                
                void Unity_Step_float(float Edge, float In, out float Out)
                {
                    Out = step(Edge, In);
                }
                
                void Unity_OneMinus_float(float In, out float Out)
                {
                    Out = 1 - In;
                }
                
                void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                {
                    Out = clamp(In, Min, Max);
                }
    
                // Graph Vertex
                struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
    
                // Graph Pixel
                struct SurfaceDescription
                {
                    float Alpha;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float4 _Property_88dbfc584015420a91ab078ecb181d3e_Out_0 = IsGammaSpace() ? LinearToSRGB(_MainCollor) : _MainCollor;
                    float4 _Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2;
                    Unity_Multiply_float(IN.VertexColor, _Property_88dbfc584015420a91ab078ecb181d3e_Out_0, _Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2);
                    float4 _Property_22ca7a64481949828913445ec861165e_Out_0 = Vector4_fa3fd3eed3404b58ba226241379c2120;
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_R_1 = _Property_22ca7a64481949828913445ec861165e_Out_0[0];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_G_2 = _Property_22ca7a64481949828913445ec861165e_Out_0[1];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_B_3 = _Property_22ca7a64481949828913445ec861165e_Out_0[2];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_A_4 = _Property_22ca7a64481949828913445ec861165e_Out_0[3];
                    float4 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGBA_4;
                    float3 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGB_5;
                    float2 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6;
                    Unity_Combine_float(_Split_05f0711b20a7491d9617ab9e43ba41b2_R_1, _Split_05f0711b20a7491d9617ab9e43ba41b2_G_2, 0, 0, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGBA_4, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGB_5, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6);
                    float4 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGBA_4;
                    float3 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGB_5;
                    float2 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6;
                    Unity_Combine_float(_Split_05f0711b20a7491d9617ab9e43ba41b2_B_3, _Split_05f0711b20a7491d9617ab9e43ba41b2_A_4, 0, 0, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGBA_4, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGB_5, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6);
                    float4 _Property_f00725938eb045f5ba39edd01bc23705_Out_0 = _SwirlSpeed;
                    float4 _Multiply_fac423eabd3946ba86caf163f2d73945_Out_2;
                    Unity_Multiply_float(_Property_f00725938eb045f5ba39edd01bc23705_Out_0, (IN.TimeParameters.x.xxxx), _Multiply_fac423eabd3946ba86caf163f2d73945_Out_2);
                    float2 _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2;
                    Unity_Add_float2(_Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6, (_Multiply_fac423eabd3946ba86caf163f2d73945_Out_2.xy), _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2);
                    float2 _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6, _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2, _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3);
                    float4 _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0 = SAMPLE_TEXTURE2D(_SwirlTex, sampler_SwirlTex, _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3);
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_R_4 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.r;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_G_5 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.g;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_B_6 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.b;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_A_7 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.a;
                    float _Add_dd29f5fda32448acb74552905c3d6d03_Out_2;
                    Unity_Add_float(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_R_4, _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_G_5, _Add_dd29f5fda32448acb74552905c3d6d03_Out_2);
                    float _Add_19b5251886274c22919c08b6bccb38e8_Out_2;
                    Unity_Add_float(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_B_6, _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_A_7, _Add_19b5251886274c22919c08b6bccb38e8_Out_2);
                    float _Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2;
                    Unity_Add_float(_Add_dd29f5fda32448acb74552905c3d6d03_Out_2, _Add_19b5251886274c22919c08b6bccb38e8_Out_2, _Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2);
                    float _Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2;
                    Unity_Divide_float(_Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2, 4, _Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2);
                    float _Property_0a2a70c33cb546dd9bdac20429a65b8c_Out_0 = _SwirlIntensity;
                    float _Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2;
                    Unity_Multiply_float(_Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2, _Property_0a2a70c33cb546dd9bdac20429a65b8c_Out_0, _Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2);
                    float4 _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0 = Vector4_999f7726b91342a6888d2ed54673d9ff;
                    float _Split_d851a2a2325a41f0b553937e4925c29a_R_1 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[0];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_G_2 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[1];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_B_3 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[2];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_A_4 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[3];
                    float4 _Combine_3596f49c4a334ab4a5040b2bea265bab_RGBA_4;
                    float3 _Combine_3596f49c4a334ab4a5040b2bea265bab_RGB_5;
                    float2 _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6;
                    Unity_Combine_float(_Split_d851a2a2325a41f0b553937e4925c29a_R_1, _Split_d851a2a2325a41f0b553937e4925c29a_G_2, 0, 0, _Combine_3596f49c4a334ab4a5040b2bea265bab_RGBA_4, _Combine_3596f49c4a334ab4a5040b2bea265bab_RGB_5, _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6);
                    float2 _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2;
                    Unity_Add_float2((_Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2.xx), _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6, _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2);
                    float4 _Combine_d1605ba853a949c9a31366a54ca24223_RGBA_4;
                    float3 _Combine_d1605ba853a949c9a31366a54ca24223_RGB_5;
                    float2 _Combine_d1605ba853a949c9a31366a54ca24223_RG_6;
                    Unity_Combine_float(_Split_d851a2a2325a41f0b553937e4925c29a_B_3, _Split_d851a2a2325a41f0b553937e4925c29a_A_4, 0, 0, _Combine_d1605ba853a949c9a31366a54ca24223_RGBA_4, _Combine_d1605ba853a949c9a31366a54ca24223_RGB_5, _Combine_d1605ba853a949c9a31366a54ca24223_RG_6);
                    float2 _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2, _Combine_d1605ba853a949c9a31366a54ca24223_RG_6, _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3);
                    float4 _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3);
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_R_4 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.r;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_G_5 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.g;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_B_6 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.b;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_A_7 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.a;
                    float4 _Multiply_4eba5955b09345558e792fe0232a0551_Out_2;
                    Unity_Multiply_float(_Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2, _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0, _Multiply_4eba5955b09345558e792fe0232a0551_Out_2);
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_R_1 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[0];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_G_2 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[1];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_B_3 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[2];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_A_4 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[3];
                    float _Property_7d3bdf602b99497eac7c62cb0a1de3b9_Out_0 = _DisTexStepSmooth;
                    float4 _Property_65268079add34c4e804825ec7a71efec_Out_0 = Vector4_557daace24cb4636a4af16509914c72f;
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_R_1 = _Property_65268079add34c4e804825ec7a71efec_Out_0[0];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_G_2 = _Property_65268079add34c4e804825ec7a71efec_Out_0[1];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_B_3 = _Property_65268079add34c4e804825ec7a71efec_Out_0[2];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_A_4 = _Property_65268079add34c4e804825ec7a71efec_Out_0[3];
                    float4 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGBA_4;
                    float3 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGB_5;
                    float2 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6;
                    Unity_Combine_float(_Split_2d06a5d7f5c849b89af1d9f0e06c48aa_R_1, _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_G_2, 0, 0, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGBA_4, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGB_5, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6);
                    float2 _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2;
                    Unity_Add_float2((_Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2.xx), _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6, _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2);
                    float4 _Combine_64df2bdcd9244910ba63c82359f35d21_RGBA_4;
                    float3 _Combine_64df2bdcd9244910ba63c82359f35d21_RGB_5;
                    float2 _Combine_64df2bdcd9244910ba63c82359f35d21_RG_6;
                    Unity_Combine_float(_Split_2d06a5d7f5c849b89af1d9f0e06c48aa_B_3, _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_A_4, 0, 0, _Combine_64df2bdcd9244910ba63c82359f35d21_RGBA_4, _Combine_64df2bdcd9244910ba63c82359f35d21_RGB_5, _Combine_64df2bdcd9244910ba63c82359f35d21_RG_6);
                    float4 _Property_2002f4ad45de4f3788ada633c47883ac_Out_0 = _DisTexSpeed;
                    float4 _Multiply_0b54c1894cce468ea71310c555797e69_Out_2;
                    Unity_Multiply_float(_Property_2002f4ad45de4f3788ada633c47883ac_Out_0, (IN.TimeParameters.x.xxxx), _Multiply_0b54c1894cce468ea71310c555797e69_Out_2);
                    float2 _Add_385457bd7bcf4d69a7735f97024bab24_Out_2;
                    Unity_Add_float2(_Combine_64df2bdcd9244910ba63c82359f35d21_RG_6, (_Multiply_0b54c1894cce468ea71310c555797e69_Out_2.xy), _Add_385457bd7bcf4d69a7735f97024bab24_Out_2);
                    float2 _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2, _Add_385457bd7bcf4d69a7735f97024bab24_Out_2, _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3);
                    float4 _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0 = SAMPLE_TEXTURE2D(_DisTex, sampler_DisTex, _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3);
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_R_4 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.r;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_G_5 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.g;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_B_6 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.b;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_A_7 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.a;
                    float _Add_bbd2209640b14872ae2f0c64037f56c5_Out_2;
                    Unity_Add_float(_SampleTexture2D_87ad03c8523043feb564e133e3472445_R_4, _SampleTexture2D_87ad03c8523043feb564e133e3472445_G_5, _Add_bbd2209640b14872ae2f0c64037f56c5_Out_2);
                    float _Add_5deebdc0a5f04cffab6096fd15406136_Out_2;
                    Unity_Add_float(_SampleTexture2D_87ad03c8523043feb564e133e3472445_B_6, _SampleTexture2D_87ad03c8523043feb564e133e3472445_A_7, _Add_5deebdc0a5f04cffab6096fd15406136_Out_2);
                    float _Add_8c567749c0f34604bf3146789ac90c01_Out_2;
                    Unity_Add_float(_Add_bbd2209640b14872ae2f0c64037f56c5_Out_2, _Add_5deebdc0a5f04cffab6096fd15406136_Out_2, _Add_8c567749c0f34604bf3146789ac90c01_Out_2);
                    float _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2;
                    Unity_Divide_float(_Add_8c567749c0f34604bf3146789ac90c01_Out_2, 4, _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2);
                    float _InverseLerp_ed66297faaa94174809a4c827835fead_Out_3;
                    Unity_InverseLerp_float(_Property_7d3bdf602b99497eac7c62cb0a1de3b9_Out_0, 1.1, _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2, _InverseLerp_ed66297faaa94174809a4c827835fead_Out_3);
                    float _Property_11fb25c356ce4fde9c81bd1c907e3cc0_Out_0 = _DisTexStep;
                    float _Step_b808e6940eb14a9dbd1374f8f9528664_Out_2;
                    Unity_Step_float(_Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2, _Property_11fb25c356ce4fde9c81bd1c907e3cc0_Out_0, _Step_b808e6940eb14a9dbd1374f8f9528664_Out_2);
                    float _OneMinus_a0c152641255443596271035468f6786_Out_1;
                    Unity_OneMinus_float(_Step_b808e6940eb14a9dbd1374f8f9528664_Out_2, _OneMinus_a0c152641255443596271035468f6786_Out_1);
                    float _Multiply_472de54326b84979813b985add57417b_Out_2;
                    Unity_Multiply_float(_InverseLerp_ed66297faaa94174809a4c827835fead_Out_3, _OneMinus_a0c152641255443596271035468f6786_Out_1, _Multiply_472de54326b84979813b985add57417b_Out_2);
                    float _Multiply_e6931bda90fe4fd09db32135618f544f_Out_2;
                    Unity_Multiply_float(_Split_6d41ccf4305240b7ba29e0d66c8d0a2b_A_4, _Multiply_472de54326b84979813b985add57417b_Out_2, _Multiply_e6931bda90fe4fd09db32135618f544f_Out_2);
                    float _Clamp_777ce98db01a49169ebede34e361ea37_Out_3;
                    Unity_Clamp_float(_Multiply_e6931bda90fe4fd09db32135618f544f_Out_2, 0, 1, _Clamp_777ce98db01a49169ebede34e361ea37_Out_3);
                    surface.Alpha = _Clamp_777ce98db01a49169ebede34e361ea37_Out_3;
                    return surface;
                }
    
                // --------------------------------------------------
                // Build Graph Inputs
    
                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =           input.normalOS;
                    output.ObjectSpaceTangent =          input.tangentOS;
                    output.ObjectSpacePosition =         input.positionOS;
                
                    return output;
                }
                
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                
                
                
                
                    output.uv0 =                         input.texCoord0;
                    output.VertexColor =                 input.color;
                    output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                    return output;
                }
                
    
                // --------------------------------------------------
                // Main
    
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
    
                ENDHLSL
            }
            Pass
            {
                Name "DepthOnly"
                Tags
                {
                    "LightMode" = "DepthOnly"
                }
    
                // Render State
                Cull Off
                Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                ZTest LEqual
                ZWrite On
                ColorMask 0
    
                // Debug
                // <None>
    
                // --------------------------------------------------
                // Pass
    
                HLSLPROGRAM
    
                // Pragmas
                #pragma target 4.5
                #pragma exclude_renderers gles gles3 glcore
                #pragma multi_compile_instancing
                #pragma multi_compile _ DOTS_INSTANCING_ON
                #pragma vertex vert
                #pragma fragment frag
    
                // DotsInstancingOptions: <None>
                // HybridV1InjectedBuiltinProperties: <None>
    
                // Keywords
                // PassKeywords: <None>
                // GraphKeywords: <None>
    
                // Defines
                #define _SURFACE_TYPE_TRANSPARENT 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define ATTRIBUTES_NEED_COLOR
                #define VARYINGS_NEED_TEXCOORD0
                #define VARYINGS_NEED_COLOR
                #define FEATURES_GRAPH_VERTEX
                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                #define SHADERPASS SHADERPASS_DEPTHONLY
                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
    
                // Includes
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
    
                // --------------------------------------------------
                // Structs and Packing
    
                struct Attributes
                {
                    float3 positionOS : POSITION;
                    float3 normalOS : NORMAL;
                    float4 tangentOS : TANGENT;
                    float4 uv0 : TEXCOORD0;
                    float4 color : COLOR;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };
                struct Varyings
                {
                    float4 positionCS : SV_POSITION;
                    float4 texCoord0;
                    float4 color;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
                struct SurfaceDescriptionInputs
                {
                    float4 uv0;
                    float4 VertexColor;
                    float3 TimeParameters;
                };
                struct VertexDescriptionInputs
                {
                    float3 ObjectSpaceNormal;
                    float3 ObjectSpaceTangent;
                    float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                    float4 positionCS : SV_POSITION;
                    float4 interp0 : TEXCOORD0;
                    float4 interp1 : TEXCOORD1;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };
    
                PackedVaryings PackVaryings (Varyings input)
                {
                    PackedVaryings output;
                    output.positionCS = input.positionCS;
                    output.interp0.xyzw =  input.texCoord0;
                    output.interp1.xyzw =  input.color;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                Varyings UnpackVaryings (PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.interp0.xyzw;
                    output.color = input.interp1.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
    
                // --------------------------------------------------
                // Graph
    
                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                float Boolean_30e886e85c17475385b1785a2f2b7751;
                float _MainIntensity;
                float4 _MainCollor;
                float4 _MainTex_TexelSize;
                float4 Vector4_999f7726b91342a6888d2ed54673d9ff;
                float4 _DisTex_TexelSize;
                float4 Vector4_557daace24cb4636a4af16509914c72f;
                float4 _DisTexSpeed;
                float _DisTexStep;
                float _DisTexStepSmooth;
                float4 _SwirlTex_TexelSize;
                float4 Vector4_fa3fd3eed3404b58ba226241379c2120;
                float _SwirlIntensity;
                float4 _SwirlSpeed;
                CBUFFER_END
                
                // Object and Global properties
                TEXTURE2D(_MainTex);
                SAMPLER(sampler_MainTex);
                TEXTURE2D(_DisTex);
                SAMPLER(sampler_DisTex);
                TEXTURE2D(_SwirlTex);
                SAMPLER(sampler_SwirlTex);
                SAMPLER(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_Sampler_3_Linear_Repeat);
                SAMPLER(_SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_Sampler_3_Linear_Repeat);
                SAMPLER(_SampleTexture2D_87ad03c8523043feb564e133e3472445_Sampler_3_Linear_Repeat);
    
                // Graph Functions
                
                void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                {
                    Out = A * B;
                }
                
                void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                {
                    RGBA = float4(R, G, B, A);
                    RGB = float3(R, G, B);
                    RG = float2(R, G);
                }
                
                void Unity_Add_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A + B;
                }
                
                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }
                
                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }
                
                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }
                
                void Unity_Multiply_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }
                
                void Unity_InverseLerp_float(float A, float B, float T, out float Out)
                {
                    Out = (T - A)/(B - A);
                }
                
                void Unity_Step_float(float Edge, float In, out float Out)
                {
                    Out = step(Edge, In);
                }
                
                void Unity_OneMinus_float(float In, out float Out)
                {
                    Out = 1 - In;
                }
                
                void Unity_Clamp_float(float In, float Min, float Max, out float Out)
                {
                    Out = clamp(In, Min, Max);
                }
    
                // Graph Vertex
                struct VertexDescription
                {
                    float3 Position;
                    float3 Normal;
                    float3 Tangent;
                };
                
                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    description.Position = IN.ObjectSpacePosition;
                    description.Normal = IN.ObjectSpaceNormal;
                    description.Tangent = IN.ObjectSpaceTangent;
                    return description;
                }
    
                // Graph Pixel
                struct SurfaceDescription
                {
                    float Alpha;
                };
                
                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float4 _Property_88dbfc584015420a91ab078ecb181d3e_Out_0 = IsGammaSpace() ? LinearToSRGB(_MainCollor) : _MainCollor;
                    float4 _Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2;
                    Unity_Multiply_float(IN.VertexColor, _Property_88dbfc584015420a91ab078ecb181d3e_Out_0, _Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2);
                    float4 _Property_22ca7a64481949828913445ec861165e_Out_0 = Vector4_fa3fd3eed3404b58ba226241379c2120;
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_R_1 = _Property_22ca7a64481949828913445ec861165e_Out_0[0];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_G_2 = _Property_22ca7a64481949828913445ec861165e_Out_0[1];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_B_3 = _Property_22ca7a64481949828913445ec861165e_Out_0[2];
                    float _Split_05f0711b20a7491d9617ab9e43ba41b2_A_4 = _Property_22ca7a64481949828913445ec861165e_Out_0[3];
                    float4 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGBA_4;
                    float3 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGB_5;
                    float2 _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6;
                    Unity_Combine_float(_Split_05f0711b20a7491d9617ab9e43ba41b2_R_1, _Split_05f0711b20a7491d9617ab9e43ba41b2_G_2, 0, 0, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGBA_4, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RGB_5, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6);
                    float4 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGBA_4;
                    float3 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGB_5;
                    float2 _Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6;
                    Unity_Combine_float(_Split_05f0711b20a7491d9617ab9e43ba41b2_B_3, _Split_05f0711b20a7491d9617ab9e43ba41b2_A_4, 0, 0, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGBA_4, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RGB_5, _Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6);
                    float4 _Property_f00725938eb045f5ba39edd01bc23705_Out_0 = _SwirlSpeed;
                    float4 _Multiply_fac423eabd3946ba86caf163f2d73945_Out_2;
                    Unity_Multiply_float(_Property_f00725938eb045f5ba39edd01bc23705_Out_0, (IN.TimeParameters.x.xxxx), _Multiply_fac423eabd3946ba86caf163f2d73945_Out_2);
                    float2 _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2;
                    Unity_Add_float2(_Combine_30593a8e529f4c01bbe31c7b59aa5856_RG_6, (_Multiply_fac423eabd3946ba86caf163f2d73945_Out_2.xy), _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2);
                    float2 _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Combine_2e24fb3e471b4b35a0ac2184fb1f0a74_RG_6, _Add_0cf988aec27549a7b6de4b773cdbcb2c_Out_2, _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3);
                    float4 _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0 = SAMPLE_TEXTURE2D(_SwirlTex, sampler_SwirlTex, _TilingAndOffset_0164ace2a1a44dd5939802801157538f_Out_3);
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_R_4 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.r;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_G_5 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.g;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_B_6 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.b;
                    float _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_A_7 = _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_RGBA_0.a;
                    float _Add_dd29f5fda32448acb74552905c3d6d03_Out_2;
                    Unity_Add_float(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_R_4, _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_G_5, _Add_dd29f5fda32448acb74552905c3d6d03_Out_2);
                    float _Add_19b5251886274c22919c08b6bccb38e8_Out_2;
                    Unity_Add_float(_SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_B_6, _SampleTexture2D_f72fedaed8cc42b2a68000f20944ecd6_A_7, _Add_19b5251886274c22919c08b6bccb38e8_Out_2);
                    float _Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2;
                    Unity_Add_float(_Add_dd29f5fda32448acb74552905c3d6d03_Out_2, _Add_19b5251886274c22919c08b6bccb38e8_Out_2, _Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2);
                    float _Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2;
                    Unity_Divide_float(_Add_5f1854c32f2d42d6b0fb230b6786a0eb_Out_2, 4, _Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2);
                    float _Property_0a2a70c33cb546dd9bdac20429a65b8c_Out_0 = _SwirlIntensity;
                    float _Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2;
                    Unity_Multiply_float(_Divide_dc8fba6ef1c2466ea7f87d7621eeff9b_Out_2, _Property_0a2a70c33cb546dd9bdac20429a65b8c_Out_0, _Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2);
                    float4 _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0 = Vector4_999f7726b91342a6888d2ed54673d9ff;
                    float _Split_d851a2a2325a41f0b553937e4925c29a_R_1 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[0];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_G_2 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[1];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_B_3 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[2];
                    float _Split_d851a2a2325a41f0b553937e4925c29a_A_4 = _Property_321019f89b404c38b9bdf90cdf3f9488_Out_0[3];
                    float4 _Combine_3596f49c4a334ab4a5040b2bea265bab_RGBA_4;
                    float3 _Combine_3596f49c4a334ab4a5040b2bea265bab_RGB_5;
                    float2 _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6;
                    Unity_Combine_float(_Split_d851a2a2325a41f0b553937e4925c29a_R_1, _Split_d851a2a2325a41f0b553937e4925c29a_G_2, 0, 0, _Combine_3596f49c4a334ab4a5040b2bea265bab_RGBA_4, _Combine_3596f49c4a334ab4a5040b2bea265bab_RGB_5, _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6);
                    float2 _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2;
                    Unity_Add_float2((_Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2.xx), _Combine_3596f49c4a334ab4a5040b2bea265bab_RG_6, _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2);
                    float4 _Combine_d1605ba853a949c9a31366a54ca24223_RGBA_4;
                    float3 _Combine_d1605ba853a949c9a31366a54ca24223_RGB_5;
                    float2 _Combine_d1605ba853a949c9a31366a54ca24223_RG_6;
                    Unity_Combine_float(_Split_d851a2a2325a41f0b553937e4925c29a_B_3, _Split_d851a2a2325a41f0b553937e4925c29a_A_4, 0, 0, _Combine_d1605ba853a949c9a31366a54ca24223_RGBA_4, _Combine_d1605ba853a949c9a31366a54ca24223_RGB_5, _Combine_d1605ba853a949c9a31366a54ca24223_RG_6);
                    float2 _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Add_8a248903e5b5482fb9b11cc0ea3526c3_Out_2, _Combine_d1605ba853a949c9a31366a54ca24223_RG_6, _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3);
                    float4 _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, _TilingAndOffset_7bcca13a450540ef81a7225f87f593d1_Out_3);
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_R_4 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.r;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_G_5 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.g;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_B_6 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.b;
                    float _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_A_7 = _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0.a;
                    float4 _Multiply_4eba5955b09345558e792fe0232a0551_Out_2;
                    Unity_Multiply_float(_Multiply_1d5a24bf327e42ab822c03d1aad4583c_Out_2, _SampleTexture2D_256d4042c1e9419d8f1a82e98b3d9845_RGBA_0, _Multiply_4eba5955b09345558e792fe0232a0551_Out_2);
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_R_1 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[0];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_G_2 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[1];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_B_3 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[2];
                    float _Split_6d41ccf4305240b7ba29e0d66c8d0a2b_A_4 = _Multiply_4eba5955b09345558e792fe0232a0551_Out_2[3];
                    float _Property_7d3bdf602b99497eac7c62cb0a1de3b9_Out_0 = _DisTexStepSmooth;
                    float4 _Property_65268079add34c4e804825ec7a71efec_Out_0 = Vector4_557daace24cb4636a4af16509914c72f;
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_R_1 = _Property_65268079add34c4e804825ec7a71efec_Out_0[0];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_G_2 = _Property_65268079add34c4e804825ec7a71efec_Out_0[1];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_B_3 = _Property_65268079add34c4e804825ec7a71efec_Out_0[2];
                    float _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_A_4 = _Property_65268079add34c4e804825ec7a71efec_Out_0[3];
                    float4 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGBA_4;
                    float3 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGB_5;
                    float2 _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6;
                    Unity_Combine_float(_Split_2d06a5d7f5c849b89af1d9f0e06c48aa_R_1, _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_G_2, 0, 0, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGBA_4, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RGB_5, _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6);
                    float2 _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2;
                    Unity_Add_float2((_Multiply_5907cff5598745c38d7e87ee003b54c2_Out_2.xx), _Combine_d60b100c93f64304ad53d612a0e3d2b5_RG_6, _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2);
                    float4 _Combine_64df2bdcd9244910ba63c82359f35d21_RGBA_4;
                    float3 _Combine_64df2bdcd9244910ba63c82359f35d21_RGB_5;
                    float2 _Combine_64df2bdcd9244910ba63c82359f35d21_RG_6;
                    Unity_Combine_float(_Split_2d06a5d7f5c849b89af1d9f0e06c48aa_B_3, _Split_2d06a5d7f5c849b89af1d9f0e06c48aa_A_4, 0, 0, _Combine_64df2bdcd9244910ba63c82359f35d21_RGBA_4, _Combine_64df2bdcd9244910ba63c82359f35d21_RGB_5, _Combine_64df2bdcd9244910ba63c82359f35d21_RG_6);
                    float4 _Property_2002f4ad45de4f3788ada633c47883ac_Out_0 = _DisTexSpeed;
                    float4 _Multiply_0b54c1894cce468ea71310c555797e69_Out_2;
                    Unity_Multiply_float(_Property_2002f4ad45de4f3788ada633c47883ac_Out_0, (IN.TimeParameters.x.xxxx), _Multiply_0b54c1894cce468ea71310c555797e69_Out_2);
                    float2 _Add_385457bd7bcf4d69a7735f97024bab24_Out_2;
                    Unity_Add_float2(_Combine_64df2bdcd9244910ba63c82359f35d21_RG_6, (_Multiply_0b54c1894cce468ea71310c555797e69_Out_2.xy), _Add_385457bd7bcf4d69a7735f97024bab24_Out_2);
                    float2 _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, _Add_8a5a200b95d84313ae4975c0ac54a390_Out_2, _Add_385457bd7bcf4d69a7735f97024bab24_Out_2, _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3);
                    float4 _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0 = SAMPLE_TEXTURE2D(_DisTex, sampler_DisTex, _TilingAndOffset_82cecdb65cfe4b488169dc899c27dcdd_Out_3);
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_R_4 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.r;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_G_5 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.g;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_B_6 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.b;
                    float _SampleTexture2D_87ad03c8523043feb564e133e3472445_A_7 = _SampleTexture2D_87ad03c8523043feb564e133e3472445_RGBA_0.a;
                    float _Add_bbd2209640b14872ae2f0c64037f56c5_Out_2;
                    Unity_Add_float(_SampleTexture2D_87ad03c8523043feb564e133e3472445_R_4, _SampleTexture2D_87ad03c8523043feb564e133e3472445_G_5, _Add_bbd2209640b14872ae2f0c64037f56c5_Out_2);
                    float _Add_5deebdc0a5f04cffab6096fd15406136_Out_2;
                    Unity_Add_float(_SampleTexture2D_87ad03c8523043feb564e133e3472445_B_6, _SampleTexture2D_87ad03c8523043feb564e133e3472445_A_7, _Add_5deebdc0a5f04cffab6096fd15406136_Out_2);
                    float _Add_8c567749c0f34604bf3146789ac90c01_Out_2;
                    Unity_Add_float(_Add_bbd2209640b14872ae2f0c64037f56c5_Out_2, _Add_5deebdc0a5f04cffab6096fd15406136_Out_2, _Add_8c567749c0f34604bf3146789ac90c01_Out_2);
                    float _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2;
                    Unity_Divide_float(_Add_8c567749c0f34604bf3146789ac90c01_Out_2, 4, _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2);
                    float _InverseLerp_ed66297faaa94174809a4c827835fead_Out_3;
                    Unity_InverseLerp_float(_Property_7d3bdf602b99497eac7c62cb0a1de3b9_Out_0, 1.1, _Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2, _InverseLerp_ed66297faaa94174809a4c827835fead_Out_3);
                    float _Property_11fb25c356ce4fde9c81bd1c907e3cc0_Out_0 = _DisTexStep;
                    float _Step_b808e6940eb14a9dbd1374f8f9528664_Out_2;
                    Unity_Step_float(_Divide_73d5a9be7eda45cea8bdfc9a8a279631_Out_2, _Property_11fb25c356ce4fde9c81bd1c907e3cc0_Out_0, _Step_b808e6940eb14a9dbd1374f8f9528664_Out_2);
                    float _OneMinus_a0c152641255443596271035468f6786_Out_1;
                    Unity_OneMinus_float(_Step_b808e6940eb14a9dbd1374f8f9528664_Out_2, _OneMinus_a0c152641255443596271035468f6786_Out_1);
                    float _Multiply_472de54326b84979813b985add57417b_Out_2;
                    Unity_Multiply_float(_InverseLerp_ed66297faaa94174809a4c827835fead_Out_3, _OneMinus_a0c152641255443596271035468f6786_Out_1, _Multiply_472de54326b84979813b985add57417b_Out_2);
                    float _Multiply_e6931bda90fe4fd09db32135618f544f_Out_2;
                    Unity_Multiply_float(_Split_6d41ccf4305240b7ba29e0d66c8d0a2b_A_4, _Multiply_472de54326b84979813b985add57417b_Out_2, _Multiply_e6931bda90fe4fd09db32135618f544f_Out_2);
                    float _Clamp_777ce98db01a49169ebede34e361ea37_Out_3;
                    Unity_Clamp_float(_Multiply_e6931bda90fe4fd09db32135618f544f_Out_2, 0, 1, _Clamp_777ce98db01a49169ebede34e361ea37_Out_3);
                    surface.Alpha = _Clamp_777ce98db01a49169ebede34e361ea37_Out_3;
                    return surface;
                }
    
                // --------------------------------------------------
                // Build Graph Inputs
    
                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);
                
                    output.ObjectSpaceNormal =           input.normalOS;
                    output.ObjectSpaceTangent =          input.tangentOS;
                    output.ObjectSpacePosition =         input.positionOS;
                
                    return output;
                }
                
                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                
                
                
                
                
                    output.uv0 =                         input.texCoord0;
                    output.VertexColor =                 input.color;
                    output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                
                    return output;
                }
                
    
                // --------------------------------------------------
                // Main
    
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
    
                ENDHLSL
            }
        }
        FallBack "Hidden/Shader Graph/FallbackError"
    }
