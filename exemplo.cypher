// MATCH (n) DETACH DELETE n;

CREATE
  (bianca:Usuario   {nome:'Bianca', idade:30}),
  (felipe:Usuario   {nome:'Felipe Gomes', idade:28}),
  (luiz:Usuario     {nome:'Luiz', idade:35}),
  (darkiane:Usuario {nome:'Darkiane Barbosa', idade:22}),
  (jaso:Usuario     {nome:'Jaso', idade:27}),
  (marcos:Usuario   {nome:'Marcospassos', idade:31}),
  (beto:Usuario     {nome:'Beto', idade:24}),
  (carol:Usuario    {nome:'Carol', idade:26}),
  (nb:Produto    {nome:'Notebook'}),
  (mouse:Produto {nome:'Mouse'}),
  (fone:Produto  {nome:'Fone'}),
  (bianca)-[:AMIGO_DE]->(felipe),
  (bianca)-[:AMIGO_DE]->(luiz),
  (bianca)-[:AMIGO_DE]->(darkiane),
  (bianca)-[:AMIGO_DE]->(jaso),
  (bianca)-[:AMIGO_DE]->(marcos),
  (bianca)-[:AMIGO_DE]->(beto),
  (bianca)-[:AMIGO_DE]->(carol),
  (felipe)-[:AMIGO_DE]->(darkiane),
  (felipe)-[:AMIGO_DE]->(luiz),
  (luiz)-[:AMIGO_DE]->(jaso),
  (darkiane)-[:AMIGO_DE]->(marcos),
  (jaso)-[:AMIGO_DE]->(beto),
  (marcos)-[:AMIGO_DE]->(carol),
  (bianca)-[:COMPROU   {data: date('2026-08-24')}]->(nb),
  (felipe)-[:COMPROU   {data: date('2026-08-25')}]->(nb),
  (felipe)-[:COMPROU   {data: date('2026-09-02')}]->(mouse),
  (darkiane)-[:COMPROU {data: date('2026-09-05')}]->(nb),
  (darkiane)-[:COMPROU {data: date('2026-09-06')}]->(mouse),
  (luiz)-[:COMPROU     {data: date('2026-09-08')}]->(nb),
  (luiz)-[:COMPROU     {data: date('2026-09-10')}]->(fone),
  (carol)-[:COMPROU    {data: date('2026-09-12')}]->(fone),
  (beto)-[:COMPROU     {data: date('2026-09-15')}]->(mouse);


MATCH (u:Usuario) RETURN count(u); // esperado: 8
MATCH ()-[r:AMIGO_DE]->() RETURN count(r); // esperado: 13

MATCH (u:Usuario)-[c:COMPROU]->(p:Produto)
WHERE u.idade > 25
RETURN u.nome, p.nome, c.data; 
// quem tem mais de 25?

MATCH (felipe:Usuario {nome:'Felipe Gomes'})-[:AMIGO_DE*2]-(fof:Usuario)
WHERE fof <> felipe AND NOT (felipe)-[:AMIGO_DE]-(fof)
RETURN DISTINCT fof.nome; 
// quem são os amigos de amigos do felipe que não são amigos dele?

MATCH (b:Usuario {nome:'Bianca'})-[:AMIGO_DE]-(comum:Usuario)
      -[:AMIGO_DE]-(f:Usuario {nome:'Felipe Gomes'})
RETURN comum.nome; 
// quem são os amigos em comum entre bianca e felipe?

MATCH p = (b:Usuario {nome:'Bianca'})
          -[:AMIGO_DE]-(comum:Usuario)
          -[:AMIGO_DE]-(f:Usuario {nome:'Felipe Gomes'})
RETURN p; 
// em grafo, qual é o caminho entre bianca e felipe?

MATCH p = shortestPath(
  (a:Usuario {nome:'Luiz'})-[:AMIGO_DE*]-(c:Usuario {nome:'Carol'})
)
RETURN p; 
// qual o caminho mais curto entre luiz e carol?

MATCH (bianca:Usuario {nome:'Bianca'})-[:COMPROU]->(:Produto)
      <-[:COMPROU]-(outro:Usuario)-[:COMPROU]->(rec:Produto)
WHERE NOT (bianca)-[:COMPROU]->(rec)
RETURN rec.nome, count(*) AS pontuacao
ORDER BY pontuacao DESC; 
// quais produtos que os amigos de bianca compraram que ela não comprou? (recomendação de produtos)

MATCH (u:Usuario)-[:AMIGO_DE]-(amigo)
RETURN u.nome, count(amigo) AS grau
ORDER BY grau DESC; 
// quem tem mais amigos? (grau do nó)


MATCH p = (:Usuario)-[:COMPROU]->(:Produto)
RETURN p; 
// quais são os caminhos de compra entre usuários e produtos? Grafo Bipartido

MATCH p = (:Usuario)-[:AMIGO_DE]->(:Usuario)
RETURN p; 
// quais são os caminhos de amizade entre usuários? Grafo Unipartido

MATCH ()-[r]->()
RETURN type(r) AS tipo, count(*) AS total; 
// quais são os tipos de relacionamentos e quantos existem de cada tipo?

// quais usuários compraram notebook e em que datas?
MATCH (u:Usuario)-[c:COMPROU]->(:Produto {nome:'Notebook'})
RETURN u.nome, c.data
ORDER BY c.data; 