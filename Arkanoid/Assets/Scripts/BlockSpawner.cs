using UnityEngine;

public class BlockSpawner : MonoBehaviour
{
    public GameObject blockPrefab;

    public int linhas = 2;
    public int colunas = 16;

    public float espacamentoX = 1.2f;
    public float espacamentoY = 0.6f;
    public float offsetX = 0f;   // Ajuste este valor para mover para os lados
    public float offsetY = 8f;   // Ajuste este valor para mover para cima

    void Start()
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
}