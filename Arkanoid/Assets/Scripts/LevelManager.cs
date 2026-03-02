using UnityEngine;
using UnityEngine.SceneManagement;

public class LevelManager : MonoBehaviour
{
    bool loadingNext = false;
    BallControl ball; // referência ao script da bola
    PlayerControl player;

    void Start()
    {
        // encontra a bola na cena
        GameObject ballObj = GameObject.FindGameObjectWithTag("Ball");
        ball = ballObj.GetComponent<BallControl>();

        //Player:
        GameObject playerObj = GameObject.FindGameObjectWithTag("Player");
        player = playerObj.GetComponent<PlayerControl>();

    }

    void loadDeath(){
        SceneManager.LoadScene("CenaFinal");

    }

    void Update()
    {
        if (loadingNext) return;

        // mostra hits da bola
        //print("Hits: " + ball.hits);

        if (ball.hits == ball.limite)
        {
            loadingNext = true;
            LoadNextLevel();
        }

        if (player.life == 0){
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
}