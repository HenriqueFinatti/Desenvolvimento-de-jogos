using UnityEngine;
using UnityEngine.SceneManagement;

public class BlockSpawner : MonoBehaviour
{
    public GameObject blockPrefab;

    public int linhas = 2;
    public int colunas = 16;

    public float espacamentoX = 1.2f;
    public float espacamentoY = 0.6f;
    public float offsetX = 0f;   // Ajuste este valor para mover para os lados
    public float offsetY = 8f;   // Ajuste este valor para mover para cima
    public int sideleft = 0;

    void Start()
    {

        Scene currentScene = SceneManager.GetActiveScene();

        if (currentScene.name == "Fase1"){
            for (int linha = 0; linha < linhas; linha++){
                for (int coluna = 0; coluna < colunas; coluna++){
                Vector2 posicao = new Vector2(
                    offsetX + (coluna * espacamentoX),
                    offsetY - (linha * espacamentoY)
                );

                Instantiate(blockPrefab, posicao, Quaternion.identity);
                }
            }   
        }
        else if (currentScene.name == "Fase2"){
            if (sideleft == 1){
                                // posições da metade esquerda do coração
                Vector2[] heartLeft = new Vector2[]{
                    new Vector2(-4, 7),
                    new Vector2(-5, 6),
                    new Vector2(-3, 6),

                    new Vector2(-6, 5),
                    new Vector2(-4, 5),
                    new Vector2(-2, 5),

                    new Vector2(-5, 4),
                    new Vector2(-3, 4),

                    new Vector2(-4, 3),

                    new Vector2(-3, 2),
                    new Vector2(-2, 1),
                    new Vector2(-1, 0)
                };

                foreach (Vector2 pos in heartLeft){
                Instantiate(blockPrefab, pos, Quaternion.identity);
                }
            }
        else if(sideleft == 0){
                // posições da metade direita do coração
                Vector2[] heartLeft = new Vector2[]
                {
                    new Vector2(-4, 7),
                    new Vector2(-5, 6),
                    new Vector2(-3, 6),

                    new Vector2(-6, 5),
                    new Vector2(-4, 5),
                    new Vector2(-2, 5),

                    new Vector2(-5, 4),
                    new Vector2(-3, 4),

                    new Vector2(-4, 3),

                    new Vector2(-3, 2),
                    new Vector2(-2, 1),
                    new Vector2(-1, 0)  
                };

                foreach (Vector2 pos in heartLeft){
                // espelha no eixo X (troca sinal)
                Vector2 mirroredPos = new Vector2(-pos.x, pos.y);
                Instantiate(blockPrefab, mirroredPos, Quaternion.identity);
                }
            }
        else if(sideleft ==2){
            Vector2[] heartCenter = new Vector2[]
            {
                new Vector2(0, 5),
                new Vector2(0, 4),
                new Vector2(0, 3),
                new Vector2(0, 2),
                new Vector2(0, 1)
            };
            foreach (Vector2 pos in heartCenter)
            {
                Instantiate(blockPrefab, pos, Quaternion.identity);
            }

        }
        }  
    }
}