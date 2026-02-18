using UnityEngine;

public class BallControl : MonoBehaviour

{
    private Rigidbody2D rb2d;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void GoBall(){
        float rand = Random.Range(0, 2);
        if(rand < 1){
            rb2d.AddForce(new Vector2(20, -15));
        } else {
            rb2d.AddForce(new Vector2(-20, -15));
        }
    }

    void Start () {
        rb2d = GetComponent<Rigidbody2D>(); // Inicializa o objeto bola
        Invoke("GoBall", 2);    // Chama a função GoBall após 2 segundos
    }


    [System.Obsolete]
    void OnCollisionEnter2D (Collision2D coll) {
        if(coll.collider.CompareTag("Player")){
            Vector2 vel;
            vel.x = rb2d.velocity.x;
            vel.y = (rb2d.velocity.y / 2) + (coll.collider.attachedRigidbody.velocity.y / 3);
            rb2d.velocity = vel;
        }
    }

    [System.Obsolete]
    void ResetBall(){
        rb2d.velocity = Vector2.zero;
        transform.position = Vector2.zero;
    }

    // Reinicializa o jogo
    [System.Obsolete]
    void RestartGame(){
        ResetBall();
        Invoke("GoBall", 1);
    }


}
