using UnityEngine;
using TMPro; // Necessário para usar o TextMeshPro

public class GameManager : MonoBehaviour
{
    public static int PlayerScore1 = 0;
    public static int PlayerScore2 = 0;

    [Header("Referências da UI")]
    public TextMeshProUGUI scoreText1; // Arraste o texto do Player 1 aqui
    public TextMeshProUGUI scoreText2; // Arraste o texto do Player 2 aqui
    public TextMeshProUGUI winText;    // Texto para anunciar o vencedor

    private GameObject theBall;

    void Start()
    {
        theBall = GameObject.FindGameObjectWithTag("Puck");

        // Esconde o texto de vitória no início
        if (winText != null) winText.gameObject.SetActive(false);

        UpdateScoreDisplay();
    }

    public static void Score(string wallID)
    {
        if (wallID == "Gol - Top")
        {
            PlayerScore1++;
        }
        else
        {
            PlayerScore2++;
        }

        // Como o método é static, precisamos achar o GameManager na cena para atualizar o texto
        FindObjectOfType<GameManager>().UpdateScoreDisplay();
    }

    void UpdateScoreDisplay()
    {
        scoreText1.text = PlayerScore1.ToString();
        scoreText2.text = PlayerScore2.ToString();

        CheckWinner();
    }

    void CheckWinner()
    {
        if (PlayerScore1 >= 10)
        {
            ShowWinner("PLAYER ONE WINS");
        }
        else if (PlayerScore2 >= 10)
        {
            ShowWinner("PLAYER TWO WINS");
        }
    }

    void ShowWinner(string message)
    {
        winText.text = message;
        winText.gameObject.SetActive(true);
        winText.color = Color.red; // Define a cor via código

        // Reinicia a bola
        theBall.SendMessage("ResetPuck", null, SendMessageOptions.RequireReceiver);
    }
}