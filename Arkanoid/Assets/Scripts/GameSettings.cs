using UnityEngine;

[CreateAssetMenu(fileName = "GameSettings", menuName = "ScriptableObjects/GameSettings")]
public class GameSettings : ScriptableObject
{
    public int playerLife = 3;
    public int playerScore = 0;

    public void ResetLife()
    {
        playerLife = 3;
    }

    public void ResetScore()
    {
        playerScore = 0;
    }
}