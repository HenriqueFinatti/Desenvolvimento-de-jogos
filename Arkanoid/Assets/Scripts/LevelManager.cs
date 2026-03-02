using UnityEngine;
using UnityEngine.SceneManagement;

public class LevelManager : MonoBehaviour
{
    bool loadingNext = false;
    BallControl ball; // referência ao script da bola
    PlayerControl player;

    void Start()
    {
        // Conecta com a bola
        GameObject ballObj = GameObject.FindGameObjectWithTag("Ball");
        ball = ballObj.GetComponent<BallControl>();

        // Conecta com o player
        GameObject playerObj = GameObject.FindGameObjectWithTag("Player");
        player = playerObj.GetComponent<PlayerControl>();
    }

    void Update()
    {
        if (loadingNext) return;

        if (ball.hits == ball.limite)
        {
            loadingNext = true;
            LoadNextLevel();
        }

        if (player.life == 0)
        {
            loadingNext = true;
            loadDeath();
        }
    }

    void LoadNextLevel()
    {
        Scene currentScene = SceneManager.GetActiveScene();

        if (currentScene.name == "Fase1")
        {
            SceneManager.LoadScene("Fase2");
        }
    }

    void loadDeath()
    {
        SceneManager.LoadScene("Derrota");
    }
}