# Documento de Planejamento - DevOps na Prática

## Seção 1 - Documento de Planejamento

### A - Descrição do Projeto, Objetivos e Requisitos

#### Descrição

Este projeto consiste no desenvolvimento e implantação de uma **API REST** construída em Python com o framework Flask, utilizando práticas modernas de DevOps para garantir qualidade, automação e reprodutibilidade em todo o ciclo de vida do software.

A aplicação é uma API de monitoramento de saúde (health check) que expõe endpoints para verificação de status, informações do sistema e métricas básicas. Embora simples em funcionalidade, o foco do projeto está na **infraestrutura e nos processos de automação** que suportam o desenvolvimento, teste, build e deploy da aplicação.

#### Objetivos

1. **Automatizar o ciclo de desenvolvimento:** Implementar um pipeline de integração contínua (CI) que execute automaticamente verificações de qualidade de código, testes e build a cada alteração no repositório.

2. **Containerizar a aplicação:** Utilizar Docker para criar um ambiente padronizado e reprodutível, eliminando problemas de "funciona na minha máquina".

3. **Provisionar infraestrutura como código:** Utilizar Terraform para definir e provisionar a infraestrutura na AWS de forma declarativa, versionada e auditável.

4. **Garantir qualidade do código:** Integrar ferramentas de linting (flake8), testes automatizados (pytest) e scan de segurança (trivy) no pipeline de CI.

5. **Documentar todo o processo:** Manter documentação clara e atualizada sobre arquitetura, decisões técnicas e procedimentos operacionais.

#### Requisitos Funcionais

| ID   | Requisito                                                    | Prioridade |
|------|--------------------------------------------------------------|------------|
| RF01 | A API deve expor um endpoint de health check (`GET /`)       | Alta       |
| RF02 | A API deve expor um endpoint de status (`GET /api/status`)   | Alta       |
| RF03 | A API deve expor um endpoint de informações (`GET /api/info`)| Média      |
| RF04 | A API deve retornar respostas em formato JSON                | Alta       |
| RF05 | A API deve rodar na porta 5000                               | Alta       |

#### Requisitos Não Funcionais

| ID    | Requisito                                                              | Prioridade |
|-------|------------------------------------------------------------------------|------------|
| RNF01 | O pipeline de CI deve executar em menos de 5 minutos                   | Alta       |
| RNF02 | A aplicação deve ser containerizada com Docker                         | Alta       |
| RNF03 | A infraestrutura deve ser definida como código (Terraform)             | Alta       |
| RNF04 | O código deve passar em verificações de linting (flake8)               | Média      |
| RNF05 | Todos os testes devem passar antes do merge na branch principal        | Alta       |
| RNF06 | A imagem Docker deve ser baseada em uma imagem slim para menor tamanho | Média      |
| RNF07 | A infraestrutura deve seguir o princípio de menor privilégio           | Alta       |

---

### B - Plano de Integração Contínua

#### Visão Geral

O pipeline de integração contínua (CI) é implementado utilizando **GitHub Actions** e é acionado automaticamente em dois eventos:

- **Push** para a branch `main`
- **Pull Request** direcionado à branch `main`

#### Etapas do Pipeline

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│    Lint      │───▶│    Test      │───▶│    Build     │───▶│  Security   │
│  (flake8)   │    │  (pytest)   │    │  (Docker)   │    │  (trivy)    │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

**1. Lint (Verificação de Qualidade)**
- Ferramenta: flake8
- Objetivo: Garantir conformidade com padrões de código Python (PEP 8)
- Configuração: linha máxima de 120 caracteres
- Critério de sucesso: zero erros de linting

**2. Test (Testes Automatizados)**
- Ferramenta: pytest
- Objetivo: Validar o comportamento correto da aplicação
- Cobertura: Testes unitários para todos os endpoints da API
- Critério de sucesso: 100% dos testes passando

**3. Build (Construção da Imagem)**
- Ferramenta: Docker
- Objetivo: Validar que a imagem Docker é construída com sucesso
- Base: Python 3.11-slim
- Critério de sucesso: build sem erros

**4. Security (Scan de Vulnerabilidades)**
- Ferramenta: trivy
- Objetivo: Identificar vulnerabilidades conhecidas na imagem Docker
- Severidade monitorada: CRITICAL e HIGH
- Critério de sucesso: sem vulnerabilidades críticas

#### Estratégia de Branches

- `main`: Branch principal, protegida, requer CI verde para merge
- `feature/*`: Branches de desenvolvimento de funcionalidades
- `fix/*`: Branches de correção de bugs

#### Notificações

O GitHub Actions fornece notificações nativas por e-mail e na interface web quando o pipeline falha, garantindo feedback rápido para o desenvolvedor.

---

### C - Especificação Detalhada da Infraestrutura Necessária

#### Diagrama de Infraestrutura

```
                    ┌──────────────────────────────────┐
                    │            AWS Cloud             │
                    │                                  │
                    │  ┌───────────────────────────┐   │
                    │  │      VPC (10.0.0.0/16)    │   │
                    │  │                           │   │
                    │  │  ┌─────────────────────┐  │   │
                    │  │  │  Subnet Pública      │  │   │
                    │  │  │  (10.0.1.0/24)      │  │   │
                    │  │  │                     │  │   │
                    │  │  │  ┌───────────────┐  │  │   │
                    │  │  │  │   EC2 (t2.micro) │  │   │
                    │  │  │  │   Docker Host  │  │   │
                    │  │  │  │   Flask API    │  │   │
                    │  │  │  └───────────────┘  │  │   │
                    │  │  │                     │  │   │
                    │  │  └─────────────────────┘  │   │
                    │  │                           │   │
                    │  │  ┌─────────────────────┐  │   │
                    │  │  │  Security Group      │  │   │
                    │  │  │  - SSH (22)          │  │   │
                    │  │  │  - HTTP (80)         │  │   │
                    │  │  │  - App (5000)        │  │   │
                    │  │  └─────────────────────┘  │   │
                    │  │                           │   │
                    │  │  ┌─────────────────────┐  │   │
                    │  │  │  Internet Gateway    │  │   │
                    │  │  └─────────────────────┘  │   │
                    │  │                           │   │
                    │  └───────────────────────────┘   │
                    │                                  │
                    └──────────────────────────────────┘
```

#### Componentes da Infraestrutura

| Componente         | Especificação                  | Justificativa                                      |
|--------------------|--------------------------------|----------------------------------------------------|
| **VPC**            | CIDR 10.0.0.0/16               | Rede isolada para o projeto                        |
| **Subnet**         | Pública, 10.0.1.0/24, AZ us-east-1a | Acesso direto à internet para a aplicação     |
| **Internet Gateway** | Associado à VPC              | Permite tráfego de entrada e saída da internet     |
| **Route Table**    | Rota padrão via IGW            | Direciona tráfego externo pelo Internet Gateway    |
| **Security Group** | Ingress: 22, 80, 5000; Egress: all | Controle de acesso à instância                |
| **EC2**            | t2.micro, Amazon Linux 2023    | Instância free-tier, suficiente para a aplicação   |
| **Key Pair**       | RSA 2048-bit                   | Acesso SSH seguro à instância                      |

#### Estimativa de Custos (AWS Free Tier)

| Recurso       | Custo Estimado | Observação                      |
|---------------|----------------|---------------------------------|
| EC2 t2.micro  | $0.00/mês      | 750 horas/mês no Free Tier      |
| EBS (8 GB)    | $0.00/mês      | 30 GB inclusos no Free Tier     |
| Tráfego       | $0.00/mês      | 15 GB de saída no Free Tier     |
| **Total**     | **$0.00/mês**  | Dentro dos limites do Free Tier |

#### Ferramenta de IaC

- **Terraform** (v1.0+): Escolhido por ser open-source, multi-cloud, e possuir uma linguagem declarativa (HCL) intuitiva
- **Provider:** AWS (hashicorp/aws ~> 5.0)
- **State:** Local (para ambiente de desenvolvimento/aprendizado)

---

## Seção 2 - Pipeline de Integração Contínua (CI)

### A - Configuração do Repositório de Código

**Repositório GitHub:** https://github.com/JohanZzZz/devops-na-pratica-pucrs

O repositório está organizado seguindo boas práticas:
- Código-fonte em `app/`
- Infraestrutura em `infra/`
- Documentação em `docs/`
- Pipeline CI em `.github/workflows/`
- Arquivo `.gitignore` configurado para Python, Terraform e Docker

### B - Implementação do Pipeline de CI com GitHub Actions

**Repositório GitHub:** https://github.com/JohanZzZz/devops-na-pratica-pucrs

O arquivo de workflow está localizado em `.github/workflows/ci.yml` e implementa as 4 etapas descritas no plano de integração contínua (Lint, Test, Build, Security).

Detalhes da implementação:
- **Trigger:** push e pull_request na branch main
- **Runner:** ubuntu-latest
- **Jobs:** lint → test → build → security (execução sequencial com dependências)
- **Cache:** pip dependencies são cacheadas para acelerar execuções

---

## Seção 3 - Scripts de Infraestrutura como Código

### A - Scripts para Provisionamento de Infraestrutura (Terraform)

**Repositório GitHub:** https://github.com/JohanZzZz/devops-na-pratica-pucrs

Os scripts Terraform estão no diretório `infra/` e provisionam:

| Arquivo                    | Descrição                                    |
|----------------------------|----------------------------------------------|
| `main.tf`                  | Recursos principais (VPC, EC2, SG, etc.)     |
| `variables.tf`             | Definição de variáveis de entrada             |
| `outputs.tf`               | Valores de saída (IP público, DNS, etc.)      |
| `terraform.tfvars.example` | Exemplo de valores para as variáveis          |

#### Comandos para Provisionamento

```bash
cd infra/
cp terraform.tfvars.example terraform.tfvars  # Editar com valores reais
terraform init                                 # Inicializar provider
terraform plan                                 # Visualizar mudanças
terraform apply                                # Aplicar infraestrutura
terraform destroy                              # Destruir infraestrutura
```

---

# Fase 2 - Entrega Contínua, Monitoramento e Segurança

## Seção 1 - Pipeline de Entrega Contínua

### A - Expansão do Pipeline de CI para Inclusão da Entrega Contínua (CD)

**Repositório GitHub:** https://github.com/JohanZzZz/devops-na-pratica-pucrs

#### Visão Geral

O pipeline de CI existente foi expandido para incluir duas novas etapas de **Entrega Contínua (CD)**, transformando-o em um pipeline CI/CD completo. As etapas de CD são executadas **apenas** em pushes para a branch `main` (não em pull requests), garantindo que somente código revisado e aprovado seja publicado e implantado.

#### Pipeline Completo (CI + CD)

```
                        CI                                          CD
┌───────┐   ┌───────┐   ┌───────┐   ┌──────────┐   ┌───────────┐   ┌──────────┐
│ Lint  │──▶│ Test  │──▶│ Build │──▶│ Security │──▶│ Publish   │──▶│ Deploy   │
│flake8 │   │pytest │   │Docker │   │ trivy    │   │ GHCR      │   │ EC2/SSH  │
└───────┘   └───────┘   └───────┘   └──────────┘   └───────────┘   └──────────┘
                                                     (só main)       (só main)
```

#### Etapas Adicionadas (CD)

**5. Publish (Publicação da Imagem Docker)**
- **Registry:** GitHub Container Registry (GHCR) - `ghcr.io`
- **Autenticação:** `GITHUB_TOKEN` nativo (sem secrets adicionais)
- **Tags geradas:**
  - `latest` — sempre aponta para a versão mais recente
  - `<sha>` — tag baseada no commit SHA para rastreabilidade
- **Condição:** Executa apenas em push na branch `main`
- **Ação:** `docker/build-push-action@v6` para build e push otimizados

**6. Deploy (Implantação em Produção)**
- **Estratégia:** Deploy via SSH na instância EC2
- **Ação:** `appleboy/ssh-action@v1` para execução remota
- **Environment:** `production` (com proteção de aprovação no GitHub)
- **Processo de deploy:**
  1. Login no GHCR na instância EC2
  2. Pull da imagem `latest`
  3. Stop e remoção do container anterior (graceful)
  4. Start do novo container com restart policy
  5. Limpeza de imagens antigas (`docker image prune`)
- **Porta:** Mapeia porta 80 (host) → 5000 (container)

#### Secrets Necessários

| Secret         | Descrição                                   | Onde Configurar                    |
|----------------|---------------------------------------------|------------------------------------|
| `GITHUB_TOKEN` | Token automático do GitHub Actions           | Fornecido automaticamente          |
| `EC2_HOST`     | IP público ou DNS da instância EC2           | Settings → Secrets → Actions       |
| `EC2_USER`     | Usuário SSH (ex: `ec2-user`)                 | Settings → Secrets → Actions       |
| `EC2_SSH_KEY`  | Chave privada SSH para acesso à EC2          | Settings → Secrets → Actions       |

#### Estratégia de Deploy

- **Tipo:** Rolling deployment (substituição do container)
- **Rollback:** Via re-execução do workflow anterior ou tag específica
- **Downtime:** Mínimo (~2-5 segundos durante a troca de container)
- **Restart policy:** `unless-stopped` garante recuperação automática

#### Proteções

- **Environment protection:** O job de deploy usa o environment `production`, que pode ser configurado com regras de aprovação manual no GitHub
- **Branch protection:** CD executa apenas em `main`, nunca em PRs
- **Dependência sequencial:** Deploy só ocorre após publicação bem-sucedida, que só ocorre após todas as etapas de CI passarem
