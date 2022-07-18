# Zab-Prox-Agent
![Zab-Prox-Agent](https://i.imgur.com/l5UnTrk.png)
> Instalação rápida do Zabbix Proxy e do Zabbix Agent 2 com configurações pré-estabelecidas.

![GitHub](https://img.shields.io/github/license/sh4dow-BR/Zab-Prox-Agent?style=plastic)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/sh4dow-BR/Zab-Prox-Agent)
![Lines of code](https://img.shields.io/tokei/lines/github/sh4dow-BR/Zab-Prox-Agent?color=red)
![GitHub language count](https://img.shields.io/github/languages/count/sh4dow-BR/Zab-Prox-Agent?color=green)
![GitHub top language](https://img.shields.io/github/languages/top/sh4dow-BR/Zab-Prox-Agent?color=yellow)
[![GitHub issues](https://img.shields.io/github/issues/Sh4dow-BR/Zab-Prox-Agent?color=blueviolet)](https://github.com/Sh4dow-BR/Zab-Prox-Agent/issues)
[![GitHub stars](https://img.shields.io/github/stars/Sh4dow-BR/Zab-Prox-Agent)](https://github.com/Sh4dow-BR/Zab-Prox-Agent/stargazers)


## Porque Dessa Ferramenta?
Essa ferramenta serve para reduzir drasticamente o tempo de instalar os proxies do Zabbix e também o agent 2.

***O proposito dessa ferramenta é automatizar a instalação em um único script para ser o mais rápido possível!***

A instalação que demorava às vezes em torno de 20 a 30 min, pode ser reduzido para menos de 5 minutos.

Como não vi nada assim, decidi criar algo para meu aprendizado e auxiliar nesse procedimento na empresa.

***Obs. Esse script provavelmente não serve para as grandes empresa, pois já deve ter um sistema pronto para fazer esse procedimento, porem para as pequenas empresas, será uma mão na roda!***

### Comunidade Zabbix!

Temos uma comunidade incrível aqui no Brasil e o proposito dessa ferramenta é para retribuir de volta para a comunidade!

Como esse é o meu primeiro projeto, irei precisar de apoio da comunidade para fazer melhorias no código!


## O Que Esse Script Faz? 

***Obs. Eu não sou um programador porem esse projeto me ensinou muitas coisas porem o meu código ainda precisa de ajustes!***

***Até esse momento, fiz o teste somente com a família Debian e CentOS, porém pode ser adicionados as outras versões também.***

***Até esse momento, o script foi criado, testado, e validado na somente na versão 6.0 do Zabbix, mas pode ser validado nas demais versões***

- Consegue trocar o hostname antes ou durante a instalação, ou pular essa etapa.
- Consegue detectar automaticamente qual versão está sendo instalado e baixar a versão necessária do proxy e agent.
- Deixar pré-estabelecidas algumas configurações para novas instalações e serve também para ser um template.
- Baixar uma versão específica do Zabbix e não seguir com o releases do Zabbix, pois o Zabbix Server está em uma versão de LTS por exemplo.
- Gera chaves de PSK para a proxy remota comunicar seguramente com o seu Zabbix Server.
- Roda a instalação e baixa as dependências necessárias automaticamente.
- Roda o comando hostnamectl para mostrar as informações do sistema durante a instalação.
- Opcionalmente, faz um update e upgrade nos pacotes antes de rodar o script.
- Faz que o proxy seja monitorada por si mesmo pelo agente.
- Ao fazer uma troca de hostname ou não, ele insere automaticamente no campo de Hostname no proxy e agente.
- Insere o IP do seu Zabbix Server, troca o proxy mode, e o local do DB em questão se for instalação sqlite3.
- Troca o file size, remote commands, config frequency, housekeeping frequency e o timeout.
- Para entender melhor o script, cada etapa esta tem uma explicação do que faz com comentários internos.


## Como Utilizar?

***Sugiro fortemente verificar as configurações default e funções caso quiser fazer uma melhorada no script e também caso for uma máquina importante fazer um backup ou snapshot antes de rodar o script por precaução***
---
Esse script tem 4 modos de ser utilizado:
1. Executa o script da forma tradicional que irá perguntar se irá querer trocar o hostname e depois faz a instalação.
2. Com o parâmetro "run", você irá pular a etapa de pedir a troca de hostname e vai direto para a instalação.
2. Com o parâmetro "change" você irá para um menu para fazer a troca de hostname e depois continuar com a instalação.
4. Com o parâmetro "change NOVO_HOSTNAME" você consegue trocar o hostname atual para um predefinido antes de fazer a instalação.


***Clique no GIF abaixo para ver o video no Vimeo:***
[<img src="https://user-images.githubusercontent.com/108578555/179556701-f29c7c53-9617-46ee-bccf-b2084a35a191.gif" width="65%">](https://vimeo.com/731052251)
---
Explicação de cada etapa e como rodar o script:
1. Entra com o usuário root
2. Vai para um diretório específico ou fica em ~
3. Baixa o git caso não tiver
4. Faz um git clone para baixar o repositório localmente na máquina
5. Entra na pasta clonada
6. Edita o script com um editor de texto que preferir e insere as configurações que quiser trocar
7. Adiciona permissões de executar o shell
8. Executa o shell com os parâmetros (change ou run) ou sem parâmetro da forma tradicional
9. Seja feliz e aproveita a instalação do proxy e agent2 que fica pronto em segundos :smile:

```
su -
cd
Se não tiver o git - Debian: apt install git
Se não tiver o git - RHEL: yum install git
git clone https://github.com/Sh4dow-BR/Zab-Prox-Agent.git
cd Zab-Prox-Agent
nano Zab-Prox-Agent-Install.sh
chmod 700 Zab-Prox-Agent-Install.sh
./Zab-Prox-Agent-Install.sh   *Setup normal*
./Zab-Prox-Agent-Install.sh run   *Executa o script sem pedir para fazer a troca de hostname*
./Zab-Prox-Agent-Install.sh change   *Executa o menu de trocar o hostname antes de rodar o script*
./Zab-Prox-Agent-Install.sh change NOVO_HOSTNAME   *Executa a troca de hostname já definido antes de rodar o script*
```

## TO DO
- Fazer o log de output do script quando ele roda
- Parar o script quando ocorrer um erro de pacote ou erro geral
- Gravar um video que mostra o script em ação

## Pessoas e sites que me ajudou de alguma forma com esse projeto!
1. Steven do grupo 0C70PU5 que me ajudou com conceitos inicias de bash e as cores e o case com o script dele: https://github.com/ticofookfook/Mini_searche_nmap/blob/main/mao_na_roda.sh
2. Nahamsec com o script dele do LazyRecon, pois me ajudou a entender o poder de funções dentro do bash e registrar as variáveis de uma forma mais organizada: https://github.com/nahamsec/lazyrecon
3. Vários e vários sites que me ajudou a entender bash, mas em específico essa playlist de blog foi o que mais me ajudou: https://linuxhandbook.com/tag/bash-beginner/
4. E dois outros sites me ajudaram bastante foi: https://linuxize.com/?linuxize-blog%5Bquery%5D=bash e https://phoenixnap.com/kb/tag/bash
