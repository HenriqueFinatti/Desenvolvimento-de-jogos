using UnityEngine;

public class PuckControl : MonoBehaviour
{
    public AudioSource source;

    private Rigidbody2D rb2d;
    public float maxSpeed = 20f;
    void Start () {
        rb2d = GetComponent<Rigidbody2D>();
        source = GetComponent<AudioSource>();
    }

    [System.Obsolete]
    void OnCollisionEnter2D (Collision2D coll) {
        if (coll.gameObject.CompareTag("Player"))
        {
            Vector2 hitDirection = (transform.position - coll.transform.position).normalized;
            float malletSpeed = coll.relativeVelocity.magnitude;
            Vector2 newVelocity = hitDirection * malletSpeed;

            rb2d.linearVelocity = Vector2.ClampMagnitude(newVelocity, maxSpeed);
        }
        source.Play();
    }

    [System.Obsolete]
    void ResetPuck(){
        rb2d.linearVelocity = Vector2.zero;
        transform.position = Vector2.zero;
    }
}
