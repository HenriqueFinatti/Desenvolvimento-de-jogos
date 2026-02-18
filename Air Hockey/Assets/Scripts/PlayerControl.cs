using UnityEngine;

public class PlayersControl : MonoBehaviour
{
    public float speed = 10.0f;
    private Rigidbody2D rb2d;
    private float boundX = 4.0f;
    private float boundTopY = -1.0f;
    private float boundBottomY = -7.0f;
    void Start () {
        rb2d = GetComponent<Rigidbody2D>();
    }

    float GetPositionX (float mousePos)
    {
        if (mousePos < -boundX)
        {
            return -boundX;
        }
        if (mousePos > boundX)
        {
            return boundX;
        }

        return mousePos;
    }

    float GetPositionY (float mousePos)
    {
        if (mousePos < boundBottomY)
        {
            return boundBottomY;
        }
        if (mousePos > boundTopY)
        {
            return boundTopY;
        }

        return mousePos;
    }
    [System.Obsolete]
    void Update () {
        Vector3 mousePos = Camera.main.ScreenToWorldPoint(Input.mousePosition);
        Vector3 playerPos = transform.position;
        var pos = transform.position;

        pos.x = GetPositionX(mousePos.x);
        pos.y = GetPositionY(mousePos.y);

        transform.position = pos;

        Vector3 dir = mousePos - playerPos;
        dir.Normalize();

        Vector3 speedVec = dir * speed;

        var vel = rb2d.velocity;
        vel.x = speedVec.x;
        vel.y = speedVec.y;
        rb2d.velocity = vel;
    }
}
