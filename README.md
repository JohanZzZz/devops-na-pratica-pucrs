# DevOps na Prática

Projeto prático de DevOps demonstrando a implementação completa de um pipeline CI/CD, infraestrutura como código (IaC) e automação.

## Estrutura do Projeto

```
.
├── docs/                          # Documentação de planejamento
│   └── planejamento.md            # Documento de planejamento completo
├── app/                           # Código-fonte da aplicação
│   ├── main.py                    # API REST (Flask)
│   ├── requirements.txt           # Dependências Python
│   └── tests/
│       └── test_main.py           # Testes automatizados
├── infra/                         # Infraestrutura como Código
│   ├── main.tf                    # Configuração principal Terraform
│   ├── variables.tf               # Variáveis Terraform
│   ├── outputs.tf                 # Outputs Terraform
│   └── terraform.tfvars.example   # Exemplo de variáveis
├── .github/
│   └── workflows/
│       └── ci.yml                 # Pipeline de CI (GitHub Actions)
├── Dockerfile                     # Imagem Docker da aplicação
├── docker-compose.yml             # Orquestração local
└── .gitignore                     # Arquivos ignorados pelo git
```

## Tecnologias Utilizadas

- **Linguagem:** Python 3.11+
- **Framework:** Flask
- **Containerização:** Docker / Docker Compose
- **CI/CD:** GitHub Actions
- **IaC:** Terraform
- **Cloud:** AWS (EC2, VPC, Security Groups)
- **Testes:** pytest
- **Linting:** flake8

## Como Executar Localmente

```bash
# Com Docker Compose
docker-compose up --build

# Sem Docker
cd app
pip install -r requirements.txt
python main.py
```

A API estará disponível em `http://localhost:5000`.

## Endpoints da API

| Método | Rota          | Descrição              |
|--------|---------------|------------------------|
| GET    | `/`           | Health check           |
| GET    | `/api/status` | Status da aplicação    |
| GET    | `/api/info`   | Informações do sistema |

## Pipeline CI

O pipeline de integração contínua executa automaticamente em cada push e pull request:

1. **Lint** - Verificação de qualidade do código com flake8
2. **Test** - Execução dos testes unitários com pytest
3. **Build** - Construção da imagem Docker
4. **Security** - Scan de vulnerabilidades com trivy

## Repositório

- **GitHub:** https://github.com/JohanZzZz/devops-na-pratica
