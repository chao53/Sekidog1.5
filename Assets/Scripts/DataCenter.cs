using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sekidog;

public class DataCenter : MonoBehaviour
{
    public GameObject stickMode;
    public GameObject viewMode;
    public GameObject UIblood;
    public GameObject UInameTag;
    public PlayerScript _player;
    public GameObject zhunxing;
    //public GameObject UIblood;
    // Start is called before the first frame update
    void Start()
    {

    }

    public void Jump()
    {
        _player.Jump();
    }

    public void changeFightState(int way)
    {
        _player.changeFightState(way);
    }

    public void Roll()
    {
        _player.Roll();
    }

    // Update is called once per frame
    void Update()
    {

    }
}


