---
layout: post.html
title: A fantástica fábrica de widgets
tags: [work, globocom, webmedia]
path1: work
path2: globocom
path3: webmedia
---

Essa é a história de como fizemos uma sequência gambiarras para conseguir entregar com sucesso uma solução de produto e plataforma, contonando a rigidez de um ambiente de produção extremamente controlado.

Isso ocorreu em meados de 2006 na Globo.com. Naquela época o portal era dívido em diversos sites independentes, como o G1, GloboEsporte e Ego entre outros. Em geral esses sites exibiam apenas noticias de texto, e todo acervo de vídeos estava concentrado em um outro site chamado GMC, Globo Media Center.

Nosso objetivo inicial era acabar com esse silo em relação ao conteúdo de videos, permitindo que os desenvolvedores dos demais sites pudessem oferecer os videos cadastrados no GMC de uma forma simplificada e padronizada. Na época, já havia uma API disponível (conhecida como WebmediaAPI) mas ela não padronizava a exibição dessas ofertas de conteúdo, o que geraria esforço a mais dessas equipes para implementação.

A solução que propusemos seria desenvolvermos widgets visuais padronizados. Esses widgets trariam ofertas de variados tipos como videos recentes, vídeos mais vistos, videos melhor avaliados, com a possibilidade de aplicação de diversos filtros e opções de layout. Dessa forma, bastaria uma importação de javascript na página com o preenchimento pro problema ser resolvido.

Eis que surje nosso primeiro problema: Naquele tempo os sites da Globo.com usavam uma plataforma chamada Vignette que estatizava todo seu conteúdo durante a publicação de homes e matérias. Ou seja, as notícias eram html estáticos gerados após cada publicação, e as homes idem. Era necessario uma publicação do editor para qualquer mudança na página ser apresentada.

Isso ia contra a dinamicidade do conteúdo de videos. Como manter um conteúdo de ordenação dinâmica como "mais vistos" em um html estático? Uma maneira seria utilizar server side include, visto que os arquivos estáticos eram servidos pelo apache.

Mas, infelizmente haviam muitas restrições para fazer qualquer mudança em infra-estrutura na globo.com em 2006. Para alcançar isso seria precisariamos de muita lábia, reuniões, apresentações e conversas 1:1, sem garantia de sucesso. Nós não tinhamos o tempo necessário nem o skill social requerido para esse objetivo. Mas tinhamos muita criativade!

Decidimos então fazer esses widgets em client side. Contudo, requisições cross domain para obter as informações da WebmediaApi só seriam possiveis se pudessemos prover os headers necessários de CORS. Mas pra fazer isso também seria necessário mudanças na infra visto que o servidor de aplicação (Apache) na frente da WebmediaApi também era rígida, fora de nosso controle e trocava todos os headers.

Nossa solução foi permitir à WebmediaApi retornar o seu conteudo com uma chamada a uma função de callback fornecida. Tínhamos então um javascript com o codigo do widget e este javascript incluia outro "javascript" que era a chamada à WebmediaAPI mandando como parâmetro o nome de uma função dinâmica. Essa função era "impressa" no response da API como uma chamada de função para enfim renderizar o widget escolhido e customizado.

Havia até um controle de timeout em caso de demora pro callback responder.

Isso resolveu nosso problema e por alguns sprints fizemos uma verdadeira fábrica de widgets. As necessidades e ideias vinham e a gente gerava o widget e filtros necessarios na WebmediaApi. Foi um sucesso. Tanto sucesso que o layout padronizado dos widgets criou a necessidade de atualizarmos o GMC, site agregador de todos os vídeos, para utilizar este mesmo padrão. Nascia então o Globo Vídeos, sucessor do GMC.

Mas havia um porém...

Naquela época o google não indexava páginas renderizadas via javascript. E precisávamos que ao menos o Globo Videos se mantivesse renderezindo server-side para não pedermos relevância nas buscas orgânicas.

A solução: passamos a renderizar os widgets feitos em javascript no servidor. Como tudo no Vignette era java, tivemos que renderizar usando Rhino (se minha memória não falha, antes do java 1.5 só era possível renderizar javascript na JVM através desta lib).

Para manter o frescor dos dados as homes do globo videos passaram a ser renderizadas no servidor a cada X tempos. Eu não lembro se essa publicação automatica havia sido feita via cron ou via alguma ferramenta do Vignette, mas o ponto é que o html estático passou a ser gerado frequentemente, com o html dos widgets, já as paginas dos videos continuaram exibindo os widgets client side pois seria impraticavel renderizar milhoes de html frequentemente.

Uma dificuldade adicional dessa solução foi que tudo na globo.com na epoca rodava em um weblogic. A solução que implementamos para renderizar o javascript server side funcionou em todos os ambientes: Local, staging, qa... Somente quando subiu pra produção não funcionou. Depois de muito debugar descobrimos o weblogic da versão de produção era diferente, e ele já possuía uma versão velha do Rhino dentro do jar dele que se sobrepunha ao nosso Rhino versão mais nova. Para renderizar então os widgets foi necessário executar os codigo instanciando um outro classloader.

Ou seja para escapar de todo alinhamento necessário para










