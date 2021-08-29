using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sekidog;

public class damScript : MonoBehaviour
{
    public int dam;
    public int type;
    [HideInInspector]
    private GameObject owner;
    private ArrayList hitList = new ArrayList();

    
    void OnTriggerStay(Collider col)
    {
       
        owner = this.transform.parent.gameObject.GetComponent<ownerScript>().owner;
        if (col.tag == "player" && col.gameObject != owner && !hitList.Contains(col))
        {
  
            hitList.Add(col);

            if (owner.GetComponent<PlayerScript>().isLocalPlayer)//»÷ÖÐ·´À¡
            {
                owner.GetComponent<PlayerScript>().zhunxingTimer = 0.5f;
            }

            if (col.GetComponent<PlayerScript>().isLocalPlayer)
            {
                print(this.name + "" + col.name);
                col.GetComponent<PlayerScript>().takeDamage(owner, dam, type);
            }
        }
    }

    //private void OnTriggerExit(Collider col)
    //{
    //    if (col.tag == "player" && col.name != EventSystem.GetComponent<player1Script>().player1.name && _switch)
    //    {
    //        EventSystem.GetComponent<player1Script>().swordLeave();
    //    }
    //}


    // Update is called once per frame
    void Update()
    {

    }
}