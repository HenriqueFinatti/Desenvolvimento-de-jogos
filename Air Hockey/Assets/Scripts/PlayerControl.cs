using UnityEngine;

public class PlayersControl : MonoBehaviour
{
    public KeyCode moveUp = KeyCode.W;      // Move a raquete para cima
    public KeyCode moveDown = KeyCode.S;    // Move a raquete para baixo
    public float speed = 10.0f;             // Define a velocidade da raquete
    public float boundY = 2.25f;            // Define os limites em Y
    private Rigidbody2D rb2d;               // Define o corpo rigido 2D que representa a raquete
    void Start () {
        rb2d = GetComponent<Rigidbody2D>();     // Inicializa a raquete
    }

    [System.Obsolete]
    void Update () {
        //no update
        Vector3 mousePos = Camera.main.ScreenToWorldPoint(Input.mousePosition);
        var pos = transform.position;
        pos.x = mousePos.x;
        pos.y = mousePos.y;
        transform.position = pos;

        Vector3 playerPos = transform.position;

        Vector3 dir = mousePos - playerPos;
        dir.Normalize();

        Vector3 speedVec = dir * speed;

        var vel = rb2d.velocity;
        vel.x = speedVec.x;
        vel.y = speedVec.y;
        rb2d.velocity = vel;

    }

}
