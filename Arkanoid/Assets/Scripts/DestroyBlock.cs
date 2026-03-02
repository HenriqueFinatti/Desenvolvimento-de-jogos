using UnityEngine;

public class DestroyBlock : MonoBehaviour
{
    void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Ball"))
        {
            
            Destroy(gameObject);
            // pega o script da bola
            BallControl ballScript = collision.gameObject.GetComponent<BallControl>();
            // incrementa hits
            ballScript.hits++;
            
        }
    }
}
