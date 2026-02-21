using UnityEngine;

public class EnemyControl : MonoBehaviour
{
    public float speed = 6f;
    public Transform puck;
    private Rigidbody2D rb2d;
    private Vector2 targetPosition;
    private Vector2 initialPosition;
    void Start()
    {
        rb2d = GetComponent<Rigidbody2D>();
        initialPosition = transform.position;
    }

    void Update()
    {
        int yMin = 0;
        int yMax = 8;
        int xMin = -5;
        int xMax = 5;
        float targetX, targetY;
        if (puck.position.y < 0)
        {
            targetX = 0;
            targetY = 6;
        }
        else
        {
            targetX = Mathf.Clamp(puck.position.x, xMin, xMax);
            targetY = Mathf.Clamp(puck.position.y, yMin, yMax);
        }

        if (rb2d.position.y < puck.position.y)
        {
            targetX++;
        }
        targetPosition = new Vector2(targetX, targetY);

        Vector2 newPosition = Vector2.MoveTowards(rb2d.position, targetPosition, speed * Time.fixedDeltaTime);
        rb2d.MovePosition(newPosition);
    }

    public void ResetPlayer() {
        rb2d.linearVelocity = Vector2.zero;
        transform.position = initialPosition;
    }
}
