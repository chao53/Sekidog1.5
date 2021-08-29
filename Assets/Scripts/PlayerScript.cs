using Mirror;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

namespace Sekidog
{

    public class PlayerScript : NetworkBehaviour
    {
        public GameObject nameTag;
        private GameObject UInameTag;
        public GameObject playerBlood;
        private GameObject UIBlood;
        private GameObject zhunxing;

        public AudioSource sound1;//人移动的声音
        public AudioSource sound2;//剑的声音
        public AudioSource sound3;//剑碰撞的声音
        public AudioSource sound4;//火焰 

        public float speed = 6;
        public int totalHp = 50;
        private int Hp;

        private Vector2 toward; //敌人朝向

        private DataCenter dataCenter;
        private SceneScript sceneScript;
        //private Material playerMaterialClone;
        private Animator _Animator;

        private float speedAdjust = 1;//速度缩放因子

        private bool CanSecondJump;
        private float jumpTimer;
        private float jump;

        private float rollCD = 0;
        private float fireCD = 0;
        private float actionCD = 0;
        private int actionState = 0;
        private int Hand = 0;

        public float zhunxingTimer;

        private int sparkCount = 0;
        private int spark3switch = 1;

        [SyncVar(hook = nameof(OnAnimatorChanged))]
        public string animatorInfo;

        [SyncVar(hook = nameof(OnNameChanged))]
        public string playerName;

        //[SyncVar(hook = nameof(OnColorChanged))]
        //public Color playerColor = Color.white;
        void Awake()
        {
            //allow all players to run this
            sceneScript = FindObjectOfType<SceneScript>();
            _Animator = GetComponent<Animator>();
            Hp = totalHp;
        }

        [Command]
        void CmdChangePlayerAni(string _animatorInfo)
        {
            animatorInfo = _animatorInfo;
        }

        [Command]
        void CmdGenerateSwordLight(string str)
        {
            RpcGenerateSwordLight(str);
        }

        [ClientRpc]
        void RpcGenerateSwordLight(string str)
        {
            GameObject c1 = Instantiate(Resources.Load<GameObject>(str), transform.position, transform.rotation);
            c1.GetComponent<ownerScript>().owner = this.gameObject;
        }

        [Command]
        void CmdGenerateSwordSound(int id, string str)
        {
            RpcGenerateSwordSound(id,str);
        }

        [ClientRpc]
        void RpcGenerateSwordSound(int id,string str)
        {
            switch (id)
            {
                case 1:
                    sound1.clip = Resources.Load<AudioClip>(str);
                    sound1.Play();
                    break;
                case 2:
                    sound2.clip = Resources.Load<AudioClip>(str);
                    sound2.Play();
                    break;
                case 3:
                    sound3.clip = Resources.Load<AudioClip>(str);
                    sound3.Play();
                    break;
                case 4:
                    sound4.clip = Resources.Load<AudioClip>(str);
                    sound4.Play();
                    break;
            }
        }


        [Command]
        void CmdGenerateFire()
        {
            RpcGenerateFire();
        }

        [ClientRpc]
        void RpcGenerateFire()
        {
            GameObject c1 = Instantiate(Resources.Load<GameObject>("Prefabs/fire"), transform.position +
                new Vector3(Mathf.Sin(transform.rotation.eulerAngles.y * Mathf.PI / 180), 1.4f, Mathf.Cos(transform.rotation.eulerAngles.y * Mathf.PI / 180)),transform.rotation);
            c1.GetComponent<ownerScript>().owner = this.gameObject;
        }

        [Command]
        void CmdGenerateFeibiao(Vector3 spPos,Vector3 feibiaoVelocity)
        {
            RpcGenerateFeibiao(spPos,feibiaoVelocity);
        }

        [ClientRpc]
        void RpcGenerateFeibiao(Vector3 spPos, Vector3 feibiaoVelocity)
        {
            GameObject cf1 = Instantiate(Resources.Load<GameObject>("Prefabs/feibiao"), spPos, Quaternion.Euler(0, transform.rotation.eulerAngles.y + 90, 0));
            GameObject cf2 = Instantiate(Resources.Load<GameObject>("Prefabs/feibiao"), spPos, Quaternion.Euler(0, transform.rotation.eulerAngles.y + 90, 0));
            GameObject cf3 = Instantiate(Resources.Load<GameObject>("Prefabs/feibiao"), spPos, Quaternion.Euler(0, transform.rotation.eulerAngles.y + 90, 0));
            cf1.GetComponent<ownerScript>().owner = this.gameObject;
            cf2.GetComponent<ownerScript>().owner = this.gameObject;
            cf3.GetComponent<ownerScript>().owner = this.gameObject;

            cf1.GetComponent<Rigidbody>().velocity = feibiaoVelocity;
            cf2.GetComponent<Rigidbody>().velocity = new Vector3(Mathf.Cos(Mathf.PI / 36) * feibiaoVelocity.x - Mathf.Sin(Mathf.PI / 36) * feibiaoVelocity.z, feibiaoVelocity.y, Mathf.Sin(Mathf.PI / 36) * feibiaoVelocity.x + Mathf.Cos(Mathf.PI / 36) * feibiaoVelocity.z);
            cf3.GetComponent<Rigidbody>().velocity = new Vector3(Mathf.Cos(-Mathf.PI / 36) * feibiaoVelocity.x - Mathf.Sin(-Mathf.PI / 36) * feibiaoVelocity.z, feibiaoVelocity.y, Mathf.Sin(-Mathf.PI / 36) * feibiaoVelocity.x + Mathf.Cos(-Mathf.PI / 36) * feibiaoVelocity.z);
        }

        public void takeDamage(GameObject enemy, int dam, int type)
        {
            print(enemy + "" + dam);
            Vector2 face = new Vector2(Mathf.Sin(transform.rotation.eulerAngles.y * Mathf.PI / 180), Mathf.Cos(transform.rotation.eulerAngles.y * Mathf.PI / 180));
            toward = new Vector2((transform.position - enemy.transform.position).x, (transform.position - enemy.transform.position).z).normalized;
            if (actionState != -1 || Vector2.Dot(face, toward) > 0)
            {
                print(actionState + " " + Vector2.Dot(face, toward));

                if (actionState == 3)//除了霸体外，僵直
                {                   
                    CmdTakeDamage(toward, dam, 2);//不僵直
                }
                else
                {
                    CmdTakeDamage(toward, dam, 1);
                }
                
            }
            else
            {
                if(type == 1)
                {
                    CmdDuang(enemy,1);//有僵直回弹
                }
                else if(type == 2)
                {
                    CmdTakeDamage(toward, dam, 2);
                }
                else if(type == 3)
                {
                    CmdDuang(enemy, 2);
                }
            }
        }

        [Command]
        public void CmdTakeDamage(Vector2 toward,int dam,int type)
        {
            RpcTakeDamage(toward, dam,type);
        }

        [ClientRpc]
        void RpcTakeDamage(Vector2 toward, int dam,int type)
        {
            if(type == 1)
            {
                this.toward = toward;
                actionState = -3;
                Hand = actionState;
                actionCD = 0.1f;
            }
          
            Hp -= dam;
            if (!isLocalPlayer)
            {
                playerBlood.transform.localScale = new Vector3((float)(Hp) / totalHp, 1, 1);
                playerBlood.transform.localPosition = new Vector3(-0.5f * ((float)(totalHp - Hp) / totalHp), 0, -0.001f);
            }
            else
            {
                UIBlood.GetComponent<RectTransform>().sizeDelta = new Vector2(400 * (float)Hp / totalHp, 20);
                UIBlood.GetComponent<RectTransform>().anchoredPosition = new Vector2(-200 * (float)(totalHp - Hp) / totalHp, 10);
            }

            if (type == 1 || type == 3)
            {
                Instantiate(Resources.Load<GameObject>("Prefabs/spark2"), transform.position, Quaternion.Euler(0, 0, 0));
                sound3.clip = Resources.Load<AudioClip>("Musics/Hurt");
                sound3.Play();
            }         
        }


        [Command]
        public void CmdDuang(GameObject enemy,int type)
        {
            RpcDuang(enemy,type);
        }

        [ClientRpc]
        void RpcDuang(GameObject enemy,int type)
        {
            if(type == 1)
            {
                GameObject c1 = Instantiate(Resources.Load<GameObject>("Prefabs/duangDam"), enemy.transform.position, enemy.transform.rotation);
                c1.GetComponent<ownerScript>().owner = this.gameObject;
            }
            Instantiate(Resources.Load<GameObject>("Prefabs/spark"), transform.position, Quaternion.Euler(0, 0, 0));
            sound3.clip = Resources.Load<AudioClip>("Musics/duang" + (sparkCount % 2 + 1));
            sound3.Play();
            sparkCount++;
        }

        void OnAnimatorChanged(string _Old, string _New)
        {
            string[] vs = animatorInfo.Split('_');
            _Animator.SetFloat("Ix", float.Parse(vs[0]));
            _Animator.SetFloat("Iz", float.Parse(vs[1]));
            _Animator.SetFloat("Jump", float.Parse(vs[2]));
            _Animator.SetFloat("JumpTimer", float.Parse(vs[3]));
            _Animator.SetInteger("Hand", int.Parse(vs[4]));
        }


        [Command]//客户端向服务端发出命令
        public void CmdSendPlayerMessage()
        {
            if (sceneScript)
            {
                sceneScript.statusText = $"{playerName} says hello {Random.Range(10, 99)}";
            }
        }


        [Command]
        public void CmdSetupPlayer(string _name, Color _col)
        {
            //player info sent to server, then server updates sync vars which handles it on all clients
            playerName = _name;
            //playerColor = _col;
            sceneScript.statusText = $"{playerName} joined.";
        }

        void OnNameChanged(string _Old, string _New)
        {
            if (!isLocalPlayer)
            {
                nameTag.GetComponent<TMP_Text>().text = playerName;
            }
            else
            {
                UInameTag.GetComponent<Text>().text = playerName;
            }
        }

        //void OnColorChanged(Color _Old, Color _New)
        //{
        //    //this.GetComponent<MeshRenderer>().material.color = _New;

        //}

        public override void OnStartLocalPlayer()
        {
            sceneScript.playerScript = this;
            dataCenter = FindObjectOfType<DataCenter>();
            dataCenter._player = this;
            GameObject.Find("UICamera").GetComponent<cameraScript>()._Player = this.transform;
            GameObject.Find("Main Camera").GetComponent<cameraScript>()._Player = this.transform;

            UIBlood = dataCenter.UIblood;
            UInameTag = dataCenter.UInameTag;
            zhunxing = dataCenter.zhunxing;
            nameTag.SetActive(false);

            string name = "Player" + Random.Range(100, 999);
            Color color = new Color(Random.Range(0f, 1f), Random.Range(0f, 1f), Random.Range(0f, 1f));
            //print(NetworkClient.ready);
            CmdSetupPlayer(name, color);
        }

        public void Jump()
        {
            if (GetComponent<Rigidbody>().velocity.y <= 0.02f && GetComponent<Rigidbody>().velocity.y >= -0.02f)
            {
                GetComponent<Rigidbody>().velocity = Vector3.up * 7.2f;
                jumpTimer = 1f;
                CmdGenerateSwordSound(1, "Musics/jump");
                CanSecondJump = true;
            }
            else if (jumpTimer > 0.4f && CanSecondJump && actionCD <= 0)
            {
                GetComponent<Rigidbody>().velocity = Vector3.up * 7.2f;
                Hand = 5;
                actionCD = 0.6f;
                actionState = 5;
                CmdGenerateSwordSound(1, "Musics/jump");
                CanSecondJump = false;
            }
        }

        public void Roll()
        {
            if (rollCD <= 0 && actionCD <= 0 && actionState == 0)
            {
                rollCD = 1.068f;
                speedAdjust = 2f;
                CmdGenerateSwordSound(1, "Musics/jump");
                actionCD = 1f;
                Hand = 7;
                actionState = 7;
                StartCoroutine(rollCountdown());
            }
        }

        IEnumerator rollCountdown()
        {
            for (float timer = 1.067f; timer >= 0; timer -= Time.deltaTime)
            {
                if (timer < 0.75f && speedAdjust > 0.8f)
                {
                    speedAdjust -= 3 * Time.deltaTime;
                }
                yield return 0;
            }
            speedAdjust = 1;
        }


        
        public void changeFightState(int way)
        {
            //三段击
            if(way == 1)
            {
                if (actionState == 0 || actionState == -2 || actionState == 6 || actionState == 8)
                {
                    if (actionCD <= 0.15f)
                    {
                        actionState = 1;
                        Hand = actionState;
                        CmdGenerateSwordLight("Prefabs/SLight01");
                        CmdGenerateSwordSound(2, "Musics/swordWind");
                        actionCD = 0.767f;

                    }
                }
                else if (actionState == 1)
                {
                    if (actionCD <= 0.15f)
                    {
                        actionState = 2;
                        Hand = actionState;
                        CmdGenerateSwordLight("Prefabs/SLight02");
                        CmdGenerateSwordSound(2, "Musics/swordWind2");
                        actionCD = 0.767f;
                    }
                }
                else if (actionState == 2)
                {
                    if (actionCD <= 0.05f)
                    {
                        actionState = 3;
                        Hand = actionState;
                        StartCoroutine(swordCountdown());
                        CmdGenerateSwordSound(2, "Musics/swordWind3");
                        actionCD = 1.6f;
                    }
                }
                else if (actionState == 3)
                {
                    if (actionCD <= 0.05f)
                    {
                        actionState = 1;
                        Hand = actionState;
                        CmdGenerateSwordLight("Prefabs/SLight01");
                        CmdGenerateSwordSound(2, "Musics/swordWind");
                        actionCD = 0.767f;
                    }
                }
                else if (actionState == -1)//反击
                {
                    if (actionCD <= 0.5f)
                    {
                        actionState = -2;
                        Hand = actionState;
                        CmdGenerateSwordLight("Prefabs/SLight00");
                        CmdGenerateSwordSound(2, "Musics/swordWind2");
                        actionCD = 0.467f;
                    }
                }
                else if (actionState == 5)//落地斩
                {
                    if (actionCD >= -0.1f && actionCD <= 0.5f)
                    {
                        actionState = 6;
                        Hand = actionState;
                        CmdGenerateSwordLight("Prefabs/SLight06");
                        CmdGenerateSwordSound(2, "Musics/swordWind2");
                        actionCD = 0.567f;
                    }
                }
                else if (actionState == 7)//上撩击
                {
                    if (actionCD <= 0.4f)
                    {
                        actionState = 8;
                        Hand = actionState;
                        CmdGenerateSwordLight("Prefabs/SLight08");
                        CmdGenerateSwordSound(2, "Musics/swordWind");
                        actionCD = 0.45f;
                    }
                }
            }
            //特殊攻击
            else if (way == 2)
            {
                if (actionCD <= 0 && fireCD <= 0)
                {
                    actionState = 4;
                    Hand = actionState;
                    StartCoroutine(fireCountdown());
                    CmdGenerateSwordSound(4, "Musics/fire");
                    actionCD = 0.667f;
                    fireCD = 2f;
                }
            }
            //格挡
            else if (way == -1)
            {
                if (actionCD <= 0)
                {
                    actionState = -1;
                    Hand = actionState;
                    actionCD = 0.733f;
                }
            }
            //手里剑
            else if (way == 4)
            {
                if (actionCD <= 0)
                {
                    actionState = 9;
                    Hand = actionState;
                    spark3switch = 0;
                    StartCoroutine(feibiaoCountdown(-0.2f));
                    actionCD = 0.5f;
                }
                else if (actionState == 9 && actionCD < 0.4f)
                {
                    spark3switch++;
                    StartCoroutine(feibiaoCountdown(actionCD));
                    actionCD += 0.5f;
                }
            }
        }
        IEnumerator swordCountdown()
        {
            for (float timer = 0.2f; timer >= 0; timer -= Time.deltaTime)
            {
                yield return 0;
            }
            CmdGenerateSwordLight("Prefabs/SLight031");
            for (float timer = 0.4f; timer >= 0; timer -= Time.deltaTime)
            {
                yield return 0;
            }
            CmdGenerateSwordLight("Prefabs/SLight032");
            for (float timer = 0.2f; timer >= 0; timer -= Time.deltaTime)
            {
                yield return 0;
            }
            CmdGenerateSwordLight("Prefabs/SLight033");
            for (float timer = 0.3f; timer >= 0; timer -= Time.deltaTime)
            {
                yield return 0;
            }
            CmdGenerateSwordLight("Prefabs/SLight034");
        }
        IEnumerator fireCountdown()
        {
            for (float timer = 0.4f; timer >= 0; timer -= Time.deltaTime)
            {
                yield return 0;
            }
            CmdGenerateFire();
        }

        IEnumerator feibiaoCountdown(float exTime)
        {
            int m = spark3switch % 2;
            for (float timer = 0.3f + exTime; timer >= 0; timer -= Time.deltaTime)
            {
                speedAdjust = 0;
                yield return 0;
            }
            CmdGenerateSwordSound(2, "Musics/feibiao");
            GameObject csp3 = Instantiate(Resources.Load<GameObject>("Prefabs/spark" + (3 + m)), transform.position, transform.rotation);
            Vector3 spPos = csp3.transform.GetChild(0).position;
            for (float timer = 0.5f; timer >= 0; timer -= Time.deltaTime)
            {
                speedAdjust = 0;
                yield return 0;
            }
            speedAdjust = 3;
            //定义射线
            Ray m_ray;
            //保存碰撞信息
            RaycastHit m_hit;
            //创建一条从摄像机发出经过屏幕上的鼠标点的一条射线
            m_ray = Camera.main.ScreenPointToRay(new Vector2(Screen.width / 2, Screen.height / 2));
            //判断射线是否碰撞到物体

            Vector3 feibiaoVelocity;
            if (Physics.Raycast(m_ray, out m_hit))
            {
                if (m == 1)
                {
                    feibiaoVelocity = (m_hit.point - spPos).normalized * 20 + new Vector3(0, 0.1f, 0);
                }
                else
                {
                    feibiaoVelocity = (m_hit.point - spPos).normalized * 20;
                }
            }
            else
            {
                feibiaoVelocity = new Vector3(Mathf.Sin(Camera.main.transform.rotation.eulerAngles.y * Mathf.PI / 180) * Mathf.Cos(Camera.main.transform.rotation.eulerAngles.z * Mathf.PI / 180),
                -Mathf.Sin(Camera.main.transform.rotation.eulerAngles.x * Mathf.PI / 180) * Mathf.Cos(Camera.main.transform.rotation.eulerAngles.z * Mathf.PI / 180),
                Mathf.Cos(Camera.main.transform.rotation.eulerAngles.x * Mathf.PI / 180) * Mathf.Cos(Camera.main.transform.rotation.eulerAngles.y * Mathf.PI / 180)).normalized * 20;
            }
            
            CmdGenerateFeibiao(spPos, feibiaoVelocity);

            for (float timer = 0.2f; timer >= 0; timer -= Time.deltaTime)
            {
                yield return 0;
            }
            speedAdjust = 1;
        }
        void Update()
        {
            if (!isLocalPlayer)
            {
                // make non-local players run this

                return;
            }

            float Ix;
            float Iz;
            float Ia = dataCenter.viewMode.GetComponent<viewControl>().input2.y;
            float angle = -1 * Mathf.PI * Ia / 180;


            if (actionCD >= 0 && actionState != 5 && actionState != 7 && actionState != 9)//二段跳,扔飞镖和翻滚可以移动
            {
                Ix = 0;
                Iz = 0;
                if (actionState == 1 || actionState == 2)//二段击
                {
                    if (actionCD < 0.6f && actionCD > 0.5f)
                    {
                        Iz = 2f;
                    }                    
                }
                else if (actionState == 3)//霸体击
                {
                    if (actionCD < 1.2f && actionCD > 1.1f)
                    {
                        Iz = 1f;
                    }
                    else if (actionCD < 1.1f && actionCD > 0.9f)
                    {
                        //hadhurt = false;
                    }
                    else if (actionCD < 0.9f && actionCD > 0.8f)
                    {
                        Iz = 1f;                       
                    }
                    else if (actionCD < 0.8f && actionCD > 0.6f)
                    {
                        //hadhurt = false;
                    }
                    else if (actionCD < 0.6f && actionCD > 0.5f)
                    {
                        Iz = 1f;
                    }
                    else if (actionCD < 0.5f && actionCD > 0.35f)
                    {
                        //hadhurt = false;
                    }
                    else if (actionCD < 0.35f && actionCD > 0.25f)
                    {
                        Iz = 2f;
                    }
                }
                else if (actionState == -2)//反击
                {
                    if (actionCD < 0.4f && actionCD > 0.3f)
                    {
                        Iz = 2f;
                    }
                }
                else if (actionState == 6)//落地斩
                {
                    if (actionCD < 0.5f && actionCD > 0.3f)
                    {
                        Iz = 2f;
                    }
                }
                else if (actionState == 8)//上撩击
                {
                    if (actionCD < 0.3f && actionCD > 0.2f)
                    {
                        Iz = 2f;
                    }
                }
                else if (actionState == 4)//特击
                {
                    if (actionCD < 0.4f && actionCD > 0.3f)
                    {
                        Iz = -2f;

                    }
                }
                else if (actionState == -3)//僵直
                {
                    if (actionCD < 0.1f && actionCD > 0)
                    {
                        Ix = 1.5f * (toward.x * Mathf.Cos(angle) + toward.y * Mathf.Sin(angle));
                        Iz = 1.5f * (-toward.x * Mathf.Sin(angle) + toward.y * Mathf.Cos(angle));
                        //print(toward.x + " " + toward.y + " " + Ix + " " + Iz + " " + angle);
                    }
                }
            }
            else
            {
                Ix = dataCenter.stickMode.GetComponent<MyjoyStick>().input.x;
                Iz = dataCenter.stickMode.GetComponent<MyjoyStick>().input.y;
            }
  
            float dx = Mathf.Cos(angle) * Ix - Mathf.Sin(angle) * Iz;
            float dz = Mathf.Sin(angle) * Ix + Mathf.Cos(angle) * Iz;

            float dy = GetComponent<Rigidbody>().velocity.y;
            Vector3 moveDirection = new Vector3(speed * speedAdjust * dx, dy, speed * speedAdjust * dz);
            GetComponent<Rigidbody>().velocity = moveDirection;
            transform.localRotation = Quaternion.Euler(0, Ia, 0);
            
            //跳跃动画
            if (jumpTimer > 0)
            {
                jumpTimer -= Time.deltaTime;               
                if (jumpTimer > 0.66f)
                {
                    jump = 3 - 3 * jumpTimer;
                }
                else if (jumpTimer <= 0.66f && jumpTimer > 0.33f)
                {
                    jump = 1;
                }
                else if (jumpTimer <= 0.33f)
                {
                    jump = 3 * jumpTimer;
                }
            }

            rollCD -= Time.deltaTime;
            fireCD -= Time.deltaTime;
            actionCD -= Time.deltaTime;       
            if(actionCD < -0.5f)
            {
                actionState = 0;
            }
            else if (actionCD < 0)
            {
                Hand = 0;
            }

            string localAnimatorInfo = "" + Ix + "_" + Iz + "_" + jump + "_" + jumpTimer + "_" + Hand + "_";
            CmdChangePlayerAni(localAnimatorInfo);


            if (zhunxingTimer > 0)
            {
                zhunxingTimer -= Time.deltaTime;
                zhunxing.transform.localScale = new Vector3(1 + 2 * zhunxingTimer, 1 + 2 * zhunxingTimer, 1);
                zhunxing.transform.localRotation = Quaternion.Euler(0, 0, 45);
                //zhunxing.GetComponent<Image>().color = new Color(1,0,0);
            }
            else
            {
                zhunxing.transform.localScale = new Vector3(1, 1, 1);
                zhunxing.transform.localRotation = Quaternion.Euler(0, 0, 0);
                //zhunxing.GetComponent<Image>().color = new Color(1, 1, 1);
            }
        }
    }
}