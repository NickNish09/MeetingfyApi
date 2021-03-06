# MeetingFy - API
Api para o site meetingfy disponível em: https://meetingfy-api.herokuapp.com/v1

exemplo de requisição: GET https://meetingfy-api.herokuapp.com/v1/rooms

para ver as salas criadas. Mais requisições abaixo na seção requisições.

## Como utilizar localmente
- Clone este repositório:

```git clone https://github.com/NickNish09/MeetingfyApi.git```

- Entre na pasta dele:

```cd MeetingfyApi```

- Execute o bundle install para instalar dependências:

```bundle install```

- Execute o comando para setar o banco de dados:

```rails db:setup```

- Rode o servidor e faça uma requisição: 

```rails s```

GET http://localhost:3000/v1/rooms

- Caso queira, você pode rodar os testes do projeto:

```rspec```

e checar a cobertura em coverage/index.html
## Features e Breve Descrição
O sistema foi dividido em backend e frontend. O Backend, este, foi feito com Ruby On Rails (API).
Existem **basicamente 3 Models, um de usuário (User), um para reuniões (Meeting)
e um para as salas (Room)**. **O planejamento do sistema foi feito no site
whimsical**, onde antes de seu desenvolvimento foram feitas algumas telas e levantados
os requisitos e uma estrutura do banco de dados:

https://whimsical.com/meetingfy-PuRYrcSneNYZRb3vsqfpKU

O desenvolvimento desta API seguiu um **desenvolvimento orientado a testes
(Test Driven Development - TDD)**, sendo feitos testes para funções dos models
e para requisições dos controllers, preferencialmente antes de suas implementações.

Foi configurada uma integração contínua com o GitHub Workflows para rodar os testes a cada
pull request feito para branch Develop ou Master, para serem feitos os merges
apenas se os testes passarem.

**Features:**
- Autenticação via Token
- Criar/Editar/Excluir/Ver salas
- Reservar salas para reuniões

**As salas podem ser criadas, editadas e deletadas** apenas por usuários autenticados. Qualquer usuário pode ver a listagem de salas.

**As reuniões só podem ser vistas, marcadas, deletadas** por usuários autenticados.
Apenas usuários que criaram a reunião podem deletá-la.

**Todas as reuniões tem validação para acontecer no horário comercial (8:00 - 18:00)**
e devem ocorrer em data futura de sua marcação.

## Tecnologias Utilizadas
- **Ruby On Rails** (API) 6.0.3
- **Ruby** 2.6.3
- **RSPEC** 4.0.1 para testes funcionais e de requisições
- **FactoryBot** para padrões de factory nos testes
- **SimpleCov** para métrica de cobertura de testes
- **DeviseAuthToken** para autenticação via token
- **FFaker** para seeds de dados para testes
- **Heroku** para hospedagem em produção
- **Whimsical** Planejamento e Mockup de Telas
- **Postman** para testar requisições
- **GitHub Workflows** para integração contínua

## Requisições
Alguns exemplos de requisições podem ser feitas pelo POSTMAN, importando
as requisições por esse link: https://www.getpostman.com/collections/ce9a7bf7d1358298e8d3
### Autenticação
Cadastro: POST https://meetingfy-api.herokuapp.com/v1/auth

Parâmetros: {
                "email": "user@test.com",
                "password": "123456",
                "name": "User Test"
            }
            
Login: POST https://meetingfy-api.herokuapp.com/v1/auth/sign_in

Parâmetros: {
                "email": "user@test.com",
                "password": "123456"
            }
            
### Salas
Criar: POST https://meetingfy-api.herokuapp.com/v1/rooms

Parâmetros: {
            	"room": {
            		"name": "Sala de Reunião",
            		"capability": 15
            	}
            }
            
Listar: GET https://meetingfy-api.herokuapp.com/v1/rooms

Ver Sala: GET https://meetingfy-api.herokuapp.com/v1/rooms/1/

Deletar Sala: DELETE https://meetingfy-api.herokuapp.com/v1/rooms/1/

Atualizar: PUT https://meetingfy-api.herokuapp.com/v1/rooms/1/

Parâmetros: {
            	"room": {
            		"name": "Sala Atualizada",
            		"capability": 25
            	}
            }
            
### Reuniões
Criar: POST https://meetingfy-api.herokuapp.com/v1/meetings

Parâmetros: {
            	"meeting": {
            		"meeting_start": "2021-11-29T13:20:00.000",
            		"meeting_end": "2021-11-29T14:40:00.000",
            		"title": "Reunião Geral",
            		"room_id": 1
            	}
            }
            
Deletar Reunião: DELETE https://meetingfy-api.herokuapp.com/v1/meetings/1/

Atualizar: PUT https://meetingfy-api.herokuapp.com/v1/meetings/1/

Parâmetros: {
            	"meeting": {
            		"meeting_start": "2021-11-29T15:20:00.000",
            		"meeting_end": "2021-11-29T16:40:00.000",
            		"title": "Reunião Atualizada",
            		"room_id": 1
            	}
            }
           