using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public enum JoystickType
{
    Fixed,      //�̶�ʽҡ��
    Floating,   //����ʽҡ��(���ݵ����Ļ��λ������ҡ�˿�����)
    Dynamic     //��̬ҡ��(ҡ�˿��Ա���̬��ק)
}

public class MyjoyStick : MonoBehaviour, IPointerDownHandler, IDragHandler, IPointerUpHandler
{
    public JoystickType joystickType = JoystickType.Fixed;
    public RectTransform background = null;
    public RectTransform handle = null;

    public GameObject fakeStick = null;

    private RectTransform baseRect = null;
    private Canvas canvas;
    public Camera _camera;

    public float MoveThreshold;

    private float deadZone = 0;
    public float DeadZone
    {
        get { return deadZone; }
        set { deadZone = Mathf.Abs(value); }
    }

    public Vector2 input = Vector2.zero;
    private Vector2 center = new Vector2(0.5f, 0.5f);
    private Vector2 fixedPosition = Vector2.zero;

    protected virtual void Start()
    {
        baseRect = GetComponent<RectTransform>();
        canvas = GetComponentInParent<Canvas>();

        background.pivot = center;
        handle.anchorMin = center;
        handle.anchorMax = center;
        handle.pivot = center;
        handle.anchoredPosition = Vector2.zero;
        fixedPosition = background.anchoredPosition;
        SetMode();
    }

    public void SetMode()
    {
        if (joystickType == JoystickType.Fixed)
        {
            background.anchoredPosition = fixedPosition;
            background.gameObject.SetActive(true);
        }
        else
            background.gameObject.SetActive(false);
    }

    private Vector2 ScreenPointToAnchoredPosition(Vector2 screenPosition)
    {
        Vector2 localPoint = Vector2.zero;
        RectTransformUtility.ScreenPointToLocalPointInRectangle(baseRect, screenPosition, _camera, out localPoint);
        return localPoint;
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        fakeStick.gameObject.SetActive(false);
        if (joystickType != JoystickType.Fixed)
        {
            background.anchoredPosition = ScreenPointToAnchoredPosition(eventData.position);
            background.gameObject.SetActive(true);
        }
        OnDrag(eventData);
    }

    public void OnDrag(PointerEventData eventData)
    {
        Vector2 position = Camera.main.WorldToScreenPoint(background.position);//��ui�����е�backgroundӳ�䵽��Ļ�е�ʵ������
        Vector2 radius = background.sizeDelta / 2;
        input = (eventData.position - position) / (radius * canvas.scaleFactor);//����Ļ�еĴ����background�ľ���ӳ�䵽ui�ռ���ʵ�ʵľ���
        HandleInput(input.magnitude, input.normalized, radius, _camera);        //�������������
        handle.anchoredPosition = input * radius;                              //ʵʱ����handle��λ��
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        fakeStick.gameObject.SetActive(true);
        if (joystickType != JoystickType.Fixed)
            background.gameObject.SetActive(false);
        input = Vector2.zero;
        handle.anchoredPosition = Vector2.zero;
    }

    public void HandleInput(float magnitude, Vector2 normalised, Vector2 radius, Camera cam)
    {
        if (joystickType == JoystickType.Dynamic && magnitude > MoveThreshold)
        {
            Vector2 difference = normalised * (magnitude - MoveThreshold) * radius;
            background.anchoredPosition += difference;
        }
        if (magnitude > deadZone)
        {
            if (magnitude > 1)
                input = normalised;
        }
        else
            input = Vector2.zero;
    }
}

