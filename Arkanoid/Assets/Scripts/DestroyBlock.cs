using UnityEngine;

public class DestroyBlock : MonoBehaviour
{
    void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Ball"))
        {
            Destroy(gameObject);
            // Conecta com a bola
            BallControl ballScript = collision.gameObject.GetComponent<BallControl>();
            ballScript.hits++;
        }
    }
}
