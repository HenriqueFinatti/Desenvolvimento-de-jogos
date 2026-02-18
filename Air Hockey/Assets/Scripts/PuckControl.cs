using UnityEngine;

public class PuckControl : MonoBehaviour
{
   private Rigidbody2D rb2d;
    void Start () {
        rb2d = GetComponent<Rigidbody2D>();
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
    void ResetPuck(){
        rb2d.velocity = Vector2.zero;
        transform.position = Vector2.zero;
    }
}
