---
layout: post.html
title: A fantástica fábrica de widgets
tags: [work, globocom, webmedia]
path1: work
path2: globocom
path3: webmedia
---

Essa história ocorreu em meados de 2006 e ela demonstra como a falta de flexibilidade e autonomia na infra estrutura de produção pode gerar belas gambiarras.

Na Globo.com tinhamos diversos sites diferentes, o G1 de noticias, GE de esportes, Ego, Entretenimento (na época não havia GShow). Em geral esses sites exibiam apenas noticias de texto, e todo acervo de vídeos estava concentrado num produto chamado GMC, globo media center.

A idéia era acabar com esse silo, provendo uma maneira simples dos demais sites oferecerem os videos cadastrados no GMC. Uma API (que chamavamos de WebmediaAPI) já estava disponível, mas ela não padronizava a exibição dessas ofertas de conteúdo.

A solução que propuzemos seria desenvolvermos widgets para que os desenvolvedores de cada site pudessem instanciá-los em suas homes. Esses widgets trariam ofertas de variados tipos como videos recentes, vídeos mais vistos, videos melhor avaliados, com a possibilidade de aplicação de diversos filtros e opções de layout.

Naquele tempo os sites da Globo.com usavam uma plataforma chamada Vignette que estatizava todo seu conteúdo durante a publicação de homes e matérias. Ou seja, as notícias eram html estaticos gerados após cada publicação, e as homes idem. Era necessario uma publicação do editor para qualquer mudança na página ser apresentada.

Isso ia contra a dinamicidade do conteúdo de videos. Como manter um conteúdo de ordenação dinâmica como "mais vistos" em um html estático? Uma maneira seria utilizar server side include, visto que os arquivos estáticos eram servidos pelo apache.

Mas, infelizmente haviam muitas restrições para fazer qualquer mudança em infra-estrutura na globo.com naquela época. O que nos exigiria dezenas de reuniões, apresentações, muita lábia e skill social. Algo que naqueles tempos de nerdisse juvenil me faltava aos montes.

Sobrou então a solução de fazer esses widgets em client side. Contudo, requisições cross domain para obter as informações da WebmediaApi só seriam possiveis se pudessemos prover os headers necessários de CORS. Mas pra fazer isso também seria necessário mudanças na infra visto que a camada (apache) na frente da WebmediaApi também era rígida, fora de nosso controle e trocava todos os headers.

Nossa solução foi permitir à WebmediaApi retornar o seu conteudo com uma chamada a uma função de callback fornecida. Tínhamos então um javascript com o codigo do widget e este javascript incluia outro "javascript" que era a chamada à WebmediaAPI mandando como parâmetro o nome de uma função dinâmica. Essa função era "impressa" no response da API como uma chamada de função para enfim renderizar o widget escolhido e customizado.

Havia até um controle de timeout em caso de demora pro callback responder.

Isso resolveu nosso problema e por alguns sprints fizemos uma verdadeira fabrica de widgets. As necessidades e ideias vinham e a gente gerava widget e filtros necessarios na webmediaapi. Foi um sucesso.

Até que resolvemos fazer o Globo Videos. Site sucessor e condensador de todoss os videos que também estariam espalhados nos outros sites. Oras, com todos os widgets, seria simples criar o site. Bastariamos encaixá-los em algumas páginas e correr pro abraço.

Mas havia um porém...

Naquela época o google não indexava páginas renderizadas via javascript. E precisávamos que ao menos o Globo Videos renderizasse no servidor.

A solução: passamos a renderizar os widgets feitos em javascript no servidor. Como tudo no vignette era java, tivemos que renderizar usando Rhino (se minha memória não falha, antes do java 1.5 só era possível renderizar javascript no servidor com essa lib).

Para manter o frescor dos dados as homes do globo videos passaram a ser renderizadas no servidor a cada X tempos. Eu não lembro se essa publicação automatica havia sido feita via cron ou via alguma ferramenta do vignette, mas o ponto é que o html estático passou a ser gerado frequentemente, com o html dos widgets.

As paginas dos videos continuaram exibindo os widgets client side pois seria impraticavel renderizar milhoes de html frequentemente.

Uma dificuldade adicional dessa solução foi que tudo na globo.com na epoca rodava em um weblogic. A solução que implementamos para renderizar o javascript server side funcionou em todos os ambientes: Local, staging, qa... Somente quando subiu pra produção não funcionou. Depois de muito debugar descobrimos o weblogic da versão de produção era diferente, e ele já possuía uma versão velha do Rhino dentro do jar dele que se sobrepunha ao nosso Rhino versão mais nova. Para renderizar então os widgets foi necessário executar os codigo instanciando um outro classloader.

Ou seja para escapar de todo alinhamento necessário para










