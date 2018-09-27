### Trabalho Prático 1 - INFO7015
O artigo Jellyfish: Networking Data Centers Randomly de Singla et al. 2012 examina as técnicas existentes para a conexão de switches top-of-rack (ToR)*,  apresenta as características e desvantagens destas e por fim propõe uma nova solução de topologia chamada Jellyfish. O objetivo deste trabalho é a reprodução parcial deste artigo. Os resultados da Figura 9 e Tabela 1 foram examinados utilizando o Mininet.

*ToR: modelo em que os servidores são conectados a um ou dois Switches instalados dentro do Rack. Estes switches por sua vez, são conectados aos switches de agregação.

#### Que problema a Jellyfish estava tentando resolver?
A experiência da indústria indica que a capacidade de expansão de datacenters é essencial para que seja possível aumentar a capacidade de forma incremental e assim poder lidar com a crescente quantidade de tráfego. Entretanto, como a estrutura das redes de alta largura de banda são normalmente rígidas e seu layout é determinado pelo número de portas disponíveis no switch (tal como na tradicional Fat-tree), a expansão incremental acaba sendo afetada. Neste sentido, os autores propuseram o Jellyfish, uma nova arquitetura de rede que adota uma topologia de grafo aleatório para a interconexão de rede de alta capacidade que objetiva viabilizar a incorporação harmoniosa de servidores adicionais (expansão incremental) e promover uma utilização mais eficiente da rede.

#### Qual era estado da arte no momento em que o artigo foi publicado:
No momento em que o artigo foi publicado havia propostas para redes de alta capacidade que exploravam a estrutura com relação a topologia e roteamento. Entre elas, estavam projetos que utilizavam servidores para encaminhamento, projetos com tecnologia de rede óptica e a Fat-tree. Entretanto, segundo os autores nenhuma destas arquiteturas abordava o problema de expansão incremental. Outras soluções utilizadas como o DCell e BCube até permitiam a expansão desde que fosse planejada e para um tamanho predefinido, no entanto demandavam servidores com portas livres e reservadas para futuras expansões. Na Fat-tree para adicionar servidores e preservar as propriedades da estrutura era necessário a substituição de grande número de elementos além de demandar uma extensa religação. Como pode ser observado, não havia abordagens para a expansão incremental ser realizada de forma simplificada.

#### Um breve resumo dos métodos e resultados do artigo original (com foco especial na Figura 9 e na Tabela 1):

Os autores de Jellyfish afirmam que uma rede de comutadores conectados aleatoriamente fornece uma estrutura mais fluida além de disponibilizar throughput maior ou igual a topologia tradicional. O ganho de desempenho vem do fato de que existem muitos caminhos entre os nós resultando em mais links que são totalmente aproveitados. Como resultado é gerada maior largura de banda de rede, melhor eficácia para utilizar toda a capacidade da rede e até mesmo evitar o congestionamento. A Figura 9 demonstra que a técnica de roteamento escolhida pode alavancar essa arquitetura.
<p align="center"><img src="https://image.ibb.co/cAeZE9/dados_originais.png" alt="dados_originais" border="0"></p> 


O gráfico (Figura 9) mostra a distribuição do número de caminhos distintos para cada link em uma topologia Jellyfish. Para a seleção dos caminhos são utilizadas três técnicas distintas: 8 Shortest Paths, 64-way ECMP e 8-way ECMP. Como pode ser observado, o algoritmo de roteamento k-shortest é melhor que o ECMP para ser utilizado com o Jellyfish. O resultado da simulação mostra que no k-shortest paths os links podem utilizar muito mais caminhos distintos. Para exemplificar, ao examinar o gráfico verifica-se que os 2.000 links ativos (eixo x) podem utilizar até 8 caminhos (eixo y) com este algoritmo de roteamento enquanto que com o ECMP, o número de caminhos disponíveis é menor que 4.  Ao analisar o cenário, pode-se concluir que o algoritmo ECMP não apresentou bons resultados por não aproveitar a diversidade de caminhos da arquitetura Jellyfish.

A Tabela 1 mostra os resultados da execução de algumas simulações de pacotes de controle de congestionamento (TCP 1 e 8 fluxos e MPTCP) e dois algoritmos de roteamento (ECMP e K-Shortest-Path) nas distintas topologias Jelllyfish (780 servidores) e Fat-tree (686 servidores). Os resultados apontam que o uso do k shortest-paths em TCP com Jellyfish apresenta throughput semelhante à execução do ECMP em Fat-tree, isto mostra que Jellyfish alcança o mesmo desempenho da Fat–tree.  Outra característica observada foi que o uso do k-shortest-path apresenta melhores resultados quando comparado ao ECMP na topologia Jellyfish.

#### Detalhe sobre sua abordagem para reproduzir a figura. Se você escolheu uma plataforma ou ferramenta específica, explique por que você fez essa escolha. Destaque as vantagens da sua abordagem, bem como quaisquer inconvenientes. Houve algum desafio que você acertou ou suposições que você precisava fazer?

Os experimentos foram executados em servidores criados na Google Cloud:

Servidor TCP: S.O. Debian GNU/Linux 9 Kernel 4.9.0-8 para simulação com TCP:
Máquina n1-standard-4:  4 vCPUs, 15 GB de memória e 30 GB de espaço em disco.
Servidor MPTCP: S.O. Debian GNU/Linux 9 Kernel 4.9.0-8 para simulação com MPTCP compilado no Kernel (https://multipathtcp.org/pmwiki.php/Users/DoItYourself)
Máquina n1-standard-4: 15 GB de memória, 30 GB de espaço em disco e 4 vCPUs.

**TESTE DO MPTC**<p align="left"><img src="https://image.ibb.co/b6Qx2U/mptcp.png" alt="dados_originais" border="0"></p> 

Para a simulação foi utilizado: 
Mininet 2.2.2.  (http://mininet.org/download/);
Python 3.5.2 (https://www.python.org/downloads/);
Pip3, networkx,  matplotlib e Iperf3 do repositório do Debian.

A princípio a simulação foi realizada em uma máquina virtual (em notebook pessoal) com a seguinte configuração: 2GB de memória, 2 processadores, 30 GB de espaço em disco e  MPTCP compilado no kernel. Devido ao baixo poder de processamento as simulações eram muito longas e muitas vezes não completavam. Dessa forma, optou-se pela utilização da Google Cloud que oferece créditos educacionais para alunos que desejam experimentar a ferramenta (https://cloud.google.com/).  Foi necessário criar duas máquinas distintas (uma com MPTCP e outra TCP) porque ao desabilitar o MPTCP no Kernel para simular utilizando o TCP, os dados da simulação não eram consistentes. 

A simulação foi baseada no código disponibilizado por Jean-Luc Watson, https://github.com/jlwatson. Este código simula a topologia Jellyfish, gera a média de throughput no algoritmo de roteamento selecionado (ECMP e K-Shortest-Path) com o número de fluxo escolhido. Entretanto, quando se utiliza um valor de fluxo superior a 3, em algumas simulações o resultado não é apresentado ou quando apresentado, os valores são contraditórios ao cenário configurado. Este mesmo problema foi observado em outros repositórios testados. Em reposta ao e-mail enviado à Jean-Luc Watson, o autor reportou uma falha de comunicação entre o Iperf e o Mininet que possivelmente foi causada devido à versão específica utilizada em seu trabalho (Mininet 2.2.2).  Este problema afeta a utilização do Mininet para limitar a largura de banda em cada link ao executar os testes Iperf, causando assim, uma inconsistência nos dados. Para tentar solucionar este problema foram testadas 4 versões anteriores do Mininet, voltando até a versão 2.0.0 apesar disso, não se obteve sucesso. Verificou-se então que em alguns testes eram computados o tráfego de 0KB/s para o cálculo do throughput, em outras situações o limite da largura de banda era superior ao configurado no início da simulação.  Neste sentido, optou-se pela utilização dos dados efetivos para a realização dos cálculos.  

Para a simulação da topologia Fat-Tree foi utilizado o repositório disponibilizado por Pranav Yerabati Venkata (https://github.com/pranav93y) com algumas adaptações para o propósito desta reprodução. O uso do Mininet foi fortemente recomentado por grande parte dos pesquisadores que reproduziram este artigo, por esta razão manteve-se a sua utilização.

#### Qual o resultado que você conseguiu? Correspondeu ao papel original?

Foram necessárias várias simulações para encontrar uma quantidade de servidores que representassem resultados próximos ao do experimento apresentado na Tabela 1. O número máximo suportado, para que as simulações fossem concluídas com sucesso (com 1 e 8 fluxos) foi de 32 servidores. Acima desta quantia de servidores as simulações se tornavam muito instáveis. 

Ao observar o resultado obtido, tem-se a impressão que o ECMP tem um desempenho melhor do que k-Shortest-Path. No entanto, acredita-se que isto ocorre devido ao fato de que a rede utilizada é pequena e com pouca diversidade de links possíveis.  Como o algoritmo 8-Shortest Paths escolhe para cada par de destino 8 caminhos que são mais curtos, tem-se um grande impulso na variedade de caminhos, porém na rede simulada não existe tamanha diversidade para se beneficiar.  Contudo, em uma rede grande o suficiente, essa tendência seria suficiente para tornar k-shortest, o melhor algoritmo em Jellyfish. Isso apoia a afirmação do autor de que a diversidade de links de caminhos mais curtos, melhora o desempenho da Jellyfish. Ao comparar os resultados obtidos em Fat-tree com EMCP e Jellyfish com k shortest verificou-se uma característica importante, os valores são semelhantes mostrando que Jellyfish pode apresentar um desempenho melhor ou igual a topologia tradicional.

Para a reprodução da Figura 9 não foi necessário modificar o número de servidores (Fat-tree=686 e Jellyfish=780).  No código disponibilizado por Jean-Luc Watson são utilizados métodos estatísticos para calcular a distribuição de caminhos. Como pode ser observado, os resultados são semelhantes ao apresentado no artigo.

#### Tabela 1
|  Congestion Control | Fat-Tree ECMP  | JF ECMP  | JF 8-shortest Paths  |
| ------------ | ------------ | ------------ | ------------ |
|  TCP1 |  95,96% |  66,8% | 66,9%  |
|TCP8   | X  | 94,7%  | 94,5%  |
|  MPTCP | X  |  76,9% | 55,6%


**Dados da Fat-Tree**
<p align="left">  <img src="https://image.ibb.co/ioX1cU/fat_1.png" alt="dados_originais" border="0"></p>

**Dados TCP para Tabela 1**<p align="left"><img src="https://image.ibb.co/m1TmU9/jellyfish_32srvrs.png" alt="dados_originais" border="0"></p> 
**Dados MPTCP para Tabela 1**<p align="left"><img src="https://image.ibb.co/mw4h2U/jellyfish_32srvrs_mptcp.png" alt="dados_originais" border="0"></p> 

## Passos para a reprodução:

##### 1- Crie duas instâncias virtuais no serviço Google Cloud (Você pode utilizar sua própria máquina caso tenha as mesmas características descritas) com a seguinte configuração:
- Região us-central (Iowa)
- 4 vCPUs e 15 GB de memória
- Ao menos 30 GB de disco para permitir a compilação do MPTCP
- Debian GNU/Linux 9 (Strech)
- Tráfego HTTP e HTTPS permitidos

##### 2- Instalar o git:
```
sudo apt install git
```
##### 3- Clonar o repositório do mininet:
```
git clone git://github.com/mininet/mininet.git
```
##### 4- Executar:
```
cd mininet
git checkout 2.2.2
util/install.sh -a
```
##### 5- Instalar bibliotecas e programas complementares
```
sudo apt install iperf3
sudo apt install python-pip
sudo pip install networkx
sudo pip install matplotlib
```
##### 6- Em uma das instâncias virtuais compilar o MPTCP:
```
git clone git://github.com/multipath-tcp/mptcp.git
sudo mv -R mptcp/  /usr/src/
cd /usr/src
sudo apt-install build-essential libncurses5-dev bc libssl-dev make libelf-dev
make mrproper
make menuconfig (selecionar pacotes do MPTCP)
make_kpkg
make modules
make modules_install
make install
```
**7- Conectar a instância com TCP (Via painel de controle do google cloud ou cliente SSH de sua preferência)**

Clonar o git do projeto:
```
git clone https://github.com/fernandonakayama/TP_1.git
cd TP_1/
sudo python tcp.py
```
A figura9 estará disponível na raiz do diretório, com o nome ***figure9.eps***

Os resultados de TCP com 1 e 8 fluxos com ECMP e K-shortest-Paths para topologia Jellyfish serão exibidos ao término da execução.

Os resultados da topologia Fat-Tree são obtidos executando o script fattree.sh
```
sudo sh ./fattree.sh
```
O resultado será exibido após a execução do script.

**8- Conectar a instância com MPTCP (Via painel de controle do google cloud ou cliente SSH de sua preferência)**

Clonar o git do projeto:
```
git clone https://github.com/fernandonakayama/TP_1.git
cd TP_1/
sudo python mptcp.py
```
Os resultados de MPTCP com 1 e 8 fluxos com ECMP e K-shortest-Paths para topologia Jellyfish serão exibidos ao término da execução.

Os resultados da topologia Fat-Tree são obtidos executando o script fattree.sh
```
sudo sh ./fattree.sh
```
O resultado será exibido após a execução do script.


