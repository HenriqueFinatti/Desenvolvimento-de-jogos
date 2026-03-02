using UnityEngine;
using UnityEngine.SceneManagement;

public class BallControl : MonoBehaviour
{
    private Rigidbody2D rb2d;               // Define o corpo rigido 2D que representa a bola
    [UnityEngine.SerializeField]
    private float speed = 25f;
    public int limite = 64;
    public int hits = 0;


    // inicializa a bola randomicamente para esquerda ou direita
    void GoBall(){                      
        float rand = Random.Range(0, 2);
        Vector2 dir;
        if(rand < 1){
            dir = new Vector2(20, -15);
        } else {
            dir = new Vector2(-20, -15);
        }
        dir = dir.normalized;
        rb2d.linearVelocity = dir * speed;
    }

    void Start () {
        rb2d = GetComponent<Rigidbody2D>(); // Inicializa o objeto bola
        Invoke("GoBall", 2);    // Chama a função GoBall após 2 segundos
    }

    // Determina o comportamento da bola nas colisões com os Players (raquetes)
    void OnCollisionEnter2D (Collision2D coll) {
        if(coll.collider.CompareTag("Player")){
            Vector2 vel = rb2d.linearVelocity;
            vel.x = (vel.x / 2f) + (coll.collider.attachedRigidbody.linearVelocity.x / 3f);
            rb2d.linearVelocity = vel.normalized * speed;
        }
    }

    // Função para dar restart no jogo
    void RestartGame(){
        UnityEngine.SceneManagement.SceneManager.LoadScene(
        UnityEngine.SceneManagement.SceneManager.GetActiveScene().name
        );
    }

    void ResetPlayer(){
        rb2d.linearVelocity = Vector2.zero;
        transform.position = Vector2.zero;
        Invoke("GoBall", 2);
    }


    // Chama a funcao quando a bolinha atinge a parte de baixo:
    void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("WallBottomLimit"))
        {
            PlayerControl player =
                FindObjectOfType<PlayerControl>();

            player.life--;

            

            ResetPlayer();
        }
    }

    




}
