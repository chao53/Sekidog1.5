using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class fireScript : MonoBehaviour
{
    public float existTime = 1.8f;
    // Start is called before the first frame update
    void Start()
    {
        Destroy(gameObject, existTime);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
