using UnityEngine;

public class PowerUpControl : MonoBehaviour
{
    public float fallSpeed = 3f;

    void Update()
    {
        transform.Translate(Vector2.down * fallSpeed * Time.deltaTime);
        if (transform.position.y < -7f)
        {
            Destroy(gameObject);
        }
    }

    void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            AplicarEfeito();
            Destroy(gameObject);
        }
    }

    void AplicarEfeito()
    {
        PlayerControl player = FindObjectOfType<PlayerControl>();
        player.GainLife();
        player.UpdateLifeUI();

    }
}