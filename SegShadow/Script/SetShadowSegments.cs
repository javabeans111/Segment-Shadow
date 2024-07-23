using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]
public class SetShadowSegments : MonoBehaviour
{
    //[HideInInspector]
    public Vector4[] segments;
    public Transform centerObject;
    [Range(0f,1f)]
    public float shadowDensity = 0.5f;

    // Start is called before the first frame update
    void Start()
    {
        //MUST declare and init segments explicitly at first due to Unity design
        segments = new Vector4[128];
        for (int i = 1; i < 128; i++) segments[i] = new Vector4(0f, 0f, 0f, 0f);
        ////////////////////////////x    z    x    z///////////////////
        segments[0] =  new Vector4(0f, 10f, 10f, 0f);
        segments[1] = (new Vector4(0f, -10f, -10f, 0f));
        segments[2] = (new Vector4(0f, 20f, -20f, 0f));
        segments[3] = (new Vector4(0f, -20f, 20f, 0f));
        segments[4] = (new Vector4(0f, 40f, 40f, 0f));
        segments[5] = (new Vector4(0f, -40f, -40f, 0f));
        segments[6] = (new Vector4(50f, 50f, 100f, 100f));
        segments[7] = (new Vector4(-50f, -50f, -100f, -100f));
        segments[8] = (new Vector4(-50f, 50f, -100f, 100f));
    }

    //float SHADOWSEGSA[MAXSEGMENTS];
    //float2 CENTER;

    // Update is called once per frame
    void Update()
    {
        //Start();
        Shader.SetGlobalVectorArray("SHADOWSEGSA", segments);

        Vector3 centerPos = centerObject.position;
        Shader.SetGlobalVector("CENTER", new Vector4(centerPos.x, centerPos.y, centerPos.z,0f));

        Shader.SetGlobalFloat("SEGSHADOW_DENSITY", shadowDensity);
        
    }
}
