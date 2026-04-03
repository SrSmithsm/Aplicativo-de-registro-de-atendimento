# SIGA - Sistema Inteligente de Gestão de Atendimento

## Sobre o Projeto

O **SIGA** é um sistema focado na modelagem de um banco de dados relacional para o gerenciamento completo de fluxos de atendimento. O projeto organiza desde o agendamento inicial até a conclusão do serviço, garantindo controle sobre filas, senhas e notificações.

A proposta evolui de um modelo básico para uma estrutura mais próxima de sistemas reais, incluindo controle de horários, check-in, geração de senhas e métricas de desempenho. Nesta etapa, o **SIGA** foi expandido com elementos de **Inteligência de Dados**, permitindo que o sistema gere insights operacionais automáticos.

---

## Inovação: Inteligência de Dados

O **SIGA** integra recursos avançados de análise de dados para otimizar a gestão:

* **Análise de Sentimento:** Processamento dos comentários de avaliações para identificar padrões de satisfação.
* **Predição de Demanda:** Tabelas dedicadas a armazenar insights sobre o fluxo de pessoas e sugestões de realocação de recursos.

---

## Protótipo de Interface

O desenvolvimento visual do **SIGA** foi realizado no Figma, contemplando as jornadas do cliente, atendente e gestor.

* **Link do Protótipo:** https://www.figma.com/make/1mYuBAJS46AKrzTsc7wb3F/Untitled?t=HnuZxSIGQdWzF8aV-20&fullscreen=1

---

## Objetivo

Desenvolver uma base de dados robusta capaz de suportar:

* Cadastro seguro de usuários
* Evitar duplicidade de pessoas
* Agendamento com controle de horários disponíveis
* Gerenciamento de filas com prioridade
* Registro completo dos atendimentos
* Avaliação de serviços prestados
* Geração de métricas e estimativas de atendimento com suporte a IA

---

## Funcionalidades

### Gestão de Usuários
* Cadastro com autenticação (email e senha)
* Verificação de email
* Associação com dados pessoais (Pessoa)
* Suporte a múltiplos papéis (Cliente e Atendente)

### Agendamento
* Seleção de fila de atendimento
* Escolha de horários disponíveis
* Controle de ocupação de horários
* Organização por prioridade

### Check-in
* Confirmação de presença antes do atendimento
* Controle de faltas (no-show)

### Atendimento
* Registro de início e fim do atendimento
* Associação com cliente e atendente
* Classificação por prioridade

### Fila em Tempo Real
* Geração de senhas
* Controle de chamadas
* Simulação de ambientes reais de atendimento

### Avaliação e Inteligência
* Avaliação do atendimento pelo cliente com registro de notas e comentários
* Análise de sentimento automatizada sobre os feedbacks recebidos
* Geração de insights operacionais e alertas de pico de demanda

### Notificações
* Envio de notificações para usuários
* Confirmações, lembretes e atualizações de status

### Métricas e Monitoramento
* Estimativa de tempo médio por fila
* Histórico de alterações de status
* Base para análise de desempenho preditiva

---

## Modelagem

O sistema utiliza uma estrutura centralizada baseada na entidade **Pessoa**, evitando duplicidade de dados. O diagrama de entidade-relacionamento detalhando as conexões entre usuários, atendimentos e os novos módulos de inteligência está disponível no arquivo de modelagem anexo.

*(Visualizar Diagrama ER no arquivo correspondente)*

---

## Estrutura do Banco

Principais entidades:

* Pessoa e Usuário
* Cliente e Atendente
* Fila e Prioridade
* Horário Disponível
* Agendamento e Atendimento
* Check-in e Senha
* Avaliação e Análise de Sentimento
* Insight Operacional
* Notificação
* Estimativa de Atendimento
* Histórico de Status

---

## Tecnologias

* **Modelagem:** Mermaid (ER Diagram)
* **Banco de Dados:** PostgreSQL
* **Prototipagem:** Figma
* **Ferramenta:** pgAdmin

---

## Status do Projeto

Estrutura concluída:
* Modelagem completa do banco de dados
* Implementação das tabelas de inovação (Inteligência de Dados)
* Protótipo de interface desenvolvido no Figma
* Pronto para testes no pgAdmin

---

## Observações

Este projeto possui caráter acadêmico, com foco no aprendizado de modelagem de dados, inovação tecnológica e simulação de sistemas reais.


```mermaid
erDiagram
    PESSOA {
        int id_pessoa PK
        string nome
        string cpf
        string telefone
        boolean cadastro_completo
        boolean ativo
    }

    USUARIO {
        int id_usuario PK
        int id_pessoa FK
        string email
        string senha_hash
        boolean email_verificado
        datetime data_criacao
    }

    CLIENTE {
        int id_cliente PK
        int id_pessoa FK
    }

    ATENDENTE {
        int id_atendente PK
        int id_pessoa FK
        string setor
        string status
    }

    FILA {
        int id_fila PK
        string nome
        string tipo_servico
        string status
    }

    ATENDENTE_FILA {
        int id_atendente FK
        int id_fila FK
    }

    PRIORIDADE {
        int id_prioridade PK
        string descricao
        int nivel
        float peso_tempo_espera
    }

    HORARIO_DISPONIVEL {
        int id_horario PK
        int id_fila FK
        datetime inicio
        datetime fim
        boolean ocupado
    }

    AGENDAMENTO {
        int id_agendamento PK
        int id_cliente FK
        int id_fila FK
        int id_prioridade FK
        int id_horario FK
        string status
    }

    CHECKIN {
        int id_checkin PK
        int id_agendamento FK
        datetime horario_checkin
        boolean confirmado
    }

    ATENDIMENTO {
        int id_atendimento PK
        int id_cliente FK
        int id_atendente FK
        int id_fila FK
        int id_prioridade FK
        int id_agendamento FK
        datetime data_hora_inicio
        datetime data_hora_fim
        string status
    }

    AVALIACAO {
        int id_avaliacao PK
        int id_atendimento FK
        int nota
        string comentario
    }

    %% ENTIDADES DE INTELIGÊNCIA DE DADOS (INOVAÇÃO)
    ANALISE_SENTIMENTO {
        int id_analise PK
        int id_avaliacao FK
        string polaridade
        float score_confianca
        datetime processado_em
    }

    INSIGHT_OPERACIONAL {
        int id_insight PK
        int id_fila FK
        string tipo_insight
        string recomendacao
        datetime validade_previsao
    }

    SENHA {
        int id_senha PK
        int id_fila FK
        int id_agendamento FK
        int numero
        datetime chamada_em
        string status
    }

    NOTIFICACAO {
        int id_notificacao PK
        int id_usuario FK
        string tipo
        string mensagem
        boolean lida
        datetime enviada_em
    }

    ESTIMATIVA_ATENDIMENTO {
        int id_estimativa PK
        int id_fila FK
        int tempo_medio_minutos
        datetime atualizado_em
    }

    HISTORICO_STATUS {
        int id_historico PK
        string entidade
        int id_referencia
        string status_anterior
        string status_novo
        datetime data_alteracao
    }

    %% RELACIONAMENTOS ORIGINAIS
    PESSOA ||--|| USUARIO : possui
    PESSOA ||--o| CLIENTE : pode_ser
    PESSOA ||--o| ATENDENTE : pode_ser

    ATENDENTE ||--o{ ATENDENTE_FILA : atua_em
    FILA ||--o{ ATENDENTE_FILA : possui

    CLIENTE ||--o{ AGENDAMENTO : solicita
    FILA ||--o{ AGENDAMENTO : organiza
    PRIORIDADE ||--o{ AGENDAMENTO : classifica
    HORARIO_DISPONIVEL ||--o{ AGENDAMENTO : agenda

    AGENDAMENTO ||--o| CHECKIN : gera
    AGENDAMENTO ||--o| ATENDIMENTO : origina

    CLIENTE ||--o{ ATENDIMENTO : recebe
    ATENDENTE ||--o{ ATENDIMENTO : realiza
    FILA ||--o{ ATENDIMENTO : organiza
    PRIORIDADE ||--o{ ATENDIMENTO : classifica

    ATENDIMENTO ||--|| AVALIACAO : recebe
    FILA ||--o{ SENHA : gera
    USUARIO ||--o{ NOTIFICACAO : recebe
    FILA ||--o{ ESTIMATIVA_ATENDIMENTO : possui

    %% RELACIONAMENTOS DE INOVAÇÃO
    AVALIACAO ||--o| ANALISE_SENTIMENTO : processa
    FILA ||--o{ INSIGHT_OPERACIONAL : gera_previsao
```
