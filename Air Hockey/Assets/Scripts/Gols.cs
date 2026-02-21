using UnityEngine;
using System.Collections;
public class Gols : MonoBehaviour
{
    void OnTriggerEnter2D (Collider2D hitInfo) {
        if (hitInfo.tag == "Puck")
        {
            // string wallName = transform.name;
            // GameManager.Score(wallName);
            hitInfo.gameObject.SendMessage("ResetPuck", null, SendMessageOptions.RequireReceiver);
            GameObject[] players = GameObject.FindGameObjectsWithTag("Player");
            foreach (GameObject p in players) {
                p.SendMessage("ResetPlayer", SendMessageOptions.DontRequireReceiver);
            }
        }
    }
}
