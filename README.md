# Shift Eligibility
Um sistema com função de verificar turnos em períodos disponíveis para que os profissionais possam estar elegíveis para trabalhar.
Possuí 3 domínios princípais: Facility(local), Worker(profissional) e Shift(turno).

Esse sistema possuí somente 2 endpoints:
- Para verificar elegibilidade dos turnos: `api/shifts`
- Para aplicar o profissional ao turno: `api/shifts/:shift_id/assign_worker`

O sistema está documentado com swagger na rota: `/api-docs/index.html`

## Como rodar o projeto:
O projeto está em docker, então todo ambiente já está preparado, basta digitar esse comando:
`docker-compose up --build`
obs. Não esquecer de criar o arquivo `.env` com os dados que se encontram no próprio arquivo `docker-compose.yml`

# Garantia de um endpoint com desempenho
## Consultas eficientes no banco de dados
- Um dos primeiros pontos importantes seria a criação de indices nos campos em que são usados filtros referente as consultas sql
- Com o Active Record, devemos atentar no uso dos `joins`, `includes` e `eager_load`. Cada um tem seu papel importante, isso tudo para evitar consultar N + 1

## Paginação
- Muito importante para não retornar grandes quantidade de dados no retorno das consultas, evitando problema de memory leak

## Background Jobs
- Não foi criado nesse projeto, mas caso houvesse algum processo mais pesado ou então algum processo para ser agendado, seria importante estar utilizando

## Logs e monitoramento
- Importante estar sempre logando processos seja alertas, error ou algum tipo de informação para acompanhar algum fluxo
- A ideia é sempre usar alguma ferramenta que facilite as buscas dos logs como Cloudwatch da aws, rapid7 ou até mesmo o elastic stack
- Em questão de monitoramento e observabilidade muito importante usar ferramentas como new relic para analisar métricas, erros e desempenhos do sistema