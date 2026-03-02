using UnityEngine;
using TMPro;
using System.Collections;
using UnityEngine.SceneManagement;
using System.Dynamic;

public class EndManager : MonoBehaviour
{
    [Header("Próxima Cena")]
    public string nextSceneName = "CenaFinal";

    void Start()
    {
        Invoke("GoToScore", 0.1f);
    }

    void GoToScore()
    {
        SceneManager.LoadScene(nextSceneName);
    }
}