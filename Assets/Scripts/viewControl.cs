using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class viewControl : MonoBehaviour, IPointerDownHandler, IDragHandler, IPointerUpHandler
{
    public RectTransform background = null;
    public RectTransform handle = null;
    private RectTransform baseRect = null;
    private Canvas canvas;
    public Camera _camera1;

    public float MoveThreshold;

    private float deadZone = 0;
    public float DeadZone
    {
        get { return deadZone; }
        set { deadZone = Mathf.Abs(value); }
    }

    public Vector2 input = Vector2.zero;
    public Vector2 input2 = Vector2.zero;
    private Vector2 keep = Vector2.zero;
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
        background.gameObject.SetActive(false);
    }

    private Vector2 ScreenPointToAnchoredPosition(Vector2 screenPosition)
    {
        Vector2 localPoint = Vector2.zero;
        RectTransformUtility.ScreenPointToLocalPointInRectangle(baseRect, screenPosition, _camera1, out localPoint);
        return localPoint;
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        
        background.anchoredPosition = ScreenPointToAnchoredPosition(eventData.position);
        background.gameObject.SetActive(true);
        OnDrag(eventData);
    }

    public void OnDrag(PointerEventData eventData)
    {
        Vector2 position = Camera.main.WorldToScreenPoint(background.position);//将ui坐标中的background映射到屏幕中的实际坐标
        Vector2 radius = background.sizeDelta / 2;
        input = (eventData.position - position) / (radius * canvas.scaleFactor);//将屏幕中的触点和background的距离映射到ui空间下实际的距离
        HandleInput(input.magnitude, input.normalized, radius, _camera1);        //对输入进行限制
        handle.anchoredPosition = input * radius;                              //实时计算handle的位置
        input2.y = keep.y + input.x * 600;
        input2.x = keep.x - input.y * 600;
        if (input2.x >= 80)
        {
            input2.x = 80;
        }
        if (input2.x <= -80)
        {
            input2.x = -80;
        }
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        keep.y += input.x * 600;
        keep.x -= input.y * 600;
        if (keep.x >= 80)
        {
            keep.x = 80;
        }
        if (keep.x <= -80)
        {
            keep.x = -80;
        }
        background.gameObject.SetActive(false);
        input = Vector2.zero;
        handle.anchoredPosition = Vector2.zero;
    }

    public void HandleInput(float magnitude, Vector2 normalised, Vector2 radius, Camera cam)
    {
        if (magnitude > deadZone)
        {
            if (magnitude > 1)
                input = normalised;
        }
        else
            input = Vector2.zero;
    }

    
}

