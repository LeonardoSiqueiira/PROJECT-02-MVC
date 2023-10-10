#INCLUDE 'Protheus.ch'
#INCLUDE 'FwMvcDef.ch'

/*/{Protheus.doc} User Function MVCSZ7
    Função principal para a construção de tela de Requisição de Compras
    @type  Function
    @author Leonardo Siqueira
    @since 10/10/2023
    @version 20231010
    (examples)
    @see https://tdn.totvs.com.br/pages/releaseview.action?pageId=28574107
    /*/

User Function MVCSZ7()
Local aArea                     := GetArea()
Local oBrowse                   := FwmBrowse():New()          // FARA O INSTANCIAMENTO DA CLASSE FWMBROWSE

oBrowse:SetAlias("SZ7")
oBrowse:SetDescription("Requisição de Compras")


oBrowse:Activate(aArea)

Return

// STATIC FUNCITON RESPONSAVEL PELO MODELO DE DADOS
Static Function ModelDef()
Local oModel                     := MPFormModel("MVCSZ7m")                              // OBJETVO PRINCIPAL DO DESENVOLVIMENTO MVC MOD 2, TRAZ AS CARACTERISTICAS DO DICIOMARIO DE DADOS
Local oStCabec                   := FWFormModelStruct():New()                           // RESPONSAVEL PELA ESTRUTURA TEMPORARIA DO CABEÇALHO
Local oStItens                   := FWFormStruct(1, "SZ7"):New()                        // RESPONSAVEL PELA ESTRUTURA DO ITEM



// CRIAÇÃO DA TABELA TEMPORARIA QUE SERA USADA NO CABEÇALHO
oStCabec:AddTable("SZ7", {"Z7_FILIAL", "Z7_NUM", "Z7_ITEM"}, "Cabeçalho SZ7")

// CRIAÇÃO DOS CAMPOS DA TABELA TEMPORARIA
oStCabec:AddField(;
"Filial",;
"Filial",;
"Z7_FILIAL",;
"C",;
TamSX3("Z7_FILIAL")[1],;
0,;
Nil,;
Nil,;
{},;
.T.,;
FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI, SZ7-> Z7_FILIAL,FWxFilial('SZ7'))"),;
.T.,;
.F.,;
.F.)

oStCabec:AddField(;
"Pedido",;
"Pedido",;
"Z7_NUM",;
"C",;
TamSX3("Z7_NUM")[1],;
0,;
Nil,;
Nil,;
{},;
.T.,;
FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI, SZ7-> Z7_NUM,'')"),;
.T.,;
.F.,;
.F.)

oStCabec:AddField(;
"Emissao",;
"Emissao",;
"Z7_EMISSAO",;
"D",;
TamSX3("Z7_EMISSAO")[1],;
0,;
Nil,;
Nil,;
{},;
.T.,;
FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI, SZ7-> Z7_EMISSAO, dDataBase)"),;
.T.,;
.F.,;
.F.)

oStCabec:AddField(;
"FORNECEDOR",;
"FORNECEDOR",;
"Z7_FORNE",;
"C",;
TamSX3("Z7_FORNE")[1],;
0,;
Nil,;
Nil,;
{},;
.T.,;
FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI, SZ7-> Z7_FORNE, '')"),;
.F.,;
.F.,;
.F.)

oStCabec:AddField(;
"LOJA",;
"LOJA",;
"Z7_LOJA",;
"C",;
TamSX3("Z7_LOJA")[1],;
0,;
Nil,;
Nil,;
{},;
.T.,;
FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI, SZ7-> Z7_LOJA, '')"),;
.F.,;
.F.,;
.F.)

oStCabec:AddField(;
"USER",;
"USER",;
"Z7_USER",;
"C",;
TamSX3("Z7_USER")[1],;
0,;
Nil,;
Nil,;
{},;
.T.,;
FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI, SZ7-> Z7_USER, __cuserid)"),;
.F.,;
.F.,;
.F.)

/* TRATANDO A ESTRUTURA DOS ITENS QUE SERÃO UTILIZADOS NO GRID DA APLICAÇÃO
 MODIFICANDO INICIALIZADORES PADRÃO PARA NÃO OCORRER MSG DE COLUNA VAZIA */

oStItens:SetProperty("Z7_NUM",      MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"') )
oStItens:SetProperty("Z7_USER",     MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '__cUserId') ) // TRAZ O USUARIO AUTOMATICO
oStItens:SetProperty("Z7_FORNE",    MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"') )
oStItens:SetProperty("Z7_LOJA",     MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"') )
oStItens:SetProperty("Z7_EMISSAO",  MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, 'dDataBase') )  // TRAZ A DATA AUTOMATICA

/* REALIZANDO UNIÃO DAS ESTRUTURAS, VINCULANDO CABEÇALHO COM ITENS 
   E ESTRUTURAS DE DADOS DOS ITENS AO MODELO
*/

oModel:AddFields("SZ7MASTER",,oStCabec)                 //VINCULAÇÃO COM O oSTCABEC( CABEÇALHO E ITENS TEMPORARIOS )
oModel:AddGrid("SZ7DETAIL", "SZ7MASTER", oStItens,,,,,)
// SETANDO A RELAÇAO ENTRE CABEÇALHO E ITENS, DIZENDO QUAL CAMPO O GRID ESTA VINCULADO AO CABEÇALHO
oModel:SetRelation("SZ7DETAIL",{{"Z7_FILIAL", "'Iif(!INCLUI, SZ7-> Z7_FILIAL,FWxFilial('SZ7'))'"},{"Z7_NUM", "SZ7 -> Z7_NUM"}}, SZ7 -> (IndexKey(1)))                                    

// SETO A CHAVE PRIMARIA
oModel:SetPrimaryKey({})

oModel:GetModel("SZ7DETAIL"):SetUniqueLine("Z7_ITEM")  // O OBJETIVO É QUE ESSE CAMPO NÃO SE REPITA


// SETAMOS A DESCRIÇÃO QUE APARECERÁ NO GRID DE ITENS E CABEÇALHO
oModel:GetModel("SZ7MASTER"):SetDescription("Cabeçalho Requisição de Compras")
oModel:GetModel("SZ7DETAIL"):SetDescription("Itens Requisição de Compras")

// FINALIZANDO A FUNÇÃO MODEL
oModel:GetModel("SZ7DETAIL"):SetUseOldGrid(.T.)        // FINALIZO SETANDO O MODELO ANTIGO DE GRID, PEGANDO O AHEADER E ACOLS


Return oModel
