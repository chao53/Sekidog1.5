using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class cameraScript : MonoBehaviour
{
    
    public Transform _Player;
    public GameObject viewMode;
    //public GameObject Evensystem;

    void Start()
    {
        //viewer = Evensystem.gameObject.GetComponent<dataScript>().viewer;
    }

    public void attatchPlayer(int x)
    {
        _Player = GameObject.Find("player" + x).transform;
    }

    void LateUpdate()
    {
        //viewer = Evensystem.gameObject.GetComponent<dataScript>().viewer;

        float dx = viewMode.gameObject.GetComponent<viewControl>().input2.x;
        float dy = viewMode.gameObject.GetComponent<viewControl>().input2.y;

        transform.position = new Vector3(_Player.position.x + 0.5f, _Player.position.y + 2 + dx / 50, _Player.position.z - 3 + Mathf.Abs(dx) / 30);
        transform.localRotation = Quaternion.Euler(dx, 0, 0);
        transform.RotateAround(_Player.position, _Player.up, dy);
    }
}
