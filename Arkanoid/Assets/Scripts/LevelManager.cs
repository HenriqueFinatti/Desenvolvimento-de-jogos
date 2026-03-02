using UnityEngine;
using UnityEngine.SceneManagement;

public class LevelManager : MonoBehaviour
{
    bool loadingNext = false;
    BallControl ball; // referência ao script da bola

    void Start()
    {
        // encontra a bola na cena
        GameObject ballObj = GameObject.FindGameObjectWithTag("Ball");
        ball = ballObj.GetComponent<BallControl>();
    }

    void Update()
    {
        if (loadingNext) return;

        // mostra hits da bola
        print("Hits: " + ball.hits);

        if (ball.hits == ball.limite)
        {
            loadingNext = true;
            LoadNextLevel();
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