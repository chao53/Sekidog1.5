//作者：陈炜潮
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MirrorCamera : MonoBehaviour
{
    public GameObject mirror;
    public GameObject MainCamera;

    //public RenderTexture rt;
    //public Material m;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    void Update()
    {
        //求平面的法向量
        Vector3 mirrorDirect = new Vector3(Mathf.Sin(mirror.transform.rotation.eulerAngles.y *  Mathf.PI/ 180) * Mathf.Cos(mirror.transform.rotation.eulerAngles.z * Mathf.PI / 180), 
            -Mathf.Sin(mirror.transform.rotation.eulerAngles.x * Mathf.PI / 180) * Mathf.Cos(mirror.transform.rotation.eulerAngles.z * Mathf.PI / 180),
            Mathf.Cos(mirror.transform.rotation.eulerAngles.x * Mathf.PI / 180) * Mathf.Cos(mirror.transform.rotation.eulerAngles.y * Mathf.PI / 180));
        
        //主摄像机到平面的距离
        float dis = Vector3.Dot(MainCamera.transform.position, mirrorDirect) - Vector3.Dot(mirror.transform.position, mirrorDirect);

        //镜像摄像机的位置
        this.transform.position = MainCamera.transform.position - 2 * dis * mirrorDirect;

        //求能让视角梯形与平面边界相切的旋转角度
        Vector3 v1 = new Vector3(0.5f*mirror.transform.localScale.x * Mathf.Cos(mirror.transform.rotation.eulerAngles.y * Mathf.PI / 180) * Mathf.Cos(mirror.transform.rotation.eulerAngles.z * Mathf.PI / 180),
            -0.5f * mirror.transform.localScale.x * Mathf.Cos(mirror.transform.rotation.eulerAngles.x * Mathf.PI / 180) * Mathf.Sin(mirror.transform.rotation.eulerAngles.z * Mathf.PI / 180),
            -0.5f * mirror.transform.localScale.x * Mathf.Cos(mirror.transform.rotation.eulerAngles.x * Mathf.PI / 180) * Mathf.Sin(mirror.transform.rotation.eulerAngles.y * Mathf.PI / 180));

        Vector3 v2 = new Vector3(-0.5f * mirror.transform.localScale.y * Mathf.Cos(mirror.transform.rotation.eulerAngles.y * Mathf.PI / 180) * Mathf.Sin(mirror.transform.rotation.eulerAngles.z * Mathf.PI / 180),
           0.5f * mirror.transform.localScale.y * Mathf.Cos(mirror.transform.rotation.eulerAngles.x * Mathf.PI / 180) * Mathf.Cos(mirror.transform.rotation.eulerAngles.z * Mathf.PI / 180),
           0.5f * mirror.transform.localScale.y * Mathf.Sin(mirror.transform.rotation.eulerAngles.x * Mathf.PI / 180) * Mathf.Cos(mirror.transform.rotation.eulerAngles.y * Mathf.PI / 180));

        Vector3 direct = (mirror.transform.position + v1 - this.transform.position).normalized + (mirror.transform.position - v1 - this.transform.position).normalized
            + (mirror.transform.position + v2 - this.transform.position).normalized + (mirror.transform.position - v2 - this.transform.position).normalized; 
        this.transform.rotation = Quaternion.LookRotation(direct);

        //求能让视角梯形与平面边界相切的视角

        float a1 = Vector3.Cross((mirror.transform.position + v1)-this.transform.position, v2.normalized).magnitude;
        float a2 = Vector3.Cross((mirror.transform.position - v1)-this.transform.position, v2.normalized).magnitude;
        float a3 = Vector3.Cross((mirror.transform.position + v2)-this.transform.position, v1.normalized).magnitude;
        float a4 = Vector3.Cross((mirror.transform.position - v2)-this.transform.position, v1.normalized).magnitude;

        float wView = 180 - (Mathf.Acos((Mathf.Pow(mirror.transform.localScale.x, 2) - Mathf.Pow(a1, 2) - Mathf.Pow(a2, 2))/ (2 * a1 * a2))) * (180 / Mathf.PI);
        float hView = 180 - (Mathf.Acos((Mathf.Pow(mirror.transform.localScale.y, 2) - Mathf.Pow(a3, 2) - Mathf.Pow(a4, 2))/ (2 * a3 * a4))) * (180 / Mathf.PI);
        this.GetComponent<Camera>().fieldOfView = Mathf.Min(wView, hView);

        //print(wView + " " + hView);
        //print(a1 + " " + a2 + " " + tt1 + " " + tt2 + " " + tt3 + " " + tt4);

        //rt = new RenderTexture((int)(512 * Mathf.Tan(wView)/ (Mathf.Tan(wView) + Mathf.Tan(hView))), (int)(512 * Mathf.Tan(hView) / (Mathf.Tan(wView) + Mathf.Tan(hView))), 0);
        //this.GetComponent<Camera>().targetTexture = rt;
        
    }
}
