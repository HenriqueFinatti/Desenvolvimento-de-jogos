using UnityEngine;
using UnityEngine.SceneManagement;

public class BlockSpawner : MonoBehaviour
{
    public GameObject blockPrefab;
    public GameObject powerUpPrefab;
    public int linhas = 2;
    public int colunas = 16;

    public float espacamentoX = 1.2f;
    public float espacamentoY = 0.6f;
    public float offsetX = 0f;   // Ajuste este valor para mover para os lados
    public float offsetY = 8f;   // Ajuste este valor para mover para cima
    public int side = 0;

    void Start()
    {
        Scene currentScene = SceneManager.GetActiveScene();

        if (currentScene.name == "Fase1")
        {
            BuildFirstGame();
            return;
        }

        if (currentScene.name == "Fase2")
        {
            BuildSecondGame();
            return;
        }
    }

    void BuildFirstGame()
    {
        for (int linha = 0; linha < linhas; linha++)
        {
            for (int coluna = 0; coluna < colunas; coluna++)
            {
                Vector2 posicao = new Vector2(
                    offsetX + (coluna * espacamentoX),
                    offsetY - (linha * espacamentoY)
                );

                Instantiate(blockPrefab, posicao, Quaternion.identity);
            }
        }
    }

    void BuildSecondGame()
    {
        Vector2[] heartLeft = BuildHearLeft();
        Vector2[] heartCenter = BuildHeartCenter();
        switch (side)
        {
            case 0: // Monta o lado esquerdo
                foreach (Vector2 pos in heartLeft)
                {
                    Vector2 mirroredPos = new Vector2(pos.x, pos.y + 0.5f);
                    Instantiate(blockPrefab, mirroredPos, Quaternion.identity);
                }
                break;

            case 1: // Monta o lado direito
                foreach (Vector2 pos in heartLeft){
                    Vector2 mirroredPos = new Vector2(-pos.x, pos.y + 0.5f);
                    Instantiate(blockPrefab, mirroredPos, Quaternion.identity);
                }
                break;

            case 2: // Monta o centro
                foreach (Vector2 pos in heartCenter)
                {
                    Vector2 mirroredPos = new Vector2(pos.x, pos.y + 0.5f);
                    Instantiate(blockPrefab, mirroredPos, Quaternion.identity);
                }
                break;

            default:
                break;
        };
    }
    Vector2[] BuildHeartCenter()
    {
        Vector2[] heartCenter = new Vector2[]
        {
            new Vector2(0, 4),
            new Vector2(0, 3),
            new Vector2(0, 2),
            new Vector2(0, 1),
            new Vector2(0, 0),
            new Vector2(0, -1),

            new Vector2(-1, 4),
            new Vector2(-1, 3),
            new Vector2(-1, 2),
            new Vector2(-1, 1),

            new Vector2(-2, 4),
            new Vector2(-2, 3),
            new Vector2(-2, 2),

            new Vector2(-3, 3),

            new Vector2(1, 4),
            new Vector2(1, 3),
            new Vector2(1, 2),
            new Vector2(1, 1),

            new Vector2(2, 4),
            new Vector2(2, 3),
            new Vector2(2, 2),

            new Vector2(3, 3)
        };

        return heartCenter;
    }

    Vector2[] BuildHearLeft()
    {
        Vector2[] heartLeft = new Vector2[]{
            new Vector2(-4, 7),
            new Vector2(-4, 6),
            new Vector2(-5, 6),
            new Vector2(-3, 6),

            new Vector2(-6, 5),
            new Vector2(-5, 5),
            new Vector2(-4, 5),
            new Vector2(-3, 5),
            new Vector2(-2, 5),

            new Vector2(-5, 4),
            new Vector2(-4, 4),
            new Vector2(-3, 4),

            new Vector2(-4, 3),

            new Vector2(-3, 2),
            new Vector2(-2, 1),
            new Vector2(-1, 0)
        };

        return heartLeft;
    }
}