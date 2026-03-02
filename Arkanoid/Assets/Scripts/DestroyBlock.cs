using UnityEngine;

public class DestroyBlock : MonoBehaviour
{
    public GameObject powerUpPrefab;
    public BlockSpawner brick;
    [Range(0, 100)]
    public float chanceDeDrop = 20f;

    void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Ball"))
        {
            VerificarDrop();
            Destroy(gameObject);
            // Conecta com a bola
            BallControl ballScript = collision.gameObject.GetComponent<BallControl>();
            ballScript.hits++;

            PlayerControl player = FindObjectOfType<PlayerControl>();
            player.GainScore();
            player.UpdateScoreUI();
        }
    }

    void VerificarDrop()
    {
        GameObject brickObj = GameObject.FindGameObjectWithTag("Brick");
        brick = brickObj.GetComponent<BlockSpawner>();
        float sorteio = Random.Range(0f, 100f);
        if (sorteio <= chanceDeDrop)
        {
            Instantiate(brick.powerUpPrefab, transform.position, Quaternion.identity);
        }
    }
}
