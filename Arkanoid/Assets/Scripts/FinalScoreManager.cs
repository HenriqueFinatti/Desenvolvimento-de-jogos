using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;
public class FinalScoreManager : MonoBehaviour
{
    public TextMeshProUGUI scoreDisplay;
    public GameSettings gameData;
    void Start()
    {
        UpdateScoreUI();
    }

    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            gameData.ResetLife();
            // gameData.ResetScore();
            SceneManager.LoadScene("CenaInicial");
        }
    }

    public void UpdateScoreUI()
    {
        if (scoreDisplay != null)
        {
            scoreDisplay.text = "Pontos: " + gameData.playerScore.ToString();
        }
    }
}
