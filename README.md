## Configuração

### 1) Clonar o Repositório

```bash
git clone https://https://github.com/YurgenSchn/segdev-desafio.git
cd segdev-desafio
```

### 2) Build dos containers

```bash
docker compose up --build
```

### 3) Testes

Basta acessar o terminal de dentro do container, para rodar os testes. Utilizei RSPEC.
```bash
docker compose exec web sh
rspec
```

É possível lançar a requisição com o *Postman* ou programa similar.

O endpoint é POST *http://localhost:3000/v1/insurance/recommended-plans*

O body deve ser:

```json
{
    "age": 35,
    "dependents": 2,
    "house": {"ownership_status": "owned"},
    "income": 0,
    "marital_status": "married",
    "risk_questions": [0, 1, 0],
    "vehicle": {"year": 2018}
}
```