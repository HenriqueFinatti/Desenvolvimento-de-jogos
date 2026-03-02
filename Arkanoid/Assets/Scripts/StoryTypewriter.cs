using UnityEngine;
using TMPro;
using System.Collections;
using UnityEngine.SceneManagement;

public class StoryTypewriter : MonoBehaviour
{
    [Header("Configurações de UI")]
    public TextMeshProUGUI textDisplay;
    public string[] sentences;
    public float typingSpeed = 0.05f;

    [Header("Próxima Cena")]
    public string nextSceneName = "Fase1";

    private int index;
    private bool isTyping = false;

    void Start()
    {
        // Começa a primeira frase
        StartCoroutine(TypeSentence());
    }

    void Update()
    {
        // Detecta o clique do jogador
        if (Input.GetMouseButtonDown(0))
        {
            if (!isTyping)
            {
                NextSentence();
            }
            else
            {
                // Opcional: Se clicar enquanto digita, mostra a frase inteira instantaneamente
                StopAllCoroutines();
                textDisplay.text = sentences[index];
                isTyping = false;
            }
        }
    }

    IEnumerator TypeSentence()
    {
        isTyping = true;
        textDisplay.text = ""; // Limpa o texto

        foreach (char letter in sentences[index].ToCharArray())
        {
            textDisplay.text += letter;
            yield return new WaitForSeconds(typingSpeed); // Espera um tiquinho entre letras
        }

        isTyping = false;
    }

    public void NextSentence()
    {
        if (index < sentences.Length - 1)
        {
            index++;
            StartCoroutine(TypeSentence());
        }
        else
        {
            // Acabou a história, carrega o jogo
            SceneManager.LoadScene(nextSceneName);
        }
    }
}